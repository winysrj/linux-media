Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:52600 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZGXKy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 06:54:28 -0400
Received: by ewy26 with SMTP id 26so1643654ewy.37
        for <linux-media@vger.kernel.org>; Fri, 24 Jul 2009 03:54:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090723155935.285f9cba@pedra.chehab.org>
References: <d9def9db0907230240w6d3a41fcv2fcef6cbb6e2cb8c@mail.gmail.com>
	 <829197380907230441q18e21e4fn63b186370b3711de@mail.gmail.com>
	 <d9def9db0907230443x49dd1b56m143b293e9bdbaaec@mail.gmail.com>
	 <d9def9db0907230446k291db7bfm1ebcb314d0c97c2@mail.gmail.com>
	 <829197380907230503y3a2ca24y4434ed759c1f4009@mail.gmail.com>
	 <d9def9db0907230510h31d1d225pb1d317c9a41fa210@mail.gmail.com>
	 <829197380907230705w4f1c3126r9cf156ca30aa2b5b@mail.gmail.com>
	 <d9def9db0907230729k4cc14707v763d242e14292ebb@mail.gmail.com>
	 <20090723155935.285f9cba@pedra.chehab.org>
Date: Fri, 24 Jul 2009 12:54:27 +0200
Message-ID: <d9def9db0907240354x15927f29k2fc0939d25202e1@mail.gmail.com>
Subject: Re: em28xx driver crashes device
From: Markus Rechberger <mrechberger@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 23, 2009 at 8:59 PM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> Em Thu, 23 Jul 2009 16:29:02 +0200
> Markus Rechberger <mrechberger@gmail.com> escreveu:
>
>> On Thu, Jul 23, 2009 at 4:05 PM, Devin
>> Heitmueller<dheitmueller@kernellabs.com> wrote:
>> > On Thu, Jul 23, 2009 at 8:10 AM, Markus Rechberger<mrechberger@gmail.com> wrote:
>> >> There's a pretty good disclosed detection from Empia available, the
>> >> linux kernel driver
>> >> just doesn't support it and very likely will never support it. Instead
>> >> of doing it the
>> >> wrong way it's better to turn it off or explicitly ask the user if he
>> >> wants to do something
>> >> undefined with his device.
>> >> The nvidia setup tools also provide an option to force it instead of
>> >> letting the software
>> >> just do whatever some developers don't know what it will cause...
>> >> You don't know what will happen to the device when doing that detection.
>> >> The initial device in question had to be replugged after we removed
>> >> the driver from the system.
>> >> You shouldn't invite people to do undefined things with their hardware
>> >> so they might break them
>> >> I think I will submit a few photos what physically can happen to the
>> >> device with wrong settings.
>> >
>> > Well, if there is a known heuristic, I would be very happy to get rid
>> > of the autodetection logic.  I haven't looked at the Empia code in
>> > months so I should probably do that.
>> >
>> > Since I used to design hardware for a living, I am quite familiar with
>> > what can happen with incorrect GPIOs so I do not believe you need to
>> > attempt to convince me with photos, which is why I am in favor of
>> > removing the logic in question.  We just need to figure out how to do
>> > it without causing a regression in current device support.
>> >
>> > Interesting...  I took a quick look at the code, and it seems like the
>> > USB errors occur before we change any GPIOs, and more interesting it
>> > appears that the em2861 itself is wedged (which I believe is the first
>> > time I've seen that).  The code in the log above suggests that the
>> > autodetection concluded that the profile was not known, so it did not
>> > arbitrarily pick some incorrect device.  I am a bit surprised that
>> > just reading the eeprom once and doing a scan of the i2c bus would
>> > wedge the chip.
>> >
>> > Is there any information you can give about the board in question in
>> > terms of what product it is or what components it contains?
>> >
>>
>> it was a simple TVP5150 based device...
>>
>> I do not mean my old code either it's also a failure as I got more information
>> for the new driver after we dropped the old project.
>> As you know the new driver is entirely in Userpace and supported by all involved
>> chipcompanies, it comes with its own LinuxDVB and video4linux2 Stack.
>>
>> Also vendors have a very low interest in supporting those devices in Kernelspace
>> as installing devices which should be sold now are not supported by
>> any distributions.
>> Devices which have been sold one year ago have a very low till no
>> motivation anymore.
>> Most people are simply not able to compile the drivers and/or prepare
>> the kernel development
>> environment just for installing and using a TV Card.
>
> PLEASE STOP WITH FUD. THIS FORUM IS FOR OPEN SOURCE DRIVER DISCUSSION. AS YOU
> DECIDED TO GO TO THE DARK SIDE, PLEASE STOP POSTING HERE OR AT THE OPEN SOURCE #IRC CHANNEL.
>

someone has problems here? We also support available opensource
players and will contribute some patches which can be used by all
devices.

Markus
