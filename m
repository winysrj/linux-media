Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:40067 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab2H1Pka (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 11:40:30 -0400
Date: Tue, 28 Aug 2012 15:43:43 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Detlev Zundel <dzu@denx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/3] mt9v022: add v4l2 controls for blanking and other
 register settings
Message-ID: <20120828154343.3c847dff@wker>
In-Reply-To: <Pine.LNX.4.64.1208242305050.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
	<1345799431-29426-2-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1208241227140.20710@axis700.grange>
	<m2pq6g5tm3.fsf@lamuella.denx.de>
	<Pine.LNX.4.64.1208241527370.20710@axis700.grange>
	<20120824182125.4d19ed64@wker>
	<Pine.LNX.4.64.1208242305050.20710@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, 24 Aug 2012 23:23:37 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > Every time the sensor is reset, it resets this register. Without setting
> > the register after sensor reset to the needed value I only get garbage data
> > from the sensor. Since the possibility to reset the sensor is provided on
> > the hardware and also used, the register has to be set after each sensor
> > reset. Only the instance controlling the reset gpio pin "knows" the time,
> > when the register should be initialized again, so it is asynchronously and
> > not related to the standard camera activities. But since the stuff is _not_
> > documented, I can only speculate. Maybe it can be set to different values
> > to achieve different things, currently I do not know.
> 
> How about adding that register write (if required by platform data) to 
> mt9v022_s_power() in the "on" case? This is called (on soc-camera hosts at 
> least) on each first open(), would this suffice?

This would suffice. But now I found some more info for this register.
Rev3. errata mentions that the bit 9 of the register should be set when
in snapshot mode (in my case this is the only mode that we can use).
Additionally the errata recommends to set bit 2 when the high dynamic
range mode is used. Now I'm not sure how to realise these settings.

The bit 9 should be set/unset when configuring the master/snapshot
mode in mt9v022_s_stream(), I think. 

For setting bit 2 we could add V4L2_CID_WIDE_DYNAMIC_RANGE control
which primarily configures the HiDy mode in register 0x0f and
additionally sets/unsets bit 2 in register 0x20. But setting this
bit 2 seems to be needed also in linear mode when manual exposure
control is used. With the recommended register value 0x03D1 in linear
mode the image quality is really bad when manual exposure mode is
used, independent of the configured exposure time. Using 0x03D5
in linear mode however gives good image quality here. So setting
bit 2 should be independent of HiDy control. The errata states "the
register setting recommendations are based on the characterization of
the image sensor only and that camera module makers should test these
recommendations on their module and evaluate the overall performance".
These settings should be configurable independently of each other,
I think.

Thanks,
Anatolij
