Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.136]:34846 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbcI0IIb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 04:08:31 -0400
Subject: Re: media: rockchip-vpu: I should place the huffman table at kernel
 or userspace?
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <5de5d305-0ecc-a994-d133-63d55c8b1741@rock-chips.com>
 <84ce2871-be3b-bf9f-ba0e-75de8c7d4824@xs4all.nl>
Cc: linux-rockchip@lists.infradead.org,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>
From: Randy Li <randy.li@rock-chips.com>
Message-ID: <8ea18fd5-44a6-5217-acdb-6472f419dbed@rock-chips.com>
Date: Tue, 27 Sep 2016 16:08:09 +0800
MIME-Version: 1.0
In-Reply-To: <84ce2871-be3b-bf9f-ba0e-75de8c7d4824@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/27/2016 03:52 PM, Hans Verkuil wrote:
> On 27/09/16 05:43, Randy Li wrote:
>> Hello:
>>   I have just done a JPEG HW encoder for the RK3288. I have been told
>> that I can't use the standard way to generate huffman table, the VPU
>> supports only 10 levels with a different huffman table.
>>   If I send the huffman table through the v4l2 extra control, the memory
>> copy is requested, although the data is not very large(2 x 64 bytes) but
>> still a overhead. The other way is to place them in the kernel driver,
>> and just define the quality every time it encode a picture. But storing
>> in kernel would make the driver a little bigger(2 x 11 x 64 bytes) and
>> beyond the FIFO job.
>>   So where Should I place the huffman table?
>
> Put it in the driver. It's less than 1.5 kB, so really small.
I see.
>
> I'm not sure what you mean with 'beyond the FIFO job' though.
I always been taught that the kernel driver is just FIFO between 
userspace and hardware.
Next time I would learn those small thing(even hard code) could be 
stored in kernel source code.
>
> My understanding is that there 10 quality levels, each with its own
> huffman table?
Right. But I still asking what the relationship is to the standard 
quality in JPEG from 0 to 100 to the other staff.
>
> So the driver would implement the V4L2_CID_JPEG_COMPRESSION_QUALITY control
> and for each quality level it picks a table. Makes sense to me.
Let looks I could omit a extra JPEG control then.
>
> Regards,
Thank you.

P.S the encoder for VP8 and H.264 is really very hard. I really need 
more time to do them. There is a new VA-API driver[1] which removed the 
most possible information from the third party library(but still need 
it) and using most decoder settings from the VA-API client.

The new kernel driver is in schedule as well.

[1] https://github.com/hizukiayaka/rockchip-video-driver/tree/rk_v4l2_mix
>
>     Hans
>

-- 
Randy Li
The third produce department
===========================================================================
This email message, including any attachments, is for the sole
use of the intended recipient(s) and may contain confidential and
privileged information. Any unauthorized review, use, disclosure or
distribution is prohibited. If you are not the intended recipient, please
contact the sender by reply e-mail and destroy all copies of the original
message. [Fuzhou Rockchip Electronics, INC. China mainland]
===========================================================================

