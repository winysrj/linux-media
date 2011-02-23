Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:18732 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1BWK2i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 05:28:38 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [Q] {enum,s,g}_input for subdev ops
Date: Wed, 23 Feb 2011 11:29:51 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <Pine.LNX.4.64.1102221612380.1380@axis700.grange> <201102221807.15647.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102231039060.10099@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102231039060.10099@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231129.51648.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, February 23, 2011 11:13:57 Guennadi Liakhovetski wrote:
> On Tue, 22 Feb 2011, Hans Verkuil wrote:
> 
> > On Tuesday, February 22, 2011 17:39:25 Guennadi Liakhovetski wrote:
> > > On Tue, 22 Feb 2011, Hans Verkuil wrote:
> > > 
> > > > > Hi
> > > > >
> > > > > Any thoughts about the subj? Hasn't anyone run into a need to select
> > > > > inputs on subdevices until now? Something like
> > > > >
> > > > > struct v4l2_subdev_video_ops {
> > > > > 	...
> > > > > 	int (*enum_input)(struct v4l2_subdev *sd, struct v4l2_input 
*inp);
> > > > > 	int (*g_input)(struct v4l2_subdev *sd, unsigned int *i);
> > > > > 	int (*s_input)(struct v4l2_subdev *sd, unsigned int i);
> > > > 
> > > > That's done through s_routing. Subdevices know nothing about inputs as
> > > > shown to userspace.
> > > > 
> > > > If you want a test pattern, then the host driver needs to add a "Test
> > > > Pattern" input and call s_routing with the correct values (specific to
> > > > that subdev) to set it up.
> > > 
> > > Hm, maybe I misunderstood something, but if we understand "host" in the 
> > > same way, then this doesn't seem very useful to me. What shall the host 
> > > have to do with various sensor inputs? It cannot know, whether the 
sensor 
> > > has a test-pattern "input" and if yes - how many of them. Many sensors 
> > > have several such patterns, and, I think, some of them also have some 
> > > parameters, like colour values, etc., which we don't have anything to 
map 
> > > to. But even without that - some sensors have several test patterns, 
which 
> > > they well might want to be able to switch between by presenting not just 
> > > one but several test inputs. So, shouldn't we have some enum_routing or 
> > > something for them?
> > 
> > What you really want is to select a test pattern. A good solution would be
> > to create a sensor menu control with all the test patterns it supports.
> 
> Ok, thinking a bit further about it. Let's take mt9p031 as an example - a 
> pretty simple bayer-only sensor. The driver is not yet in the mainline, 
> but I'll be pushing something simple in the mainline soon. I just picked 
> it up as an example, because it has quite a few test modes.
> 
> On the total it can generate 9 test patterns, including gradients, bars, 
> constant colour-field, etc. Apart from selecting a specific test pattern, 
> the RGB colour values and monochrome "intensity" values and bar widths can 
> be set for the colour-field and monochrome-bars test-patterns respectively.
> 
> Using a control menu we can select one of the 9 test-modes. But do we also 
> want standard controls for colour values and bar widths? Or are they too 
> hardware-specific and too unimportant and can only be supported by private 
> controls?

I think all test pattern controls would be prime candidates as subdev-specific 
controls: they are hardware specific so it's difficult anyway to make them 
generic controls and they are typically only used for debugging.

But we can't do that until the MC code is merged. This also requires that the 
subdev uses the control framework.

The MC code will hopefully be merged soon and I have worked on the control 
framework patches for soc-camera, although those need more work.

Regards,

	Hans

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
