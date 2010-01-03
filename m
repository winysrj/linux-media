Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:54423 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0ACUfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jan 2010 15:35:07 -0500
Message-ID: <4B40FF73.2060906@freemail.hu>
Date: Sun, 03 Jan 2010 21:34:59 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] rj54n1cb0c: remove compiler warning
References: <201001031950.o03JoIjh012466@smtp-vbr4.xs4all.nl>
In-Reply-To: <201001031950.o03JoIjh012466@smtp-vbr4.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Remove the following compiler warning: 'dummy' is used uninitialized in this function.
Although the result in the dummy variable is not used the program flow in
soc_camera_limit_side() depends on the value in dummy. The program flow is better
to be deterministic.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 62ee2b0f6556 linux/drivers/media/video/rj54n1cb0c.c
--- a/linux/drivers/media/video/rj54n1cb0c.c	Wed Dec 30 18:19:11 2009 +0100
+++ b/linux/drivers/media/video/rj54n1cb0c.c	Sun Jan 03 21:30:20 2010 +0100
@@ -563,7 +563,7 @@
 	struct i2c_client *client = sd->priv;
 	struct rj54n1 *rj54n1 = to_rj54n1(client);
 	struct v4l2_rect *rect = &a->c;
-	unsigned int dummy, output_w, output_h,
+	unsigned int dummy = 0, output_w, output_h,
 		input_w = rect->width, input_h = rect->height;
 	int ret;

