Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933475Ab0CLXfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 18:35:37 -0500
Message-ID: <4B9ACFC0.4080507@redhat.com>
Date: Fri, 12 Mar 2010 20:35:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Remaining drivers that aren't V4L2?
References: <829197381003121211l469c30bfjba077cea028bf680@mail.gmail.com>	 <201003122242.06508.hverkuil@xs4all.nl> <4B9AC590.3020408@redhat.com> <829197381003121459oed85501wbe7870785e91893@mail.gmail.com>
In-Reply-To: <829197381003121459oed85501wbe7870785e91893@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Mar 12, 2010 at 5:52 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:

> Yup, I was indeed aware that tvtime doesn't really work with webcams.
> I wanted to see the list of remaining drivers, and now that I see the
> list (and also came to the conclusion that they were all webcams), I
> feel much more comfortable just dropping V4L1 support.

Yep. For its target, V4L1 is not needed anymore.

> I have actually been considering converting tvtime to using libv4l for
> a while now, as I need it to support cards that use the HM12
> pixelformat (such as the HVR-1600).  I wanted to rip out the V4L1
> support first to make the conversion more straightforward.
> 
> It really isn't my goal to make tvtime support webcams, although they
> might just start to work as an unintended side-effect.

If you take the right decisions with tvtime, you'll end to have it allowing
webcams, even unintentionally.

For example, on a quick brainstorming, I see some interesting features for
the tvtime todo list (just my $0,01 cents):

1) alsa support (undergoing/finished work?);

2) allow adjusting frame rate, to better support environments where the bus 
bandwidth is limited;

3) support for other video formats;

4) a generic control interface (a qv4l2 like interface);

5) support to adjust the resolution based on the screen size (as xawtv does);

6) allow tvtime to record programs;

7) direct access to IR event interface, in order to better work with IR's without
needing any extra software like lirc;

8) allow changing video standard without needing to restart tvtime. It is very common
on some Countries the usage of two or more simultaneous standard - For example, almost
all DVD/STB devices in Brazil outputs in NTSC, while TV is broadcasted in PAL-M. As far
as I know, the other Countries where Analog TV is still the main/only broadcast standard
have similar issues.

For sure the top priority is Alsa, but, at the end of the day, by handling (some) of the
above requirements, its usage with webcams will make more sense, and you won't need to
spend any time specifically devoted to webcam support.

Also, assuming that analog TV will end broadcasting some day in the world, the usage for
a tvtime-like application will likely be for video surveillance and other webcam usages.

So, in brief, I think a webcam support side-effect is a good thing.

-- 

Cheers,
Mauro
