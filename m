Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab1G1TjE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 15:39:04 -0400
Message-ID: <4E31BACE.2060809@redhat.com>
Date: Thu, 28 Jul 2011 16:38:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alina Friedrichsen <x-alina@gmx.net>
CC: linux-media@vger.kernel.org, rglowery@exemail.com.au
Subject: Re: [PATCH v3] tuner_xc2028: Allow selection of the frequency adjustment
 code for XC3028
References: <20110722183552.169950@gmx.net>
In-Reply-To: <20110722183552.169950@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alina,

Em 22-07-2011 15:35, Alina Friedrichsen escreveu:
> Since many, many kernel releases my Hauppauge WinTV HVR-1400 doesn't work
> anymore, and nobody feels responsible to fix it.

Could you please check if the enclosed patch fixes the tuner issue?

Use it instead of the patch you've made. If it doesn't work, please send us
the dmesg logs with tuner-xc2028 debug enabled.

Thanks!
Mauro

-

cx23885-dvb: Fix demod IF

This device is not using the proper demod IF. Instead of using the
IF macro, it is specifying a IF frequency. This doesn't work, as xc3028
needs to load an specific SCODE for the tuner. In this case, there's
no IF table for 5 MHz.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index ad2fd13..168142e 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -844,7 +844,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			static struct xc2028_ctrl ctl = {
 				.fname   = XC3028L_DEFAULT_FIRMWARE,
 				.max_len = 64,
-				.demod   = 5000,
+				.demod   = XC3028_FE_DIBCOM52,
 				/* This is true for all demods with
 					v36 firmware? */
 				.type    = XC2028_D2633,


