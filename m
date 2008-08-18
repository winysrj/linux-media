Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <robert.golding@gmail.com>) id 1KUwJV-0005AK-3u
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 06:26:06 +0200
Received: by wr-out-0506.google.com with SMTP id 50so1957580wra.13
	for <linux-dvb@linuxtv.org>; Sun, 17 Aug 2008 21:25:39 -0700 (PDT)
Message-ID: <ae5231870808172125t5426c61w9859f5361406f9f1@mail.gmail.com>
Date: Mon, 18 Aug 2008 13:55:38 +0930
From: "Robert Golding" <robert.golding@gmail.com>
To: stev391@email.com
In-Reply-To: <20080818000053.793B8BE4078@ws1-9.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080818000053.793B8BE4078@ws1-9.us4.outblaze.com>
Cc: LinuxTV DVB list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
	H - DVB Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

2008/8/18  <stev391@email.com>:
>
>> It seems that kernel 2.6.27 (what I was using) is different enough
>> that the modules and fw from Stephens downloads won't work properly.
>
>> I went back to 2.6.25 and it worked there, so I tried 2.6.26 and it
>> worked there as well.
>
>> These are the steps I had to do so it would load properly;
>> 1) Compile kernel WITHOUT 'multimedia'
>> i.e. #
>> # Multimedia devices
>> #
>>
>> #
>> # Multimedia core support
>> #
>> # CONFIG_VIDEO_DEV is not set
>> # CONFIG_DVB_CORE is not set
>> # CONFIG_VIDEO_MEDIA is not set
>
>> #
>> # Multimedia drivers
>> #
>> # CONFIG_DAB is not set
>
>> & reboot with new kernel (if it was the kernel you were already booted
>> too, don't bother)
>
>> 2) Download Stephens latest media patches
>> #> wget http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2
>> extract to current dir, then;
>> #> make all
>> #> make install
>
>> 3) Download Stephens firmware and follow instructions in
>> /Documentation/video4linux/extract_xc3028.pl
>
>> 4) Reboot machine to load all the correct modules and fw, then open
>> favourite tuner prog (I use Me-TV) and enjoy the viewing.
>
>> --
>> Regards,      Robert
>
> Robert,
>
> I'm glad you got it working.
>
> The v4l-dvb drivers will not work against a kernel that has the video/multimedia drivers compiled in to the kernel.
> When you compile your kernel you select the above options, which you disabled, as modules and this will also allow the v4l-dvb drivers to be compiled as modules and overwrite the older drivers.
>
> If the kernel you were using, that it didn't work against, was part of a distro, perhaps a bug report to them about their kernel config should be sent...
>

I actually have Gentoo as my install base, however, I have become used
to navigating around the vanilla sources for so many years I still use
them rather than the gentoo-sources.

I reckon I just have to find the difference in some parts of the
2.6.27 kernel as I used the oldconfig to fire it up. Yeah, I was lazy
and this is what happens when you get lazy. :-/ .. It wouldn't compile
the nvidia drivers either, so I'll have to get into it to see what has
been changed that caused that to happen.

> Regards,
>
> Stephen.
>
>
> --
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com
>
>

On another note, is it the 'cx23885' that controls 'analog' (aka
Winfast 107d:66xx series) as well on this card?  Or another chip I
don't know about?

The FM Radio would use the 'analog' chip too, wouldn't it?  I was
given to understand that the cx23885 was a newer version of the
Conexant 'bt878' continuum, is that correct?

-- 
Regards,	Robert

..... Some people can tell what time it is by looking at the sun, but
I have never been able to make out the numbers.
---
Errata: Spelling mistakes are not intentional, however, I don't use
spell checkers because it's too easy to allow the spell checker to
make the decisions and use words that are out of context for that
being written, i.e. their/there, your/you're, threw/through and even
accept/except, not to mention foreign (I'm Australian) English
spelling, i.e. colour/color, socks/sox, etc,.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
