Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:48405 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757AbaKJMtm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 07:49:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv6 PATCH 13/16] videobuf2-dvb.c: convert to vb2_plane_begin_cpu_access()
Date: Mon, 10 Nov 2014 13:49:28 +0100
Message-Id: <1415623771-29634-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl>
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

