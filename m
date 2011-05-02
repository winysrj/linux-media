Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2143 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1EBUHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 16:07:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] V4L2 API for flash devices
Date: Mon, 2 May 2011 22:07:12 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <4D90854C.2000802@maxwell.research.nokia.com> <201105022113.56088.hverkuil@xs4all.nl> <201105022132.47900.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105022132.47900.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105022207.12505.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, May 02, 2011 21:32:46 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 02 May 2011 21:13:56 Hans Verkuil wrote:
> > On Monday, May 02, 2011 18:04:18 Sakari Ailus wrote:
> > > Sakari Ailus wrote:
> > > > Laurent Pinchart wrote:
> > > >> On Tuesday 29 March 2011 13:51:38 Sakari Ailus wrote:
> > > >>> Sakari Ailus wrote:
> > > >>>> Hans Verkuil wrote:
> > > >>>>> On Tuesday, March 29, 2011 11:35:19 Sakari Ailus wrote:
> > > >>>>>> Hi Hans,
> > > >>>>>> 
> > > >>>>>> Many thanks for the comments!
> > > >>>> 
> > > >>>> ...
> > > >>>> 
> > > >>>>>> It occurred to me that an application might want to turn off a
> > > >>>>>> flash which has been strobed on software. That can't be done on a
> > > >>>>>> single button control.
> > > >>>>>> 
> > > >>>>>> V4L2_CID_FLASH_SHUTDOWN?
> > > >>>>>> 
> > > >>>>>> The application would know the flash strobe is ongoing before it
> > > >>>>>> receives a timeout fault. I somehow feel that there should be a
> > > >>>>>> control telling that directly.
> > > >>>>>> 
> > > >>>>>> What about using a bool control for the strobe?
> > > >>>>> 
> > > >>>>> It depends: is the strobe signal just a pulse that kicks off the
> > > >>>>> flash, or is it active throughout the flash duration? In the
> > > >>>>> latter case a bool makes sense, in the first case an extra button
> > > >>>>> control makes sense.
> > > >>>> 
> > > >>>> I like buttons since I associate them with action (like strobing)
> > > >>>> but on the other hand buttons don't allow querying the current
> > > >>>> state. On the other hand, the current state isn't always
> > > >>>> determinable, e.g. in the absence of the interrupt line from the
> > > >>>> flash controller interrupt pin (e.g. N900!).
> > > >>> 
> > > >>> Oh, I need to take my words back a bit.
> > > >>> 
> > > >>> There indeed is a way to get the on/off status for the flash, but
> > > >>> that involves I2C register access --- when you read the fault
> > > >>> registers, you do get the state, even if the interrupt linke is
> > > >>> missing from the device. At least I can't see why this wouldn't
> > > >>> work, at least on this particular chip.
> > > >>> 
> > > >>> What you can't have in this case is the event.
> > > >>> 
> > > >>> So, in my opinion this suggests that a single boolean control is the
> > > >>> way to go.
> > > >> 
> > > >> Why would an application want to turn off a flash that has been
> > > >> strobbed in software ? Applications should set the flash duration and
> > > >> then strobe it.
> > > > 
> > > > The applications won't know beforehand the exact timing of the exposure
> > > > of the frames on the sensor and the latencies of the operating system
> > > > possibly affected by other processes running on the system. Thus it's
> > > > impossible to know exactly how long flash strobe (on software, that
> > > > is!) is required.
> > > > 
> > > > So, as far as I see there should be a way to turn the flash off and the
> > > > timeout would mostly function as a safeguard. This is likely dependent
> > > > on the flash controller as well.
> > > 
> > > Today I was working on the ADP1653 driver and realised that this chip
> > > doesn't actually provide a way to stop the strobe by the user at all.
> > > There's just the timeout. The user may not turn off the strobe, as it
> > > first seemed to me in the spec. If I look at the AS3654A spec, it's
> > > almost equally vague on this topic.
> > > 
> > > This means that there are chips that do not allow explicitly stopping
> > > the strobe and probably those that do (I assume that hardware people
> > > will learn some day that a hard timeout isn't the best you can provide
> > > to software!).
> > > 
> > > There was a discussion on the type of the V4L2_CID_FLASH_STROBE control;
> > > whether that should be a button or boolean control. Buttons cannot be
> > > unpressed, so a button control would work for adp1653 but possibly not
> > > for other similar chips in the future.
> > > 
> > > Even if we have a standard control, can the type of the control change,
> > > depending on the properties of the hardware? This would also allow
> > > providing to user the knowledge on whether the flash may be explicitly
> > > turned off. On the other hand, I don't like the idea of having a
> > > standard control with several possible types (there are none at the
> > > moment, AFAIK). I would side with keeping the type of the control
> > > boolean all the time but I'm not fully certain.
> > > 
> > > Hans, do you have an opinion on this?
> > 
> > Theoretically the type may change depending on the hardware, but I don't
> > think that is something we should support. In particularly, that will make
> > it very hard to programmatically use such controls. There are all sorts of
> > subtle problems you run into when you allow for different types for the
> > same standard control.
> 
> I'm still undecided. If we standardize a boolean control, how will userspace 
> know that, for the adp1653, the control can be written to 1 but can't be 
> written to 0 ?

We need two controls: one button control, one boolean control. The first can
be called FLASH_STROBE, the second FLASH_STROBE_ON. Depending on the hardware,
only one of these is implemented. These two strobe implementations behave
differently in important ways, so I believe it makes sense to have two controls
as well.

Regards,

	Hans
