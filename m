Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2795 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab0KPV4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:56:37 -0500
Message-Id: <a205cdcf84cccbe0950adb7b51cf35b2ff06c26f.1289944160.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289944159.git.hverkuil@xs4all.nl>
References: <cover.1289944159.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 16 Nov 2010 22:56:33 +0100
Subject: [RFCv2 PATCH 10/15] et61x251_core: trivial conversion to unlocked_ioctl.
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/et61x251/et61x251_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index a5cfc76..bb16409 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -2530,7 +2530,7 @@ static const struct v4l2_file_operations et61x251_fops = {
 	.owner = THIS_MODULE,
 	.open =    et61x251_open,
 	.release = et61x251_release,
-	.ioctl =   et61x251_ioctl,
+	.unlocked_ioctl =   et61x251_ioctl,
 	.read =    et61x251_read,
 	.poll =    et61x251_poll,
 	.mmap =    et61x251_mmap,
-- 
1.7.0.4

