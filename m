Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63010 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1FNNwM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 09:52:12 -0400
Received: by ewy4 with SMTP id 4so2024860ewy.19
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 06:52:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF7667C.9030502@redhat.com>
References: <4DF6C10C.8070605@redhat.com>
	<4DF758AF.3010301@redhat.com>
	<4DF75C84.9000200@redhat.com>
	<4DF7667C.9030502@redhat.com>
Date: Tue, 14 Jun 2011 09:52:10 -0400
Message-ID: <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com>
Subject: Re: Some fixes for alsa_stream
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jun 14, 2011 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hmm, we really don't need more cmdline options IMHO, it is quite easy to
> detect
> if an alsa device supports mmap mode, and if not fall back to r/w mode, I
> know
> several programs which do that (some if which I've written the patches to do
> this for myself).

Agreed.

>> It should be noticed that the driver tries first to access the alsa driver
>> directly,
>> by using hw:0,0 output device. If it fails, it falls back to plughw:0,0.
>> I'm not sure
>> what's the name of the pulseaudio output, but I suspect that both are just
>> bypassing
>> pulseaudio, with is good ;)
>
> Right this means you're just bypassing pulse audio, which for a tvcard +
> tv-viewing

Actually, the ALSA client libraries route through PulseAudio (as long
as Pulse is running).  Basically PulseAudio is providing emulation for
the ALSA interface even if you specify "hw:1,0" as the device.

> app is a reasonable thing to do. Defaulting to hw:0,0 makes no sense to me
> though, we
> should default to either the audio devices belonging to the video device (as
> determined
> through sysfs), or to alsa's default input (which will likely be
> pulseaudio).

Mauro was talking about the output device, not the input device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
