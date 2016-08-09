Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:58796 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518AbcHIVlr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:47 -0400
Subject: [PATCH 12/12] drivers/media/media-device: fix double free bug in
 _unregister()
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:33:03 +0200
Message-ID: <147077838352.21835.6880456010787221722.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While removing all interfaces in media_device_unregister(), all
media_interface pointers are freed.  This is illegal and results in
double kfree() if any media_interface is still linked at this point;
maybe because a userspace process still has a file handle.  Once the
process closes the file handle, dvb_media_device_free() gets called,
which frees the dvb_device.intf_devnode again.

This patch removes the unnecessary kfree() call, and documents who's
responsible for really freeing it.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/media-device.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1795abe..113a4d1 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -803,9 +803,13 @@ void media_device_unregister(struct media_device *mdev)
 	/* Remove all interfaces from the media device */
 	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
 				 graph_obj.list) {
+		/*
+		 * Unlink the interface, but don't free it here; the
+		 * module which created it is responsible for freeing
+		 * it
+		 */
 		__media_remove_intf_links(intf);
 		media_gobj_destroy(&intf->graph_obj);
-		kfree(intf);
 	}
 
 	mutex_unlock(&mdev->graph_mutex);

