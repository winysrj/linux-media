Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40278 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933958AbcCITJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 14:09:52 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to demod enum
Date: Wed,  9 Mar 2016 16:09:24 -0300
Message-Id: <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The enum demod_pad_index list the PADs that an analog TV demod has but
in some decoders the S-Video Y (luminance) and C (chrominance) signals
are carried by different connectors. So a single DEMOD_PAD_IF_INPUT is
not enough and an additional PAD is needed in the case of S-Video for
the additional C signal.

Add a DEMOD_PAD_C_INPUT that can be used for this case and the existing
DEMOD_PAD_IF_INPUT can be used for either Composite or the Y signal.

Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---
Hello,

This change was suggested by Mauro in [0] although is still not clear
if this is the way forward since changing PAD indexes can break the
uAPI depending on how the PADs are looked up. Another alternative is
to have a PAD type as Mauro mentioned on the same email but since the
series are RFC, I'm making this change as an example and hopping that
the patches can help with the discussion.

[0]: http://www.spinics.net/lists/linux-media/msg98042.html

Best regards,
Javier

 include/media/v4l2-mc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 98a938aabdfb..47c00c288a06 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -94,7 +94,8 @@ enum if_aud_dec_pad_index {
  * @DEMOD_NUM_PADS:	Maximum number of output pads.
  */
 enum demod_pad_index {
-	DEMOD_PAD_IF_INPUT,
+	DEMOD_PAD_IF_INPUT, /* S-Video Y input or Composite */
+	DEMOD_PAD_C_INPUT,  /* S-Video C input or Composite */
 	DEMOD_PAD_VID_OUT,
 	DEMOD_PAD_VBI_OUT,
 	DEMOD_PAD_AUDIO_OUT,
-- 
2.5.0

