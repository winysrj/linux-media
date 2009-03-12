Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56536 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbZCLKvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 06:51:06 -0400
Date: Thu, 12 Mar 2009 07:50:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Sri Deevi via Mercurial <Srinivasa.Deevi@conexant.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Add cx231xx USB driver
Message-ID: <20090312075057.71948082@pedra.chehab.org>
In-Reply-To: <200903120838.59192.hverkuil@xs4all.nl>
References: <E1LhZu5-0002zX-83@www.linuxtv.org>
	<200903120838.59192.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Thu, 12 Mar 2009 08:38:59 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Mauro,
> 
> What the hell??!
> 
> Since when does a big addition like this get merged without undergoing a 
> public review?
> 
> I've been working my ass off converting drivers to the new i2c API and 
> v4l2_subdev structures and here you merge a big driver that uses old-style 
> (which will lead to 'deprecated' warnings when compiling with 2.6.29, BTW), 
> where the driver writes directly to i2c modules instead of adding a proper 
> i2c module for them. And what are 'colibri', 'flatrion' and 'hammerhead' 
> anyway? Are they integrated devices of the cx231xx? Can they be used 
> separately in other products as well?
> 
> So yes, I have objections. At the minimum it should be converted first to 
> use v4l2_device/v4l2_subdev and I need more information on the new i2c 
> devices so I can tell whether the code for those should be split off into 
> separate i2c modules. Not to mention that I want to have the time to review 
> this code more closely.
> 
> Sorry Sri, this isn't your fault.

Hans,

I know that you're rushing to convert all drivers to the new model, but you
should give time to time. Even with Kernel's fast development cycle, we should
take care to not depreciate things faster than developers can track (btw,
lwn.net already complained that V4L subsystem changes their APIs faster than
usual).

First of all, except for ivtv drivers, the first conversion to the new model
occurred just few weeks ago. The new model will bring some gains, but this
shouldn't stop the merge of the drivers whose development started before we
port the drivers used as example by the developer.

This is a new model, and we should give people some time to adapt to it. This
is the way we worked in the past and it is the way we should keep working. For
example, video_ioctl2 were added several Kernel releases before merging uvc
driver. Yet, we've accepted uvc driver without using the new model, because its
development that occurred before video_ioctl2.

The second point is that there's nothing at
Documentation/feature-removal-schedule.txt informing that those stuff is
deprecated.

So, we should still accept new drivers without the conversion at least until
the end of 2.6.30 window, and add some notice at feature-removal-schedule.txt
on 2.6.30 clearly stating what's deprecated and when, before generating penalty
over the developers that are using the current drivers as their model of
development.

In the specific case of cx231xx driver, I've explained to Sri, there are still
some issues to be fixed at the driver. Although the driver works, It is not
ready for 2.6.30 yet. 

However, keeping this on a separate tree will just create more mess (according
with Sri, he already had to rebase this driver 4 times during 2.6.29-rc cycle,
due to the high speed of internal API changes).

Since his driver seems to be based on em28xx, he had no sample on how to convert it to
v4l2_device/v4l2_subdev/new_i2c model.

After committing Devin's Austek patches (also seemed to be based on em28xx), it will
probably be easier for Uri to convert his driver to the new approach.

-- 

Cheers,
Mauro
