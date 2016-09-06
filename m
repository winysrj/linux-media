Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:54898 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752270AbcIFGxU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 02:53:20 -0400
To: Tiffany Lin <tiffany.lin@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: mediatek decoder: compiler/sparse warnings
Message-ID: <dcfce4f9-e50e-74c4-31f7-0f81329f864d@xs4all.nl>
Date: Tue, 6 Sep 2016 08:53:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

I get a bunch of warnings when I compile the decoder driver in my daily build setup:

/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c: In function 'put_fb_to_free':
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c:242:47: warning: cast from pointer to integer of
different size [-Wpointer-to-int-cast]
   list->fb_list[list->write_idx].vdec_fb_va = (u64)fb;
                                               ^
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c: In function 'vdec_h264_decode':
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c:353:24: warning: cast from pointer to integer of
different size [-Wpointer-to-int-cast]
  uint64_t vdec_fb_va = (u64)fb;
                        ^
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c: In function 'vdec_h264_get_fb':
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c:446:7: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
  fb = (struct vdec_fb *)list->fb_list[list->read_idx].vdec_fb_va;
       ^
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c: In function 'vdec_vp9_decode':
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c:794:37: warning: format '%ld' expects argument of type
'long int', but argument 4 has type 'size_t {aka unsigned int}' [-Wformat=]
  mtk_vcodec_debug(inst, "Input BS Size = %ld", bs->size);
                                     ^

^^^^^^ Should be %zu.

/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c: In function 'handle_init_ack_msg':
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c:22:30: warning: cast to pointer from integer of different
size [-Wint-to-pointer-cast]
  struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
                              ^
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c: In function 'vpu_dec_ipi_handler':
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c:41:30: warning: cast to pointer from integer of different
size [-Wint-to-pointer-cast]
  struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
                              ^

sparse: ERRORS
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c:404:16: error: undefined identifier 'kzalloc'
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c:436:9: error: undefined identifier 'kfree'
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c:618:9: error: undefined identifier 'kfree'
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c:404:9: error: implicit declaration of function
'kzalloc' [-Werror=implicit-function-declaration]
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c:404:7: warning: assignment makes pointer from integer
without a cast [-Wint-conversion]
/home/hans/work/build/media-git/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c:436:2: error: implicit declaration of function 'kfree'
[-Werror=implicit-function-declaration]

^^^^ Apparently a slab.h include is missing here that breaks building it with sparse.

Can you look at these and provide a patch fixing these? I'll fold it in the patch series.

Regards,

	Hans
