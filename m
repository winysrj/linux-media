Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:63836 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2F0KoP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 06:44:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 PATCH 32/34] v4l2-dev.c: also add debug support for the fops.
Date: Wed, 27 Jun 2012 12:44:01 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl> <b4bdccc87fa1e14e3605c28468a67ebdf290ff83.1340366355.git.hans.verkuil@cisco.com> <1911273.6nHMAvcosU@avalon>
In-Reply-To: <1911273.6nHMAvcosU@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206271244.01746.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 27 June 2012 11:59:06 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 22 June 2012 14:21:26 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/v4l2-dev.c |   25 ++++++++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> > index 1b34360..b51bee9 100644
> > --- a/drivers/media/video/v4l2-dev.c
> > +++ b/drivers/media/video/v4l2-dev.c
> > @@ -305,6 +305,9 @@ static ssize_t v4l2_read(struct file *filp, char __user
> > *buf, ret = vdev->fops->read(filp, buf, sz, off);
> >  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
> >  		mutex_unlock(vdev->lock);
> > +	if (vdev->debug)
> > +		printk(KERN_DEBUG "%s: read: %zd (%d)\n",
> > +			video_device_node_name(vdev), sz, ret);
> 
> Would it make sense to introduce a v4l_dbg macro ? BTW, what was the outcome 
> of the pr_ vs. dev_ tests ?

When using e.g. dev_info you would get 'video4linux video0' as prefix, which is a
mouthful. So I decided against using it.

I've thought about adding a v4l_dbg macro, but I decided against it. This use of
KERN_DEBUG is quite unusual: usually any _dbg macro is either compiled away if
DEBUG isn't defined, uses dynamic printk, or uses a debug variable somewhere. In
this case you don't want any of those, you really want to print a message
unconditionally to the log at log level KERN_DEBUG.

Regards,

	Hans

> 
> >  	return ret;
> >  }
> > 
> > @@ -323,6 +326,9 @@ static ssize_t v4l2_write(struct file *filp, const char
> > __user *buf, ret = vdev->fops->write(filp, buf, sz, off);
> >  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
> >  		mutex_unlock(vdev->lock);
> > +	if (vdev->debug)
> > +		printk(KERN_DEBUG "%s: write: %zd (%d)\n",
> > +			video_device_node_name(vdev), sz, ret);
> >  	return ret;
> >  }
> > 
> > @@ -339,6 +345,9 @@ static unsigned int v4l2_poll(struct file *filp, struct
> > poll_table_struct *poll) ret = vdev->fops->poll(filp, poll);
> >  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
> >  		mutex_unlock(vdev->lock);
> > +	if (vdev->debug)
> > +		printk(KERN_DEBUG "%s: poll: %08x\n",
> > +			video_device_node_name(vdev), ret);
> >  	return ret;
> >  }
> > 
> > @@ -403,12 +412,17 @@ static unsigned long v4l2_get_unmapped_area(struct
> > file *filp, unsigned long flags)
> >  {
> >  	struct video_device *vdev = video_devdata(filp);
> > +	int ret;
> > 
> >  	if (!vdev->fops->get_unmapped_area)
> >  		return -ENOSYS;
> >  	if (!video_is_registered(vdev))
> >  		return -ENODEV;
> > -	return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
> > +	ret = vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
> > +	if (vdev->debug)
> > +		printk(KERN_DEBUG "%s: get_unmapped_area (%d)\n",
> > +			video_device_node_name(vdev), ret);
> > +	return ret;
> >  }
> >  #endif
> > 
> > @@ -426,6 +440,9 @@ static int v4l2_mmap(struct file *filp, struct
> > vm_area_struct *vm) ret = vdev->fops->mmap(filp, vm);
> >  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
> >  		mutex_unlock(vdev->lock);
> > +	if (vdev->debug)
> > +		printk(KERN_DEBUG "%s: mmap (%d)\n",
> > +			video_device_node_name(vdev), ret);
> >  	return ret;
> >  }
> > 
> > @@ -464,6 +481,9 @@ err:
> >  	/* decrease the refcount in case of an error */
> >  	if (ret)
> >  		video_put(vdev);
> > +	if (vdev->debug)
> > +		printk(KERN_DEBUG "%s: open (%d)\n",
> > +			video_device_node_name(vdev), ret);
> >  	return ret;
> >  }
> > 
> > @@ -483,6 +503,9 @@ static int v4l2_release(struct inode *inode, struct file
> > *filp) /* decrease the refcount unconditionally since the release()
> >  	   return value is ignored. */
> >  	video_put(vdev);
> > +	if (vdev->debug)
> > +		printk(KERN_DEBUG "%s: release\n",
> > +			video_device_node_name(vdev));
> >  	return ret;
> >  }
> 
