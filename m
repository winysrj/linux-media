Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57254 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab1HEXQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 19:16:15 -0400
Date: Sat, 6 Aug 2011 01:16:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Chew <AChew@nvidia.com>
cc: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	'Doug Anderson' <dianders@google.com>
Subject: RE: Guidance regarding deferred I2C transactions
In-Reply-To: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D5@HQMAIL03.nvidia.com>
Message-ID: <Pine.LNX.4.64.1108060108580.26715@axis700.grange>
References: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D0@HQMAIL03.nvidia.com>
 <4E3C557A.2060103@redhat.com> <643E69AA4436674C8F39DCC2C05F76383CF0DD22D5@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Aug 2011, Andrew Chew wrote:

> > > One way to solve this can be to defer these I2C 
> > transactions in the image sensor driver all the way up 
> > > to the time the image sensor is asked to start streaming 
> > frames. However, it seems to me that this breaks 
> > > the spirit of the probe; applications will successfully 
> > probe for camera presence even though the camera 
> > > isn't actually there. Is this okay?
> > > 
> > > Is there a better way to do this? Maybe a more general 
> > thing we can add to the V4L2 framework?
> > 
> > Probing for the presence of the device hardware at driver 
> > init time seems 
> > to be the right thing to do, even when the LED blinks. PC 
> > keyboard LEDs
> > also blinks during machine reset, and this is not really 
> > annoying. Even
> > on some embedded devices like some cell phones, LEDs blink 
> > during the boot
> > time.
> 
> It's a bit different when the camera LED blinks, though.  The whole 
> problem is that the user will have thought that the system took a 
> picture of them without knowing.  What the user sees will potentially be 
> indistinguishable between expected behavior, and a system that has been 
> compromised to make use of that blink to actually take a picture, 
> leading to privacy concerns.
> 
> 
> > So, as a general rule, I'd say that the better is to keep the 
> > capability of 
> > probing the hardware at init time, especially since the same 
> > sensor may
> > eventually be used by non SoC drivers.
> 
> I completely agree with you.  I was just hoping that others have run 
> into this as well, and that there was an officially endorsed method to 
> solve this.  Sounds like there isn't.
> 
> 
> > One strategy that several drivers do, and that solves the 
> > issue of blinking
> > after the device reset is to have a shadow copy of the 
> > register contents.
> > This way, you can defer the device register writes to occur 
> > only when you're
> > actually streaming. E. g. you'll still have the blink at 
> > probe time (probably
> > a longer one), but, after that, the driver can just work with 
> > the cached
> > values, up to the moment it will really start streaming.
> 
> Yes, that's easy to do, and will completely solve the blink on open issue.

This would require modifying each sensor driver. And not always these 
shadowing is desired.

A simpler approach seems to be to only load the driver, when streaming is 
required. Yes, it would add a (considerable) delay to streaming begin, but 
you'd be completely honest to your user and privacy would be guaranteed.

Another less secure approach would be to tie your LED to a different 
function, to one, that only activates, when actual data is transferred. 
Maybe you can tie it to one of sync or clock signals? Look whether your 
sensor has any pins, that only get activated, when video data is 
transferred. You can also trigger it from the software, but this might 
contradict your security policy. However, if you think about it, I don't 
think your users anyway have a chance to make really 100% sure, their 
privacy is not violated, so...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
