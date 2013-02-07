Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1427 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905Ab3BGRH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 12:07:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC PATCH] ivtv-alsa: regression fix: remove __init from ivtv_alsa_load
Date: Thu, 7 Feb 2013 18:07:47 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302071807.47221.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy,

Please review this patch. This fix probably should be fast-tracked to 3.8 and
queued for stable 3.7.

ivtv-alsa kept crashing my machine every time I loaded it, and this is the
cause.

Regards,

	Hans

This function is called after initialization, so it should never be marked
__init!

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 4a221c6..e970cfa 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -205,7 +205,7 @@ err_exit:
 	return ret;
 }
 
-static int __init ivtv_alsa_load(struct ivtv *itv)
+static int ivtv_alsa_load(struct ivtv *itv)
 {
 	struct v4l2_device *v4l2_dev = &itv->v4l2_dev;
 	struct ivtv_stream *s;
-- 
1.7.10.4

