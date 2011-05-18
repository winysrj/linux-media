Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48408 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab1ERQDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 12:03:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: Codec controls question
Date: Wed, 18 May 2011 18:03:18 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <003801cc14ae$be448b90$3acda2b0$%debski@samsung.com> <16ed9ac8f44869af2d6ff7cded1c0023.squirrel@webmail.xs4all.nl> <4DD3EC71.5040100@samsung.com>
In-Reply-To: <4DD3EC71.5040100@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105181803.18893.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

On Wednesday 18 May 2011 17:57:37 Sylwester Nawrocki wrote:
> On 05/18/2011 05:22 PM, Hans Verkuil wrote:
> > 
> > I have experimented with control events to change ranges and while it can
> > be done technically it is in practice a bit of a mess. I think personally
> > it is just easier to have separate controls.
> > 
> > We are going to have similar problems if different video inputs are
> > controlled by different i2c devices with different (but partially
> > overlapping) controls. So switching an input also changes the controls. I
> > have experimented with this while working on control events and it became
> > very messy indeed. I won't do this for the first version of control
> > events.
> > 
> > One subtle but real problem with changing control ranges on the fly is
> > that it makes it next to impossible to save all control values to a file
> > and restore them later. That is a desirable feature that AFAIK is
> > actually in use already.
> 
> What are your views on creating controls in subdev s_power operation ?
> Some sensors/ISPs have control ranges dependant on a firmware revision.
> So before creating the controls min/max/step values need to be read from
> them over I2C. We chose to postpone enabling ISP's power until a
> corresponding video (or subdev) device node is opened. And thus controls
> are not created during driver probing, because there is no enough
> information to do this.

You can power the device up during probe, read the hardware/firmware version, 
power it down and create/initialize controls depending on the retrieved 
information.

> I don't see a possibility for the applications to be able to access the
> controls before they are created as this happens during a first device
> (either video or subdev) open(). And they are destroyed only in
> video/subdev device relase().
> 
> Do you see any potential issues with this scheme ?

-- 
Regards,

Laurent Pinchart
