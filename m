Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63458 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751432AbdL2U5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 15:57:47 -0500
Date: Sat, 30 Dec 2017 04:56:43 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [linuxtv-media:master 3288/3327]
 drivers/media/common/videobuf/videobuf2-v4l2.c:678: undefined reference to
 `video_devdata'
Message-ID: <201712300436.bhbNzRQw%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://linuxtv.org/media_tree.git master
head:   d0c8f6ad8b381dd572576ac50b9696d4d31142bb
commit: 03fbdb2fc2b8bb27b0ee0534fd3e9c57cdc3854a [3288/3327] media: move videobuf2 to drivers/media/common
config: x86_64-randconfig-s4-12300216 (attached as .config)
compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
reproduce:
        git checkout 03fbdb2fc2b8bb27b0ee0534fd3e9c57cdc3854a
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

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

--FCuugMFkClbJLl1L
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--FCuugMFkClbJLl1L--
