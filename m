Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:39203 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbeDNJpH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 05:45:07 -0400
Received: by mail-lf0-f67.google.com with SMTP id p142-v6so15727832lfd.6
        for <linux-media@vger.kernel.org>; Sat, 14 Apr 2018 02:45:07 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [PATCH] gpio: Add a reference to CEC on GPIO
Date: Sat, 14 Apr 2018 11:44:58 +0200
Message-Id: <20180414094458.5700-1-linus.walleij@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a pointer to the CEC GPIO driver from the GPIO list of
examples of drivers on top of GPIO.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/driver-api/gpio/drivers-on-gpio.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/driver-api/gpio/drivers-on-gpio.rst b/Documentation/driver-api/gpio/drivers-on-gpio.rst
index 7da0c1dd1f7a..f3a189320e11 100644
--- a/Documentation/driver-api/gpio/drivers-on-gpio.rst
+++ b/Documentation/driver-api/gpio/drivers-on-gpio.rst
@@ -85,6 +85,10 @@ hardware descriptions such as device tree or ACPI:
   any other serio bus to the system and makes it possible to connect drivers
   for e.g. keyboards and other PS/2 protocol based devices.
 
+- cec-gpio: drivers/media/platform/cec-gpio/ is used to interact with a CEC
+  Consumer Electronics Control bus using only GPIO. It is used to communicate
+  with devices on the HDMI bus.
+
 Apart from this there are special GPIO drivers in subsystems like MMC/SD to
 read card detect and write protect GPIO lines, and in the TTY serial subsystem
 to emulate MCTRL (modem control) signals CTS/RTS by using two GPIO lines. The
-- 
2.14.3
