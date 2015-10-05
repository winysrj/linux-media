Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:42893 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbbJEMgI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 08:36:08 -0400
Date: Mon, 5 Oct 2015 20:35:21 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kbuild-all@01.org, Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: Re: How to fix DocBook parsers for private fields inside #ifdefs
Message-ID: <201510052026.1AEaWSJ2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20151005090348.7937fa4a@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

[auto build test WARNING on v4.3-rc4 -- if it's inappropriate base, please ignore]

reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/linux/init.h:1: warning: no structured comments found
   kernel/sys.c:1: warning: no structured comments found
   drivers/dma-buf/seqno-fence.c:1: warning: no structured comments found
   drivers/dma-buf/reservation.c:1: warning: no structured comments found
   include/linux/reservation.h:1: warning: no structured comments found
   include/media/v4l2-dv-timings.h:29: warning: cannot understand function prototype: 'const struct v4l2_dv_timings v4l2_dv_timings_presets[]; '
   include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'frame_height'
   include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'hfreq'
   include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'vsync'
   include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'active_width'
   include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'polarities'
   include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'interlaced'
   include/media/v4l2-dv-timings.h:147: warning: No description found for parameter 'fmt'
   include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'frame_height'
   include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'hfreq'
   include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'vsync'
   include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'polarities'
   include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'interlaced'
   include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'aspect'
   include/media/v4l2-dv-timings.h:171: warning: No description found for parameter 'fmt'
   include/media/v4l2-dv-timings.h:184: warning: No description found for parameter 'hor_landscape'
   include/media/v4l2-dv-timings.h:184: warning: No description found for parameter 'vert_portrait'
   include/media/videobuf2-core.h:112: warning: No description found for parameter 'get_dmabuf'
>> include/media/videobuf2-core.h:233: warning: Excess struct/union/enum/typedef member 'state' description in 'vb2_buffer'
>> include/media/videobuf2-core.h:233: warning: Excess struct/union/enum/typedef member 'queued_entry' description in 'vb2_buffer'
>> include/media/videobuf2-core.h:233: warning: Excess struct/union/enum/typedef member 'done_entry' description in 'vb2_buffer'
>> include/media/videobuf2-core.h:233: warning: Excess struct/union/enum/typedef member 'planes' description in 'vb2_buffer'
   drivers/media/dvb-core/dvbdev.h:199: warning: Excess function parameter 'device' description in 'dvb_register_device'
   drivers/media/dvb-core/dvbdev.h:199: warning: Excess function parameter 'adapter_nums' description in 'dvb_register_device'
   include/linux/hsi/hsi.h:150: warning: Excess struct/union/enum/typedef member 'e_handler' description in 'hsi_client'
   include/linux/hsi/hsi.h:150: warning: Excess struct/union/enum/typedef member 'pclaimed' description in 'hsi_client'
   include/linux/hsi/hsi.h:150: warning: Excess struct/union/enum/typedef member 'nb' description in 'hsi_client'

vim +233 include/media/videobuf2-core.h

e23ccc0a Pawel Osciak          2010-10-11  106  	void		*(*vaddr)(void *buf_priv);
e23ccc0a Pawel Osciak          2010-10-11  107  	void		*(*cookie)(void *buf_priv);
e23ccc0a Pawel Osciak          2010-10-11  108  
e23ccc0a Pawel Osciak          2010-10-11  109  	unsigned int	(*num_users)(void *buf_priv);
e23ccc0a Pawel Osciak          2010-10-11  110  
e23ccc0a Pawel Osciak          2010-10-11  111  	int		(*mmap)(void *buf_priv, struct vm_area_struct *vma);
e23ccc0a Pawel Osciak          2010-10-11 @112  };
e23ccc0a Pawel Osciak          2010-10-11  113  
e23ccc0a Pawel Osciak          2010-10-11  114  struct vb2_plane {
e23ccc0a Pawel Osciak          2010-10-11  115  	void			*mem_priv;
c5384048 Sumit Semwal          2012-06-14  116  	struct dma_buf		*dbuf;
c5384048 Sumit Semwal          2012-06-14  117  	unsigned int		dbuf_mapped;
e23ccc0a Pawel Osciak          2010-10-11  118  };
e23ccc0a Pawel Osciak          2010-10-11  119  
e23ccc0a Pawel Osciak          2010-10-11  120  /**
e23ccc0a Pawel Osciak          2010-10-11  121   * enum vb2_io_modes - queue access methods
e23ccc0a Pawel Osciak          2010-10-11  122   * @VB2_MMAP:		driver supports MMAP with streaming API
e23ccc0a Pawel Osciak          2010-10-11  123   * @VB2_USERPTR:	driver supports USERPTR with streaming API
e23ccc0a Pawel Osciak          2010-10-11  124   * @VB2_READ:		driver supports read() style access
e23ccc0a Pawel Osciak          2010-10-11  125   * @VB2_WRITE:		driver supports write() style access
c5384048 Sumit Semwal          2012-06-14  126   * @VB2_DMABUF:		driver supports DMABUF with streaming API
e23ccc0a Pawel Osciak          2010-10-11  127   */
e23ccc0a Pawel Osciak          2010-10-11  128  enum vb2_io_modes {
e23ccc0a Pawel Osciak          2010-10-11  129  	VB2_MMAP	= (1 << 0),
e23ccc0a Pawel Osciak          2010-10-11  130  	VB2_USERPTR	= (1 << 1),
e23ccc0a Pawel Osciak          2010-10-11  131  	VB2_READ	= (1 << 2),
e23ccc0a Pawel Osciak          2010-10-11  132  	VB2_WRITE	= (1 << 3),
c5384048 Sumit Semwal          2012-06-14  133  	VB2_DMABUF	= (1 << 4),
e23ccc0a Pawel Osciak          2010-10-11  134  };
e23ccc0a Pawel Osciak          2010-10-11  135  
e23ccc0a Pawel Osciak          2010-10-11  136  /**
e23ccc0a Pawel Osciak          2010-10-11  137   * enum vb2_buffer_state - current video buffer state
e23ccc0a Pawel Osciak          2010-10-11  138   * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
b18a8ff2 Hans Verkuil          2013-12-13  139   * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
ebc087d0 Guennadi Liakhovetski 2011-08-31  140   * @VB2_BUF_STATE_PREPARED:	buffer prepared in videobuf and by the driver
e23ccc0a Pawel Osciak          2010-10-11  141   * @VB2_BUF_STATE_QUEUED:	buffer queued in videobuf, but not in driver
6d058c56 Sakari Ailus          2015-07-03  142   * @VB2_BUF_STATE_REQUEUEING:	re-queue a buffer to the driver
e23ccc0a Pawel Osciak          2010-10-11  143   * @VB2_BUF_STATE_ACTIVE:	buffer queued in driver and possibly used
e23ccc0a Pawel Osciak          2010-10-11  144   *				in a hardware operation
e23ccc0a Pawel Osciak          2010-10-11  145   * @VB2_BUF_STATE_DONE:		buffer returned from driver to videobuf, but
e23ccc0a Pawel Osciak          2010-10-11  146   *				not yet dequeued to userspace
e23ccc0a Pawel Osciak          2010-10-11  147   * @VB2_BUF_STATE_ERROR:	same as above, but the operation on the buffer
e23ccc0a Pawel Osciak          2010-10-11  148   *				has ended with an error, which will be reported
e23ccc0a Pawel Osciak          2010-10-11  149   *				to the userspace when it is dequeued
e23ccc0a Pawel Osciak          2010-10-11  150   */
e23ccc0a Pawel Osciak          2010-10-11  151  enum vb2_buffer_state {
e23ccc0a Pawel Osciak          2010-10-11  152  	VB2_BUF_STATE_DEQUEUED,
b18a8ff2 Hans Verkuil          2013-12-13  153  	VB2_BUF_STATE_PREPARING,
ebc087d0 Guennadi Liakhovetski 2011-08-31  154  	VB2_BUF_STATE_PREPARED,
e23ccc0a Pawel Osciak          2010-10-11  155  	VB2_BUF_STATE_QUEUED,
6d058c56 Sakari Ailus          2015-07-03  156  	VB2_BUF_STATE_REQUEUEING,
e23ccc0a Pawel Osciak          2010-10-11  157  	VB2_BUF_STATE_ACTIVE,
e23ccc0a Pawel Osciak          2010-10-11  158  	VB2_BUF_STATE_DONE,
e23ccc0a Pawel Osciak          2010-10-11  159  	VB2_BUF_STATE_ERROR,
e23ccc0a Pawel Osciak          2010-10-11  160  };
e23ccc0a Pawel Osciak          2010-10-11  161  
e23ccc0a Pawel Osciak          2010-10-11  162  struct vb2_queue;
e23ccc0a Pawel Osciak          2010-10-11  163  
e23ccc0a Pawel Osciak          2010-10-11  164  /**
e23ccc0a Pawel Osciak          2010-10-11  165   * struct vb2_buffer - represents a video buffer
e23ccc0a Pawel Osciak          2010-10-11  166   * @v4l2_buf:		struct v4l2_buffer associated with this buffer; can
e23ccc0a Pawel Osciak          2010-10-11  167   *			be read by the driver and relevant entries can be
e23ccc0a Pawel Osciak          2010-10-11  168   *			changed by the driver in case of CAPTURE types
e23ccc0a Pawel Osciak          2010-10-11  169   *			(such as timestamp)
e23ccc0a Pawel Osciak          2010-10-11  170   * @v4l2_planes:	struct v4l2_planes associated with this buffer; can
e23ccc0a Pawel Osciak          2010-10-11  171   *			be read by the driver and relevant entries can be
e23ccc0a Pawel Osciak          2010-10-11  172   *			changed by the driver in case of CAPTURE types
e23ccc0a Pawel Osciak          2010-10-11  173   *			(such as bytesused); NOTE that even for single-planar
e23ccc0a Pawel Osciak          2010-10-11  174   *			types, the v4l2_planes[0] struct should be used
e23ccc0a Pawel Osciak          2010-10-11  175   *			instead of v4l2_buf for filling bytesused - drivers
e23ccc0a Pawel Osciak          2010-10-11  176   *			should use the vb2_set_plane_payload() function for that
e23ccc0a Pawel Osciak          2010-10-11  177   * @vb2_queue:		the queue to which this driver belongs
e23ccc0a Pawel Osciak          2010-10-11  178   * @num_planes:		number of planes in the buffer
e23ccc0a Pawel Osciak          2010-10-11  179   *			on an internal driver queue
e23ccc0a Pawel Osciak          2010-10-11  180   * @state:		current buffer state; do not change
e23ccc0a Pawel Osciak          2010-10-11  181   * @queued_entry:	entry on the queued buffers list, which holds all
e23ccc0a Pawel Osciak          2010-10-11  182   *			buffers queued from userspace
e23ccc0a Pawel Osciak          2010-10-11  183   * @done_entry:		entry on the list that stores all buffers ready to
e23ccc0a Pawel Osciak          2010-10-11  184   *			be dequeued to userspace
e23ccc0a Pawel Osciak          2010-10-11  185   * @planes:		private per-plane information; do not change
e23ccc0a Pawel Osciak          2010-10-11  186   */
e23ccc0a Pawel Osciak          2010-10-11  187  struct vb2_buffer {
e23ccc0a Pawel Osciak          2010-10-11  188  	struct v4l2_buffer	v4l2_buf;
e23ccc0a Pawel Osciak          2010-10-11  189  	struct v4l2_plane	v4l2_planes[VIDEO_MAX_PLANES];
e23ccc0a Pawel Osciak          2010-10-11  190  
e23ccc0a Pawel Osciak          2010-10-11  191  	struct vb2_queue	*vb2_queue;
e23ccc0a Pawel Osciak          2010-10-11  192  
e23ccc0a Pawel Osciak          2010-10-11  193  	unsigned int		num_planes;
e23ccc0a Pawel Osciak          2010-10-11  194  
e23ccc0a Pawel Osciak          2010-10-11  195  /* Private: internal use only */
e23ccc0a Pawel Osciak          2010-10-11  196  	enum vb2_buffer_state	state;
e23ccc0a Pawel Osciak          2010-10-11  197  
e23ccc0a Pawel Osciak          2010-10-11  198  	struct list_head	queued_entry;
e23ccc0a Pawel Osciak          2010-10-11  199  	struct list_head	done_entry;
e23ccc0a Pawel Osciak          2010-10-11  200  
e23ccc0a Pawel Osciak          2010-10-11  201  	struct vb2_plane	planes[VIDEO_MAX_PLANES];
b5b4541e Hans Verkuil          2014-01-29  202  
b5b4541e Hans Verkuil          2014-01-29  203  #ifdef CONFIG_VIDEO_ADV_DEBUG
b5b4541e Hans Verkuil          2014-01-29  204  	/*
b5b4541e Hans Verkuil          2014-01-29  205  	 * Counters for how often these buffer-related ops are
b5b4541e Hans Verkuil          2014-01-29  206  	 * called. Used to check for unbalanced ops.
b5b4541e Hans Verkuil          2014-01-29  207  	 */
b5b4541e Hans Verkuil          2014-01-29  208  	u32		cnt_mem_alloc;
b5b4541e Hans Verkuil          2014-01-29  209  	u32		cnt_mem_put;
b5b4541e Hans Verkuil          2014-01-29  210  	u32		cnt_mem_get_dmabuf;
b5b4541e Hans Verkuil          2014-01-29  211  	u32		cnt_mem_get_userptr;
b5b4541e Hans Verkuil          2014-01-29  212  	u32		cnt_mem_put_userptr;
b5b4541e Hans Verkuil          2014-01-29  213  	u32		cnt_mem_prepare;
b5b4541e Hans Verkuil          2014-01-29  214  	u32		cnt_mem_finish;
b5b4541e Hans Verkuil          2014-01-29  215  	u32		cnt_mem_attach_dmabuf;
b5b4541e Hans Verkuil          2014-01-29  216  	u32		cnt_mem_detach_dmabuf;
b5b4541e Hans Verkuil          2014-01-29  217  	u32		cnt_mem_map_dmabuf;
b5b4541e Hans Verkuil          2014-01-29  218  	u32		cnt_mem_unmap_dmabuf;
b5b4541e Hans Verkuil          2014-01-29  219  	u32		cnt_mem_vaddr;
b5b4541e Hans Verkuil          2014-01-29  220  	u32		cnt_mem_cookie;
b5b4541e Hans Verkuil          2014-01-29  221  	u32		cnt_mem_num_users;
b5b4541e Hans Verkuil          2014-01-29  222  	u32		cnt_mem_mmap;
b5b4541e Hans Verkuil          2014-01-29  223  
b5b4541e Hans Verkuil          2014-01-29  224  	u32		cnt_buf_init;
b5b4541e Hans Verkuil          2014-01-29  225  	u32		cnt_buf_prepare;
b5b4541e Hans Verkuil          2014-01-29  226  	u32		cnt_buf_finish;
b5b4541e Hans Verkuil          2014-01-29  227  	u32		cnt_buf_cleanup;
b5b4541e Hans Verkuil          2014-01-29  228  	u32		cnt_buf_queue;
b5b4541e Hans Verkuil          2014-01-29  229  
b5b4541e Hans Verkuil          2014-01-29  230  	/* This counts the number of calls to vb2_buffer_done() */
b5b4541e Hans Verkuil          2014-01-29  231  	u32		cnt_buf_done;
b5b4541e Hans Verkuil          2014-01-29  232  #endif
e23ccc0a Pawel Osciak          2010-10-11 @233  };
e23ccc0a Pawel Osciak          2010-10-11  234  
e23ccc0a Pawel Osciak          2010-10-11  235  /**
e23ccc0a Pawel Osciak          2010-10-11  236   * struct vb2_ops - driver-specific callbacks

:::::: The code at line 233 was first introduced by commit
:::::: e23ccc0ad9258634e6d52cedf473b35dc34416c7 [media] v4l: add videobuf2 Video for Linux 2 driver framework

:::::: TO: Pawel Osciak <p.osciak@samsung.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--YZ5djTAD1cGYuMQK
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ubBVQvALqFHBO0ZVAAA=

--YZ5djTAD1cGYuMQK--
