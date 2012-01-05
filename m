Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39218 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AEXHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 18:07:33 -0500
Received: by qcqz2 with SMTP id z2so619113qcq.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 15:07:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiw7c8=o5doJcYctmRbsj-idmxsRKVE5OzCOQ_xhLGBxMg@mail.gmail.com>
References: <CAHF9RemG4M2apwcbUG+7YvkLrbpoZmE6Nh2XMHPT4FM3jRW_Ng@mail.gmail.com>
	<CAGoCfiwEeFiU+0scdZ48nbDfF-NCg8Ac701XkCZtXuTjckq0ng@mail.gmail.com>
	<CAHF9Re=V8MOH-wg8TWeMjSC9d-iOtWAWH-RshPAxbBjiP65OJQ@mail.gmail.com>
	<CAGoCfiw7c8=o5doJcYctmRbsj-idmxsRKVE5OzCOQ_xhLGBxMg@mail.gmail.com>
Date: Fri, 6 Jan 2012 00:07:32 +0100
Message-ID: <CAHF9RemRjBz8whMHi79dgXk3TYCs0nEftOD0SSh1O-5Ych989Q@mail.gmail.com>
Subject: Re: Support for RC-6 in em28xx driver?
From: =?ISO-8859-1?Q?Simon_S=F8ndergaard?= <john7doe@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/1/5 Devin Heitmueller <dheitmueller@kernellabs.com>:
> 2012/1/5 Simon Søndergaard <john7doe@gmail.com>:
>> 2012/1/5 Devin Heitmueller <dheitmueller@kernellabs.com>:
>>> 2012/1/5 Simon Søndergaard <john7doe@gmail.com>:
>>>> Hi,
>>>>
>>>> I recently purchased a PCTV 290e USB Stick (em28174) it comes with a
>>>> remote almost as small as the stick itself... I've been able to get
>>>> both stick and remote to work. I also own an MCE media center remote
>>>> from HP (this make
>>>> http://www.ebay.com/itm/Original-Win7-PC-MCE-Media-Center-HP-Remote-Controller-/170594956920)
>>>> that sends RC-6 codes. While it do have a windows logo I still think
>>>> it is vastly superior to the one that shipped with the stick :-)
>>>>
>>>> If I understand it correctly em28174 is a derivative of em2874?
>>>>
>>>> In em28xx-input.c it is stated that: "em2874 supports more protocols.
>>>> For now, let's just announce the two protocols that were already
>>>> tested"
>>>>
>>>> I've been searching high and low for a datasheet for em28(1)74, but
>>>> have been unable to find it online. Do anyone know if one of the
>>>> protocols supported is RC-6? and if so how do I get a copy of the
>>>> datasheet?
>>>
>>> The 2874 supports NEC, RC-5, and RC-6/6A.  I did the original support
>>> (based on the docs provided under NDA) but ironically enough I didn't
>>> have an RC6 remote kicking around so I didn't do the support for it.
>>>
>>> IR receivers for MCE devices are dirt cheap (< $20), and if you're
>>> doing a media center then it's likely the PCTV 290e probably isn't in
>>> line-of-site for a remote anyway.
>>
>> The 290e will be in line of sight.
>>
>> Perhaps the info is already there, not sure why I overlooked it in the
>> first place:
>>
>> EM2874_IR_RC6_MODE_0    0x08
>> EM2874_IR_RC6_MODE_6A 0x0b
>
> Ah, so I guess I did put at least some of the info into the driver.
> Also, for RC6 make sure bits 0-1 are 00 and for RC6A they need to be
> set based on the number of bytes expected to be received (2 bytes=00,
> 3bytes=01, 4bytes=10).  The received data gets stored in 0x52-0x55 (I
> don't remember if the driver actually looks are 0x54/55 currently
> since they aren't used for NEC or RC5)..
>

The driver already reads up to 0x55.

Do you mean bits 0-1 of EM2874_R50_IR_CONFIG? The Driver code and the
defines above is in LSB 0 syntax, so bit 0-1 would overlap with the
0x0b value... Regardless I tried using 0x8b, 0x4b, 0x0b, 0x0a and 0x09
as the value for EM2874_R50_IR_CONFIG, but I never observed any
changes to EM2874_R51_IR :-(

I'm assuming that read count should still be read from EM2874_R51_IR
regardless of the mode

Br,
/Simon
