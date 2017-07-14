Return-path: <linux-media-owner@vger.kernel.org>
Received: from nat-hk.nvidia.com ([203.18.50.4]:65533 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752774AbdGNCL4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 22:11:56 -0400
Subject: Re: [PATCH 1/1 V2] media: usb: uvc: Fix incorrect timeout for Get
 Request
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1499669029-3412-1-git-send-email-jilin@nvidia.com>
 <3026364.oSOK2ZPSm0@avalon>
CC: <mchehab@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>
From: Jim Lin <jilin@nvidia.com>
Message-ID: <75068995-ce49-dbac-76cb-f4fe911cb597@nvidia.com>
Date: Fri, 14 Jul 2017 10:11:53 +0800
MIME-Version: 1.0
In-Reply-To: <3026364.oSOK2ZPSm0@avalon>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017年07月11日 03:47, Laurent Pinchart wrote:
> Hi Jim,
>
> Thank you for the patch.
>
> On Monday 10 Jul 2017 14:43:49 Jim Lin wrote:
>> Section 9.2.6.4 of USB 2.0/3.x specification describes that
>> "device must be able to return the first data packet to host within
>> 500 ms of receipt of the request. For subsequent data packet, if any,
>> the device must be able to return them within 500 ms".
>>
>> This is to fix incorrect timeout and change it from 300 ms to 500 ms
>> to meet the timing specified by specification for Get Request.
>>
>> Signed-off-by: Jim Lin <jilin@nvidia.com>
>
> The patch looks good to me, so
>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> but I'm curious, have you noticed issues with some devices in practice ?
>

Sometimes this device takes about 360 ms to respond.

usb 1-2: new high-speed USB device number 16
usb 1-2: New USB device found, idVendor=045e, idProduct=0772
usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-2: Product: Microsoft�® LifeCam Studio(TM)
usb 1-2: Manufacturer: Microsoft
:
uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 4: -110 (exp. 2).

And it will be working well with correct timeout value.

--nvpublic
