Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:55536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab1FPM3D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 08:29:03 -0400
Message-ID: <4DF9F734.1090508@redhat.com>
Date: Thu, 16 Jun 2011 14:29:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some fixes for alsa_stream
References: <4DF6C10C.8070605@redhat.com>	<4DF758AF.3010301@redhat.com>	<4DF75C84.9000200@redhat.com>	<4DF7667C.9030502@redhat.com> <BANLkTi=9L+oxjpUaFo3ge0iqcZ2NCjJWWA@mail.gmail.com> <4DF76D88.5000506@redhat.com> <4DF77229.2020607@redhat.com> <4DF77405.2070104@redhat.com> <4DF8B716.1020406@redhat.com> <4DF8C0D2.5070900@redhat.com> <4DF8C32A.7090004@redhat.com> <4DF8D37C.7010307@redhat.com>
In-Reply-To: <4DF8D37C.7010307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/15/2011 05:45 PM, Mauro Carvalho Chehab wrote:

<snip>

> 1) try to find a common buffer size that are acceptable by both drivers,
>     as using the same buffer size helps to avoid memcpy's, especially if
>     mmap mode is enabled;
>

This is not needed, using the same buffer size does nothing to avoid memcpy's
there are 2 possible scenarios:
1) Use read() + write() like we do now, this means 2 memcpy's in the form
    of copy_to_user to our buffer followed by a copy_from_user, and we don't
    need to care about buffer sizes, we just write the amount of samples we
    managed to read.

2) Properly implemented mmap, in this case we need to do a regular
    memcpy in userspace from the mmap-ed capture buffers to the mmapped
    playback buffers. In this case having indentical buffersizes would
    simplify the code, as it avoids the need to split the memcpy into
    multiple memcpy's when crossing a buffer boundary. But we
    need to handle this case anyways in case we cannot find a shared
    period size. More over mmap mode is a pain and just not worth it IMHO.

> 2) If the buffer size means that the latency will be more than a reasonable
>     time interval [1], then fall back to use different periods;

It is better to just aim for the optimal period size right away, this
greatly simplifies the code, as said before trying to get identical buffer
sizes is premature optimization IMHO. xawtv barely registers in top on
my machine and this includes copying over the actual video data from
/dev/video# to shared memory xv pixmaps. If that part does not even
register imagine how little CPU the audio part is using. There is no
need to make the code more complicated for some theoretical performance
gain here, instead we should KISS.

Note that I've just pushed a patch set which includes rewritten period
/ buf size negotiation and a bunch of cleanups in general. This removes
over 150 lines of code, while at the same time making the code more
flexible. It should now work with pretty much any combination of
input / output device (tested with a bt878 input and intel hda,
usb-audio or pulseaudio output).

I've also changed the default -alsa-pb value to "default" as we should
not be picking something else then the user / distro configured defaults
for output IMHO. The user can set a generic default in alsarc, and override
that on the cmdline if he/she wants, but unless overridden on the cmdline
we should respect the users generic default as specified in his
alsarc.

We could consider making the desired latency configurable, currently
I've hardcoded it to 30 ms (was 38 with the old code on my system) note
that I've chosen to specify the latency in ms rather then in a number
of samples, since it should be samplerate independent IMO.

Regards,

Hans
