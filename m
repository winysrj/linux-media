Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933729Ab3JOViD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 17:38:03 -0400
Date: Tue, 15 Oct 2013 23:37:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFD] use-counting V4L2 clocks
In-Reply-To: <2086760.XpLDTRAYT5@avalon>
Message-ID: <Pine.LNX.4.64.1310152242150.11960@axis700.grange>
References: <Pine.LNX.4.64.1309121947590.7038@axis700.grange>
 <38373771.lqz4Seg2Ij@avalon> <Pine.LNX.4.64.1310150938040.5601@axis700.grange>
 <2086760.XpLDTRAYT5@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Tue, 15 Oct 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Tuesday 15 October 2013 10:05:45 Guennadi Liakhovetski wrote:
> > On Thu, 10 Oct 2013, Laurent Pinchart wrote:
> > > On Tuesday 08 October 2013 23:57:55 Guennadi Liakhovetski wrote:
> > > > Hi Mauro,
> > > > 
> > > > Thanks for your long detailed mail. For the sake of brevity however I'll
> > > > drop most of it in this my reply, everybody interested should be able to
> > > > read the original.
> > > > 
> > > > On Wed, 9 Oct 2013, Mauro Carvalho Chehab wrote:
> > > > 
> > > > [snip]
> > > > 
> > > > > In other words, what you're actually proposing is to change the
> > > > > default used by most drivers since 1997 from a POWER ON/CLOCK ON
> > > > > default, into a POWER OFF/ CLOCK OFF default.
> > > > 
> > > > To remind, we are now trying to fix a problem, present in the current
> > > > kernel. In one specific driver. And the proposed fix only affects one
> > > > specific (family of) driver(s) - the em28xx USB driver. The two patches
> > > > are quite simple:
> > > > 
> > > > (1) the first patch adds a clock to the em28xx driver, which only
> > > > affects ov2640, because only it uses that clock
> > > > 
> > > > (2) the second patch adds a call to subdev's .s_power(1) method. And I
> > > > cannot see how this change can be a problem either. Firstly I haven't
> > > > found many subdevices, used by em28xx, that implement .s_power().
> > > > Secondly, I don't think any of them does any kind of depth-counting in
> > > > that method, apart from the one, that we're trying to fix - ov2640.
> > > > 
> > > > > Well, for me, it sounds that someone will need to re-test all
> > > > > supported devices, to be sure that such change won't cause
> > > > > regressions.
> > > > > 
> > > > > If you are willing to do such tests (and to get all those hardware to
> > > > > be sure that nothing will break) or to find someone to do it for you,
> > > > > I'm ok with such change.
> > > > 
> > > > I'm willing to try to identify all subdevices, used by em28xx, look at
> > > > their .s_power() methods and report my analysis, whether calling
> > > > .s_power(1) for those respective drivers could cause problems. Would
> > > > this suffice?
> > >
> > > From a high level point of view, I believe that's the way to go. V4L2
> > > clock enable/disable calls must be balanced, as we will later switch to
> > > the non-V4L2 clock API that requires calls to be balanced.
> > > 
> > > This pushes the problem back to the .s_power() implementation that call
> > > the clock enable/disable functions. As a temporary measure, we could add a
> > > use count to the .s_power() handlers of drivers used by both power-
> > > unbalanced and power-balanced bridges that call the clock API or the
> > > regulator API in their .s_power() implementation (that's just ov2640 if
> > > I'm not mistaken). This would ensure that clock calls are always balanced,
> > > even if the .s_power() calls are not.
> > > 
> > > Now I'd like to avoid that as possible: In the long term I believe we
> > > should switch all .s_power() calls to  balanced mode, a detailed analysis
> > > of the subdevices used by em28xx would thus have my preference. However,
> > > if it helps solving the issue right now, buying us time to fix the
> > > problem correctly, I could live with it.
> > 
> > Please, correct me if I'm wrong, but I seem to remember, that we wanted to
> > eliminate .s_power() methods completely eventually. We could try to find
> > that old discussion, but it would need some searching. In short - only
> > subdevice drivers know, when their devices need power or clock. Higher
> > layers just request specific functions - setting parameters, starting or
> > stopping streaming etc., and subdev drivers decide when they have to
> > access (I2C) registers, which regulators they have to turn on for that,
> > when they have to power on the sensor array and activate the data
> > interface... IIRC we were thinking about some exceptions like SoC internal
> > subdevices, which are initialised by the main SoC camera interface driver.
> > It was then suggested, that that central camera interface driver also
> > knows when those internal subdevices should be turned up and down.
> > Although I'm not sure even that would be needed.
> > 
> > Shall we not maybe move in that direction?
> 
> I believe you remember correctly, and that's indeed a good idea. 
> However, now might not be the best time to do so, we need to fix the 
> em28xx problem.

Yes, except this "now" already lasts for quite some time, so, we don't 
seem to be in a hurry and could take a month or two to fix it properly...

> What's your preferred solution there ?

The one, that will be acceptable for all. As everybody has heard multiple 
times in this threads already, we're really dealing with 2 iddues here:

1. ov2640 needs a (V4L2) clock and em28xx currently isn't providing one.

2. if we add the clock, as suggested by my patches, the ov2640 then 
enables and disables it in its .s_power() method. The em28xx driver only 
powers its subdevices down by calling their .s_power(0), which then causes 
unbalanced clock disable warnings.

An alternative solution for (1) has been proposed - to make ov2640 (and 
other v4l2-clk users) also usable without a clock, proposed by Mauro. 
IIRC, Sylwester, Laurent and myself spoke against it in favour of keeping 
a clock object compulsory, where a clock is really required by the 
hardware. I don't know whether this can be considered a resolved issue and 
if respective patches to em28xx would now be accepted.

For (2) there are also several solutions:

(a) I proposed a patch to balance .s_power(0) and .s_power(1) in em28xx 
and to review all relevant subdevice drivers for possible problems

(b) as a temporary measure we could also allow unbalanced calls to 
.s_power() and balance calls to v4l2_clk_enable() / disable() in them - 
proposed by Laurent, but it also has been put forward before

(c) Mauro proposed to add a new callback to only suspend subdevices to 
mimic original .s_standby() behaviour and to use it with tuner and other 
devices, waking up automatically

Of the above 3 possibilities, I'm not sure how (c) shall be implemented: 
e.g. in the em28xx case, does this mean, that the core em28xx driver would 
have to call the unbalanced .s_standby() for tuner subdevices and the 
balanced .s_power() for camera sensors?... This could be done, but doesn't 
appear particularly pretty to me. Or maybe I'm misunderstanding something?

In principle though, I can live with any of (a), (b) and (c) in that order 
of preference.

However, if we want to try to remove .s_power() completely, I think, 
ov2640 wouldn't be a difficult case. It only exports two controls and 
supports setting of the frame format. If instead of immediately applying 
them to the hardware we store them internally and only power on the sensor 
in .s_stream(1), write the configuration to the hardware and start 
streaming and then power the hardware off again in .s_stream(0) wouldn't 
this suffice?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
