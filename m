Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01.ipfire.org ([178.63.73.247]:52176 "EHLO
	mail01.ipfire.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2KMIRh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 03:17:37 -0500
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Nov 2012 08:17:34 +0000
From: Arne Fitzenreiter <Arne.Fitzenreiter@ipfire.org>
To: <linux-media@vger.kernel.org>, <mchehab@redhat.com>
Subject: [PATCH] [media] fix tua6034 pll bandwich configuration [resend]
Message-ID: <edefdcacfac7e65ad271d1f649127995@mail01.ipfire.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

i have already send this patch to you and the mailing list around 3 
weeks ago but get no response.
The tua6034 pll is corrupted by your commit [media] dvb-pll: use DVBv5 
parameters on set_params()
http://git.linuxtv.org/media_tree.git/commit/80d8d4985f280dca3c395286d13b49f910a029e7

[SNIP]
 /* Infineon TUA6034
  * used in LG TDTP E102P
  */
-static void tua6034_bw(struct dvb_frontend *fe, u8 *buf,
-                      const struct dvb_frontend_parameters *params)
+static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
 {
-       if (BANDWIDTH_7_MHZ != params->u.ofdm.bandwidth)
+       u32 bw = fe->dtv_property_cache.bandwidth_hz;
+       if (bw == 7000000)
                buf[3] |= 0x08;
 }
[SNIP]

so here is a patch to fix this typo to get the Skymaster DTMU100 
(HANFTEK UMT010 OEM BOX)
working again.

Arne

Signed-off-by: Arne Fitzenreiter <Arne.Fitzenreiter@ipfire.org>

---

diff -Naur a/drivers/media/dvb-frontends/dvb-pll.c 
b/drivers/media/dvb-frontends/dvb-pll.c
--- a/drivers/media/dvb-frontends/dvb-pll.c	2012-08-14 
05:45:22.000000000 +0200
+++ b/drivers/media/dvb-frontends/dvb-pll.c	2012-10-25 
14:06:42.123360189 +0200
@@ -247,7 +247,7 @@
static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
{
	u32 bw = fe->dtv_property_cache.bandwidth_hz;
-	if (bw == 7000000)
+	if (bw != 7000000)
		buf[3] |= 0x08;
}

