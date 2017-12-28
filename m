Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:13537 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751220AbdL1VYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 16:24:03 -0500
Date: Fri, 29 Dec 2017 05:23:40 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Satendra Singh Thakur <satendra.t@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>
Subject: [linuxtv-media:master 3281/3294]
 drivers/media/dvb-core/dvb_vb2.c:173: undefined reference to
 `vb2_core_queue_init'
Message-ID: <201712290533.51vYjzoI%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   201b56737f4ea59ee840ebdb88a9970ea6d49cf1
commit: 57868acc369ab73ec8f6b43a0c6749077376b189 [3281/3294] media: videobuf2: Add new uAPI for DVB streaming I/O
config: i386-randconfig-s1-201752 (attached as .config)
compiler: gcc-6 (Debian 6.4.0-9) 6.4.0 20171026
reproduce:
        git checkout 57868acc369ab73ec8f6b43a0c6749077376b189
        # save the attached .config to linux build tree
        make ARCH=i386 

Note: the linuxtv-media/master HEAD 201b56737f4ea59ee840ebdb88a9970ea6d49cf1 builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_init':
   drivers/media/dvb-core/dvb_vb2.c:170: undefined reference to `vb2_vmalloc_memops'
>> drivers/media/dvb-core/dvb_vb2.c:173: undefined reference to `vb2_core_queue_init'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_release':
>> drivers/media/dvb-core/dvb_vb2.c:198: undefined reference to `vb2_core_queue_release'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_stream_on':
>> drivers/media/dvb-core/dvb_vb2.c:211: undefined reference to `vb2_core_streamon'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_stream_off':
>> drivers/media/dvb-core/dvb_vb2.c:238: undefined reference to `vb2_buffer_done'
>> drivers/media/dvb-core/dvb_vb2.c:242: undefined reference to `vb2_core_streamoff'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_fill_buffer':
   drivers/media/dvb-core/dvb_vb2.c:294: undefined reference to `vb2_buffer_done'
>> drivers/media/dvb-core/dvb_vb2.c:301: undefined reference to `vb2_plane_vaddr'
   drivers/media/dvb-core/dvb_vb2.c:310: undefined reference to `vb2_buffer_done'
   drivers/media/dvb-core/dvb_vb2.c:317: undefined reference to `vb2_buffer_done'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_reqbufs':
>> drivers/media/dvb-core/dvb_vb2.c:336: undefined reference to `vb2_core_reqbufs'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_querybuf':
>> drivers/media/dvb-core/dvb_vb2.c:352: undefined reference to `vb2_core_querybuf'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_expbuf':
>> drivers/media/dvb-core/dvb_vb2.c:362: undefined reference to `vb2_core_expbuf'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_qbuf':
>> drivers/media/dvb-core/dvb_vb2.c:378: undefined reference to `vb2_core_qbuf'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_dqbuf':
>> drivers/media/dvb-core/dvb_vb2.c:393: undefined reference to `vb2_core_dqbuf'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_mmap':
>> drivers/media/dvb-core/dvb_vb2.c:407: undefined reference to `vb2_mmap'
   drivers/media/dvb-core/dvb_vb2.o: In function `dvb_vb2_poll':
>> drivers/media/dvb-core/dvb_vb2.c:421: undefined reference to `vb2_core_poll'

vim +173 drivers/media/dvb-core/dvb_vb2.c

   151	
   152	/*
   153	 * Videobuf operations
   154	 */
   155	int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int nonblocking)
   156	{
   157		struct vb2_queue *q = &ctx->vb_q;
   158		int ret;
   159	
   160		memset(ctx, 0, sizeof(struct dvb_vb2_ctx));
   161		q->type = DVB_BUF_TYPE_CAPTURE;
   162		/**capture type*/
   163		q->is_output = 0;
   164		/**only mmap is supported currently*/
   165		q->io_modes = VB2_MMAP;
   166		q->drv_priv = ctx;
   167		q->buf_struct_size = sizeof(struct dvb_buffer);
   168		q->min_buffers_needed = 1;
   169		q->ops = &dvb_vb2_qops;
 > 170		q->mem_ops = &vb2_vmalloc_memops;
   171		q->buf_ops = &dvb_vb2_buf_ops;
   172		q->num_buffers = 0;
 > 173		ret = vb2_core_queue_init(q);
   174		if (ret) {
   175			ctx->state = DVB_VB2_STATE_NONE;
   176			dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
   177			return ret;
   178		}
   179	
   180		mutex_init(&ctx->mutex);
   181		spin_lock_init(&ctx->slock);
   182		INIT_LIST_HEAD(&ctx->dvb_q);
   183	
   184		strncpy(ctx->name, name, DVB_VB2_NAME_MAX);
   185		ctx->nonblocking = nonblocking;
   186		ctx->state = DVB_VB2_STATE_INIT;
   187	
   188		dprintk(3, "[%s]\n", ctx->name);
   189	
   190		return 0;
   191	}
   192	
   193	int dvb_vb2_release(struct dvb_vb2_ctx *ctx)
   194	{
   195		struct vb2_queue *q = (struct vb2_queue *)&ctx->vb_q;
   196	
   197		if (ctx->state & DVB_VB2_STATE_INIT)
 > 198			vb2_core_queue_release(q);
   199	
   200		ctx->state = DVB_VB2_STATE_NONE;
   201		dprintk(3, "[%s]\n", ctx->name);
   202	
   203		return 0;
   204	}
   205	
   206	int dvb_vb2_stream_on(struct dvb_vb2_ctx *ctx)
   207	{
   208		struct vb2_queue *q = &ctx->vb_q;
   209		int ret;
   210	
 > 211		ret = vb2_core_streamon(q, q->type);
   212		if (ret) {
   213			ctx->state = DVB_VB2_STATE_NONE;
   214			dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
   215			return ret;
   216		}
   217		ctx->state |= DVB_VB2_STATE_STREAMON;
   218		dprintk(3, "[%s]\n", ctx->name);
   219	
   220		return 0;
   221	}
   222	
   223	int dvb_vb2_stream_off(struct dvb_vb2_ctx *ctx)
   224	{
   225		struct vb2_queue *q = (struct vb2_queue *)&ctx->vb_q;
   226		int ret;
   227		unsigned long flags = 0;
   228	
   229		ctx->state &= ~DVB_VB2_STATE_STREAMON;
   230		spin_lock_irqsave(&ctx->slock, flags);
   231		while (!list_empty(&ctx->dvb_q)) {
   232			struct dvb_buffer       *buf;
   233	
   234			buf = list_entry(ctx->dvb_q.next,
   235					 struct dvb_buffer, list);
   236			list_del(&buf->list);
   237			spin_unlock_irqrestore(&ctx->slock, flags);
 > 238			vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
   239			spin_lock_irqsave(&ctx->slock, flags);
   240		}
   241		spin_unlock_irqrestore(&ctx->slock, flags);
 > 242		ret = vb2_core_streamoff(q, q->type);
   243		if (ret) {
   244			ctx->state = DVB_VB2_STATE_NONE;
   245			dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
   246			return ret;
   247		}
   248		dprintk(3, "[%s]\n", ctx->name);
   249	
   250		return 0;
   251	}
   252	
   253	int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx)
   254	{
   255		return (ctx->state & DVB_VB2_STATE_STREAMON);
   256	}
   257	
   258	int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
   259				const unsigned char *src, int len)
   260	{
   261		unsigned long flags = 0;
   262		void *vbuf = NULL;
   263		int todo = len;
   264		unsigned char *psrc = (unsigned char *)src;
   265		int ll = 0;
   266	
   267		dprintk(3, "[%s] %d bytes are rcvd\n", ctx->name, len);
   268		if (!src) {
   269			dprintk(3, "[%s]:NULL pointer src\n", ctx->name);
   270			/**normal case: This func is called twice from demux driver
   271			 * once with valid src pointer, second time with NULL pointer
   272			 */
   273			return 0;
   274		}
   275		while (todo) {
   276			if (!ctx->buf) {
   277				spin_lock_irqsave(&ctx->slock, flags);
   278				if (list_empty(&ctx->dvb_q)) {
   279					spin_unlock_irqrestore(&ctx->slock, flags);
   280					dprintk(3, "[%s] Buffer overflow!!!\n",
   281						ctx->name);
   282					break;
   283				}
   284	
   285				ctx->buf = list_entry(ctx->dvb_q.next,
   286						      struct dvb_buffer, list);
   287				list_del(&ctx->buf->list);
   288				spin_unlock_irqrestore(&ctx->slock, flags);
   289				ctx->remain = vb2_plane_size(&ctx->buf->vb, 0);
   290				ctx->offset = 0;
   291			}
   292	
   293			if (!dvb_vb2_is_streaming(ctx)) {
 > 294				vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_ERROR);
   295				ctx->buf = NULL;
   296				break;
   297			}
   298	
   299			/* Fill buffer */
   300			ll = min(todo, ctx->remain);
 > 301			vbuf = vb2_plane_vaddr(&ctx->buf->vb, 0);
   302			memcpy(vbuf + ctx->offset, psrc, ll);
   303			todo -= ll;
   304			psrc += ll;
   305	
   306			ctx->remain -= ll;
   307			ctx->offset += ll;
   308	
   309			if (ctx->remain == 0) {
 > 310				vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_DONE);
   311				ctx->buf = NULL;
   312			}
   313		}
   314	
   315		if (ctx->nonblocking && ctx->buf) {
   316			vb2_set_plane_payload(&ctx->buf->vb, 0, ll);
   317			vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_DONE);
   318			ctx->buf = NULL;
   319		}
   320	
   321		if (todo)
   322			dprintk(1, "[%s] %d bytes are dropped.\n", ctx->name, todo);
   323		else
   324			dprintk(3, "[%s]\n", ctx->name);
   325	
   326		dprintk(3, "[%s] %d bytes are copied\n", ctx->name, len - todo);
   327		return (len - todo);
   328	}
   329	
   330	int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req)
   331	{
   332		int ret;
   333	
   334		ctx->buf_siz = req->size;
   335		ctx->buf_cnt = req->count;
 > 336		ret = vb2_core_reqbufs(&ctx->vb_q, VB2_MEMORY_MMAP, &req->count);
   337		if (ret) {
   338			ctx->state = DVB_VB2_STATE_NONE;
   339			dprintk(1, "[%s] count=%d size=%d errno=%d\n", ctx->name,
   340				ctx->buf_cnt, ctx->buf_siz, ret);
   341			return ret;
   342		}
   343		ctx->state |= DVB_VB2_STATE_REQBUFS;
   344		dprintk(3, "[%s] count=%d size=%d\n", ctx->name,
   345			ctx->buf_cnt, ctx->buf_siz);
   346	
   347		return 0;
   348	}
   349	
   350	int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
   351	{
 > 352		vb2_core_querybuf(&ctx->vb_q, b->index, b);
   353		dprintk(3, "[%s] index=%d\n", ctx->name, b->index);
   354		return 0;
   355	}
   356	
   357	int dvb_vb2_expbuf(struct dvb_vb2_ctx *ctx, struct dmx_exportbuffer *exp)
   358	{
   359		struct vb2_queue *q = &ctx->vb_q;
   360		int ret;
   361	
 > 362		ret = vb2_core_expbuf(&ctx->vb_q, &exp->fd, q->type, exp->index,
   363				      0, exp->flags);
   364		if (ret) {
   365			dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
   366				exp->index, ret);
   367			return ret;
   368		}
   369		dprintk(3, "[%s] index=%d fd=%d\n", ctx->name, exp->index, exp->fd);
   370	
   371		return 0;
   372	}
   373	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--EeQfGwPcQSOJBaQU
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--EeQfGwPcQSOJBaQU--
