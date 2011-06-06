Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52184 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1FFLAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 07:00:32 -0400
Date: Mon, 6 Jun 2011 14:00:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Martin Strubel <hackfin@section5.ch>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: v4l2 device property framework in userspace
Message-ID: <20110606110027.GA7498@valkosipuli.localdomain>
References: <4DE244F4.90203@section5.ch>
 <201105311001.40826.hverkuil@xs4all.nl>
 <4DE4A67A.9070007@section5.ch>
 <201105311255.02481.hverkuil@xs4all.nl>
 <4DE4D20C.1090206@section5.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE4D20C.1090206@section5.ch>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 31, 2011 at 01:33:32PM +0200, Martin Strubel wrote:
> Hi,

Hi Martin,

> > 
> > Not religion, it's experience. I understand what you want to do and it is
> > just a bad idea in the long term. Mind you, it's great for prototyping and
> > experimentation. But if you want to get stable sensor support in the kernel,
> > then it has to conform to the rules. Having some sensor drivers in the kernel
> > and some in userspace will be a maintenance disaster.
> 
> Sorry, from our perspective the current v4l2 system *has* already been a
> maintenance disaster. No offense, but that is exactly the reason why we
> had to internally circumvent it.
> You're free to use the system for early prototyping stage as well as for
> a stable release (the framework is in fact running since 2006 in medical
> imaging devices). It certainly cost us less maintenance so far than
> syncing up to the changing v4l2 APIs.

The V4L2 framework supports imaging devices far better nowadays than
earlier. If you use the V4L2, you may benefit from the work that
others have been doing as well. The V4L2 does much for you that you had to
do in a driver specific way earlier.

What comes to your original question, I've had a roughly similar problem in
the past. A sensor that is controlled with sets of register lists. See
camera-firmware here:

<URL:http://gitorious.org/omap3camera/pages/Home>

The solution for this in the future is to make V4L2 understand these
parameters, such as low level sensor control, including cropping, blanking,
scaling, skipping, binning etc. in a generic way. Some of these parameters
will be configured through format parameters, some through separate ioctls
and many of them will be V4L2 controls. The V4L2 framework needs to be
extended a little to support some of the new functionality.

This way, you can even change your sensor to another from a different vendor
using a different driver with minimal effort on user space software as long
as both of the sensor drivers are implemented as V4L2 subdev drivers as Hans
explained. This allows the user space to stay more generic.

[clip]

> > You (or your company/organization) designed a system without as far as I am aware
> > consulating the people responsible for the relevant kernel subsystem (V4L in this
> > case). And now you want to get your code in with a minimum of change. Sorry, that's
> > not the way it works.
> > 
> 
> Just that you understand: I'm not wanting to get our code into
> somewhere. I'd rather avoid it, one reason being lengthy discussions :-)
> Bottomline again: I'm trying to find a solution to avoid bloated and
> potentially unstable kernel drivers. Why do you think we (and our
> customers) spent the money to develop alternative solutions?

Please keep in mind that others do have requirements which may differ from
yours. The V4L2 is intended to serve very different ones, not just yours.
The current V4L2 framework does follow more generic principles which are
known to be good in general. This allows it to be something that you can
actually build on, not something just you need to adapt to.

Please follow up the development of V4L2 and participate to it. This way you
may have your views and requirements taken into account. But do remember
others do have theirs as well.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
