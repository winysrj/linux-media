Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:35606 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3DPKl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 06:41:58 -0400
Received: by mail-vb0-f54.google.com with SMTP id w16so240945vbf.41
        for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 03:41:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201304151703.30416.hverkuil@xs4all.nl>
References: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com>
	<1365810779-24335-2-git-send-email-scott.jiang.linux@gmail.com>
	<201304151703.30416.hverkuil@xs4all.nl>
Date: Tue, 16 Apr 2013 18:41:56 +0800
Message-ID: <CAHG8p1C09V0NO+=Rg8_ND1pZukx72s8ydJs5MaGiT_adOfH+-w@mail.gmail.com>
Subject: Re: [PATCH RFC] [media] blackfin: add video display driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

>> +/*
>> + * Analog Devices video display driver
>> + *
>> + * Copyright (c) 2011 Analog Devices Inc.
>
> Analog Devices? What has this to do with Analog Devices?
>
I wrote this driver for Analog Devices Blackfin.


>> +
>> +static int disp_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +     struct disp_device *disp = video_drvdata(file);
>> +     int ret;
>> +
>> +     if (mutex_lock_interruptible(&disp->mutex))
>> +             return -ERESTARTSYS;
>> +     ret = vb2_mmap(&disp->buffer_queue, vma);
>> +     mutex_unlock(&disp->mutex);
>> +     return ret;
>> +}
>> +
>> +#ifndef CONFIG_MMU
>> +static unsigned long disp_get_unmapped_area(struct file *file,
>> +                                         unsigned long addr,
>> +                                         unsigned long len,
>> +                                         unsigned long pgoff,
>> +                                         unsigned long flags)
>> +{
>> +     struct disp_device *disp = video_drvdata(file);
>> +     int ret;
>> +
>> +     if (mutex_lock_interruptible(&disp->mutex))
>> +             return -ERESTARTSYS;
>> +     ret = vb2_get_unmapped_area(&disp->buffer_queue,
>> +                                 addr,
>> +                                 len,
>> +                                 pgoff,
>> +                                 flags);
>> +     mutex_unlock(&disp->mutex);
>> +     return ret;
>> +}
>> +#endif
>> +
>> +static unsigned int disp_poll(struct file *file, poll_table *wait)
>> +{
>> +     struct disp_device *disp = video_drvdata(file);
>> +     int ret;
>> +
>> +     mutex_lock(&disp->mutex);
>> +     ret = vb2_poll(&disp->buffer_queue, file, wait);
>> +     mutex_unlock(&disp->mutex);
>> +     return ret;
>> +}
>
> Use the helper functions in media/videobuf2-core.h for these file ops.
>
OK, I will use vb2_fop_mmap. But I'm not sure if I need to lock it.

>> +static int disp_reqbufs(struct file *file, void *priv,
>> +                     struct v4l2_requestbuffers *req_buf)
>> +{
>> +     struct disp_device *disp = video_drvdata(file);
>> +     struct vb2_queue *vq = &disp->buffer_queue;
>> +     struct v4l2_fh *fh = file->private_data;
>> +     struct disp_fh *disp_fh = container_of(fh, struct disp_fh, fh);
>> +
>> +     if (vb2_is_busy(vq))
>> +             return -EBUSY;
>> +
>> +     disp_fh->io_allowed = true;
>
> There is no need for io_allowed. The vb2_is_busy() function does the same
> thing. It saves a lot of code since you now can just use v4l2_fh instead of
> disp_fh, which allows you to use even more helper functions (v4l2_fh_open and
> v4l2_fh_release for starters).
>
> In fact, you can use all the vb2 ioctl helpers saving you a lot of code.
>
I don't think so. vb2_is_busy can't check if this file instance has
the right to stream off output.
