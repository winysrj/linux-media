Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3JOIFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 04:05:51 -0400
Date: Tue, 15 Oct 2013 10:05:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFD] use-counting V4L2 clocks
In-Reply-To: <38373771.lqz4Seg2Ij@avalon>
Message-ID: <Pine.LNX.4.64.1310150938040.5601@axis700.grange>
References: <Pine.LNX.4.64.1309121947590.7038@axis700.grange>
 <20131009053327.091686f3@concha.lan> <Pine.LNX.4.64.1310082334430.5846@axis700.grange>
 <38373771.lqz4Seg2Ij@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

Thanks for your opinion.

On Thu, 10 Oct 2013, Laurent Pinchart wrote:

> Hi Guennadi and Mauro,
> 
> On Tuesday 08 October 2013 23:57:55 Guennadi Liakhovetski wrote:
> > Hi Mauro,
> > 
> > Thanks for your long detailed mail. For the sake of brevity however I'll
> > drop most of it in this my reply, everybody interested should be able to
> > read the original.
> > 
> > On Wed, 9 Oct 2013, Mauro Carvalho Chehab wrote:
> > 
> > [snip]
> > 
> > > In other words, what you're actually proposing is to change the default
> > > used by most drivers since 1997 from a POWER ON/CLOCK ON default, into a
> > > POWER OFF/ CLOCK OFF default.
> > 
> > To remind, we are now trying to fix a problem, present in the current
> > kernel. In one specific driver. And the proposed fix only affects one
> > specific (family of) driver(s) - the em28xx USB driver. The two patches
> > are quite simple:
> > 
> > (1) the first patch adds a clock to the em28xx driver, which only
> > affects ov2640, because only it uses that clock
> > 
> > (2) the second patch adds a call to subdev's .s_power(1) method. And I
> > cannot see how this change can be a problem either. Firstly I haven't
> > found many subdevices, used by em28xx, that implement .s_power().
> > Secondly, I don't think any of them does any kind of depth-counting in
> > that method, apart from the one, that we're trying to fix - ov2640.
> > 
> > > Well, for me, it sounds that someone will need to re-test all supported
> > > devices, to be sure that such change won't cause regressions.
> > > 
> > > If you are willing to do such tests (and to get all those hardware to be
> > > sure that nothing will break) or to find someone to do it for you, I'm ok
> > > with such change.
> > 
> > I'm willing to try to identify all subdevices, used by em28xx, look at
> > their .s_power() methods and report my analysis, whether calling
> > .s_power(1) for those respective drivers could cause problems. Would this
> > suffice?
> 
> >From a high level point of view, I believe that's the way to go. V4L2 clock 
> enable/disable calls must be balanced, as we will later switch to the non-V4L2 
> clock API that requires calls to be balanced.
> 
> This pushes the problem back to the .s_power() implementation that call the 
> clock enable/disable functions. As a temporary measure, we could add a use 
> count to the .s_power() handlers of drivers used by both power-unbalanced and 
> power-balanced bridges that call the clock API or the regulator API in their 
> .s_power() implementation (that's just ov2640 if I'm not mistaken). This would 
> ensure that clock calls are always balanced, even if the .s_power() calls are 
> not.
> 
> Now I'd like to avoid that as possible: In the long term I believe we should 
> switch all .s_power() calls to  balanced mode, a detailed analysis of the 
> subdevices used by em28xx would thus have my preference. However, if it helps 
> solving the issue right now, buying us time to fix the problem correctly, I 
> could live with it.

Please, correct me if I'm wrong, but I seem to remember, that we wanted to 
eliminate .s_power() methods completely eventually. We could try to find 
that old discussion, but it would need some searching. In short - only 
subdevice drivers know, when their devices need power or clock. Higher 
layers just request specific functions - setting parameters, starting or 
stopping streaming etc., and subdev drivers decide when they have to 
access (I2C) registers, which regulators they have to turn on for that, 
when they have to power on the sensor array and activate the data 
interface... IIRC we were thinking about some exceptions like SoC internal 
subdevices, which are initialised by the main SoC camera interface driver. 
It was then suggested, that that central camera interface driver also 
knows when those internal subdevices should be turned up and down. 
Although I'm not sure even that would be needed.

Shall we not maybe move in that direction?

Thanks
Guennadi

> > > Otherwise, we should stick with the present behavior, as otherwise we will
> > > cause regressions.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
