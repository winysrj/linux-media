Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37429 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab2BZATs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 19:19:48 -0500
References: <CALF0-+V99jWjnxYC-fdLGF8ggYukMjiRpkEGj+fY4j3kE-K-Jg@mail.gmail.com>
In-Reply-To: <CALF0-+V99jWjnxYC-fdLGF8ggYukMjiRpkEGj+fY4j3kE-K-Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [question] v4l read() operation
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 25 Feb 2012 19:17:51 -0500
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>,
	devel@driverdev.osuosl.org,
	kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-media@vger.kernel.org
Message-ID: <9a9380ab-67ad-4481-b757-ff0ab34d7c31@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Ezequiel García" <elezegarcia@gmail.com> wrote:

>Hi,
>
>If I register a video device with this fops:
>
>static const struct v4l2_file_operations v4l2_fops = {
>        .owner      = THIS_MODULE,
>        .open        = xxx_open,
>        .unlocked_ioctl = xxx_unlocked_ioctl,
>        .poll           = xxx_poll,
>        .mmap      = xxx_mmap,
>};
>
>then if I "cat" the device
>
>$ cat /dev/video0
>
>Who is supporting read() ?
>
>I thought it could be v4l2_read(),
>however this function seems to return EINVAL:
>
>static ssize_t v4l2_read(struct file *filp, char __user *buf,
>                size_t sz, loff_t *off)
>{
>        struct video_device *vdev = video_devdata(filp);
>        int ret = -ENODEV;
>
>        if (!vdev->fops->read)
>                return -EINVAL;
>        if (vdev->lock && mutex_lock_interruptible(vdev->lock))
>                return -ERESTARTSYS;
>        if (video_is_registered(vdev))
>                ret = vdev->fops->read(filp, buf, sz, off);
>        if (vdev->lock)
>                mutex_unlock(vdev->lock);
>        return ret;
>}
>
>Thanks,
>Ezequiel.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Please read the v4l2 specification.  Drivers can support the read/write methods or streaming IO methods (using mmap) or both.

Often it is the case that drivers for MPEG encoders or other chips that produce container formats use read/write.  Drivers for chips the provide raw frames often use streaming IO.

Note that the videobuf2 framework can provide read/write method emulation for a driver IIRC.

- Andy
