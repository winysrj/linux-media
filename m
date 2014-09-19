Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44859 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbaISIHj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 04:07:39 -0400
Date: Fri, 19 Sep 2014 16:06:38 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kbuild-all@01.org
Subject: [next:master 6630/6742]
 drivers/media/platform/coda/coda-bit.c:231:4: error: implicit declaration
 of function 'kmalloc'
Message-ID: <541be40e.BU15UVvdJLAqODYA%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   6a10bca9b608df445baa23c3bfafc510d93d425b
commit: 8fdb4a28beeda1e6626c43b70cd0575512173c3a [6630/6742] Merge remote-tracking branch 'v4l-dvb/master'
config: arm-imx_v6_v7_defconfig
reproduce:
  wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
  chmod +x ~/bin/make.cross
  git checkout 8fdb4a28beeda1e6626c43b70cd0575512173c3a
  make.cross ARCH=arm  imx_v6_v7_defconfig
  make.cross ARCH=arm 

All error/warnings:

   drivers/media/platform/coda/coda-bit.c: In function 'coda_fill_bitstream':
>> drivers/media/platform/coda/coda-bit.c:231:4: error: implicit declaration of function 'kmalloc' [-Werror=implicit-function-declaration]
       ts = kmalloc(sizeof(*ts), GFP_KERNEL);
       ^
>> drivers/media/platform/coda/coda-bit.c:231:7: warning: assignment makes pointer from integer without a cast
       ts = kmalloc(sizeof(*ts), GFP_KERNEL);
          ^
   drivers/media/platform/coda/coda-bit.c: In function 'coda_alloc_framebuffers':
>> drivers/media/platform/coda/coda-bit.c:312:3: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
      kfree(name);
      ^
   cc1: some warnings being treated as errors

vim +/kmalloc +231 drivers/media/platform/coda/coda-bit.c

79924ca9 Philipp Zabel 2014-07-23  225  			/*
79924ca9 Philipp Zabel 2014-07-23  226  			 * Source buffer is queued in the bitstream ringbuffer;
79924ca9 Philipp Zabel 2014-07-23  227  			 * queue the timestamp and mark source buffer as done
79924ca9 Philipp Zabel 2014-07-23  228  			 */
79924ca9 Philipp Zabel 2014-07-23  229  			src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
79924ca9 Philipp Zabel 2014-07-23  230  
79924ca9 Philipp Zabel 2014-07-23  231  			ts = kmalloc(sizeof(*ts), GFP_KERNEL);
79924ca9 Philipp Zabel 2014-07-23  232  			if (ts) {
79924ca9 Philipp Zabel 2014-07-23  233  				ts->sequence = src_buf->v4l2_buf.sequence;
79924ca9 Philipp Zabel 2014-07-23  234  				ts->timecode = src_buf->v4l2_buf.timecode;
79924ca9 Philipp Zabel 2014-07-23  235  				ts->timestamp = src_buf->v4l2_buf.timestamp;
79924ca9 Philipp Zabel 2014-07-23  236  				list_add_tail(&ts->list, &ctx->timestamp_list);
79924ca9 Philipp Zabel 2014-07-23  237  			}
79924ca9 Philipp Zabel 2014-07-23  238  
79924ca9 Philipp Zabel 2014-07-23  239  			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
79924ca9 Philipp Zabel 2014-07-23  240  		} else {
79924ca9 Philipp Zabel 2014-07-23  241  			break;
79924ca9 Philipp Zabel 2014-07-23  242  		}
79924ca9 Philipp Zabel 2014-07-23  243  	}
79924ca9 Philipp Zabel 2014-07-23  244  }
79924ca9 Philipp Zabel 2014-07-23  245  
79924ca9 Philipp Zabel 2014-07-23  246  void coda_bit_stream_end_flag(struct coda_ctx *ctx)
79924ca9 Philipp Zabel 2014-07-23  247  {
79924ca9 Philipp Zabel 2014-07-23  248  	struct coda_dev *dev = ctx->dev;
79924ca9 Philipp Zabel 2014-07-23  249  
79924ca9 Philipp Zabel 2014-07-23  250  	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
79924ca9 Philipp Zabel 2014-07-23  251  
f23797b6 Philipp Zabel 2014-08-06  252  	/* If this context is currently running, update the hardware flag */
79924ca9 Philipp Zabel 2014-07-23  253  	if ((dev->devtype->product == CODA_960) &&
79924ca9 Philipp Zabel 2014-07-23  254  	    coda_isbusy(dev) &&
79924ca9 Philipp Zabel 2014-07-23  255  	    (ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX))) {
f23797b6 Philipp Zabel 2014-08-06  256  		coda_write(dev, ctx->bit_stream_param,
f23797b6 Philipp Zabel 2014-08-06  257  			   CODA_REG_BIT_BIT_STREAM_PARAM);
79924ca9 Philipp Zabel 2014-07-23  258  	}
79924ca9 Philipp Zabel 2014-07-23  259  }
79924ca9 Philipp Zabel 2014-07-23  260  
79924ca9 Philipp Zabel 2014-07-23  261  static void coda_parabuf_write(struct coda_ctx *ctx, int index, u32 value)
79924ca9 Philipp Zabel 2014-07-23  262  {
79924ca9 Philipp Zabel 2014-07-23  263  	struct coda_dev *dev = ctx->dev;
79924ca9 Philipp Zabel 2014-07-23  264  	u32 *p = ctx->parabuf.vaddr;
79924ca9 Philipp Zabel 2014-07-23  265  
79924ca9 Philipp Zabel 2014-07-23  266  	if (dev->devtype->product == CODA_DX6)
79924ca9 Philipp Zabel 2014-07-23  267  		p[index] = value;
79924ca9 Philipp Zabel 2014-07-23  268  	else
79924ca9 Philipp Zabel 2014-07-23  269  		p[index ^ 1] = value;
79924ca9 Philipp Zabel 2014-07-23  270  }
79924ca9 Philipp Zabel 2014-07-23  271  
79924ca9 Philipp Zabel 2014-07-23  272  static void coda_free_framebuffers(struct coda_ctx *ctx)
79924ca9 Philipp Zabel 2014-07-23  273  {
79924ca9 Philipp Zabel 2014-07-23  274  	int i;
79924ca9 Philipp Zabel 2014-07-23  275  
79924ca9 Philipp Zabel 2014-07-23  276  	for (i = 0; i < CODA_MAX_FRAMEBUFFERS; i++)
79924ca9 Philipp Zabel 2014-07-23  277  		coda_free_aux_buf(ctx->dev, &ctx->internal_frames[i]);
79924ca9 Philipp Zabel 2014-07-23  278  }
79924ca9 Philipp Zabel 2014-07-23  279  
79924ca9 Philipp Zabel 2014-07-23  280  static int coda_alloc_framebuffers(struct coda_ctx *ctx,
79924ca9 Philipp Zabel 2014-07-23  281  				   struct coda_q_data *q_data, u32 fourcc)
79924ca9 Philipp Zabel 2014-07-23  282  {
79924ca9 Philipp Zabel 2014-07-23  283  	struct coda_dev *dev = ctx->dev;
79924ca9 Philipp Zabel 2014-07-23  284  	int width, height;
79924ca9 Philipp Zabel 2014-07-23  285  	dma_addr_t paddr;
79924ca9 Philipp Zabel 2014-07-23  286  	int ysize;
79924ca9 Philipp Zabel 2014-07-23  287  	int ret;
79924ca9 Philipp Zabel 2014-07-23  288  	int i;
79924ca9 Philipp Zabel 2014-07-23  289  
79924ca9 Philipp Zabel 2014-07-23  290  	if (ctx->codec && (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
79924ca9 Philipp Zabel 2014-07-23  291  	     ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264)) {
79924ca9 Philipp Zabel 2014-07-23  292  		width = round_up(q_data->width, 16);
79924ca9 Philipp Zabel 2014-07-23  293  		height = round_up(q_data->height, 16);
79924ca9 Philipp Zabel 2014-07-23  294  	} else {
79924ca9 Philipp Zabel 2014-07-23  295  		width = round_up(q_data->width, 8);
79924ca9 Philipp Zabel 2014-07-23  296  		height = q_data->height;
79924ca9 Philipp Zabel 2014-07-23  297  	}
79924ca9 Philipp Zabel 2014-07-23  298  	ysize = width * height;
79924ca9 Philipp Zabel 2014-07-23  299  
79924ca9 Philipp Zabel 2014-07-23  300  	/* Allocate frame buffers */
79924ca9 Philipp Zabel 2014-07-23  301  	for (i = 0; i < ctx->num_internal_frames; i++) {
79924ca9 Philipp Zabel 2014-07-23  302  		size_t size;
79924ca9 Philipp Zabel 2014-07-23  303  		char *name;
79924ca9 Philipp Zabel 2014-07-23  304  
79924ca9 Philipp Zabel 2014-07-23  305  		size = ysize + ysize / 2;
79924ca9 Philipp Zabel 2014-07-23  306  		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
79924ca9 Philipp Zabel 2014-07-23  307  		    dev->devtype->product != CODA_DX6)
79924ca9 Philipp Zabel 2014-07-23  308  			size += ysize / 4;
79924ca9 Philipp Zabel 2014-07-23  309  		name = kasprintf(GFP_KERNEL, "fb%d", i);
79924ca9 Philipp Zabel 2014-07-23  310  		ret = coda_alloc_context_buf(ctx, &ctx->internal_frames[i],
79924ca9 Philipp Zabel 2014-07-23  311  					     size, name);
79924ca9 Philipp Zabel 2014-07-23  312  		kfree(name);
79924ca9 Philipp Zabel 2014-07-23  313  		if (ret < 0) {
79924ca9 Philipp Zabel 2014-07-23  314  			coda_free_framebuffers(ctx);
79924ca9 Philipp Zabel 2014-07-23  315  			return ret;

:::::: The code at line 231 was first introduced by commit
:::::: 79924ca9cf95544213d320e3f20d0aff3288e0cb [media] coda: move BIT specific functions into separate file

:::::: TO: Philipp Zabel <p.zabel@pengutronix.de>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
