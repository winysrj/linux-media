Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47384 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbbJFKvt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Oct 2015 06:51:49 -0400
Date: Tue, 6 Oct 2015 18:51:15 +0800
From: kbuild test robot <lkp@intel.com>
To: Junghak Sung <jh1009.sung@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: Re: [PATCH] media: videobuf2: Add new uAPI for DVB streaming I/O
Message-ID: <201510061848.TgTPWT1j%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1444125542-1256-2-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Junghak,

[auto build test WARNING on v4.3-rc4 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/media/dvb-core/dvb_vb2.c:114:35: sparse: incorrect type in initializer (incompatible argument 2 (different base types))
   drivers/media/dvb-core/dvb_vb2.c:114:35:    expected int ( *queue_setup )( ... )
   drivers/media/dvb-core/dvb_vb2.c:114:35:    got int ( static [toplevel] *<noident> )( ... )
   drivers/media/dvb-core/dvb_vb2.c:128:22: sparse: no member 'index' in struct vb2_buffer
   drivers/media/dvb-core/dvb_vb2.c:129:34: sparse: no member 'length' in struct vb2_plane
   drivers/media/dvb-core/dvb_vb2.c:130:37: sparse: no member 'bytesused' in struct vb2_plane
   drivers/media/dvb-core/dvb_vb2.c:131:34: sparse: no member 'm' in struct vb2_plane
   drivers/media/dvb-core/dvb_vb2.c:143:18: sparse: no member 'bytesused' in struct vb2_plane
   drivers/media/dvb-core/dvb_vb2.c:150:10: sparse: unknown field name in initializer
   drivers/media/dvb-core/dvb_vb2.c:151:10: sparse: unknown field name in initializer
   drivers/media/dvb-core/dvb_vb2.c:170:10: sparse: no member 'buf_ops' in struct vb2_queue
   drivers/media/dvb-core/dvb_vb2.c:173:15: sparse: undefined identifier 'vb2_core_queue_init'
   drivers/media/dvb-core/dvb_vb2.c:198:17: sparse: undefined identifier 'vb2_core_queue_release'
   drivers/media/dvb-core/dvb_vb2.c:211:15: sparse: undefined identifier 'vb2_core_streamon'
   drivers/media/dvb-core/dvb_vb2.c:237:15: sparse: undefined identifier 'vb2_core_streamoff'
   drivers/media/dvb-core/dvb_vb2.c:322:15: sparse: undefined identifier 'vb2_core_reqbufs'
   drivers/media/dvb-core/dvb_vb2.c:340:15: sparse: undefined identifier 'vb2_core_querybuf'
   drivers/media/dvb-core/dvb_vb2.c:356:15: sparse: undefined identifier 'vb2_core_expbuf'
   drivers/media/dvb-core/dvb_vb2.c:372:15: sparse: undefined identifier 'vb2_core_qbuf'
   drivers/media/dvb-core/dvb_vb2.c:387:15: sparse: undefined identifier 'vb2_core_dqbuf'
   drivers/media/dvb-core/dvb_vb2.c:32:5: warning: 'struct vb2_format' declared inside parameter list
        unsigned int sizes[], void *alloc_ctxs[])
        ^
   drivers/media/dvb-core/dvb_vb2.c:32:5: warning: its scope is only this definition or declaration, which is probably not what you want
   drivers/media/dvb-core/dvb_vb2.c:114:18: warning: initialization from incompatible pointer type [-Wincompatible-pointer-types]
     .queue_setup  = _queue_setup,
                     ^
   drivers/media/dvb-core/dvb_vb2.c:114:18: note: (near initialization for 'dvb_vb2_qops.queue_setup')
   drivers/media/dvb-core/dvb_vb2.c: In function '_fill_dmx_buffer':
   drivers/media/dvb-core/dvb_vb2.c:128:15: error: 'struct vb2_buffer' has no member named 'index'
     b->index = vb->index;
                  ^
   drivers/media/dvb-core/dvb_vb2.c:129:27: error: 'struct vb2_plane' has no member named 'length'
     b->length = vb->planes[0].length;
                              ^
   drivers/media/dvb-core/dvb_vb2.c:130:30: error: 'struct vb2_plane' has no member named 'bytesused'
     b->bytesused = vb->planes[0].bytesused;
                                 ^
   drivers/media/dvb-core/dvb_vb2.c:131:27: error: 'struct vb2_plane' has no member named 'm'
     b->offset = vb->planes[0].m.offset;
                              ^
   drivers/media/dvb-core/dvb_vb2.c: In function '_fill_vb2_buffer':
   drivers/media/dvb-core/dvb_vb2.c:143:11: error: 'struct vb2_plane' has no member named 'bytesused'
     planes[0].bytesused = 0;
              ^
   drivers/media/dvb-core/dvb_vb2.c: At top level:
   drivers/media/dvb-core/dvb_vb2.c:149:21: error: variable 'dvb_vb2_buf_ops' has initializer but incomplete type
    static const struct vb2_buf_ops dvb_vb2_buf_ops = {
                        ^
   drivers/media/dvb-core/dvb_vb2.c:150:2: error: unknown field 'fill_user_buffer' specified in initializer
     .fill_user_buffer = _fill_dmx_buffer,
     ^
   drivers/media/dvb-core/dvb_vb2.c:150:22: warning: excess elements in struct initializer
     .fill_user_buffer = _fill_dmx_buffer,
                         ^
   drivers/media/dvb-core/dvb_vb2.c:150:22: note: (near initialization for 'dvb_vb2_buf_ops')
   drivers/media/dvb-core/dvb_vb2.c:151:2: error: unknown field 'fill_vb2_buffer' specified in initializer
     .fill_vb2_buffer = _fill_vb2_buffer,
     ^
   drivers/media/dvb-core/dvb_vb2.c:151:21: warning: excess elements in struct initializer
     .fill_vb2_buffer = _fill_vb2_buffer,
                        ^
   drivers/media/dvb-core/dvb_vb2.c:151:21: note: (near initialization for 'dvb_vb2_buf_ops')
   drivers/media/dvb-core/dvb_vb2.c: In function 'dvb_vb2_init':
   drivers/media/dvb-core/dvb_vb2.c:170:3: error: 'struct vb2_queue' has no member named 'buf_ops'
     q->buf_ops = &dvb_vb2_buf_ops;
      ^
   drivers/media/dvb-core/dvb_vb2.c:173:8: error: implicit declaration of function 'vb2_core_queue_init' [-Werror=implicit-function-declaration]
     ret = vb2_core_queue_init(q);
           ^
   drivers/media/dvb-core/dvb_vb2.c: In function 'dvb_vb2_release':
   drivers/media/dvb-core/dvb_vb2.c:198:3: error: implicit declaration of function 'vb2_core_queue_release' [-Werror=implicit-function-declaration]
      vb2_core_queue_release(q);
      ^
   drivers/media/dvb-core/dvb_vb2.c: In function 'dvb_vb2_stream_on':
   drivers/media/dvb-core/dvb_vb2.c:211:8: error: implicit declaration of function 'vb2_core_streamon' [-Werror=implicit-function-declaration]
     ret = vb2_core_streamon(q, q->type);
           ^
   drivers/media/dvb-core/dvb_vb2.c: In function 'dvb_vb2_stream_off':
   drivers/media/dvb-core/dvb_vb2.c:237:8: error: implicit declaration of function 'vb2_core_streamoff' [-Werror=implicit-function-declaration]
     ret = vb2_core_streamoff(q, q->type);
           ^
   drivers/media/dvb-core/dvb_vb2.c: In function 'dvb_vb2_reqbufs':
   drivers/media/dvb-core/dvb_vb2.c:322:8: error: implicit declaration of function 'vb2_core_reqbufs' [-Werror=implicit-function-declaration]
     ret = vb2_core_reqbufs(&ctx->vb_q, VB2_MEMORY_MMAP, &req->count);
           ^
   drivers/media/dvb-core/dvb_vb2.c:322:37: error: 'VB2_MEMORY_MMAP' undeclared (first use in this function)
     ret = vb2_core_reqbufs(&ctx->vb_q, VB2_MEMORY_MMAP, &req->count);
                                        ^
   drivers/media/dvb-core/dvb_vb2.c:322:37: note: each undeclared identifier is reported only once for each function it appears in
   drivers/media/dvb-core/dvb_vb2.c: In function 'dvb_vb2_querybuf':
   drivers/media/dvb-core/dvb_vb2.c:340:8: error: implicit declaration of function 'vb2_core_querybuf' [-Werror=implicit-function-declaration]
     ret = vb2_core_querybuf(&ctx->vb_q, b->index, b);
           ^
   drivers/media/dvb-core/dvb_vb2.c: In function 'dvb_vb2_expbuf':
   drivers/media/dvb-core/dvb_vb2.c:356:8: error: implicit declaration of function 'vb2_core_expbuf' [-Werror=implicit-function-declaration]
     ret = vb2_core_expbuf(&ctx->vb_q, &exp->fd, q->type, exp->index,
           ^
   drivers/media/dvb-core/dvb_vb2.c: In function 'dvb_vb2_qbuf':
   drivers/media/dvb-core/dvb_vb2.c:372:8: error: implicit declaration of function 'vb2_core_qbuf' [-Werror=implicit-function-declaration]
     ret = vb2_core_qbuf(&ctx->vb_q, b->index, b);

vim +114 drivers/media/dvb-core/dvb_vb2.c

    98		struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
    99	
   100		mutex_lock(&ctx->mutex);
   101		dprintk(3, "[%s]\n", ctx->name);
   102	}
   103	
   104	static void _dmxdev_unlock(struct vb2_queue *vq)
   105	{
   106		struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
   107	
   108		if (mutex_is_locked(&ctx->mutex))
   109			mutex_unlock(&ctx->mutex);
   110		dprintk(3, "[%s]\n", ctx->name);
   111	}
   112	
   113	static const struct vb2_ops dvb_vb2_qops = {
 > 114		.queue_setup		= _queue_setup,
   115		.buf_prepare		= _buffer_prepare,
   116		.buf_queue		= _buffer_queue,
   117		.start_streaming	= _start_streaming,
   118		.stop_streaming		= _stop_streaming,
   119		.wait_prepare		= _dmxdev_unlock,
   120		.wait_finish		= _dmxdev_lock,
   121	};
   122	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
