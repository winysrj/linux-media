Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:38114 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZLTXka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 18:40:30 -0500
Received: by ewy1 with SMTP id 1so5787333ewy.28
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 15:40:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912201032re3590ael3c4f70ce2afa6349@mail.gmail.com>
References: <74fd948d0912200907j21fcc7b1qd2bfd2da00d4f72@mail.gmail.com>
	 <829197380912201032re3590ael3c4f70ce2afa6349@mail.gmail.com>
Date: Sun, 20 Dec 2009 23:40:27 +0000
Message-ID: <74fd948d0912201540u287dedaby81932da32359a11a@mail.gmail.com>
Subject: Re: Pinnacle PCTV Hybrid (2) dvb woes
From: Pedro Ribeiro <pedrib@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 20, 2009 at 6:32 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sun, Dec 20, 2009 at 12:07 PM, Pedro Ribeiro <pedrib@gmail.com> wrote:
>> Hello all,
>>
>> I'm having trouble setting up DVB for my Pinnacle PCTV Hybrid Stick
>> (2), AKA 330e.
>
> You can check the linux-media archives for more info, but I can tell
> you that the 330e is not currently supported for DVB mode (analog
> only).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

Damn, I suspected that.

Anyway, I'm having trouble viewing analog TV. I can scan and watch
channels fine, but there is no audio, and I don't know how to
configure it. If you could help me, I would really appreciate it

Should I use the em28xx soundcard for output or my own internal soundcard?

tvtime only uses ALSA, but my internal soundcard as OSS mixer
emulation (the em28xx has not). However, I cannot control the volume
in tvtime

Alsa says that the em28xx soundcard has no mixer controls.


Thanks,
Pedro
