Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37138 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0LTMxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 07:53:38 -0500
Date: Mon, 20 Dec 2010 15:53:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Richard =?iso-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] [media] timblogiw: too large value for strncpy()
Message-ID: <20101220125316.GW1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a copy and paste error.  It should be using sizeof(cap->driver)
instead of sizeof(cap->card).

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index cf48aa9..ef1b7a5 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -241,7 +241,7 @@ static int timblogiw_querycap(struct file *file, void  *priv,
 	dev_dbg(&vdev->dev, "%s: Entry\n",  __func__);
 	memset(cap, 0, sizeof(*cap));
 	strncpy(cap->card, TIMBLOGIWIN_NAME, sizeof(cap->card)-1);
-	strncpy(cap->driver, DRIVER_NAME, sizeof(cap->card)-1);
+	strncpy(cap->driver, DRIVER_NAME, sizeof(cap->driver) - 1);
 	strlcpy(cap->bus_info, vdev->name, sizeof(cap->bus_info));
 	cap->version = TIMBLOGIW_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
