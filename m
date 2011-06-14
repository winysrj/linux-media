Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62228 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1FNOs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 10:48:57 -0400
Received: by eyx24 with SMTP id 24so2060341eyx.19
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 07:48:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF77405.2070104@redhat.com>
References: <4DF6C10C.8070605@redhat.com>
	<4DF758AF.3010301@redhat.com>
	<4DF75C84.9000200@redhat.com>
	<4DF7667C.9030502@redhat.com>
	<BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com>
	<4DF76D88.5000506@redhat.com>
	<4DF77229.2020607@redhat.com>
	<4DF77405.2070104@redhat.com>
Date: Tue, 14 Jun 2011 10:48:55 -0400
Message-ID: <BANLkTimXw37fZMsoOqN3ZcWtg7HY1T-w8Q@mail.gmail.com>
Subject: Re: Some fixes for alsa_stream
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jun 14, 2011 at 10:45 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Pulseaudio sucks. See what happens when I pass "-alsa-pb default" argument to pulseaudio:
>
> 1) ssh section. User is the same as the console owner:
>
> ALSA lib pulse.c:229:(pulse_connect) PulseAudio: Unable to connect: Connection refused
> Cannot open ALSA Playback device default: Connection refused
>
> 2) console, with mmap enabled:
>
> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
> Access type not available for playback: Invalid argument
> Unable to set parameters for playback stream: Invalid argument
> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz with mmap enabled
> write error: File descriptor in bad state
> ...
> write error: File descriptor in bad state
>
> 3) console, with mmap disabled:
>
> Alsa devices: cap: hw:1,0 (/dev/video0), out: default
> Alsa stream started, capturing from hw:1,0, playing back on default at 1 Hz
> write error: Input/output error
> ...
> write error: Input/output error
>
> Pulseaudio needs first to be fixed in order to work like an alsa device, before
> having applications supporting it as default.

People have been screaming about Pulseaudio for *years*, and those
concerns/complaints have largely fallen on deaf ears.  Lennart works
for Red Hat too - maybe you can convince him to take these issues
seriously.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
