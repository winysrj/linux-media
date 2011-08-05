Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13229 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1HEVBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Aug 2011 17:01:07 -0400
From: Andrew Chew <AChew@nvidia.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	'Doug Anderson' <dianders@google.com>
Date: Fri, 5 Aug 2011 14:01:03 -0700
Subject: RE: Guidance regarding deferred I2C transactions
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D5@HQMAIL03.nvidia.com>
References: <643E69AA4436674C8F39DCC2C05F76383CF0DD22D0@HQMAIL03.nvidia.com>
 <4E3C557A.2060103@redhat.com>
In-Reply-To: <4E3C557A.2060103@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > One way to solve this can be to defer these I2C 
> transactions in the image sensor driver all the way up 
> > to the time the image sensor is asked to start streaming 
> frames. However, it seems to me that this breaks 
> > the spirit of the probe; applications will successfully 
> probe for camera presence even though the camera 
> > isn't actually there. Is this okay?
> > 
> > Is there a better way to do this? Maybe a more general 
> thing we can add to the V4L2 framework?
> 
> Probing for the presence of the device hardware at driver 
> init time seems 
> to be the right thing to do, even when the LED blinks. PC 
> keyboard LEDs
> also blinks during machine reset, and this is not really 
> annoying. Even
> on some embedded devices like some cell phones, LEDs blink 
> during the boot
> time.

It's a bit different when the camera LED blinks, though.  The whole problem is that the user will have thought that the system took a picture of them without knowing.  What the user sees will potentially be indistinguishable between expected behavior, and a system that has been compromised to make use of that blink to actually take a picture, leading to privacy concerns.


> So, as a general rule, I'd say that the better is to keep the 
> capability of 
> probing the hardware at init time, especially since the same 
> sensor may
> eventually be used by non SoC drivers.

I completely agree with you.  I was just hoping that others have run into this as well, and that there was an officially endorsed method to solve this.  Sounds like there isn't.


> One strategy that several drivers do, and that solves the 
> issue of blinking
> after the device reset is to have a shadow copy of the 
> register contents.
> This way, you can defer the device register writes to occur 
> only when you're
> actually streaming. E. g. you'll still have the blink at 
> probe time (probably
> a longer one), but, after that, the driver can just work with 
> the cached
> values, up to the moment it will really start streaming.

Yes, that's easy to do, and will completely solve the blink on open issue.
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
