Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50459 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaCJL7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/15] drx-j: Fix dubious usage of "&" instead of "&&"
Date: Mon, 10 Mar 2014 08:58:54 -0300
Message-Id: <1394452747-5426-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warnings:
	drivers/media/dvb-frontends/drx39xyj/drxj.c:16764:68: warning: dubious: x & !y
	drivers/media/dvb-frontends/drx39xyj/drxj.c:16778:68: warning: dubious: x & !y
	drivers/media/dvb-frontends/drx39xyj/drxj.c:16797:68: warning: dubious: x & !y

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index af3b69ce8c16..1e6dab7e5892 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -16762,12 +16762,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 	case DRX_OOB_MODE_A:
 		if (
 			   /* signal is transmitted inverted */
-			   ((oob_param->spectrum_inverted == true) &
+			   ((oob_param->spectrum_inverted == true) &&
 			    /* and tuner is not mirroring the signal */
 			    (!mirror_freq_spect_oob)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
-			   ((oob_param->spectrum_inverted == false) &
+			   ((oob_param->spectrum_inverted == false) &&
 			    /* and tuner is mirroring the signal */
 			    (mirror_freq_spect_oob))
 		    )
@@ -16780,12 +16780,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 	case DRX_OOB_MODE_B_GRADE_A:
 		if (
 			   /* signal is transmitted inverted */
-			   ((oob_param->spectrum_inverted == true) &
+			   ((oob_param->spectrum_inverted == true) &&
 			    /* and tuner is not mirroring the signal */
 			    (!mirror_freq_spect_oob)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
-			   ((oob_param->spectrum_inverted == false) &
+			   ((oob_param->spectrum_inverted == false) &&
 			    /* and tuner is mirroring the signal */
 			    (mirror_freq_spect_oob))
 		    )
@@ -16799,12 +16799,12 @@ static int ctrl_set_oob(struct drx_demod_instance *demod, struct drxoob *oob_par
 	default:
 		if (
 			   /* signal is transmitted inverted */
-			   ((oob_param->spectrum_inverted == true) &
+			   ((oob_param->spectrum_inverted == true) &&
 			    /* and tuner is not mirroring the signal */
 			    (!mirror_freq_spect_oob)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
-			   ((oob_param->spectrum_inverted == false) &
+			   ((oob_param->spectrum_inverted == false) &&
 			    /* and tuner is mirroring the signal */
 			    (mirror_freq_spect_oob))
 		    )
-- 
1.8.5.3

