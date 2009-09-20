Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34197 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZITMzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 08:55:05 -0400
Received: by ewy2 with SMTP id 2so280362ewy.17
        for <linux-media@vger.kernel.org>; Sun, 20 Sep 2009 05:55:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AB4B79C.7000802@iki.fi>
References: <1e68a10b0908150515l217126f7j41e15ece329176e1@mail.gmail.com>
	 <1e68a10b0909182348v2026a57dsc877a8c5c1e9289f@mail.gmail.com>
	 <4AB4B79C.7000802@iki.fi>
Date: Sun, 20 Sep 2009 14:55:06 +0200
Message-ID: <1e68a10b0909200555l32c34d94w8c7beedc04d10c88@mail.gmail.com>
Subject: Re: usb dvb-c tuner status
From: Bert Haverkamp <bert@bertenselena.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti,

Thanks for your list.
The reddo looks interesting, unfortunately distribution is not
widespread. I only see some scandinavian sites. (and your finish
sounding name seems to confirm the above;-) Do you know where they are
coming from?
The annysees are bulky, pricy and i really don't need the cardreader,
because I'm only interested in the free2cable channels.

I know it is a relatively small market.  (couldn't find the exact
spread on wikipedia, but Netherlands is definitely in from personal
experience.)
The fact that dongles like the Hauppauge WinTV-HVR-930C are of yet not
supported is a big shame.
If only the drx-j/k chips could get foss support these devices would
come in reach... But reverse engineering seems to be the only option
there.

Regards,

Bert


On Sat, Sep 19, 2009 at 12:51 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 09/19/2009 09:48 AM, Bert Haverkamp wrote:
>>
>> Hello all,
>>
>> A while back I asked about supported USB dvb-c devices.
>> Meanwhile my search continued and I have extended my list of available
>> devices.
>> Unfortunately, none of them currently are supported by linux.
>>
>> Does anyone have viable solution for me?
>>
>> - Technotrend CT 1200 which is an old device, hard to get.
>> - Technotrend CT-3650 for which there is one report that dvb-c works
>> with a patch,(is this already in-tree?), but dvb-t and CI not
>>  - Sundtek MediaTV Pro for which a closed source driver exists. I
>> don't want to go that way.
>>  Terratec Cinergy Hybrid H5  which seems to be troubled with a driver
>> for a drx-k or drx-j chip.
>> - Pinnacle 340e, depends on the xc4000 chip, under development by Devin.
>> - Hauppauge WinTV HVR-930C, also drx-j based as far as I can see
>
> Anysee E30C Plus
> Anysee E30 Combo (DVB-T/DVB-C)
> Reddo DVB-C USB BOx (I just added, goes to 2.6.32)
>
> All those are using Philips TDA10023 demod, which seems to be almost only
> solution currently for open Linux DVB-C. Anysee contains also smartcard
> reader which is not supported (it is not CAM, just reader). Unfortunately
> market situation for those devices is currently few EU countries or Finland
> only.
>
> Antti
> --
> http://palosaari.fi/
>



-- 
-----------------------------------------------------
38 is NOT a random number!!!!
