Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59392 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaCNAOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/17] rtl28xxu: constify demod config structs
Date: Fri, 14 Mar 2014 02:14:21 +0200
Message-Id: <1394756071-22410-8-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-1-git-send-email-crope@iki.fi>
References: <1394756071-22410-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Optimize a little bit from data to text.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index ae07740..db98f1c 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -516,7 +516,7 @@ err:
 	return ret;
 }
 
-static struct rtl2830_config rtl28xxu_rtl2830_mt2060_config = {
+static const struct rtl2830_config rtl28xxu_rtl2830_mt2060_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
 	.ts_mode = 0,
@@ -527,7 +527,7 @@ static struct rtl2830_config rtl28xxu_rtl2830_mt2060_config = {
 
 };
 
-static struct rtl2830_config rtl28xxu_rtl2830_qt1010_config = {
+static const struct rtl2830_config rtl28xxu_rtl2830_qt1010_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
 	.ts_mode = 0,
@@ -537,7 +537,7 @@ static struct rtl2830_config rtl28xxu_rtl2830_qt1010_config = {
 	.agc_targ_val = 0x2d,
 };
 
-static struct rtl2830_config rtl28xxu_rtl2830_mxl5005s_config = {
+static const struct rtl2830_config rtl28xxu_rtl2830_mxl5005s_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
 	.ts_mode = 0,
@@ -551,7 +551,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2830_config *rtl2830_config;
+	const struct rtl2830_config *rtl2830_config;
 	int ret;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
@@ -586,31 +586,31 @@ err:
 	return ret;
 }
 
-static struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
+static const struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
 	.tuner = TUNER_RTL2832_FC0012
 };
 
-static struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
+static const struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
 	.tuner = TUNER_RTL2832_FC0013
 };
 
-static struct rtl2832_config rtl28xxu_rtl2832_tua9001_config = {
+static const struct rtl2832_config rtl28xxu_rtl2832_tua9001_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
 	.tuner = TUNER_RTL2832_TUA9001,
 };
 
-static struct rtl2832_config rtl28xxu_rtl2832_e4000_config = {
+static const struct rtl2832_config rtl28xxu_rtl2832_e4000_config = {
 	.i2c_addr = 0x10, /* 0x20 */
 	.xtal = 28800000,
 	.tuner = TUNER_RTL2832_E4000,
 };
 
-static struct rtl2832_config rtl28xxu_rtl2832_r820t_config = {
+static const struct rtl2832_config rtl28xxu_rtl2832_r820t_config = {
 	.i2c_addr = 0x10,
 	.xtal = 28800000,
 	.tuner = TUNER_RTL2832_R820T,
@@ -734,7 +734,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	int ret;
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_priv *priv = d_to_priv(d);
-	struct rtl2832_config *rtl2832_config;
+	const struct rtl2832_config *rtl2832_config;
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-- 
1.8.5.3

