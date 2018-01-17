Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:38554 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752554AbeAQXGN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 18:06:13 -0500
Date: Thu, 18 Jan 2018 07:06:07 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [linux-next:master 6054/10286]
 drivers/media/common/videobuf/videobuf2-v4l2.c:678: undefined reference to
 `video_devdata'
Message-ID: <201801180705.FpxQG8Br%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mauro,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   1fec57a31e561b110756a8b0bd2135a29bd6268f
commit: 03fbdb2fc2b8bb27b0ee0534fd3e9c57cdc3854a [6054/10286] media: move videobuf2 to drivers/media/common
config: x86_64-randconfig-h0-01180022 (attached as .config)
compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
reproduce:
        git checkout 03fbdb2fc2b8bb27b0ee0534fd3e9c57cdc3854a
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   drivers/media/common/videobuf/videobuf2-core.o: In function `__read_once_size':
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_queue'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_queue'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_queue'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_queue'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_done'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_done'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_done'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_buf_done'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_qbuf'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_qbuf'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_qbuf'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_qbuf'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_dqbuf'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_dqbuf'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_dqbuf'
   include/linux/compiler.h:183: undefined reference to `__tracepoint_vb2_dqbuf'
   drivers/media/common/videobuf/videobuf2-core.o: In function `vb2_core_streamon':
   drivers/media/common/videobuf/videobuf2-core.c:1726: undefined reference to `v4l_vb2q_enable_media_source'
   drivers/media/common/videobuf/videobuf2-core.o:(__jump_table+0x10): undefined reference to `__tracepoint_vb2_buf_queue'
   drivers/media/common/videobuf/videobuf2-core.o:(__jump_table+0x28): undefined reference to `__tracepoint_vb2_buf_done'
   drivers/media/common/videobuf/videobuf2-core.o:(__jump_table+0x40): undefined reference to `__tracepoint_vb2_qbuf'
   drivers/media/common/videobuf/videobuf2-core.o:(__jump_table+0x58): undefined reference to `__tracepoint_vb2_dqbuf'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_poll':
>> drivers/media/common/videobuf/videobuf2-v4l2.c:678: undefined reference to `video_devdata'
>> drivers/media/common/videobuf/videobuf2-v4l2.c:685: undefined reference to `v4l2_event_pending'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_ioctl_reqbufs':
   drivers/media/common/videobuf/videobuf2-v4l2.c:714: undefined reference to `video_devdata'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_ioctl_create_bufs':
   drivers/media/common/videobuf/videobuf2-v4l2.c:733: undefined reference to `video_devdata'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_ioctl_prepare_buf':
   drivers/media/common/videobuf/videobuf2-v4l2.c:759: undefined reference to `video_devdata'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_ioctl_querybuf':
   drivers/media/common/videobuf/videobuf2-v4l2.c:769: undefined reference to `video_devdata'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_ioctl_qbuf':
   drivers/media/common/videobuf/videobuf2-v4l2.c:778: undefined reference to `video_devdata'
   drivers/media/common/videobuf/videobuf2-v4l2.o:drivers/media/common/videobuf/videobuf2-v4l2.c:788: more undefined references to `video_devdata' follow
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `_vb2_fop_release':
>> drivers/media/common/videobuf/videobuf2-v4l2.c:848: undefined reference to `v4l2_fh_release'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_fop_release':
   drivers/media/common/videobuf/videobuf2-v4l2.c:854: undefined reference to `video_devdata'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_fop_write':
   drivers/media/common/videobuf/videobuf2-v4l2.c:864: undefined reference to `video_devdata'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_fop_read':
   drivers/media/common/videobuf/videobuf2-v4l2.c:888: undefined reference to `video_devdata'
   drivers/media/common/videobuf/videobuf2-v4l2.o: In function `vb2_fop_poll':
   drivers/media/common/videobuf/videobuf2-v4l2.c:911: undefined reference to `video_devdata'

vim +678 drivers/media/common/videobuf/videobuf2-v4l2.c

3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  675  
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  676  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  677  {
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03 @678  	struct video_device *vfd = video_devdata(file);
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  679  	unsigned long req_events = poll_requested_events(wait);
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  680  	unsigned int res = 0;
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  681  
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  682  	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  683  		struct v4l2_fh *fh = file->private_data;
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  684  
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03 @685  		if (v4l2_event_pending(fh))
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  686  			res = POLLPRI;
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  687  		else if (req_events & POLLPRI)
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  688  			poll_wait(file, &fh->wait, wait);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  689  	}
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  690  
49d8ab9f drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-11-03  691  	return res | vb2_core_poll(q, file, wait);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  692  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  693  EXPORT_SYMBOL_GPL(vb2_poll);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  694  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  695  /*
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  696   * The following functions are not part of the vb2 core API, but are helper
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  697   * functions that plug into struct v4l2_ioctl_ops, struct v4l2_file_operations
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  698   * and struct vb2_ops.
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  699   * They contain boilerplate code that most if not all drivers have to do
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  700   * and so they simplify the driver code.
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  701   */
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  702  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  703  /* The queue is busy if there is a owner and you are not that owner. */
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  704  static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  705  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  706  	return vdev->queue->owner && vdev->queue->owner != file->private_data;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  707  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  708  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  709  /* vb2 ioctl helpers */
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  710  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  711  int vb2_ioctl_reqbufs(struct file *file, void *priv,
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  712  			  struct v4l2_requestbuffers *p)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  713  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  714  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  715  	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  716  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  717  	if (res)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  718  		return res;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  719  	if (vb2_queue_is_busy(vdev, file))
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  720  		return -EBUSY;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  721  	res = vb2_core_reqbufs(vdev->queue, p->memory, &p->count);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  722  	/* If count == 0, then the owner has released all buffers and he
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  723  	   is no longer owner of the queue. Otherwise we have a new owner. */
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  724  	if (res == 0)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  725  		vdev->queue->owner = p->count ? file->private_data : NULL;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  726  	return res;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  727  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  728  EXPORT_SYMBOL_GPL(vb2_ioctl_reqbufs);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  729  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  730  int vb2_ioctl_create_bufs(struct file *file, void *priv,
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  731  			  struct v4l2_create_buffers *p)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  732  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06 @733  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  734  	int res = vb2_verify_memory_type(vdev->queue, p->memory,
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  735  			p->format.type);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  736  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  737  	p->index = vdev->queue->num_buffers;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  738  	/*
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  739  	 * If count == 0, then just check if memory and type are valid.
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  740  	 * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  741  	 */
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  742  	if (p->count == 0)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  743  		return res != -EBUSY ? res : 0;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  744  	if (res)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  745  		return res;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  746  	if (vb2_queue_is_busy(vdev, file))
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  747  		return -EBUSY;
df9ecb0c drivers/media/v4l2-core/videobuf2-v4l2.c Hans Verkuil 2015-10-28  748  
df9ecb0c drivers/media/v4l2-core/videobuf2-v4l2.c Hans Verkuil 2015-10-28  749  	res = vb2_create_bufs(vdev->queue, p);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  750  	if (res == 0)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  751  		vdev->queue->owner = file->private_data;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  752  	return res;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  753  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  754  EXPORT_SYMBOL_GPL(vb2_ioctl_create_bufs);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  755  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  756  int vb2_ioctl_prepare_buf(struct file *file, void *priv,
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  757  			  struct v4l2_buffer *p)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  758  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  759  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  760  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  761  	if (vb2_queue_is_busy(vdev, file))
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  762  		return -EBUSY;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  763  	return vb2_prepare_buf(vdev->queue, p);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  764  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  765  EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  766  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  767  int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  768  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  769  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  770  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  771  	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  772  	return vb2_querybuf(vdev->queue, p);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  773  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  774  EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  775  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  776  int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  777  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  778  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  779  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  780  	if (vb2_queue_is_busy(vdev, file))
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  781  		return -EBUSY;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  782  	return vb2_qbuf(vdev->queue, p);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  783  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  784  EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  785  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  786  int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  787  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  788  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  789  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  790  	if (vb2_queue_is_busy(vdev, file))
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  791  		return -EBUSY;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  792  	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  793  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  794  EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  795  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  796  int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  797  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  798  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  799  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  800  	if (vb2_queue_is_busy(vdev, file))
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  801  		return -EBUSY;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  802  	return vb2_streamon(vdev->queue, i);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  803  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  804  EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  805  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  806  int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  807  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  808  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  809  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  810  	if (vb2_queue_is_busy(vdev, file))
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  811  		return -EBUSY;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  812  	return vb2_streamoff(vdev->queue, i);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  813  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  814  EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  815  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  816  int vb2_ioctl_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *p)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  817  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  818  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  819  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  820  	if (vb2_queue_is_busy(vdev, file))
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  821  		return -EBUSY;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  822  	return vb2_expbuf(vdev->queue, p);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  823  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  824  EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  825  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  826  /* v4l2_file_operations helpers */
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  827  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  828  int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  829  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  830  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  831  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  832  	return vb2_mmap(vdev->queue, vma);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  833  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  834  EXPORT_SYMBOL_GPL(vb2_fop_mmap);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  835  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  836  int _vb2_fop_release(struct file *file, struct mutex *lock)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  837  {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  838  	struct video_device *vdev = video_devdata(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  839  
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  840  	if (lock)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  841  		mutex_lock(lock);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  842  	if (file->private_data == vdev->queue->owner) {
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  843  		vb2_queue_release(vdev->queue);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  844  		vdev->queue->owner = NULL;
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  845  	}
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  846  	if (lock)
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  847  		mutex_unlock(lock);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06 @848  	return v4l2_fh_release(file);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  849  }
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  850  EXPORT_SYMBOL_GPL(_vb2_fop_release);
3c5be988 drivers/media/v4l2-core/videobuf2-v4l2.c Junghak Sung 2015-10-06  851  

:::::: The code at line 678 was first introduced by commit
:::::: 49d8ab9feaf20e7247edfdb36ce9ffa8db6b5f19 [media] media: videobuf2: Separate vb2_poll()

:::::: TO: Junghak Sung <jh1009.sung@samsung.com>
:::::: CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--n8g4imXOkfNTN/H1
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
SmANVlouZcRhnDT/D9G1QSC9BAIA

--n8g4imXOkfNTN/H1--
