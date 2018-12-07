Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C929C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D6120892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0D6120892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbeLGLax (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:30:53 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35893 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726006AbeLGLaw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 06:30:52 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VELHg64hlgJOKVELKgYZIA; Fri, 07 Dec 2018 12:30:51 +0100
Subject: Re: [PATCH 4/5 RESEND] si470x-i2c: Add optional reset-gpio support
To:     =?UTF-8?Q?Pawe=c5=82_Chmiel?= <pawel.mikolaj.chmiel@gmail.com>
Cc:     Michael Nazzareno Trimarchi <michael@amarulasolutions.com>,
        linux-media@vger.kernel.org
References: <20181205154750.17996-5-pawel.mikolaj.chmiel@gmail.com>
 <231a4d80-4026-c17c-dfcc-80a304965391@xs4all.nl>
 <CAOf5uwmXjYMdEj9SCtmem881Jm8YUzjUrjsZf9gjZ48RBdV7DQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <53ee96b5-ddd4-02ad-c165-3f719024bbae@xs4all.nl>
Date:   Fri, 7 Dec 2018 12:30:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAOf5uwmXjYMdEj9SCtmem881Jm8YUzjUrjsZf9gjZ48RBdV7DQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfME3hm0qAarb2auowSXxKbKFsHrh3fYnVA+9Pzar0ByQO4K7mcdUcoSxmy4HhCPQYshb5DptooV0gmVCUd+0ya57ysTVkMC/lMmkQe4MZ5bemz0WaNCr
 Y/GzFlxFiggACnjtx6m5ZxJkHZ5ehSjNjQSvaaWa4jvmyKFGvUrUySBgw0pUauV922jBNTGTC2ViWJPdfLRIHszV8tbprupVcczqVGQaN2YyTvMPo17kz+a+
 /nEHByIyyokXYQH21ZOqw8ETtHZdufMDovwOgQrnWSE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Adding the actual author :-)

Regards,

	Hans

On 12/07/2018 12:25 PM, Michael Nazzareno Trimarchi wrote:
> Hi
> 
> On Fri, Dec 7, 2018 at 12:12 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> Subject: [PATCH 4/5] si470x-i2c: Add optional reset-gpio support
>> Date: Wed,  5 Dec 2018 16:47:49 +0100
>> From: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
>> To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
>> CC: hverkuil@xs4all.nl, fischerdouglasc@gmail.com, keescook@chromium.org, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
>> devicetree@vger.kernel.org, Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
>>
>> If reset-gpio is defined, use it to bring device out of reset.
>> Without this, it's not possible to access si470x registers.
>>
>> Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
>> ---
>> For some reason this patch was not picked up by patchwork. Resending to see if
>> it is picked up now.
>> ---
>>  drivers/media/radio/si470x/radio-si470x-i2c.c | 15 +++++++++++++++
>>  drivers/media/radio/si470x/radio-si470x.h     |  1 +
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
>> index a7ac09c55188..15eea2b2c90f 100644
>> --- a/drivers/media/radio/si470x/radio-si470x-i2c.c
>> +++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/i2c.h>
>>  #include <linux/slab.h>
>>  #include <linux/delay.h>
>> +#include <linux/gpio/consumer.h>
>>  #include <linux/interrupt.h>
>>   #include "radio-si470x.h"
>> @@ -392,6 +393,17 @@ static int si470x_i2c_probe(struct i2c_client *client,
>>         radio->videodev.release = video_device_release_empty;
>>         video_set_drvdata(&radio->videodev, radio);
>>  +      radio->gpio_reset = devm_gpiod_get_optional(&client->dev, "reset",
>> +                                                   GPIOD_OUT_LOW);
>> +       if (IS_ERR(radio->gpio_reset)) {
>> +               retval = PTR_ERR(radio->gpio_reset);
>> +               dev_err(&client->dev, "Failed to request gpio: %d\n", retval);
>> +               goto err_all;
>> +       }
>> +
>> +       if (radio->gpio_reset)
>> +               gpiod_set_value(radio->gpio_reset, 1);
>> +
>>         /* power up : need 110ms */
>>         radio->registers[POWERCFG] = POWERCFG_ENABLE;
>>         if (si470x_set_register(radio, POWERCFG) < 0) {
>> @@ -478,6 +490,9 @@ static int si470x_i2c_remove(struct i2c_client *client)
>>         video_unregister_device(&radio->videodev);
>>  +      if (radio->gpio_reset)
>> +               gpiod_set_value(radio->gpio_reset, 0);
> 
> I have a question for you. If the gpio is the last of the bank
> acquired for this cpu, when you put to 0, then the gpio will
> be free on remove and the clock of the logic will be deactivated so I
> think that you don't have any
> garantee that the state will be 0
> 
> Michael
> 
>> +
>>         return 0;
>>  }
>>  diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
>> index 35fa0f3bbdd2..6fd6a399cb77 100644
>> --- a/drivers/media/radio/si470x/radio-si470x.h
>> +++ b/drivers/media/radio/si470x/radio-si470x.h
>> @@ -189,6 +189,7 @@ struct si470x_device {
>>   #if IS_ENABLED(CONFIG_I2C_SI470X)
>>         struct i2c_client *client;
>> +       struct gpio_desc *gpio_reset;
>>  #endif
>>  };
>>  -- 2.17.1
>>
> 
> 

