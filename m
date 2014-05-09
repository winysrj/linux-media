Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:58653 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaEIMi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 08:38:58 -0400
Received: by mail-yh0-f53.google.com with SMTP id i57so1387104yha.12
        for <linux-media@vger.kernel.org>; Fri, 09 May 2014 05:38:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <536C3403.8010402@cevel.net>
References: <536C3403.8010402@cevel.net>
Date: Fri, 9 May 2014 08:38:57 -0400
Message-ID: <CALzAhNVtyhmt8cCapu2oK5pGkJY2zNTaf6Ws26Sn9kZxgAddew@mail.gmail.com>
Subject: Re: Support for Elgato Game Capture HD / MStar MST3367CMK
From: Steven Toth <stoth@kernellabs.com>
To: tolga@cevel.net
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 8, 2014 at 9:48 PM, Tolga Cakir <tolga@cevel.net> wrote:
> Hello everyone!

Hi Tolga!

>
> Over the past weeks, I've been busy capturing USB packets between the Elgato
> Game Capture HD and my PC. It's using the MStar MST3367CMK chip, which seems
> to have proprietary Linux support available only for hardware vendors in
> form of an SDK. Problem is, that this SDK is strictly kept under an NDA,
> making it kinda impossible for us to get our hands on.

Thanks for raising the subject.

While your comment is true, it would have been more appropriate to the
development community to say that it truly uses the Fujitsu USB
encoder, a fujitsu USB API along with a series of smaller subsystems
for HDMI receivers and transmitters. Your capture logs indicate
(largely) interaction with the Fujitsu USB bridge + integral encoder.
The distinction is important.

We outlined the architecture of the device (along with the brief tear
down) here: http://www.kernellabs.com/blog/?p=1959

>
> So, I got my hands dirty and have found some very good stuff! First of all,
> in contrast to many sources, the Elgato Game Capture HD outputs compressed
> video and audio via USB! It's already encoded, so there is no need for
> reencoding, this will save CPU power. For testing purposes, I've only tried
> capturing 720p data for now, but this should be more than enough.

Have you posted any source code? I don't see any in the zips or on github.

Paging through a 600MB usb capture to find an occasional comment
(assuming you have inserted them) doesn't encourage me to contribute.

>
> Basically, we need to read raw USB traffic, write an MPEG-TS file header,
> put in the raw USB data and close the file. I'm not super experienced in C /
> kernel development (especially V4L), but I'll give my best to get this
> project forward. My next step is getting a prototype working with libusb in
> userland; after that's done, I'll try porting it over to kernel / V4L
>
> Project page can be found here:
> https://github.com/tolga9009/elgato-gchd

I must be missing something. your repo contains a LICENSE file and
README. Did you forget to checking a homebrew datasheet or working
sample source code?

>
> USB logs and docs:
> v1.0 as 7zip: https://docs.google.com/file/d/0B29z6-xPIPLEQVBMTWZHbUswYjg
> v1.0 as rar: https://docs.google.com/file/d/0B29z6-xPIPLEcENMWnh1MklPdTQ
> v1.0 as zip: https://docs.google.com/file/d/0B29z6-xPIPLEQWtibWk3T3AtVjA

Ahh, thank you for circulating the datasheets and images from our blog
post, you are most welcome! The internet is a wonderful thing, I'm
glad you found them useful.

>
> Is anyone interested in getting involved / taking over? Overall, it seems
> doable and not too complex. I'd be happy about any help! Also, if you need
> more information, just ask me. I'll provide you everything I have about this
> little device.

How about instead of some usb dumps, pictures and pdfs, a working
program and a description of the device protocol? This would help.

I spent a few days late 2012 with the usb analyzer and brought
together a primitive collection of personal notes on the API. Sadly
I'm struggling to locate them currently. From memory, the device has
an odd protocol which isn't exactly obvious. Its firmware like, not
i2c based. You don't appear to control the HDMI rx/tx silicon by hand,
the fijutsu firmware does this via firmware APIs. you would think,
YAY! firmware API, easy, surprisingly not. A lot of byte guess to be
done. If you have any significant homebrew documentation on the byte
sequences that control the device, this would help.

Part of the problem is that the device also streams (with the
windows/osx drivers I was using) permanently on, making it difficult
to see the wood from the noise. So, even when you are not 'using it',
its streaming payload via USB to the host. Urgh. I hope they've fixed
this.

The device outputs native ISO13818 TS packets which are easily
playable in VLC as is. I don't even think you need to add a header,
unless you are electing to create an updated PMT.

I have datasheets and/or source on everything except the fujitsu
encoder, sorry - I can't share.

Keep going with your project, this should be a fun to follow. libusb
is easy to work with, you should have the device running in no time.

If you can make the device run at both 720p and 1080i then you should
find enough variance in the protocol bytes, build that into your app,
to be useful for some people.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
