Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NG22dM018940
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 12:02:02 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NG11fC032357
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 12:01:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Date: Mon, 23 Jun 2008 18:00:44 +0200
References: <3dbf42455956d17b8aa6.1214002733@localhost>
	<200806221334.45894.hverkuil@xs4all.nl>
	<20080623150734.GF18397@plankton.ifup.org>
In-Reply-To: <20080623150734.GF18397@plankton.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231800.44274.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, mchehab@infradead.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] [PATCH] v4l: Introduce "index"
	attribute for	persistent video4linux device nodes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Monday 23 June 2008 17:07:34 Brandon Philips wrote:
> On 13:34 Sun 22 Jun 2008, Hans Verkuil wrote:
> > I might misunderstand it, but it looks like for every v4l device
> > that's created you temporarily allocate a structure, loop over all
> > current v4l devices to find which indices are in use, determine the
> > new index and free the structure again.
>
> Yes, that is the way it currently works.  Note that this searches for
> indices that are in use by the physical device that we are adding.
> Index is not videodev global.
>
> > Isn't it better to have a static bitarray in videodev that keeps
> > track of which devices are in use?
>
> A simple global bit array wouldn't work.  You need to have a separate
> bit array for every physical device that could possibly be plugged in
> since the indices are per-physical device.

I hadn't realized it's indexed per physical device. But we don't need 
VIDEO_NUM_DEVICES for that, an u32 is enough for now. There are no 
physical devices at the moment that register more than 9 devices I 
think.

> > Or if that's not possible for some reason, at least avoid the
> > expensive struct allocation and simply use a bitarray allocated on
> > the stack (max 256 devices = 32 bytes)?
>
> Using ffz and set_bit would be an option (since bitfields can't be
> used on arrays) but I don't think the savings would be worth the
> effort since we would need to use division and an array if
> VIDEO_NUM_DEVICES grows past 256.

The cost of using set_bit etc. is close to zero compared to the cost of 
doing a kzalloc/kfree each time.

There is also no need to use class_for_each_device(): you can also 
iterate over the video_device[] array.

So get_index would look something like this:

static int get_index(struct video_device *vdev, int num)
{
	u32 used = 0;
        int i;

        if (num >= 32)
                return -EINVAL;

	for (i = 0; i < VIDEO_NUM_DEVICES; i++) {
		if (video_device[i] != NULL &&
		    video_device[i] != vdev &&
		    video_device[i]->dev == vdev->dev) {
			used |= 1 << video_device[i]->index;
		}
	}

        if (num >= 0) {
                if (used & (1 << num))
                        return -ENFILE;
		return num;
        }

        for (i = 0; i < 32; i++) {
                if (used & (1 << i))
                        continue;
                return i;
        }
        return -ENFILE;
}

Untested code, but it looks much simpler to me.

> I think changing "used" to a uchar is a good choice though.
>
> diff --git a/linux/drivers/media/video/videodev.c
> b/linux/drivers/media/video/videodev.c ---
> a/linux/drivers/media/video/videodev.c
> +++ b/linux/drivers/media/video/videodev.c
> @@ -2053,7 +2053,7 @@ EXPORT_SYMBOL(video_ioctl2);
>
>  struct index_info {
>  	struct device *dev;
> -	unsigned int used[VIDEO_NUM_DEVICES];
> +	unsigned char used[VIDEO_NUM_DEVICES];
>  };
>
>  static int __fill_index_info(struct device *cd, void *data)
>
> I will send a new patch to Mauro with this change.
>
> > I'm looking at this patch and I wonder whether it isn't rather
> > inefficient.
>
> IMHO, probe isn't a fast path and simple code beats complex fast code
> in this case.

I agree, but I think it is too complicated for what it should do.

> > Note that class_for_each_device() didn't appear until 2.6.25, so
> > I've a simple patch pending in my tree that puts all of this under
> > a kernel
> >
> > >= 2.6.25 check.
>
> Backporting class_for_each_device should be trivial since it just
> uses list_for_each_entry and get/put device.

Let me know what you think of my approach (and if it works!).

Regards,

	Hans

>
> Cheers,
>
> 	Brandon
>
> > On Saturday 21 June 2008 00:58:53 brandon@ifup.org wrote:
> > > # HG changeset patch
> > > # User Brandon Philips <brandon@ifup.org>
> > > # Date 1214002727 25200
> > > # Node ID 3dbf42455956d17b8aa65bf92319edc3c52b88b8
> > > # Parent  4012ea1a6a06acad9509aee70ee6059af9000a37
> > > [PATCH] v4l: Introduce "index" attribute for persistent
> > > video4linux device nodes
> > >
> > > A number of V4L drivers have a mod param to specify their
> > > preferred minors. This is because it is often desirable for
> > > applications to have a static /dev name for a particular device. 
> > > However, using minors has several disadvantages:
> > >
> > >   1) the requested minor may already be taken
> > >   2) using a mod param is driver specific
> > >   3) it requires every driver to add a param
> > >   4) requires configuration by hand
> > >
> > > This patch introduces an "index" attribute that when combined
> > > with udev rules can create static device paths like this:
> > >
> > > /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0
> > > /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video1
> > > /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video2
> > >
> > > # ls -la /dev/v4l/by-path/pci-0000\:00\:1d.2-usb-0\:1\:1.0-video0
> > > lrwxrwxrwx 1 root root 12 2008-04-28 00:02
> > > /dev/v4l/by-path/pci-0000:00:1d.2-usb-0:1:1.0-video0 ->
> > > ../../video1
> > >
> > > These paths are steady across reboots and should be resistant to
> > > rearranging across Kernel versions.
> > >
> > > video_register_device_index is available to drivers to request a
> > > specific index number.
> > >
> > > Signed-off-by: Brandon Philips <bphilips@suse.de>
> > > Signed-off-by: Kees Cook <kees@outflux.net>
> > > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > >
> > > ---
> > >  linux/drivers/media/video/videodev.c |   98
> > > ++++++++++++++++++++++++++++++++++-
> > > linux/include/media/v4l2-dev.h
> > >
> > >    |    4 +
> > >
> > >  2 files changed, 100 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/linux/drivers/media/video/videodev.c
> > > b/linux/drivers/media/video/videodev.c ---
> > > a/linux/drivers/media/video/videodev.c
> > > +++ b/linux/drivers/media/video/videodev.c
> > > @@ -429,6 +429,14 @@ EXPORT_SYMBOL(v4l_printk_ioctl);
> > >   *	sysfs stuff
> > >   */
> > >
> > > +static ssize_t show_index(struct device *cd,
> > > +			 struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct video_device *vfd = container_of(cd, struct
> > > video_device, +						class_dev);
> > > +	return sprintf(buf, "%i\n", vfd->index);
> > > +}
> > > +
> > >  #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,13)
> > >  static ssize_t show_name(struct class_device *cd, char *buf)
> > >  #else
> > > @@ -487,6 +495,7 @@ static void video_release(struct device
> > >  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,13)
> > >  static struct device_attribute video_device_attrs[] = {
> > >  	__ATTR(name, S_IRUGO, show_name, NULL),
> > > +	__ATTR(index, S_IRUGO, show_index, NULL),
> > >  	__ATTR_NULL
> > >  };
> > >  #endif
> > > @@ -2042,7 +2051,81 @@ out:
> > >  }
> > >  EXPORT_SYMBOL(video_ioctl2);
> > >
> > > +struct index_info {
> > > +	struct device *dev;
> > > +	unsigned int used[VIDEO_NUM_DEVICES];
> > > +};
> > > +
> > > +static int __fill_index_info(struct device *cd, void *data)
> > > +{
> > > +	struct index_info *info = data;
> > > +	struct video_device *vfd = container_of(cd, struct
> > > video_device, +						class_dev);
> > > +
> > > +	if (info->dev == vfd->dev)
> > > +		info->used[vfd->index] = 1;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/**
> > > + * assign_index - assign stream number based on parent device
> > > + * @vdev: video_device to assign index number to, vdev->dev
> > > should be assigned + * @num: -1 if auto assign, requested number
> > > otherwise + *
> > > + *
> > > + * returns -ENFILE if num is already in use, a free index number
> > > if + * successful.
> > > + */
> > > +static int get_index(struct video_device *vdev, int num)
> > > +{
> > > +	struct index_info *info;
> > > +	int i;
> > > +	int ret = 0;
> > > +
> > > +	if (num >= VIDEO_NUM_DEVICES)
> > > +		return -EINVAL;
> > > +
> > > +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> > > +	if (!info)
> > > +		return -ENOMEM;
> > > +
> > > +	info->dev = vdev->dev;
> > > +
> > > +	ret = class_for_each_device(&video_class, info,
> > > +					__fill_index_info);
> > > +
> > > +	if (ret < 0)
> > > +		goto out;
> > > +
> > > +	if (num >= 0) {
> > > +		if (!info->used[num])
> > > +			ret = num;
> > > +		else
> > > +			ret = -ENFILE;
> > > +
> > > +		goto out;
> > > +	}
> > > +
> > > +	for (i = 0; i < VIDEO_NUM_DEVICES; i++) {
> > > +		if (info->used[i])
> > > +			continue;
> > > +		ret = i;
> > > +		goto out;
> > > +	}
> > > +
> > > +out:
> > > +	kfree(info);
> > > +	return ret;
> > > +}
> > > +
> > >  static const struct file_operations video_fops;
> > > +
> > > +int video_register_device(struct video_device *vfd, int type,
> > > int nr) +{
> > > +	return video_register_device_index(vfd, type, nr, -1);
> > > +}
> > > +EXPORT_SYMBOL(video_register_device);
> > >
> > >  /**
> > >   *	video_register_device - register video4linux devices
> > > @@ -2069,7 +2152,8 @@ static const struct file_operations vide
> > >   *	%VFL_TYPE_RADIO - A radio card
> > >   */
> > >
> > > -int video_register_device(struct video_device *vfd, int type,
> > > int nr) +int video_register_device_index(struct video_device
> > > *vfd, int type, int nr, +					int index)
> > >  {
> > >  	int i=0;
> > >  	int base;
> > > @@ -2126,6 +2210,16 @@ int video_register_device(struct video_d
> > >  	}
> > >  	video_device[i]=vfd;
> > >  	vfd->minor=i;
> > > +
> > > +	ret = get_index(vfd, index);
> > > +	if (ret < 0) {
> > > +		printk(KERN_ERR "%s: get_index failed\n",
> > > +		       __func__);
> > > +		goto fail_minor;
> > > +	}
> > > +
> > > +	vfd->index = ret;
> > > +
> > >  	mutex_unlock(&videodev_lock);
> > >  	mutex_init(&vfd->lock);
> > >
> > > @@ -2188,7 +2282,7 @@ fail_minor:
> > >  	mutex_unlock(&videodev_lock);
> > >  	return ret;
> > >  }
> > > -EXPORT_SYMBOL(video_register_device);
> > > +EXPORT_SYMBOL(video_register_device_index);
> > >
> > >  /**
> > >   *	video_unregister_device - unregister a video4linux device
> > > diff --git a/linux/include/media/v4l2-dev.h
> > > b/linux/include/media/v4l2-dev.h ---
> > > a/linux/include/media/v4l2-dev.h +++
> > > b/linux/include/media/v4l2-dev.h
> > > @@ -112,6 +112,8 @@ struct video_device
> > >  	int type;       /* v4l1 */
> > >  	int type2;      /* v4l2 */
> > >  	int minor;
> > > +	/* attribute to diferentiate multiple indexs on one physical
> > > device */ +	int index;
> > >
> > >  	int debug;	/* Activates debug level*/
> > >
> > > @@ -377,6 +379,8 @@ void *priv;
> > >
> > >  /* Version 2 functions */
> > >  extern int video_register_device(struct video_device *vfd, int
> > > type, int nr); +int video_register_device_index(struct
> > > video_device *vfd, int type, int nr, +					int index);
> > >  void video_unregister_device(struct video_device *);
> > >  extern int video_ioctl2(struct inode *inode, struct file *file,
> > >  			  unsigned int cmd, unsigned long arg);
> > >
> > > --
> > > video4linux-list mailing list
> > > Unsubscribe
> > > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > > https://www.redhat.com/mailman/listinfo/video4linux-list
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
