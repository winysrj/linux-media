Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53563 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1INOav (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 10:30:51 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRI00CEIOBCZ0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Sep 2011 15:30:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRI00I7HOBCGL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Sep 2011 15:30:48 +0100 (BST)
Date: Wed, 14 Sep 2011 16:30:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
In-reply-to: <CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Message-id: <4E70BA97.1090904@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
 <1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
 <4E6FC8E8.70008@gmail.com>
 <CAHG8p1C5F_HKX_GPHv_RdCRRNw9s3+ybK4giCjUXxgSUAUDRVw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2011 09:10 AM, Scott Jiang wrote:
>>> +static int bcap_qbuf(struct file *file, void *priv,
>>> +                     struct v4l2_buffer *buf)
>>> +{
>>> +     struct bcap_device *bcap_dev = video_drvdata(file);
>>> +     struct v4l2_fh *fh = file->private_data;
>>> +     struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
>>> +
>>> +     if (!bcap_fh->io_allowed)
>>> +             return -EACCES;
>>
>> I suppose -EBUSY would be more appropriate here.
>>
> no, io_allowed is to control which file instance has the right to do I/O.

Looks like you are doing here what the v4l2 priority mechanism is meant for.
Have you considered the access priority (VIDIOC_G_PRIORITY/VIDIOC_S_PRIORITY
and friends)? Does it have any shortcomings?

> 
>>> +                     fmt =&bcap_formats[i];
>>> +                     if (mbus_code)
>>> +                             *mbus_code = fmt->mbus_code;
>>> +                     if (bpp)
>>> +                             *bpp = fmt->bpp;
>>> +                     v4l2_fill_mbus_format(&mbus_fmt, pixfmt,
>>> +                                             fmt->mbus_code);
>>> +                     ret = v4l2_subdev_call(bcap->sd, video,
>>> +                                             try_mbus_fmt,&mbus_fmt);
>>> +                     if (ret<  0)
>>> +                             return ret;
>>> +                     v4l2_fill_pix_format(pixfmt,&mbus_fmt);
>>> +                     pixfmt->bytesperline = pixfmt->width * fmt->bpp;
>>> +                     pixfmt->sizeimage = pixfmt->bytesperline
>>> +                                             * pixfmt->height;
>>
>> Still pixfmt->pixelformat isn't filled.
>>
> no here pixfmt->pixelformat is passed in
> 
>>> +                     return 0;
>>> +             }
>>> +     }
>>> +     return -EINVAL;
>>
>> I think you should return some default format, rather than giving up
>> when the fourcc doesn't match. However I'm not 100% sure this is
>> the specification requirement.
>>
> no, there is no default format for bridge driver because it knows
> nothing about this.
> all the format info bridge needs ask subdevice.

It's the bridge driver that exports a device node and is responsible for
setting the default format. It should be possible to start streaming right
after opening the device, without VIDIOC_S_FMT, with some reasonable defaults.

If, as you say, the bridge knows nothing about formats what the bcap_formats[]
array is here for ?

> 
>>> +static const struct ppi_ops ppi_ops = {
>>> +     .attach_irq = ppi_attach_irq,
>>> +     .detach_irq = ppi_detach_irq,
>>> +     .start = ppi_start,
>>> +     .stop = ppi_stop,
>>> +     .set_params = ppi_set_params,
>>> +     .update_addr = ppi_update_addr,
>>> +};
>>
>> How about moving this struct to the bottom of the file and getting rid of
>> all the above forward declarations ?
>>
> I'd like to put global varible before function in a file.
> 
>>> +
>>> +void delete_ppi_instance(struct ppi_if *ppi)
>>> +{
>>> +     peripheral_free_list(ppi->info->pin_req);
>>> +     kfree(ppi);
>>> +}
>>
>> As a side note, I was not sure if this is just a resend of your original
>> patches or a second version. It would be good to indicate that in the message
>> subject. I think it's not a big deal and makes the reviewers' life easier.
> if I don't add a version number in subject, it means it is the first version.

Sorry, please ignore this. I got confused by the mailer and thought the same
patches appeared twice on the list.


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
