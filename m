Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53849 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751265AbeBTUhX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 15:37:23 -0500
Date: Wed, 21 Feb 2018 04:37:08 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: drivers/media/common/videobuf2/videobuf2-v4l2.c:678: undefined
 reference to `video_devdata'
Message-ID: <201802210445.JSTkGKqx%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hans,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   af3e79d29555b97dd096e2f8e36a0f50213808a8
commit: 7952be9b6ece3d3c4d61f9811d7e5a984580064a media: drivers/media/common/videobuf2: rename from videobuf
date:   4 weeks ago
config: x86_64-randconfig-u0-02210105 (attached as .config)
compiler: gcc-5 (Debian 5.5.0-3) 5.4.1 20171010
reproduce:
        git checkout 7952be9b6ece3d3c4d61f9811d7e5a984580064a
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   drivers/media/common/videobuf2/videobuf2-v4l2.o: In function `vb2_poll':
>> drivers/media/common/videobuf2/videobuf2-v4l2.c:678: undefined reference to `video_devdata'
>> drivers/media/common/videobuf2/videobuf2-v4l2.c:685: undefined reference to `v4l2_event_pending'
   drivers/media/common/videobuf2/videobuf2-v4l2.o: In function `vb2_ioctl_reqbufs':
   drivers/media/common/videobuf2/videobuf2-v4l2.c:714: undefined reference to `video_devdata'
   drivers/media/common/videobuf2/videobuf2-v4l2.o: In function `vb2_ioctl_create_bufs':
   drivers/media/common/videobuf2/videobuf2-v4l2.c:733: undefined reference to `video_devdata'
   drivers/media/common/videobuf2/videobuf2-v4l2.o: In function `vb2_ioctl_prepare_buf':
   drivers/media/common/videobuf2/videobuf2-v4l2.c:759: undefined reference to `video_devdata'
   drivers/media/common/videobuf2/videobuf2-v4l2.o: In function `vb2_ioctl_querybuf':
   drivers/media/common/videobuf2/videobuf2-v4l2.c:769: undefined reference to `video_devdata'
   drivers/media/common/videobuf2/videobuf2-v4l2.o: In function `vb2_ioctl_qbuf':
   drivers/media/common/videobuf2/videobuf2-v4l2.c:778: undefined reference to `video_devdata'
   drivers/media/common/videobuf2/videobuf2-v4l2.o:drivers/media/common/videobuf2/videobuf2-v4l2.c:788: more undefined references to `video_devdata' follow
   drivers/media/common/videobuf2/videobuf2-v4l2.o: In function `_vb2_fop_release':
>> drivers/media/common/videobuf2/videobuf2-v4l2.c:848: undefined reference to `v4l2_fh_release'

vim +678 drivers/media/common/videobuf2/videobuf2-v4l2.c

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

--pWyiEgJYm5f9v55/
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ecpkY4dSao1Xh01EjiPWPP4fRJwU1uk2AgA=

--pWyiEgJYm5f9v55/--
