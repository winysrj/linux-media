Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59452 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1KVGU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 01:20:57 -0500
From: "Zhu, Mingcheng" <mingchen@quicinc.com>
To: Pawel Osciak <pawel@osciak.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v1 2/2] vb2: add support for app_offset field of the
 v4l2_plane struct
Date: Tue, 22 Nov 2011 06:18:44 +0000
Message-ID: <3D233F78EE854A4BA3D34C11AD4FAC1FDCC509@nasanexd01b.na.qualcomm.com>
References: <1321939597-6239-1-git-send-email-pawel@osciak.com>
 <1321939597-6239-3-git-send-email-pawel@osciak.com>
In-Reply-To: <1321939597-6239-3-git-send-email-pawel@osciak.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Pawel for this enhancement. The app_offset is needed in the ICS for the app to store meta data header in recording frame.

--Mingcheng


-----Original Message-----
From: Pawel Osciak [mailto:pawel@osciak.com] 
Sent: Monday, November 21, 2011 9:27 PM
To: linux-media@vger.kernel.org
Cc: Zhu, Mingcheng; hverkuil@xs4all.nl; Pawel Osciak; Marek Szyprowski
Subject: [PATCH v1 2/2] vb2: add support for app_offset field of the v4l2_plane struct

The app_offset can only be set by userspace and will be passed by vb2 to
the driver.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 979e544..41cc8e9 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -830,6 +830,11 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 			}
 		}
 
+		/* App offset can only be set by userspace, for all types */
+		for (plane = 0; plane < vb->num_planes; ++plane)
+			v4l2_planes[plane].app_offset =
+				b->m.planes[plane].app_offset;
+
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				v4l2_planes[plane].m.userptr =
-- 
1.7.7.3

