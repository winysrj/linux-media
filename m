Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46733 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408AbaKGIur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 03:50:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 12/15] videobuf2-dvb.c: convert to vb2_plane_begin_cpu_access()
Date: Fri,  7 Nov 2014 09:50:31 +0100
Message-Id: <1415350234-9826-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dvb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dvb.c b/drivers/media/v4l2-core/videobuf2-dvb.c
index d092698..d954bb8 100644
--- a/drivers/media/v4l2-core/videobuf2-dvb.c
+++ b/drivers/media/v4l2-core/videobuf2-dvb.c
@@ -30,9 +30,12 @@ MODULE_LICENSE("GPL");
 static int dvb_fnc(struct vb2_buffer *vb, void *priv)
 {
 	struct vb2_dvb *dvb = priv;
+	void *p = vb2_plane_begin_cpu_access(vb, 0);
 
-	dvb_dmx_swfilter(&dvb->demux, vb2_plane_vaddr(vb, 0),
-				      vb2_get_plane_payload(vb, 0));
+	if (p == NULL)
+		return -ENOMEM;
+	dvb_dmx_swfilter(&dvb->demux, p, vb2_get_plane_payload(vb, 0));
+	vb2_plane_end_cpu_access(vb, 0);
 	return 0;
 }
 
-- 
2.1.1

