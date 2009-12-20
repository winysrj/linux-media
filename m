Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:41817 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZLTX5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 18:57:32 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2097097fgg.1
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 15:57:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <74fd948d0912201540u287dedaby81932da32359a11a@mail.gmail.com>
References: <74fd948d0912200907j21fcc7b1qd2bfd2da00d4f72@mail.gmail.com>
	 <829197380912201032re3590ael3c4f70ce2afa6349@mail.gmail.com>
	 <74fd948d0912201540u287dedaby81932da32359a11a@mail.gmail.com>
Date: Mon, 21 Dec 2009 00:57:29 +0100
Message-ID: <d9def9db0912201557r78a528aaod2aeb6b68f90763a@mail.gmail.com>
Subject: Re: Pinnacle PCTV Hybrid (2) dvb woes
From: Markus Rechberger <mrechberger@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 21, 2009 at 12:40 AM, Pedro Ribeiro <pedrib@gmail.com> wrote:
> On Sun, Dec 20, 2009 at 6:32 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> On Sun, Dec 20, 2009 at 12:07 PM, Pedro Ribeiro <pedrib@gmail.com> wrote:
>>> Hello all,
>>>
>>> I'm having trouble setting up DVB for my Pinnacle PCTV Hybrid Stick
>>> (2), AKA 330e.
>>
>> You can check the linux-media archives for more info, but I can tell
>> you that the 330e is not currently supported for DVB mode (analog
>> only).
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
>>
>
> Damn, I suspected that.
>
> Anyway, I'm having trouble viewing analog TV. I can scan and watch
> channels fine, but there is no audio, and I don't know how to
> configure it. If you could help me, I would really appreciate it
>
> Should I use the em28xx soundcard for output or my own internal soundcard?
>
> tvtime only uses ALSA, but my internal soundcard as OSS mixer
> emulation (the em28xx has not). However, I cannot control the volume
> in tvtime
>
> Alsa says that the em28xx soundcard has no mixer controls.
>

for some reason I would say to sell the card and buy another device (which one?)
Pinnacle never wanted to pay developers, although they were interested
in Linux drivers.
Their max offer was 500 eur/half year for writing a linux driver for
them. Devin is smart enough
to "work" for them for free (smart dude!). Since I got that offer on
the phone I denied to do any work for them anymore.
Even though if it is opensource (with an obvious bad quality) it should not be
free for them). But this also explains their previous quality of the
windows software.
Nowadays PCTV Systems is selling half working hardware in eastern Europe (wonder
why they are not selling it in Germany, fear of getting sued by someone?)...

Markus
