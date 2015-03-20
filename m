Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34196 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbCTMLX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 08:11:23 -0400
MIME-Version: 1.0
In-Reply-To: <550C0D1C.1070200@gmail.com>
References: <1426852133-14539-1-git-send-email-prabhakar.csengg@gmail.com> <550C0D1C.1070200@gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 20 Mar 2015 12:10:51 +0000
Message-ID: <CA+V-a8uMa9j5BHKPDakXYZn_cXwp_e8t1CyguVshJTm=A-mqMQ@mail.gmail.com>
Subject: Re: [PATCH v8] media: i2c: add support for omnivision's ov2659 sensor
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 20, 2015 at 12:05 PM, Varka Bhadram <varkabhadram@gmail.com> wrote:
> On 03/20/2015 05:18 PM, Lad Prabhakar wrote:
>
>> From: Benoit Parrot <bparrot@ti.com>
>>
>> this patch adds support for omnivision's ov2659
>> sensor, the driver supports following features:
>> 1: Asynchronous probing
>> 2: DT support
>> 3: Media controller support
>>
>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>   Changes for v8:
>>   --------------
>>   a. Now setting the link_frequency control in set_fmt
>>      callback instead of implementing g_volatile_ctrl()
>>      for it and setting it there.
>>
>>   v7: https://patchwork.kernel.org/patch/6034651/
>>   v6: https://patchwork.kernel.org/patch/6012751/
>>   v5: https://patchwork.kernel.org/patch/6000161/
>>   v4: https://patchwork.kernel.org/patch/5961661/
>>   v3: https://patchwork.kernel.org/patch/5959401/
>>   v2: https://patchwork.kernel.org/patch/5859801/
>>   v1: https://patchwork.linuxtv.org/patch/27919/
>>
>>   .../devicetree/bindings/media/i2c/ov2659.txt       |   38 +
>>   MAINTAINERS                                        |   10 +
>>   drivers/media/i2c/Kconfig                          |   11 +
>>   drivers/media/i2c/Makefile                         |    1 +
>>   drivers/media/i2c/ov2659.c                         | 1528
>> ++++++++++++++++++++
>>   include/media/ov2659.h                             |   33 +
>>   6 files changed, 1621 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/media/i2c/ov2659.txt
>>   create mode 100644 drivers/media/i2c/ov2659.c
>>   create mode 100644 include/media/ov2659.h
>>
> (...)
>
>> +static struct ov2659_platform_data *
>> +ov2659_get_pdata(struct i2c_client *client)
>> +{
>> +       struct ov2659_platform_data *pdata;
>> +       struct device_node *endpoint;
>> +       int ret;
>> +
>> +       if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node) {
>> +               dev_err(&client->dev, "ov2659_get_pdata: DT Node
>> found\n");
>
>
> ov2659_get_pdata: DT Node *not* found...?
>
Good catch!

Cheers,
--Prabhakar Lad
