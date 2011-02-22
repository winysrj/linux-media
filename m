Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1053 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1BVRHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 12:07:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [Q] {enum,s,g}_input for subdev ops
Date: Tue, 22 Feb 2011 18:07:15 +0100
Cc: linux-media@vger.kernel.org
References: <Pine.LNX.4.64.1102221612380.1380@axis700.grange> <ddc4d0fcf85526c5fc88594e100f192b.squirrel@webmail.xs4all.nl> <Pine.LNX.4.64.1102221733350.1380@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102221733350.1380@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221807.15647.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, February 22, 2011 17:39:25 Guennadi Liakhovetski wrote:
> On Tue, 22 Feb 2011, Hans Verkuil wrote:
> 
> > > Hi
> > >
> > > Any thoughts about the subj? Hasn't anyone run into a need to select
> > > inputs on subdevices until now? Something like
> > >
> > > struct v4l2_subdev_video_ops {
> > > 	...
> > > 	int (*enum_input)(struct v4l2_subdev *sd, struct v4l2_input *inp);
> > > 	int (*g_input)(struct v4l2_subdev *sd, unsigned int *i);
> > > 	int (*s_input)(struct v4l2_subdev *sd, unsigned int i);
> > 
> > That's done through s_routing. Subdevices know nothing about inputs as
> > shown to userspace.
> > 
> > If you want a test pattern, then the host driver needs to add a "Test
> > Pattern" input and call s_routing with the correct values (specific to
> > that subdev) to set it up.
> 
> Hm, maybe I misunderstood something, but if we understand "host" in the 
> same way, then this doesn't seem very useful to me. What shall the host 
> have to do with various sensor inputs? It cannot know, whether the sensor 
> has a test-pattern "input" and if yes - how many of them. Many sensors 
> have several such patterns, and, I think, some of them also have some 
> parameters, like colour values, etc., which we don't have anything to map 
> to. But even without that - some sensors have several test patterns, which 
> they well might want to be able to switch between by presenting not just 
> one but several test inputs. So, shouldn't we have some enum_routing or 
> something for them?

What you really want is to select a test pattern. A good solution would be
to create a sensor menu control with all the test patterns it supports.

Regards,

	Hans

> 
> Feel free to re-add the ML to CC.
> 
> Thanks
> Guennadi
> 
> > The saa7127 subdev does something like this (see include/media/saa7127.h).
> > The ivtv host driver only selects this during firmware load, though. It's
> > not mapped to a user input.
> > 
> > Regards,
> > 
> >      Hans
> > 
> > >
> > > For example, we discussed implementing sensor test patterns as separate
> > > inputs.
> > >
> > > Thanks
> > > Guennadi
> > > ---
> > > Guennadi Liakhovetski, Ph.D.
> > > Freelance Open-Source Software Developer
> > > http://www.open-technology.de/
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
