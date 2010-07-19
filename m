Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:58587 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760538Ab0GSK4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 06:56:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 01/10] media: Media device node support
Date: Mon, 19 Jul 2010 12:56:43 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279114219-27389-2-git-send-email-laurent.pinchart@ideasonboard.com> <201007181258.16303.hverkuil@xs4all.nl>
In-Reply-To: <201007181258.16303.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007191256.44278.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Sunday 18 July 2010 12:58:16 Hans Verkuil wrote:
> On Wednesday 14 July 2010 15:30:10 Laurent Pinchart wrote:
> > The media_devnode structure provides support for registering and
> > unregistering character devices using a dynamic major number. Reference
> > counting is handled internally, making device drivers easier to write
> > without having to solve the open/disconnect race condition issue over
> > and over again.
> > 
> > The code is copied mostly verbatim from video/v4l2-dev.c.

[snip]

> > diff --git a/drivers/media/media-devnode.c
> > b/drivers/media/media-devnode.c new file mode 100644
> > index 0000000..53f618b
> > --- /dev/null
> > +++ b/drivers/media/media-devnode.c
> > @@ -0,0 +1,479 @@

[snip]

> > +/*
> > + *	Active devices
> > + */
> > +static struct media_devnode *media_devnodes[MEDIA_NUM_DEVICES];
> > +static DEFINE_MUTEX(media_devnode_lock);
> > +static DECLARE_BITMAP(devnode_nums[MEDIA_TYPE_MAX], MEDIA_NUM_DEVICES);
> > +
> > +/* Device node utility functions */
> > +
> > +/* Note: these utility functions all assume that type is in the range
> > +   [0, MEDIA_TYPE_MAX-1]. */
> > +
> > +/* Return the bitmap corresponding to type. */
> > +static inline unsigned long *devnode_bits(int type)
> > +{
> > +	return devnode_nums[type];
> > +}
> > +
> > +/* Mark device node number mdev->num as used */
> > +static inline void devnode_set(struct media_devnode *mdev)
> > +{
> > +	set_bit(mdev->num, devnode_bits(mdev->type));
> > +}
> > +
> > +/* Mark device node number mdev->num as unused */
> > +static inline void devnode_clear(struct media_devnode *mdev)
> > +{
> > +	clear_bit(mdev->num, devnode_bits(mdev->type));
> > +}
> > +
> > +/* Try to find a free device node number in the range [from, to> */
> > +static inline int devnode_find(struct media_devnode *mdev, int from, int
> > to) +{
> > +	return find_next_zero_bit(devnode_bits(mdev->type), to, from);
> > +}
> 
> We really don't need media_devnodes and devnode_nums. Or allow for other
> media types for that matter. That's all legacy stuff from v4l2 that can
> just be nuked for this new character driver.

OK, I'll remove them. I'll still need to keep a bitmap for minor number 
allocation though.

[snip]

> > +struct media_devnode *media_devnode_data(struct file *file)
> > +{
> > +	return media_devnodes[iminor(file->f_path.dentry->d_inode)];
> 
> This can become:
> 
> struct media_devnode *media_devnode_data(struct inode *inode)
> {
> 	return container_of(inode->i_cdev, struct media_devnode, cdev);
> }
> 
> where struct cdev is embedded in struct media_devnode. See also the
> 'Linux Device Drivers' book.
> 
> It's probably better if the media_open function does this operation and
> sets filp->private_data to media_devnode. Then we can just use:
> 
> struct media_devnode *media_devnode_data(struct file *filep)
> {
> 	return filp->private_data;
> }

Agreed. I'll change that.

[snip]

> > +static long media_ioctl(struct file *filp, unsigned int cmd, unsigned
> > long arg) +{
> > +	struct media_devnode *mdev = media_devnode_data(filp);
> > +	int ret = -ENOTTY;
> > +
> > +	/* Allow ioctl to continue even if the device was unregistered.
> > +	   Things like dequeueing buffers might still be useful. */
> 
> Definitely out of date comment.
> 
> I would bail out if the device was unregistered. Unless there is a good
> solid use case for this.
> 
> > +	if (mdev->fops->unlocked_ioctl)
> > +		ret = mdev->fops->unlocked_ioctl(filp, cmd, arg);
> 
> I would only support unlocked_ioctl. Let's not introduce a BKL in this new
> char device.

Agreed. I'll change that.

[snip]

> > +static unsigned long media_get_unmapped_area(struct file *filp,
> > +		unsigned long addr, unsigned long len, unsigned long pgoff,
> > +		unsigned long flags)
> > +{
> > +	struct media_devnode *mdev = media_devnode_data(filp);
> > +
> > +	if (!mdev->fops->get_unmapped_area)
> > +		return -ENOSYS;
> > +	if (!media_devnode_is_registered(mdev))
> > +		return -ENODEV;
> > +	return mdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
> > +}
> > +#endif
> 
> Do we really need this? I know it is in v4l2-dev.c, but AFAIK there isn't a
> single driver that implements get_unmapped_area. I never understood why it
> is in v4l2-dev.c for that matter.

OK, I'll remove it.

> > +
> > +static int media_mmap(struct file *filp, struct vm_area_struct *vm)
> > +{
> > +	struct media_devnode *mdev = media_devnode_data(filp);
> > +
> > +	if (!mdev->fops->mmap || !media_devnode_is_registered(mdev))
> > +		return -ENODEV;
> > +	return mdev->fops->mmap(filp, vm);
> > +}
> 
> Hmm. Do we want mmap support? I wouldn't add this unless there is a driver
> that actually needs this.

OK, I'll remove it.

[snip]

> > +static const struct file_operations media_devnode_fops = {
> > +	.owner = THIS_MODULE,
> > +	.read = media_read,
> > +	.write = media_write,
> > +	.open = media_open,
> > +	.get_unmapped_area = media_get_unmapped_area,
> > +	.mmap = media_mmap,
> > +	.unlocked_ioctl = media_ioctl,
> > +#ifdef CONFIG_COMPAT
> > +/*	.compat_ioctl = media_compat_ioctl32, */
> > +#endif
> 
> Just remove this.

OK.

> > +	.release = media_release,
> > +	.poll = media_poll,
> > +	.llseek = no_llseek,
> > +};
> > +
> > +/**
> > + * media_devnode_register - register a media device node
> > + * @mdev: media device node structure we want to register
> > + * @type: type of device node to register
> > + *
> > + * The registration code assigns minor numbers and device node numbers
> > based + * on the requested type and registers the new device node with
> > the kernel. An + * error is returned if no free minor or device node
> > number could be found, or + * if the registration of the device node
> > failed.
> > + *
> > + * Zero is returned on success.
> > + *
> > + * Note that if the media_devnode_register call fails, the release()
> > callback of + * the media_devnode structure is *not* called, so the
> > caller is responsible for + * freeing any data.
> > + *
> > + * Valid types are
> > + *
> > + * %MEDIA_TYPE_DEVICE - A media device
> > + */
> > +int __must_check media_devnode_register(struct media_devnode *mdev, int
> > type)
> 
> Don't do types. I see no need for that.

Agreed, I'll remove them.

-- 
Regards,

Laurent Pinchart
