Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:50966 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdJPDLr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 23:11:47 -0400
Subject: Re: [PATCH 0/4] media: ov7670: add media controller support
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-media@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
 <20171013204843.eho3dhkeltvjnajd@valkosipuli.retiisi.org.uk>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <01abd331-7a92-314f-b4ab-7a741f76536b@Microchip.com>
Date: Mon, 16 Oct 2017 11:11:41 +0800
MIME-Version: 1.0
In-Reply-To: <20171013204843.eho3dhkeltvjnajd@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 2017/10/14 4:48, Sakari Ailus wrote:
> Hi Akinobu,
>
> On Fri, Oct 13, 2017 at 01:21:13AM +0900, Akinobu Mita wrote:
>> This series adds media controller support and other related changes to the
>> OV7670 which is cheap and highly available CMOS image sensor for hobbyists.
>>
>> This enables to control a video pipeline system with the OV7670.  I've
>> tested this with the xilinx video IP pipeline.
>>
>> Akinobu Mita (4):
>>    media: ov7670: create subdevice device node
>>    media: ov7670: use v4l2_async_unregister_subdev()
>>    media: ov7670: add media controller support
>>    media: ov7670: add get_fmt() pad ops callback
>>
>>   drivers/media/i2c/ov7670.c | 55 +++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 54 insertions(+), 1 deletion(-)
> I understand Wenyou has submitted a set with similar functionality +
> runtime PM as well, but it has issues. There hasn't been updated for some
> time on that. Wenyou, what's the status of your patchset?
Sorry for I missed your previous mail.

I will update the patchset soon.
> The set was submitted on the list under subject "[PATCH v5 0/3] media:
> ov7670: Add entity init and power operation"
>

Best Regards,
Wenyou Yang
