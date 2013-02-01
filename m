Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3588 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3BAMRe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 07:17:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 5/6] tm6000: add poll op for radio device node.
Date: Fri,  1 Feb 2013 13:17:20 +0100
Message-Id: <0dffdfc9573b75523937c617f3f51eecba379051.1359720708.git.hans.verkuil@cisco.com>
In-Reply-To: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
References: <1359721041-5133-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
References: <db596a5954282c998c516d9a8ebd719df71549b3.1359720708.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tm6000/tm6000-video.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index ac25885..f41dbb1 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1583,6 +1583,7 @@ static struct video_device tm6000_template = {
 static const struct v4l2_file_operations radio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= tm6000_open,
+	.poll		= v4l2_ctrl_poll,
 	.release	= tm6000_release,
 	.unlocked_ioctl	= video_ioctl2,
 };
-- 
1.7.10.4

