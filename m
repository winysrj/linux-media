Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40161 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab3CJCEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 08/41] af9035: constify clock tables
Date: Sun, 10 Mar 2013 04:03:00 +0200
Message-Id: <1362881013-5271-8-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index f995339..7086ff2 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -61,7 +61,7 @@ struct state {
 	struct af9033_config af9033_config[2];
 };
 
-u32 clock_lut[] = {
+static const u32 clock_lut[] = {
 	20480000, /*      FPGA */
 	16384000, /* 16.38 MHz */
 	20480000, /* 20.48 MHz */
@@ -76,7 +76,7 @@ u32 clock_lut[] = {
 	12000000, /* 12.00 MHz */
 };
 
-u32 clock_lut_it9135[] = {
+static const u32 clock_lut_it9135[] = {
 	12000000, /* 12.00 MHz */
 	20480000, /* 20.48 MHz */
 	36000000, /* 36.00 MHz */
-- 
1.7.11.7

