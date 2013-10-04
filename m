Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4148 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3JDODO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:03:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, Mike Isely <isely@pobox.com>
Subject: [PATCH 02/14] pvrusb2: fix sparse warning
Date: Fri,  4 Oct 2013 16:01:40 +0200
Message-Id: <1380895312-30863-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/pvrusb2/pvrusb2-hdw.c:2871:13: warning: symbol 'pvr2_hdw_get_detected_std' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mike Isely <isely@pobox.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index c4d51d7..ea05f67 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2868,7 +2868,7 @@ static void pvr2_subdev_set_control(struct pvr2_hdw *hdw, int id,
 		pvr2_subdev_set_control(hdw, id, #lab, (hdw)->lab##_val); \
 	}
 
-v4l2_std_id pvr2_hdw_get_detected_std(struct pvr2_hdw *hdw)
+static v4l2_std_id pvr2_hdw_get_detected_std(struct pvr2_hdw *hdw)
 {
 	v4l2_std_id std;
 	std = (v4l2_std_id)hdw->std_mask_avail;
-- 
1.8.3.2

