Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.meprolight.com ([194.90.149.17]:37015 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752421Ab2HAO1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 10:27:18 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 1 Aug 2012 17:27:24 +0300
Subject: RE: [PATCH v2] media: mx3_camera: buf_init() add buffer state check
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2E31A0CA1D@MEP-EXCH.meprolight.com>
References: <1343675227-9061-1-git-send-email-alexg@meprolight.com>,<Pine.LNX.4.64.1208011002020.5406@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1208011002020.5406@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


From: Alex Gershgorin <alexg@meprolight.com>

This patch check the state of the buffer when calling buf_init() method.
The thread http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/48587
also includes report witch can show the problem. This patch solved the problem.
Both MMAP and USERPTR methods was successfully tested.

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
[g.liakhovetski@gmx.de: remove mx3_camera_buffer::state completely]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

> > Hi Alex

> > Thanks for your explanation. Please, check whether this version of your
> > patch also fixes the problem and works in both MMAP and USERPTR modes.

> > Thanks
> > Guennadi

Hi Guennadi,

This is a good upgrade :-)
 I tested both modes, it works fine without any problems.

Sincerely,
Alex

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 02d54a0..0af24d0 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -61,15 +61,9 @@

 #define MAX_VIDEO_MEM 16

-enum csi_buffer_state {
-       CSI_BUF_NEEDS_INIT,
-       CSI_BUF_PREPARED,
-};
-
 struct mx3_camera_buffer {
        /* common v4l buffer stuff -- must be first */
        struct vb2_buffer                       vb;
-       enum csi_buffer_state                   state;
        struct list_head                        queue;

        /* One descriptot per scatterlist (per frame) */
@@ -285,7 +279,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
                goto error;
        }

-       if (buf->state == CSI_BUF_NEEDS_INIT) {
+       if (!buf->txd) {
                sg_dma_address(sg)      = vb2_dma_contig_plane_dma_addr(vb, 0);
                sg_dma_len(sg)          = new_size;

@@ -298,7 +292,6 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
                txd->callback_param     = txd;
                txd->callback           = mx3_cam_dma_done;

-               buf->state              = CSI_BUF_PREPARED;
                buf->txd                = txd;
        } else {
                txd = buf->txd;
@@ -385,7 +378,6 @@ static void mx3_videobuf_release(struct vb2_buffer *vb)

        /* Doesn't hurt also if the list is empty */
        list_del_init(&buf->queue);
-       buf->state = CSI_BUF_NEEDS_INIT;

        if (txd) {
                buf->txd = NULL;
@@ -405,13 +397,13 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
        struct mx3_camera_dev *mx3_cam = ici->priv;
        struct mx3_camera_buffer *buf = to_mx3_vb(vb);

-       /* This is for locking debugging only */
-       INIT_LIST_HEAD(&buf->queue);
-       sg_init_table(&buf->sg, 1);
+       if (!buf->txd) {
+               /* This is for locking debugging only */
+               INIT_LIST_HEAD(&buf->queue);
+               sg_init_table(&buf->sg, 1);

-       buf->state = CSI_BUF_NEEDS_INIT;
-
-       mx3_cam->buf_total += vb2_plane_size(vb, 0);
+               mx3_cam->buf_total += vb2_plane_size(vb, 0);
+       }

        return 0;
 }