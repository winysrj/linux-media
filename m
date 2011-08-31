Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1HaScQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 14:32:16 -0400
Message-ID: <4E5E7E2B.90603@redhat.com>
Date: Wed, 31 Aug 2011 15:32:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 02/21] [media] tuner/xc2028: Fix frequency offset for
 radio mode.
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de> <1312442059-23935-3-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-3-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-08-2011 04:14, Thierry Reding escreveu:
> In radio mode, no frequency offset is needed. While at it, split off the
> frequency offset computation for digital TV into a separate function.

Nah, it is better to keep the offset calculation there. there is already
a set_freq for DVB. breaking the frequency logic even further seems to
increase the driver's logic. Also, patch is simpler and easier to review.

The patch bellow seems to be better. On a quick review, I think that the 
	send_seq(priv, {0x00, 0x00})
sequence may be wrong. I suspect that the device is just discarding that,
but changing it needs more testing.

-

[media] tuner/xc2028: Fix frequency offset for radio mode

In radio mode, no frequency offset should be used.
  
Instead of taking Thierry's patch that creates a separate function
to calculate the digital offset, it seemed better to just keep
everything at the same place.

Reported-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index b6b2868..3acbaa0 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -940,11 +940,16 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 	 * that xc2028 will be in a safe state.
 	 * Maybe this might also be needed for DTV.
 	 */
-	if (new_type == V4L2_TUNER_ANALOG_TV) {
+	switch (new_type) {
+	case V4L2_TUNER_ANALOG_TV:
 		rc = send_seq(priv, {0x00, 0x00});
 
-		/* Analog modes require offset = 0 */
-	} else {
+		/* Analog mode requires offset = 0 */
+		break;
+	case V4L2_TUNER_RADIO:
+		/* Radio mode requires offset = 0 */
+		break;
+	case V4L2_TUNER_DIGITAL_TV:
 		/*
 		 * Digital modes require an offset to adjust to the
 		 * proper frequency. The offset depends on what
