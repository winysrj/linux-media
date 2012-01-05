Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:38283 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab2AEU5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 15:57:34 -0500
Received: by qadb15 with SMTP id b15so595134qad.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 12:57:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiwEeFiU+0scdZ48nbDfF-NCg8Ac701XkCZtXuTjckq0ng@mail.gmail.com>
References: <CAHF9RemG4M2apwcbUG+7YvkLrbpoZmE6Nh2XMHPT4FM3jRW_Ng@mail.gmail.com>
	<CAGoCfiwEeFiU+0scdZ48nbDfF-NCg8Ac701XkCZtXuTjckq0ng@mail.gmail.com>
Date: Thu, 5 Jan 2012 21:57:33 +0100
Message-ID: <CAHF9Re=V8MOH-wg8TWeMjSC9d-iOtWAWH-RshPAxbBjiP65OJQ@mail.gmail.com>
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
>> Hi,
>>
>> I recently purchased a PCTV 290e USB Stick (em28174) it comes with a
>> remote almost as small as the stick itself... I've been able to get
>> both stick and remote to work. I also own an MCE media center remote
>> from HP (this make
>> http://www.ebay.com/itm/Original-Win7-PC-MCE-Media-Center-HP-Remote-Controller-/170594956920)
>> that sends RC-6 codes. While it do have a windows logo I still think
>> it is vastly superior to the one that shipped with the stick :-)
>>
>> If I understand it correctly em28174 is a derivative of em2874?
>>
>> In em28xx-input.c it is stated that: "em2874 supports more protocols.
>> For now, let's just announce the two protocols that were already
>> tested"
>>
>> I've been searching high and low for a datasheet for em28(1)74, but
>> have been unable to find it online. Do anyone know if one of the
>> protocols supported is RC-6? and if so how do I get a copy of the
>> datasheet?
>
> The 2874 supports NEC, RC-5, and RC-6/6A.  I did the original support
> (based on the docs provided under NDA) but ironically enough I didn't
> have an RC6 remote kicking around so I didn't do the support for it.
>
> IR receivers for MCE devices are dirt cheap (< $20), and if you're
> doing a media center then it's likely the PCTV 290e probably isn't in
> line-of-site for a remote anyway.

The 290e will be in line of sight.

Perhaps the info is already there, not sure why I overlooked it in the
first place:

EM2874_IR_RC6_MODE_0    0x08
EM2874_IR_RC6_MODE_6A 0x0b

RC5 and RC6 use same carrier frequency? so do I need another value for
EM28XX_R0F_XCLK?

Br,
/Simon

 That said, if you still really want
> to see it supported I can probably find a couple of hours to do it (or
> walk Mauro through the register differences if he cares to).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
