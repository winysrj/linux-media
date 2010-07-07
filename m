Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34752 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab0GGFvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 01:51:21 -0400
Received: by gwj21 with SMTP id 21so1672807gwj.19
        for <linux-media@vger.kernel.org>; Tue, 06 Jul 2010 22:51:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C33BBEA.5000807@iki.fi>
References: <4C332A5F.4000706@redhat.com>
	<4C33BBEA.5000807@iki.fi>
Date: Wed, 7 Jul 2010 13:51:18 +0800
Message-ID: <AANLkTilNt3PH6Gxd1wlbVg7JQhfhhvYr8GXQcDPcPAAP@mail.gmail.com>
Subject: Re: Status of the patches under review at LMML (60 patches)
From: Bee Hock Goh <beehock@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Nikola Pajkovsky <npajkovs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I know that a couple of users(including) tested the patch to be
working. Many users(from forum) is still looking for tda18218 support
or have been using a very old hg changeset using another patch also
written by Nikola.

I have been using that old change set for many months and its working
well for me.

On Wed, Jul 7, 2010 at 7:27 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 07/06/2010 04:06 PM, Mauro Carvalho Chehab wrote:
>>
>> This is the summary of the patches that are currently under review at
>> Linux Media Mailing List<linux-media@vger.kernel.org>.
>> Each patch is represented by its submission date, the subject (up to 70
>> chars) and the patchwork link (if submitted via email).
>>
>> P.S.: This email is c/c to the developers where some action is expected.
>>       If you were copied, please review the patches, acking/nacking or
>>       submitting an update.
>>
>
>>                == Waiting for Antti Palosaari<crope@iki.fi>  review ==
>>
>> Mar,21 2010: af9015 : more robust eeprom parsing
>>          http://patchwork.kernel.org/patch/87243
>
> NACK, partly. I think it is rather useless.
>
>
>> May,20 2010: New NXP tda18218 tuner
>>           http://patchwork.kernel.org/patch/101170
>
> AF9015/AF9013: ACK, partly from the AF9015/AF9013 side. It is safe to merge,
> it will not break any currently supported device. But I am not sure if all
> settings are correct since I don't have suitable device (AF9015+TDA18218) to
> figure out configuration and test.
>
> TDA18218: I don't know. I have reviewed it, feedback can be found from the
> patchwork. I don't resist to merge, but also I don't want to take any
> responsibility since I don't have this device.
>
> regards
> Antti
> --
> http://palosaari.fi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
