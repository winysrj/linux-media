Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676Ab3DJOns (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 10:43:48 -0400
Date: Wed, 10 Apr 2013 16:43:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Barry Song <21cnbao@gmail.com>
cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"renwei.wu" <renwei.wu@csr.com>,
	DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
	xiaomeng.hou@csr.com, zilong.wu@csr.com
Subject: Re: [PATCH 07/14] media: soc-camera: support deferred probing of
 clients
In-Reply-To: <CAGsJ_4z-FnbHtmbi16YD5LmYfpL+=ngke8EgkPHWy_PJ8QBPNg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1304101637300.13557@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-8-git-send-email-g.liakhovetski@gmx.de>
 <CAGsJ_4yUY6PE0NWZ9yaOLFmRb3O-HL55=w7Y6muwL0YbkJtP0Q@mail.gmail.com>
 <Pine.LNX.4.64.1304101358490.13557@axis700.grange>
 <CAGsJ_4xn_R7D7Uh0dJB7WuDQG3K_mZkMwYNtMDuHMhX+4oTk=Q@mail.gmail.com>
 <Pine.LNX.4.64.1304101601160.13557@axis700.grange>
 <CAGsJ_4z-FnbHtmbi16YD5LmYfpL+=ngke8EgkPHWy_PJ8QBPNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Apr 2013, Barry Song wrote:

> 2013/4/10 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > On Wed, 10 Apr 2013, Barry Song wrote:

[snip]

> >> > This cannot work, because some I2C devices, e.g. sensors, need a clock
> >> > signal from the camera interface to probe. Before the bridge driver has
> >> > completed its probing and registered a suitable clock source with the
> >> > v4l2-clk framework, sensors cannot be probed. And no, we don't want to
> >> > fake successful probing without actually being able to talk to the
> >> > hardware.
> >>
> >> i'd say same dependency also exists on ASoC.  a "fake" successful
> >> probing doesn't mean it should really begin to work if there is no
> >> external trigger source.  ASoC has successfully done that by a machine
> >> driver to connect all DAI.
> >> a way is we put all things ready in their places, finally we connect
> >> them together and launch the whole hardware flow.
> >>
> >> anyway, if you have maken the things work by some simple hacking and
> >> that means minimial changes to current soc-camera, i think we can
> >> follow.
> >
> > If you want to volunteer to step up as a new soc-camera maintainer to
> > replace my simple hacking with your comprehencive and advanced designs -
> > feel free, I'll ack straight away.
> 
> i am not sure whether you agree the new way or not. if you also agree
> this is a better way,

In fact I don't.

> i think we can do something to move ahead. i
> need sync and get input from you expert :-)

I suggest you read all the mailing list discussions of these topics over 
last months / years, conference discussion protocols instead of restarting 
a beaten to death topic at the v8 time-frame.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
