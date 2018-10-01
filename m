Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47556 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbeJAXHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 19:07:40 -0400
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
To: Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl>
 <d24d3977163f6c05cd65210b743f4e0dc321388d.camel@ndufresne.ca>
 <29bc7b9ffd2ca761cc6df88ff113bb6bcc844e1d.camel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0ea4fe85-508a-8a9d-0abe-7ae06b0146d3@xs4all.nl>
Date: Mon, 1 Oct 2018 18:28:58 +0200
MIME-Version: 1.0
In-Reply-To: <29bc7b9ffd2ca761cc6df88ff113bb6bcc844e1d.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/2018 06:12 PM, Ezequiel Garcia wrote:
> On Mon, 2018-10-01 at 08:42 -0400, Nicolas Dufresne wrote:
>> Hello Hans,
>>
>> Le lundi 01 octobre 2018 à 10:43 +0200, Hans Verkuil a écrit :
>>> It turns out that we have both JPEG and Motion-JPEG pixel formats defined.
>>>
>>> Furthermore, some drivers support one, some the other and some both.
>>>
>>> These pixelformats both mean the same.
>>>
>>> I propose that we settle on JPEG (since it seems to be used most often) and
>>> add JPEG support to those drivers that currently only use MJPEG.
>>
>> Thanks for looking into this. As per GStreamer code, I see 3 alias for
>> JPEG. V4L2_PIX_FMT_MJPEG/JPEG/PJPG. I don't know the context, this code
>> was written before I knew GStreamer existed. It's possible there is a
>> subtle difference, I have never looked at it, but clearly all our JPEG
>> decoder handle these as being the same.
>>
>> https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/sys/v4l2/gstv4l2object.c#n956
>>
> 
> To add more data points on the gstreamer side, there's really no difference
> between gstreamer's types image/jpeg and video/x-jpeg.
> 
> Notably, jpegdec element just stuffs a huffman table if one is missing,
> for any jpeg:
> 
> https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/ext/jpeg/gstjpegdec.c#n584

lib/libv4lconvert/libv4lconvert.c also treats JPEG and MJPEG the same.

It looks like JPEG and MJPEG are randomly used and I don't think you can assume
that one will have a huffman table and not the other.

Regards,

	Hans

> 
>>>
>>> We also need to update the V4L2_PIX_FMT_JPEG documentation since it just says
>>> TBD:
>>>
>>> https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-compressed.html
>>>
>>> $ git grep -l V4L2_PIX_FMT_MJPEG
>>> drivers/media/pci/meye/meye.c
>>> drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
>>> drivers/media/platform/sti/delta/delta-cfg.h
>>> drivers/media/platform/sti/delta/delta-mjpeg-dec.c
>>> drivers/media/usb/cpia2/cpia2_v4l.c
>>> drivers/media/usb/go7007/go7007-driver.c
>>> drivers/media/usb/go7007/go7007-fw.c
>>> drivers/media/usb/go7007/go7007-v4l2.c
>>> drivers/media/usb/s2255/s2255drv.c
>>> drivers/media/usb/uvc/uvc_driver.c
>>> drivers/staging/media/zoran/zoran_driver.c
>>> drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
>>> drivers/usb/gadget/function/uvc_v4l2.c
>>>
>>> It looks like s2255 and cpia2 support both already, so that would leave
>>> 8 drivers that need to be modified, uvc being the most important of the
>>> lot.
>>>
>>> Any comments?
>>>
>>> Regards,
>>>
>>> 	Hans
>>
>>
> 
