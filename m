Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:58300 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbZEWShe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 14:37:34 -0400
Received: by fxm12 with SMTP id 12so483237fxm.37
        for <linux-media@vger.kernel.org>; Sat, 23 May 2009 11:37:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A18358F.6040404@gmail.com>
References: <200905230810.39344.jarhuba2@poczta.onet.pl>
	 <1a297b360905222341t4e66e2c6x95d339838db43139@mail.gmail.com>
	 <200905231436.58072.gernot@pansy.at> <4A180DD8.4030009@gmail.com>
	 <1a297b360905230941m69085ab5jf3b75f3c42ded48b@mail.gmail.com>
	 <4A18358F.6040404@gmail.com>
Date: Sat, 23 May 2009 22:37:33 +0400
Message-ID: <1a297b360905231137i157e5dbt2c023e656c690e99@mail.gmail.com>
Subject: Re: Question about driver for Mantis
From: Manu Abraham <abraham.manu@gmail.com>
To: David Lister <foceni@gmail.com>
Cc: Gernot Pansy <gernot@pansy.at>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 23, 2009 at 9:42 PM, David Lister <foceni@gmail.com> wrote:
> Manu Abraham wrote:
>> 2009/5/23 David Lister <foceni@gmail.com>:
>>
>>> Not sure if you didn't get this email already, I had a slip-up while
>>> sending it. :) Anyway, there's also another supported card with a CI. A
>>> friend of mine has it, so I guess it works quite well with Linux. It's
>>> Mystique SaTiX-S2 (AFAIK, similar to KNC1+). Mystiques have rather
>>> quality finish and the CI module is ready for 3.5" drive installation.
>>> Some pictures from google:
>>>
>>> http://www.cesarex.com/images/Mystique-CI-1.jpg
>>> http://www.sat-servis.cz/data/eshop/fotky/produkty/velke/619.jpg
>>>
>>> Others might be able to tell you more details, I just know it works -
>>> friend has a Cryptoworks CAM in it. Take a look around, bye.
>>>
>>
>> The Mystique is just a rebranded KNC1+ which just uses the same
>> STB0899 module, FYI. :-)
>>
> Not exactly. People usually say it is a rebrand/clone of KNC1+, but it's
> not. :) There are couple of differences -- Mystique is a lighter version
> missing these features:
> 1) Signal passthrough via loop-out connector
> 2) Video input port for analogue capture
>
> I'm glad you reminded me of this misconception, the differences might be
> important for somebody. I was considering Mystique for myself, but chose
> CX24116 over STB0899, because this time, I wanted official support. I
> don't need analogue capture and CI anyway (I use softcam and for analog,
> much better Hauppauge PVR-500). I suggest Mystique instead of KNC1+ for
> purely practical reasons - it's more available, cheaper and nicer. :)


No misconceptions:


So support for it just appeared like magic ?

There are 2 card variants:

1. KNC1
a) KNC1 DVB-S2+ (With analog support)
b) KNC1 DVB-S2 (without analog support, the board has the place to
solder the SAA7113, just that no chip and connectors)

2. Satelco

Satelco DVB-S2 KNC1 (OEM clone of b)

3. Mystique

CI uses polling model in all the above 3.

Mystique (clone of KNC1 either A or B, even subsystem ID's itself
aren't different, AFAICS)



Now, there are other STB0899 based cards:

4. TT S2 3200

Very similar to the ST reference design. Uses a SAA7146 for the PCI bridge
CI uses an interrupt driven model.

5. VP-1041

Very similar to the ST reference design. Uses a Mantis PCI bridge.

CI is using a much different model. CI slot supports raw PCMCIA devices as well.
currently CI support is very preliminary and not much functional.

HTH
