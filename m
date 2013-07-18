Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:53459 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3GRQfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 12:35:21 -0400
Received: by mail-ea0-f170.google.com with SMTP id h10so1867839eaj.29
        for <linux-media@vger.kernel.org>; Thu, 18 Jul 2013 09:35:20 -0700 (PDT)
Message-ID: <51E819CD.8060400@googlemail.com>
Date: Thu, 18 Jul 2013 18:37:33 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Alban Browaeys <alban.browaeys@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 1/4] [media] em28xx: fix assignment of the eeprom data.
References: <1374015476-26197-1-git-send-email-prahal@yahoo.com> <51E80622.3020803@googlemail.com> <51E80F10.8030406@iki.fi>
In-Reply-To: <51E80F10.8030406@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.07.2013 17:51, schrieb Antti Palosaari:
> On 07/18/2013 06:13 PM, Frank Schäfer wrote:
>> Am 17.07.2013 00:57, schrieb Alban Browaeys:
>>> Set the config structure pointer to the eeprom data pointer (data,
>>> here eedata dereferenced) not the pointer to the pointer to
>>> the eeprom data (eedata itself).
>>>
>>> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
>>> ---
>>>   drivers/media/usb/em28xx/em28xx-i2c.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c
>>> b/drivers/media/usb/em28xx/em28xx-i2c.c
>>> index 4851cc2..c4ff973 100644
>>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>>> @@ -726,7 +726,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev,
>>> unsigned bus,
>>>
>>>       *eedata = data;
>>>       *eedata_len = len;
>>> -    dev_config = (void *)eedata;
>>> +    dev_config = (void *)*eedata;
>>>
>>>       switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
>>>       case 0:
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>
> Does that SOB mean you will pick that patch via you tree, or was it
> only a mistake?

No, I don't have a public tree.
Following the official rules (SubmittingPatches) strictly, it should
indeed have been Acked-by instead, sorry.

>
> I have thought few times what should I reply to patches which are for
> modules I am maintaining and I will pick up and pull-request via own
> tree. Usually I just reply "patch applied" but maybe Signed-off-by is
> used for same.

The problem is, that although there are rules, things like this are
handled slightly differently from project to project. (Coding style is
the other example ;) )
I'm always trying to adapt myself to the habits of a project, but
sometimes I make a mistake (especially when switching between multiple
projects).

Regards,
Frank

>
> regards
> Antti
>

