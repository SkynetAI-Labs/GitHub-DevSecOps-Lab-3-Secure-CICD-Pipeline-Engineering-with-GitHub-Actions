import unittest

from app.health import health_status


class HealthStatusTests(unittest.TestCase):
    def test_health_status_returns_expected_result(self):
        self.assertEqual(
            health_status(),
            {"status": "healthy", "service": "secure-cicd-demo"},
        )


if __name__ == "__main__":
    unittest.main()
