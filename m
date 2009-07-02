Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:41173 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbZGBVS4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 17:18:56 -0400
Received: by qyk31 with SMTP id 31so2142071qyk.33
        for <linux-media@vger.kernel.org>; Thu, 02 Jul 2009 14:18:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A4D1DBD.4080607@powercraft.nl>
References: <4A4481AC.4050302@powercraft.nl> <4A4A71B9.5010603@powercraft.nl>
	 <4A4C7349.2080705@powercraft.nl>
	 <829197380907020909s98d5a4s2d8fa1e145f2d64@mail.gmail.com>
	 <4A4D1DBD.4080607@powercraft.nl>
Date: Thu, 2 Jul 2009 17:18:58 -0400
Message-ID: <829197380907021418x58c5e1c1q7976c47f9c17fddb@mail.gmail.com>
Subject: Re: Afatech AF9013 DVB-T not working with mplayer radio streams
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 2, 2009 at 4:51 PM, Jelle de Jong<jelledejong@powercraft.nl> wrote:
> Devin Heitmueller wrote:
>> On Thu, Jul 2, 2009 at 4:43 AM, Jelle de Jong<jelledejong@powercraft.nl> wrote:
>>> Is there an other USB DVB-T device that works out of the box with the
>>> 2.9.30 kernel? Could somebody show me a link or name of this device so I
>>> can buy and test it?
>>
>> You might want to check out the WinTV-Ministick, which is both
>> currently available for sale and supported in Linux.
>>
>> http://www.hauppauge.co.uk/site/products/data_ministickhd.html
>>
>> Devin
>>
>
> Hi Devin,
>
> Thanks for your response, I am kind of hitting a deadline next Tuesday.
> I must a kind of working dvb-t system here. The af9013 will be a backup
> plan.
>
> So this is my local supplier. Can I ask you to just make a list of
> product ids (ArtNr) and I will order them, if they do not work I will
> sent them out to developers that volunteer:
>
> http://www.informatique.nl/cgi-bin/iqshop.cgi?M=ART&G=167
>
> I am only interested in USB DVB-T devices. I will try to make the order
> tomorrow morning.
>
> Thanks in advance,
>
> Cheers,
>
> Jelle

Jelle,

Well, before I offer any suggestions, bear in mind that I actually
don't use DVB-T and I don't have these products, so I cannot claim
that they work from my own experience.

Looking at the DVB-T USB entries in list you sent:

the ASUS U3000 works according to the Wiki:

http://linuxtv.org/wiki/index.php/ASUS_My_Cinema-U3000_Mini

>From the Hauppauge list, the any HVR-900 you would buy today would
almost certainly be an "HVR-900 R2", which is known to not be
supported in the current tree.

>From the Pinnacle list, I can tell you that both versions of the 340e
are not supported (I am actively developing the xc4000 driver required
for them this week).  According to the wiki, both the 72e and 73e do
work:

http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_72e
http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_nano_Stick_%2873e%29

I'm not familiar with the products from Plextor and Technisat.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
