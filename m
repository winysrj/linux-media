Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:21585 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758835AbcLCA5F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 19:57:05 -0500
Date: Sat, 3 Dec 2016 08:56:17 +0800
From: kbuild test robot <lkp@intel.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH v4 1/9] media: v4l2-mem2mem: extend m2m APIs for more
 accurate buffer management
Message-ID: <201612030839.yeFqAbPP%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1480583001-32236-2-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stanimir,

[auto build test WARNING on linuxtv-media/master]
[also build test WARNING on v4.9-rc7 next-20161202]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Stanimir-Varbanov/Qualcomm-video-decoder-encoder-driver/20161203-054705
base:   git://linuxtv.org/media_tree.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
   include/linux/init.h:1: warning: no structured comments found
   include/linux/workqueue.h:392: warning: No description found for parameter '...'
   include/linux/workqueue.h:392: warning: Excess function parameter 'args' description in 'alloc_workqueue'
   include/linux/workqueue.h:413: warning: No description found for parameter '...'
   include/linux/workqueue.h:413: warning: Excess function parameter 'args' description in 'alloc_ordered_workqueue'
   include/linux/kthread.h:26: warning: No description found for parameter '...'
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   include/linux/fence-array.h:61: warning: No description found for parameter 'fence'
   include/sound/core.h:324: warning: No description found for parameter '...'
   include/sound/core.h:335: warning: No description found for parameter '...'
   include/sound/core.h:388: warning: No description found for parameter '...'
   drivers/media/dvb-core/dvb_frontend.h:677: warning: No description found for parameter 'refcount'
   include/media/media-entity.h:1054: warning: No description found for parameter '...'
>> include/media/v4l2-mem2mem.h:446: warning: No description found for parameter 'b'
   include/media/v4l2-mem2mem.h:454: warning: No description found for parameter 'b'
   include/media/v4l2-mem2mem.h:463: warning: No description found for parameter 'b'
>> include/media/v4l2-mem2mem.h:463: warning: No description found for parameter 'n'
   include/media/v4l2-mem2mem.h:472: warning: No description found for parameter 'b'
   include/media/v4l2-mem2mem.h:472: warning: No description found for parameter 'n'
>> include/media/v4l2-mem2mem.h:533: warning: No description found for parameter 'vbuf'
   include/media/v4l2-mem2mem.h:543: warning: No description found for parameter 'vbuf'
   include/media/v4l2-mem2mem.h:555: warning: No description found for parameter 'vbuf'
   include/net/mac80211.h:3207: ERROR: Unexpected indentation.
   include/net/mac80211.h:3210: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:3212: ERROR: Unexpected indentation.
   include/net/mac80211.h:3213: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/net/mac80211.h:1772: ERROR: Unexpected indentation.
   include/net/mac80211.h:1776: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/sched/fair.c:7259: WARNING: Inline emphasis start-string without end-string.
   kernel/time/timer.c:1240: ERROR: Unexpected indentation.
   kernel/time/timer.c:1242: ERROR: Unexpected indentation.
   kernel/time/timer.c:1243: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:121: WARNING: Block quote ends without a blank line; unexpected unindent.
   include/linux/wait.h:124: ERROR: Unexpected indentation.
   include/linux/wait.h:126: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/time/hrtimer.c:1021: WARNING: Block quote ends without a blank line; unexpected unindent.
   kernel/signal.c:317: WARNING: Inline literal start-string without end-string.
   drivers/base/firmware_class.c:1348: WARNING: Bullet list ends without a blank line; unexpected unindent.
   drivers/message/fusion/mptbase.c:5054: WARNING: Definition list ends without a blank line; unexpected unindent.
   drivers/tty/serial/serial_core.c:1893: WARNING: Definition list ends without a blank line; unexpected unindent.
   include/linux/spi/spi.h:369: ERROR: Unexpected indentation.
   WARNING: dvipng command 'dvipng' cannot be run (needed for math display), check the imgmath_dvipng setting

vim +/b +446 include/media/v4l2-mem2mem.h

   440	 * v4l2_m2m_for_each_dst_buf() - iterate over a list of destination ready
   441	 * buffers
   442	 *
   443	 * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
   444	 */
   445	#define v4l2_m2m_for_each_dst_buf(m2m_ctx, b)	\
 > 446		list_for_each_entry(b, &m2m_ctx->cap_q_ctx.rdy_queue, list)
   447	
   448	/**
   449	 * v4l2_m2m_for_each_src_buf() - iterate over a list of source ready buffers
   450	 *
   451	 * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
   452	 */
   453	#define v4l2_m2m_for_each_src_buf(m2m_ctx, b)	\
   454		list_for_each_entry(b, &m2m_ctx->out_q_ctx.rdy_queue, list)
   455	
   456	/**
   457	 * v4l2_m2m_for_each_dst_buf_safe() - iterate over a list of destination ready
   458	 * buffers safely
   459	 *
   460	 * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
   461	 */
   462	#define v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, b, n)	\
 > 463		list_for_each_entry_safe(b, n, &m2m_ctx->cap_q_ctx.rdy_queue, list)
   464	
   465	/**
   466	 * v4l2_m2m_for_each_src_buf_safe() - iterate over a list of source ready
   467	 * buffers safely
   468	 *
   469	 * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
   470	 */
   471	#define v4l2_m2m_for_each_src_buf_safe(m2m_ctx, b, n)	\
   472		list_for_each_entry_safe(b, n, &m2m_ctx->out_q_ctx.rdy_queue, list)
   473	
   474	/**
   475	 * v4l2_m2m_get_src_vq() - return vb2_queue for source buffers
   476	 *
   477	 * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
   478	 */
   479	static inline
   480	struct vb2_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
   481	{
   482		return &m2m_ctx->out_q_ctx.q;
   483	}
   484	
   485	/**
   486	 * v4l2_m2m_get_dst_vq() - return vb2_queue for destination buffers
   487	 *
   488	 * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
   489	 */
   490	static inline
   491	struct vb2_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
   492	{
   493		return &m2m_ctx->cap_q_ctx.q;
   494	}
   495	
   496	/**
   497	 * v4l2_m2m_buf_remove() - take off a buffer from the list of ready buffers and
   498	 * return it
   499	 *
   500	 * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
   501	 */
   502	void *v4l2_m2m_buf_remove(struct v4l2_m2m_queue_ctx *q_ctx);
   503	
   504	/**
   505	 * v4l2_m2m_src_buf_remove() - take off a source buffer from the list of ready
   506	 * buffers and return it
   507	 *
   508	 * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
   509	 */
   510	static inline void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
   511	{
   512		return v4l2_m2m_buf_remove(&m2m_ctx->out_q_ctx);
   513	}
   514	
   515	/**
   516	 * v4l2_m2m_dst_buf_remove() - take off a destination buffer from the list of
   517	 * ready buffers and return it
   518	 *
   519	 * @m2m_ctx: m2m context assigned to the instance given by struct &v4l2_m2m_ctx
   520	 */
   521	static inline void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
   522	{
   523		return v4l2_m2m_buf_remove(&m2m_ctx->cap_q_ctx);
   524	}
   525	
   526	/**
   527	 * v4l2_m2m_buf_remove_exact() - take off exact buffer from the list of ready
   528	 * buffers
   529	 *
   530	 * @q_ctx: pointer to struct @v4l2_m2m_queue_ctx
   531	 */
   532	void v4l2_m2m_buf_remove_exact(struct v4l2_m2m_queue_ctx *q_ctx,
 > 533				       struct vb2_v4l2_buffer *vbuf);
   534	
   535	/**
   536	 * v4l2_m2m_src_buf_remove_exact() - take off exact source buffer from the list

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--cNdxnHkX5QqsyA0e
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--cNdxnHkX5QqsyA0e--
