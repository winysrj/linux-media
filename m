Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38900 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753662AbcKNMxU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 07:53:20 -0500
Received: by mail-wm0-f49.google.com with SMTP id f82so96404092wmf.1
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2016 04:53:20 -0800 (PST)
Subject: Re: [PATCH v7 2/2] media: Add a driver for the ov5645 camera sensor.
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1479119076-26363-1-git-send-email-todor.tomov@linaro.org>
 <1479119076-26363-3-git-send-email-todor.tomov@linaro.org>
 <5871917.9Xm98D97nL@avalon>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5829B3B8.2020404@linaro.org>
Date: Mon, 14 Nov 2016 14:53:12 +0200
MIME-Version: 1.0
In-Reply-To: <5871917.9Xm98D97nL@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you once again for the review.

On 11/14/2016 02:38 PM, Laurent Pinchart wrote:
> Hi Todor,
> 
> Thank you for the patch.
> 
> On Monday 14 Nov 2016 12:24:36 Todor Tomov wrote:
>> The ov5645 sensor from Omnivision supports up to 2592x1944
>> and CSI2 interface.
>>
>> The driver adds support for the following modes:
>> - 1280x960
>> - 1920x1080
>> - 2592x1944
>>
>> Output format is packed 8bit UYVY.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/i2c/Kconfig  |   12 +
>>  drivers/media/i2c/Makefile |    1 +
>>  drivers/media/i2c/ov5645.c | 1352 +++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1365 insertions(+)
>>  create mode 100644 drivers/media/i2c/ov5645.c
> 
> [snip]
> 
>> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
>> new file mode 100644
>> index 0000000..2b33bc6
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov5645.c
> 
> [snip]
> 
>> +static const struct ov5645_mode_info *
>> +ov5645_find_nearest_mode(unsigned int width, unsigned int height)
>> +{
>> +       unsigned int i;
>> +
>> +       for (i = ARRAY_SIZE(ov5645_mode_info_data) - 1; i >= 0; i--) {
>> +               if (ov5645_mode_info_data[i].width <= width &&
>> +                   ov5645_mode_info_data[i].height <= height)
>> +                       break;
>> +       }
>> +
>> +       if (i < 0)
> 
> i needs to be int for this condition to be true.

Oops, I'll fix this for the next version. Let's wait for other feedback too until then.

> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
>> +               i = 0;
>> +
>> +       return &ov5645_mode_info_data[i];
>> +}
> 

-- 
Best regards,
Todor Tomov
