Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:54435 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729092AbeJAScB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 14:32:01 -0400
Subject: Re: [RFC] V4L2_PIX_FMT_MJPEG vs V4L2_PIX_FMT_JPEG
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
References: <03c10b29-6ead-1aa2-334a-c6357004a5ac@xs4all.nl>
 <2438028.OjeO6a9KTA@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <71200c21-1073-789c-aa94-813042afc352@xs4all.nl>
Date: Mon, 1 Oct 2018 13:54:29 +0200
MIME-Version: 1.0
In-Reply-To: <2438028.OjeO6a9KTA@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/01/2018 01:48 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday, 1 October 2018 11:43:04 EEST Hans Verkuil wrote:
>> It turns out that we have both JPEG and Motion-JPEG pixel formats defined.
>>
>> Furthermore, some drivers support one, some the other and some both.
>>
>> These pixelformats both mean the same.
> 
> Do they ? I thought MJPEG was JPEG using fixed Huffman tables that were not 
> included in the JPEG headers.

I'm not aware of any difference. If there is one, then it is certainly not
documented.

Ezequiel, since you've been working with this recently, do you know anything
about this?

Regards,

	Hans

> 
>> I propose that we settle on JPEG (since it seems to be used most often) and
>> add JPEG support to those drivers that currently only use MJPEG.
>>
>> We also need to update the V4L2_PIX_FMT_JPEG documentation since it just
>> says TBD:
>>
>> https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/pixfmt-compresse
>> d.html
>>
>> $ git grep -l V4L2_PIX_FMT_MJPEG
>> drivers/media/pci/meye/meye.c
>> drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
>> drivers/media/platform/sti/delta/delta-cfg.h
>> drivers/media/platform/sti/delta/delta-mjpeg-dec.c
>> drivers/media/usb/cpia2/cpia2_v4l.c
>> drivers/media/usb/go7007/go7007-driver.c
>> drivers/media/usb/go7007/go7007-fw.c
>> drivers/media/usb/go7007/go7007-v4l2.c
>> drivers/media/usb/s2255/s2255drv.c
>> drivers/media/usb/uvc/uvc_driver.c
>> drivers/staging/media/zoran/zoran_driver.c
>> drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
>> drivers/usb/gadget/function/uvc_v4l2.c
>>
>> It looks like s2255 and cpia2 support both already, so that would leave
>> 8 drivers that need to be modified, uvc being the most important of the
>> lot.
>>
>> Any comments?
> 
