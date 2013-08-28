Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46224 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3H1Jsi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 05:48:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
Date: Wed, 28 Aug 2013 11:50 +0200
Message-ID: <10693086.5dU3qYIIgB@avalon>
In-Reply-To: <20130828062752.18604873@samsung.com>
References: <520E76E7.30201@googlemail.com> <521DBC3A.7090604@samsung.com> <20130828062752.18604873@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 28 August 2013 06:27:52 Mauro Carvalho Chehab wrote:
> Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:
> > On 08/27/2013 06:00 PM, Mauro Carvalho Chehab wrote:
> > >>> > > The thing is that you're wanting to use the clock register as a
> > >>> > > way to detect that the device got initialized.
> > >> > 
> > >> > I'm not sure to follow you there, I don't think that's how I want to
> > >> > use the clock. Could you please elaborate ?
> > > 
> > > As Sylwester pointed, the lack of clock register makes ov2640 to defer
> > > probing, as it assumes that the sensor is not ready.
> > 
> > Hmm, actually there are two drivers here - the sensor driver defers its
> > probing() when a clock provided by the bridge driver is missing. Thus
> > let's not misunderstand it that missing clock is used as an indication
> > of the sensor not being ready. It merely means that the clock provider
> > (which in this case is the bridge driver) has not initialized yet.
> > It's pretty standard situation, the sensor doesn't know who provides
> > the clock but it knows it needs the clock and when that's missing it
> > defers its probe().
> 
> On an always on clock, there's no sense on defer probe.

The point is that the sensor driver doesn't know whether the clock is always 
on or not, so it must defer the probe if the clock object isn't available 
(remember that even for always-on clocks the sensor driver often needs to 
query the clock rate). That won't happen in this case as the sensor device is 
instanciated by the em28xx driver, so the clock object will always be 
available.

-- 
Regards,

Laurent Pinchart

