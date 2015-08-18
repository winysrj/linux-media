Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbbHRLuQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 07:50:16 -0400
Date: Tue, 18 Aug 2015 19:46:51 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [renesas-drivers:master 4533/5645]
 drivers/media/platform/rcar_jpu.c:1147:51: sparse: incorrect type in
 assignment (different base types)
Message-ID: <201508181948.np7IQwCc%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git master
head:   d7ba9d1e0b037c24ee7f278fdcf9c44f80f3dbe7
commit: 2c42cdbaec56a9565a2717b450506150c9c55103 [4533/5645] [media] V4L2: platform: Add Renesas R-Car JPEG codec driver
reproduce:
  # apt-get install sparse
  git checkout 2c42cdbaec56a9565a2717b450506150c9c55103
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/platform/rcar_jpu.c:1147:51: sparse: incorrect type in assignment (different base types)
   drivers/media/platform/rcar_jpu.c:1147:51:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/media/platform/rcar_jpu.c:1147:51:    got restricted __be16 [usertype] <noident>
   drivers/media/platform/rcar_jpu.c:1149:50: sparse: incorrect type in assignment (different base types)
   drivers/media/platform/rcar_jpu.c:1149:50:    expected unsigned short [unsigned] [short] [usertype] <noident>
   drivers/media/platform/rcar_jpu.c:1149:50:    got restricted __be16 [usertype] <noident>

vim +1147 drivers/media/platform/rcar_jpu.c

  1131		struct jpu_buffer *jpu_buf = vb2_to_jpu_buffer(vb);
  1132		struct jpu_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
  1133		struct jpu_q_data *q_data = &ctx->out_q;
  1134		enum v4l2_buf_type type = vb->vb2_queue->type;
  1135		u8 *buffer;
  1136	
  1137		if (vb->state == VB2_BUF_STATE_DONE)
  1138			vb->v4l2_buf.sequence = jpu_get_q_data(ctx, type)->sequence++;
  1139	
  1140		if (!ctx->encoder || vb->state != VB2_BUF_STATE_DONE ||
  1141		    V4L2_TYPE_IS_OUTPUT(type))
  1142			return;
  1143	
  1144		buffer = vb2_plane_vaddr(vb, 0);
  1145	
  1146		memcpy(buffer, jpeg_hdrs[jpu_buf->compr_quality], JPU_JPEG_HDR_SIZE);
> 1147		*(u16 *)(buffer + JPU_JPEG_HEIGHT_OFFSET) =
  1148						cpu_to_be16(q_data->format.height);
  1149		*(u16 *)(buffer + JPU_JPEG_WIDTH_OFFSET) =
  1150						cpu_to_be16(q_data->format.width);
  1151		*(buffer + JPU_JPEG_SUBS_OFFSET) = q_data->fmtinfo->subsampling;
  1152	}
  1153	
  1154	static int jpu_start_streaming(struct vb2_queue *vq, unsigned count)
  1155	{

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
