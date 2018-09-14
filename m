Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38072 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbeINPLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 11:11:42 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for request_api branch] v4l2-compat-ioctl32.c: fix sparse
 warning
Message-ID: <8867b0c6-8e9e-f6ca-b036-1d06076e0dfa@xs4all.nl>
Date: Fri, 14 Sep 2018 11:57:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this sparse warning:

drivers/media/v4l2-core/v4l2-compat-ioctl32.c:256: warning:
Function parameter or member 'capabilities' not described in 'v4l2_create_buffers32'

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 0028e0be6b5b..f4325329fbd6 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -244,6 +244,7 @@ struct v4l2_format32 {
  *		return: number of created buffers
  * @memory:	buffer memory type
  * @format:	frame format, for which buffers are requested
+ * @capabilities: capabilities of this buffer type.
  * @reserved:	future extensions
  */
 struct v4l2_create_buffers32 {
