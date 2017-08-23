Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:38686 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753948AbdHWM7N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 08:59:13 -0400
Received: by mail-lf0-f41.google.com with SMTP id y15so6981469lfd.5
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 05:59:12 -0700 (PDT)
Date: Wed, 23 Aug 2017 14:59:10 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: Re: [RFC 00/19] Async sub-notifiers and how to use them
Message-ID: <20170823125909.GA12099@bigcity.dyn.berto.se>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <eb0ff309-bdf5-30f9-06da-2fc6c35fbf6a@xs4all.nl>
 <20170720161400.ijud3kppizb44acw@valkosipuli.retiisi.org.uk>
 <20170721065754.GC20077@bigcity.dyn.berto.se>
 <4fa22637-c58e-79e3-be22-575b0a4ff3f9@iki.fi>
 <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea92d79c-bba0-ca22-c0a7-0535d635729c@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2017-08-23 11:09:15 +0200, Hans Verkuil wrote:
> On 08/04/17 20:25, Sakari Ailus wrote:
> > Niklas Söderlund wrote:
> >> Hi Sakari,
> >>
> >> On 2017-07-20 19:14:01 +0300, Sakari Ailus wrote:
> >>> Hi Hans,
> >>>
> >>> Thanks for the review.
> >>>
> >>> On Wed, Jul 19, 2017 at 01:42:55PM +0200, Hans Verkuil wrote:
> >>>> On 18/07/17 21:03, Sakari Ailus wrote:
> >>>>> Hi folks,
> >>>>>
> >>>>> This RFC patchset achieves a number of things which I've put to the same
> >>>>> patchset for they need to be show together to demonstrate the use cases.
> >>>>>
> >>>>> I don't really intend this to compete with Niklas's patchset but much of
> >>>>> the problem area addressed by the two is the same.
> >>>>>
> >>>>> Comments would be welcome.
> >>>>>
> >>>>> - Add AS3645A LED flash class driver.
> >>>>>
> >>>>> - Add async notifiers (by Niklas).
> >>>>>
> >>>>> - V4L2 sub-device node registration is moved to take place at the same time
> >>>>>   with the registration of the sub-device itself. With this change,
> >>>>>   sub-device node registration behaviour is aligned with video node
> >>>>>   registration.
> >>>>>
> >>>>> - The former is made possible by moving the bound() callback after
> >>>>>   sub-device registration.
> >>>>>
> >>>>> - As all the device node registration and link creation is done as the
> >>>>>   respective devices are probed, there is no longer dependency to the
> >>>>>   notifier complete callback which as itself is seen problematic. The
> >>>>>   complete callback still exists but there's no need to use it, pending
> >>>>>   changes in individual drivers.
> >>>>>
> >>>>>   See:
> >>>>>   <URL:http://www.spinics.net/lists/linux-media/msg118323.html>
> >>>>>
> >>>>>   As a result, if a part of the media device fails to initialise because it
> >>>>>   is e.g. physically broken, it will be possible to use what works.
> >>>>
> >>>> I've got major problems with this from a userspace point of view. In the vast
> >>>> majority of cases you just want to bail out if one or more subdevs fail.
> >>>
> >>> I admit it's easier for the user space if the device becomes available only
> >>> when all its component drivers have registered.
> >>>
> >>> Also remember that video nodes are registered in the file system right on
> >>> device probe time. It's only sub-device and media device node registration
> >>> that has taken place in the notifier's complete handler.
> >>
> >> Is this always the case? In the R-Car VIN driver I register the video 
> >> devices using video_register_device() in the complete handler. Am I 
> >> doing things wrong in that driver? I had a patch where I moved the 
> >> video_register_device() call to probe time but it got shoot down in 
> >> review and was dropped.
> > 
> > I don't think the current implementation is wrong, it's just different
> > from other drivers; there's really no requirement regarding this AFAIU.
> > It's one of the things where no attention has been paid I presume.
> 
> It actually is a requirement: when a device node appears applications can
> reasonably expect to have a fully functioning device. True for any device
> node. You don't want to have to wait until some unspecified time before
> the full functionality is there.
> 
> I try to pay attention to this when reviewing code, since not following this
> rule basically introduces a race condition which is hard to test.

In the latest version of the R-Car VIN series I have now moved the video 
device registration to happen at probe time... So I think it would be a 
good time to clarify what and what is not the intended way of where this 
can happen. I'm not keen on reworking that series for each time it's 
posted to where the video device is registered :-) I can see both good 
and bad things with both solutions.

If the video device is registered in the complete callback it do make it 
easier to spot some race conditions (my VIN series got review comments 
where I missed this almost instantly). It is also clear to user-space 
when a device is ready to be used. At the same time as Sakari points out 
this prevents partially complete graphs which might contain a valid 
pipeline to be able to function, which of these two behaviors is the 
most opportune I assume differs with use-cases and which one is best 
from a framework point of view I don't know.

But I do know that if a video device is registered from the complete 
callback it's reasonable that it should be unregistered if the unbind 
callback is called, right? Else the same situation as registering it at 
probe time is reached if a subdevice is ever unbound and the driver 
needs to handle the corner cases of both situations. And this use-case 
is today broken in v4l2! If a video device is registered in the complete 
callback, unregistered in the unbind callback and later re-registered in 
the complete callback once the subdevice is re-bound everything blows up 
with

  kobject (eb3be918): tried to init an initialized object, something is seriously wrong.

But yes if the video device is registered at probe time there are more 
races and object life-time issues for the driver to handle, but these 
needs to be considered anyhow if the unbind/re-bind scenario is to be 
fixed, right? So maybe it don't really matter where the video device is 
registered and both methods should be allowed and documented (so all 
drivers returns same -ENOSUBDEVBOUNDYET etc) and leave it up to each 
driver to handle this for how it perceives it primary use-case to be?  
And instead we should talk about how to fix the bind/unbind issues as 
this is where IMHO where the real problem is.

> 
> > However doing anything that can fail earlier on would be nicer since
> > there's no reasonable way to signal an error from complete callback either.
> 
> Right.
> 
> Adding support for cases where devices may not be present is very desirable,
> but this should go through an RFC process first to hammer out all the details.
> 
> Today we do not support this and we have to review code with that in mind.
> 
> So the first async subnotifiers implementation should NOT support this (although
> it can of course be designed with this in mind). Once it is in we can start
> on an RFC on how to support partial pipelines. I have a lot of questions about
> that that need to be answered first.
> 
> One thing at a time. Trying to do everything at once never works.
> 
> Regards,
> 
> 	Hans

-- 
Regards,
Niklas Söderlund
