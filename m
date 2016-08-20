Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36678 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753616AbcHTKrP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Aug 2016 06:47:15 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, linus.walleij@linaro.org,
        khilman@baylibre.com, carlo@caione.org
Cc: linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com,
        robh+dt@kernel.org, b.galvani@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 1/6] pinctrl: amlogic: gxbb: add the IR remote input pin
Date: Sat, 20 Aug 2016 11:54:19 +0200
Message-Id: <20160820095424.636-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160820095424.636-1-martin.blumenstingl@googlemail.com>
References: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
 <20160820095424.636-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds the IR remote receiver to the AO domain devices.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/pinctrl/meson/pinctrl-meson-gxbb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pinctrl/meson/pinctrl-meson-gxbb.c b/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
index cb4d6ad..ff900d1 100644
--- a/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
+++ b/drivers/pinctrl/meson/pinctrl-meson-gxbb.c
@@ -225,6 +225,8 @@ static const unsigned int i2c_sda_ao_pins[] = {PIN(GPIOAO_5, 0) };
 static const unsigned int i2c_slave_sck_ao_pins[] = {PIN(GPIOAO_4, 0) };
 static const unsigned int i2c_slave_sda_ao_pins[] = {PIN(GPIOAO_5, 0) };
 
+static const unsigned int remote_input_ao_pins[] = {PIN(GPIOAO_7, 0) };
+
 static struct meson_pmx_group meson_gxbb_periphs_groups[] = {
 	GPIO_GROUP(GPIOZ_0, EE_OFF),
 	GPIO_GROUP(GPIOZ_1, EE_OFF),
@@ -432,6 +434,7 @@ static struct meson_pmx_group meson_gxbb_aobus_groups[] = {
 	GROUP(i2c_sda_ao,	0,	5),
 	GROUP(i2c_slave_sck_ao, 0,	2),
 	GROUP(i2c_slave_sda_ao, 0,	1),
+	GROUP(remote_input_ao,	0,	0),
 };
 
 static const char * const gpio_periphs_groups[] = {
@@ -521,6 +524,10 @@ static const char * const i2c_slave_ao_groups[] = {
 	"i2c_slave_sdk_ao", "i2c_slave_sda_ao",
 };
 
+static const char * const remote_input_ao_groups[] = {
+	"remote_input_ao",
+};
+
 static struct meson_pmx_func meson_gxbb_periphs_functions[] = {
 	FUNCTION(gpio_periphs),
 	FUNCTION(emmc),
@@ -537,6 +544,7 @@ static struct meson_pmx_func meson_gxbb_aobus_functions[] = {
 	FUNCTION(uart_ao_b),
 	FUNCTION(i2c_ao),
 	FUNCTION(i2c_slave_ao),
+	FUNCTION(remote_input_ao),
 };
 
 static struct meson_bank meson_gxbb_periphs_banks[] = {
-- 
2.9.3

