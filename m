Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0081.outbound.protection.outlook.com ([104.47.34.81]:45184
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752176AbeBIBWR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 20:22:17 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH v2 8/9] v4l: xilinx: dma: Get scaling and padding factor to calculate DMA params
Date: Thu, 8 Feb 2018 17:22:00 -0800
Message-ID: <1518139320-21906-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get multiplying factor to calculate bpp especially
in case of 10 bit formats.
Get multiplying factor to calculate padding width

Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 29 ++++++++++++++++++++++++++=
---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/pla=
tform/xilinx/xilinx-dma.c
index 664981b..3c2fd02 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -417,6 +417,7 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *vb=
)
        struct xvip_dma_buffer *buf =3D to_xvip_dma_buffer(vbuf);
        struct dma_async_tx_descriptor *desc;
        u32 flags, luma_size;
+       u32 padding_factor_nume, padding_factor_deno, bpl_nume, bpl_deno;
        dma_addr_t addr =3D vb2_dma_contig_plane_dma_addr(vb, 0);

        if (dma->queue.type =3D=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ||
@@ -442,8 +443,15 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *v=
b)
                struct v4l2_pix_format_mplane *pix_mp;

                pix_mp =3D &dma->format.fmt.pix_mp;
+               xvip_width_padding_factor(pix_mp->pixelformat,
+                                         &padding_factor_nume,
+                                         &padding_factor_deno);
+               xvip_bpl_scaling_factor(pix_mp->pixelformat, &bpl_nume,
+                                       &bpl_deno);
                dma->xt.frame_size =3D dma->fmtinfo->num_planes;
-               dma->sgl[0].size =3D pix_mp->width * dma->fmtinfo->bpl_fact=
or;
+               dma->sgl[0].size =3D (pix_mp->width * dma->fmtinfo->bpl_fac=
tor *
+                                   padding_factor_nume * bpl_nume) /
+                                   (padding_factor_deno * bpl_deno);
                dma->sgl[0].icg =3D pix_mp->plane_fmt[0].bytesperline -
                                                        dma->sgl[0].size;
                dma->xt.numf =3D pix_mp->height;
@@ -472,8 +480,15 @@ static void xvip_dma_buffer_queue(struct vb2_buffer *v=
b)
                struct v4l2_pix_format *pix;

                pix =3D &dma->format.fmt.pix;
+               xvip_width_padding_factor(pix->pixelformat,
+                                         &padding_factor_nume,
+                                         &padding_factor_deno);
+               xvip_bpl_scaling_factor(pix->pixelformat, &bpl_nume,
+                                       &bpl_deno);
                dma->xt.frame_size =3D dma->fmtinfo->num_planes;
-               dma->sgl[0].size =3D pix->width * dma->fmtinfo->bpl_factor;
+               dma->sgl[0].size =3D (pix->width * dma->fmtinfo->bpl_factor=
 *
+                                   padding_factor_nume * bpl_nume) /
+                                   (padding_factor_deno * bpl_deno);
                dma->sgl[0].icg =3D pix->bytesperline - dma->sgl[0].size;
                dma->xt.numf =3D pix->height;
                dma->sgl[0].dst_icg =3D dma->sgl[0].size;
@@ -682,6 +697,8 @@ __xvip_dma_try_format(struct xvip_dma *dma,
        unsigned int align;
        unsigned int bpl;
        unsigned int i, hsub, vsub, plane_width, plane_height;
+       unsigned int padding_factor_nume, padding_factor_deno;
+       unsigned int bpl_nume, bpl_deno;

        /* Retrieve format information and select the default format if the
         * requested format isn't supported.
@@ -694,6 +711,10 @@ __xvip_dma_try_format(struct xvip_dma *dma,
        if (IS_ERR(info))
                info =3D xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);

+       xvip_width_padding_factor(info->fourcc, &padding_factor_nume,
+                                 &padding_factor_deno);
+       xvip_bpl_scaling_factor(info->fourcc, &bpl_nume, &bpl_deno);
+
        /* The transfer alignment requirements are expressed in bytes. Comp=
ute
         * the minimum and maximum values, clamp the requested width and co=
nvert
         * it back to pixels.
@@ -737,7 +758,9 @@ __xvip_dma_try_format(struct xvip_dma *dma,
                        for (i =3D 0; i < info->num_planes; i++) {
                                plane_width =3D pix_mp->width / (i ? hsub :=
 1);
                                plane_height =3D pix_mp->height / (i ? vsub=
 : 1);
-                               min_bpl =3D plane_width * info->bpl_factor;
+                               min_bpl =3D (plane_width * info->bpl_factor=
 *
+                                          padding_factor_nume * bpl_nume) =
/
+                                          (padding_factor_deno * bpl_deno)=
;
                                max_bpl =3D rounddown(XVIP_DMA_MAX_WIDTH,
                                                    dma->align);
                                bpl =3D pix_mp->plane_fmt[i].bytesperline;
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
