Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53216 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971Ab2BYXOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 18:14:37 -0500
Received: by wibhm11 with SMTP id hm11so628361wib.19
        for <linux-media@vger.kernel.org>; Sat, 25 Feb 2012 15:14:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALF0-+V99jWjnxYC-fdLGF8ggYukMjiRpkEGj+fY4j3kE-K-Jg@mail.gmail.com>
References: <CALF0-+V99jWjnxYC-fdLGF8ggYukMjiRpkEGj+fY4j3kE-K-Jg@mail.gmail.com>
Date: Sat, 25 Feb 2012 15:14:35 -0800
Message-ID: <CABi1daHoWASPq6XmrfW3JYSmzQEZmZMMyfHNmabM4cgZV0j4EA@mail.gmail.com>
Subject: Re: [question] v4l read() operation
From: Dave Hylands <dhylands@gmail.com>
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
Cc: devel@driverdev.osuosl.org,
	kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel

2012/2/25 Ezequiel García <elezegarcia@gmail.com>:
> Hi,
>
> If I register a video device with this fops:
>
> static const struct v4l2_file_operations v4l2_fops = {
>        .owner      = THIS_MODULE,
>        .open        = xxx_open,
>        .unlocked_ioctl = xxx_unlocked_ioctl,
>        .poll           = xxx_poll,
>        .mmap      = xxx_mmap,
> };
>
> then if I "cat" the device
>
> $ cat /dev/video0
>
> Who is supporting read() ?
>
> I thought it could be v4l2_read(),
> however this function seems to return EINVAL:
>
> static ssize_t v4l2_read(struct file *filp, char __user *buf,
>                size_t sz, loff_t *off)
> {
>        struct video_device *vdev = video_devdata(filp);
>        int ret = -ENODEV;
>
>        if (!vdev->fops->read)
>                return -EINVAL;
>        if (vdev->lock && mutex_lock_interruptible(vdev->lock))
>                return -ERESTARTSYS;
>        if (video_is_registered(vdev))
>                ret = vdev->fops->read(filp, buf, sz, off);
>        if (vdev->lock)
>                mutex_unlock(vdev->lock);
>        return ret;
> }

I'm not all that familiar with v4l, but based on what you've posted,
you need to populate the read routine in your v4l2_fops structure to
support read.

-- 
Dave Hylands
Shuswap, BC, Canada
http://www.davehylands.com
