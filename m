Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:53595 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZEaGmA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 02:42:00 -0400
Received: by pzk7 with SMTP id 7so5453187pzk.33
        for <linux-media@vger.kernel.org>; Sat, 30 May 2009 23:42:02 -0700 (PDT)
Subject: [PATCH] ov511.c: video_register_device() return zero on success
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kraxel@bytesex.org,
	Hans Verkuil <hverkuil@xs4all.nl>, mark@alpha.dyndns.org,
	Mark McClelland <mark@alpha.dyndns.org>, cpbotha@ieee.org,
	claudio@conectiva.com
Content-Type: text/plain
Date: Sun, 31 May 2009 14:41:52 +0800
Message-Id: <1243752113.3425.12.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video_register_device() return zero on success, it would not return a positive integer.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
 drivers/media/video/ov511.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 9af5532..816427e 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -5851,7 +5851,7 @@ ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
 			break;
 
 		if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
-			unit_video[i]) >= 0) {
+			unit_video[i]) == 0) {
 			break;
 		}
 	}


