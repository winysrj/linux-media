Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:63992 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766Ab2BYW3x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 17:29:53 -0500
Received: by obcva7 with SMTP id va7so4182054obc.19
        for <linux-media@vger.kernel.org>; Sat, 25 Feb 2012 14:29:52 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 25 Feb 2012 19:29:52 -0300
Message-ID: <CALF0-+V99jWjnxYC-fdLGF8ggYukMjiRpkEGj+fY4j3kE-K-Jg@mail.gmail.com>
Subject: [question] v4l read() operation
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: devel@driverdev.osuosl.org,
	kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

If I register a video device with this fops:

static const struct v4l2_file_operations v4l2_fops = {
        .owner      = THIS_MODULE,
        .open        = xxx_open,
        .unlocked_ioctl = xxx_unlocked_ioctl,
        .poll           = xxx_poll,
        .mmap      = xxx_mmap,
};

then if I "cat" the device

$ cat /dev/video0

Who is supporting read() ?

I thought it could be v4l2_read(),
however this function seems to return EINVAL:

static ssize_t v4l2_read(struct file *filp, char __user *buf,
                size_t sz, loff_t *off)
{
        struct video_device *vdev = video_devdata(filp);
        int ret = -ENODEV;

        if (!vdev->fops->read)
                return -EINVAL;
        if (vdev->lock && mutex_lock_interruptible(vdev->lock))
                return -ERESTARTSYS;
        if (video_is_registered(vdev))
                ret = vdev->fops->read(filp, buf, sz, off);
        if (vdev->lock)
                mutex_unlock(vdev->lock);
        return ret;
}

Thanks,
Ezequiel.
