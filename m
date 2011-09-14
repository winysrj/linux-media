Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f42.google.com ([209.85.216.42]:64527 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab1INHKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 03:10:33 -0400
Received: by qwi4 with SMTP id 4so1800663qwi.1
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 00:10:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E6FC8E8.70008@gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<4E6FC8E8.70008@gmail.com>
Date: Wed, 14 Sep 2011 15:10:32 +0800
Message-ID: <CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> +static int bcap_qbuf(struct file *file, void *priv,
>> +                     struct v4l2_buffer *buf)
>> +{
>> +     struct bcap_device *bcap_dev = video_drvdata(file);
>> +     struct v4l2_fh *fh = file->private_data;
>> +     struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
>> +
>> +     if (!bcap_fh->io_allowed)
>> +             return -EACCES;
>
> I suppose -EBUSY would be more appropriate here.
>
no, io_allowed is to control which file instance has the right to do I/O.

>> +                     fmt =&bcap_formats[i];
>> +                     if (mbus_code)
>> +                             *mbus_code = fmt->mbus_code;
>> +                     if (bpp)
>> +                             *bpp = fmt->bpp;
>> +                     v4l2_fill_mbus_format(&mbus_fmt, pixfmt,
>> +                                             fmt->mbus_code);
>> +                     ret = v4l2_subdev_call(bcap->sd, video,
>> +                                             try_mbus_fmt,&mbus_fmt);
>> +                     if (ret<  0)
>> +                             return ret;
>> +                     v4l2_fill_pix_format(pixfmt,&mbus_fmt);
>> +                     pixfmt->bytesperline = pixfmt->width * fmt->bpp;
>> +                     pixfmt->sizeimage = pixfmt->bytesperline
>> +                                             * pixfmt->height;
>
> Still pixfmt->pixelformat isn't filled.
>
no here pixfmt->pixelformat is passed in

>> +                     return 0;
>> +             }
>> +     }
>> +     return -EINVAL;
>
> I think you should return some default format, rather than giving up
> when the fourcc doesn't match. However I'm not 100% sure this is
> the specification requirement.
>
no, there is no default format for bridge driver because it knows
nothing about this.
all the format info bridge needs ask subdevice.

>> +static const struct ppi_ops ppi_ops = {
>> +     .attach_irq = ppi_attach_irq,
>> +     .detach_irq = ppi_detach_irq,
>> +     .start = ppi_start,
>> +     .stop = ppi_stop,
>> +     .set_params = ppi_set_params,
>> +     .update_addr = ppi_update_addr,
>> +};
>
> How about moving this struct to the bottom of the file and getting rid of
> all the above forward declarations ?
>
I'd like to put global varible before function in a file.

>> +
>> +void delete_ppi_instance(struct ppi_if *ppi)
>> +{
>> +     peripheral_free_list(ppi->info->pin_req);
>> +     kfree(ppi);
>> +}
>
> As a side note, I was not sure if this is just a resend of your original
> patches or a second version. It would be good to indicate that in the message
> subject. I think it's not a big deal and makes the reviewers' life easier.
if I don't add a version number in subject, it means it is the first version.
