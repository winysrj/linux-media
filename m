Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40096 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbaCMMJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 08:09:44 -0400
Message-ID: <53219FE0.8010604@ti.com>
Date: Thu, 13 Mar 2014 17:39:04 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 02/14] v4l: ti-vpe: register video device only when
 firmware is loaded
References: <1393922965-15967-1-git-send-email-archit@ti.com> <1394526833-24805-1-git-send-email-archit@ti.com> <1394526833-24805-3-git-send-email-archit@ti.com> <000001cf3eb2$39817540$ac845fc0$%debski@samsung.com>
In-Reply-To: <000001cf3eb2$39817540$ac845fc0$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Thursday 13 March 2014 05:18 PM, Kamil Debski wrote:
> Hi Archit,
>
>> From: Archit Taneja [mailto:archit@ti.com]
>> Sent: Tuesday, March 11, 2014 9:34 AM
>>
>> vpe fops(vpe_open in particular) should be called only when VPDMA
>> firmware is loaded. File operations on the video device are possible
>> the moment it is registered.
>>
>> Currently, we register the video device for VPE at driver probe, after
>> calling a vpdma helper to initialize VPDMA and load firmware. This
>> function is non-blocking(it calls request_firmware_nowait()), and
>> doesn't ensure that the firmware is actually loaded when it returns.
>>
>> We remove the device registration from vpe probe, and move it to a
>> callback provided by the vpe driver to the vpdma library, through
>> vpdma_create().
>>
>> The ready field in vpdma_data is no longer needed since we always have
>> firmware loaded before the device is registered.
>>
>> A minor problem with this approach is that if the video_register_device
>> fails(which doesn't really happen), the vpe platform device would be
>> registered.
>> however, there won't be any v4l2 device corresponding to it.
>
> Could you explain to me one thing. request_firmware cannot be used in
> probe, thus you are using request_firmware_nowait. Why cannot the firmware
> be
> loaded on open with a regular request_firmware that is waiting?

I totally agree with you here. Placing the firmware in open() would 
probably make more sense.

The reason I didn't place it in open() is because I didn't want to 
release firmware in a corresponding close(), and be in a situation where 
the firmware is loaded multiple times in the driver's lifetime.

There are some reasons for doing this. First, it will require more 
testing with respect to whether the firmware is loaded correctly 
successive times :), the second is that loading firmware might probably 
take a bit of time, and we don't want to make applications too slow(I 
haven't measured the time taken, so I don't have a strong case for this 
either)

>
> This patch seems to swap one problem for another. The possibility that open
> fails (because firmware is not yet loaded) is swapped for a vague
> possibility
> that video_register_device.

The driver will work fine in most cases even without this patch(apart 
from the possibility mentioned as above).

We could discard this patch from this series, and I can work on a patch 
which moves firmware loading to the vpe_open() call, and hence solving 
the issue in the right manner. Does that sound fine?

Thanks,
Archit

