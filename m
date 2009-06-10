Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4357 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbZFJWBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 18:01:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera: status, roadmap
Date: Thu, 11 Jun 2009 00:00:18 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.0906101802450.4817@axis700.grange> <200906102209.08535.hverkuil@xs4all.nl> <Pine.LNX.4.64.0906102343560.4817@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906102343560.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906110000.25862.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 June 2009 23:49:23 Guennadi Liakhovetski wrote:
> On Wed, 10 Jun 2009, Hans Verkuil wrote:
> > On Wednesday 10 June 2009 18:45:36 Guennadi Liakhovetski wrote:
>
> [snip]
>
> > > 3. This also means, development will become more difficult, new
> > > features and drivers will only be accepted on the top of my patch
> > > stack, bugfixes will have to be accpeted against the mainline, which
> > > then will mean extra porting work for me.
> >
> > If there is anything I can do to help this along, please let me know.
> > In particular: what else besides the v4l2_i2c_new_subdev_board do you
> > need? I didn't have much time in the past few weeks, but things are
> > more relaxed now and I expect to be able to do a lot more in the coming
> > weeks (fingers crossed :-) ).
>
> Thanks for your offer!
>
> Well, yes, at least we could start with these three things:
>
> 1. s_crop, g_crop, cropcap. Would be nice if you could add them just
> following the standard API.

No problem.

> 2. bus parameter negotiation. I appreciate Murali's effort, but I don't
> like re-inventing the wheel. So, we should now either bring his
> implementation to support _at least_ all features so far supported in
> soc-camera, or you could just copy the soc-camera implementation over,
> just renaming functions and macros as appropriate.

Obviously all features should be supported, but as you can no doubt tell I'm 
not sold (yet?) on the autonegotiation part of the soc-camera 
implementation.

> 3. pixel format negotiation. The easiest would be to also just copy it
> over.

I haven't looked at this yet, but I will do so soon.

> These 3 points would make the porting much easier. I'll certainly be
> happy to answer any questions you might get working with soc-camera code.

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
