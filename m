Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:58631 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131AbbKJUq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 15:46:57 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, tiwai@suse.de, perex@perex.cz,
	chehabrafael@gmail.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, chris.j.arges@canonical.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Subject: [PATCH MC Next Gen v3 1/6] sound/usb: Fix media_stream_delete() to remove intf devnode
Date: Tue, 10 Nov 2015 13:40:44 -0700
Message-Id: <192c21ec5392e122c22caeca2b19f50fea4440b0.1447184000.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1447183999.git.shuahkh@osg.samsung.com>
References: <cover.1447183999.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1447183999.git.shuahkh@osg.samsung.com>
References: <cover.1447183999.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

media_stream_delete() doesn't remove intf_devnode. Fix it to
call media_devnode_remove() to remove the intf_devnode.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 sound/usb/media.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/media.c b/sound/usb/media.c
index 9b455ad..0cbfee6 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -173,6 +173,7 @@ void media_stream_delete(struct snd_usb_substream *subs)
 		mdev = media_device_find_devres(&subs->dev->dev);
 		if (mdev) {
 			media_entity_remove_links(&mctl->media_entity);
+			media_devnode_remove(mctl->intf_devnode);
 			media_device_unregister_entity(&mctl->media_entity);
 			media_entity_cleanup(&mctl->media_entity);
 		}
-- 
2.5.0

