Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:47916 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3FFPqP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jun 2013 11:46:15 -0400
Received: by mail-ea0-f180.google.com with SMTP id k10so2868954eaj.11
        for <linux-media@vger.kernel.org>; Thu, 06 Jun 2013 08:46:14 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com, crope@iki.fi
Cc: mkrufky@linuxtv.org, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] r820t: fix imr calibration
Date: Thu,  6 Jun 2013 17:45:42 +0200
Message-Id: <1370533542-4432-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The r820t_imr() calibration function of the Rafael Micro R820T tuner
generates this error at every tune attempt:

r820t 0-001a: No valid PLL values for 2252021 kHz!

The function was inspired by the original Realtek driver for rtl2832 devices
with the r820t tuner; anyway, in the original code the XTAL frequency of
the tuner was expressed in KHz, while in the kernel driver it is expressed
in Hz; so the calibration failed because of an out-of-range initial value.

The final result of the computation is then passed to the r820t_set_mux()
and r820t_set_pll() functions, but the conversion from KHz to Hz is already
correctly implemented. 

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/tuners/r820t.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 4835021..b817110 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1857,9 +1857,9 @@ static int r820t_imr(struct r820t_priv *priv, unsigned imr_mem, bool im_flag)
 	int reg18, reg19, reg1f;
 
 	if (priv->cfg->xtal > 24000000)
-		ring_ref = priv->cfg->xtal / 2;
+		ring_ref = priv->cfg->xtal / 2000;
 	else
-		ring_ref = priv->cfg->xtal;
+		ring_ref = priv->cfg->xtal / 1000;
 
 	n_ring = 15;
 	for (n = 0; n < 16; n++) {
-- 
1.8.3

