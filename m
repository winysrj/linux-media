Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:57190 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751189AbdJ1JT4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 05:19:56 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Todor Tomov <todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] camss-video.c: drop unused header
Message-ID: <70668427-5b11-3ba4-68f5-bbd819d9fcd7@xs4all.nl>
Date: Sat, 28 Oct 2017 11:19:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drop unused vb1 header.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-video.c b/drivers/media/platform/qcom/camss-8x16/camss-video.c
index cf4219e871bd..ffaa2849e0c1 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-video.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-video.c
@@ -21,7 +21,6 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mc.h>
-#include <media/videobuf-core.h>
 #include <media/videobuf2-dma-sg.h>

 #include "camss-video.h"
