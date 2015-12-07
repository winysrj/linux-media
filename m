Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:43277 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932649AbbLGSmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 13:42:16 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH v2 MC Next Gen] sound/usb: Fix out of bounds access in media_entity_init()
Date: Mon,  7 Dec 2015 11:42:12 -0700
Message-Id: <1449513732-5482-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the out of bounds access in media_entity_init() found
by KASan. This is a result of media_mixer_init() failing
to allocate memory for all 3 of its pads before calling
media_entity_init(). Fix it to allocate memory for the
right struct media_mixer_ctl instead of struct media_ctl.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

Changes since v1:
Change to address review comment from Takashi Iwai

This patch fixes the mixer patch below:
https://patchwork.linuxtv.org/patch/31827/

 sound/usb/media.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/media.c b/sound/usb/media.c
index bebe27b..b0d283f 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -233,8 +233,8 @@ int media_mixer_init(struct snd_usb_audio *chip)
 		if (mixer->media_mixer_ctl)
 			continue;
 
-		/* allocate media_ctl */
-		mctl = kzalloc(sizeof(struct media_ctl), GFP_KERNEL);
+		/* allocate media_mixer_ctl */
+		mctl = kzalloc(sizeof(*mctl), GFP_KERNEL);
 		if (!mctl)
 			return -ENOMEM;
 
-- 
2.5.0

