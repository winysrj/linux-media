Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:58821 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1HaIVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 04:21:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: none of the drivers should be enabled by default
Date: Wed, 31 Aug 2011 10:21:05 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1108301921040.19151@axis700.grange> <201108302228.45059.hverkuil@xs4all.nl> <Pine.LNX.4.64.1108302233001.20921@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108302233001.20921@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311021.05793.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, August 30, 2011 23:31:06 Guennadi Liakhovetski wrote:
> On Tue, 30 Aug 2011, Hans Verkuil wrote:
> 
> > On Tuesday, August 30, 2011 22:12:09 Guennadi Liakhovetski wrote:
> > > On Tue, 30 Aug 2011, Hans Verkuil wrote:
> > > 
> > > > On Tuesday, August 30, 2011 19:22:00 Guennadi Liakhovetski wrote:
> > > > > None of the media drivers are compulsory, let users select which 
drivers
> > > > > they want to build, instead of having to unselect them one by one.
> > > > 
> > > > I disagree with this: while this is fine for SoCs, for a generic 
kernel I
> > > > think it is better to build it all. Even expert users can have a hard 
time
> > > > figuring out what chip is in a particular device.
> > > 
> > > Then could someone, please, explain to me, why I don't find this 
> > > "convenience" in any other kernel driver class? Wireless, ALSA, USB, I2C 
- 
> > > you name them. Is there something special about media, that I'm missing, 
> > > or are all others just user-unfriendly? Why are distro-kernels, 
> > > allmodconfig, allyesconfig not enough for media and we think it's 
> > > necessary to build everything "just in case?"
> > 
> > That's actually a good question. I certainly think that the more obscure
> > drivers can be disabled by default. But I also think that you want to keep
> > a certain subset of commonly used drivers enabled. I'm thinking bttv, uvc,
> > perhaps gspca.
> 
> Good, this is a good beginning! It was actually the purpose of my patch - 
> to make us actually consider which drivers we need enabled per default, 
> and which we don't, instead of just enabling all.
> 
> > As far as I can see, alsa enables for example HD Audio, which almost all
> > modern hw supports. We should do something similar for v4l.
> 
> Yes, agree.
> 
> > And we should really reorder some of the entries in the menu: one of the
> > first drivers you see are parallel port webcams and other very obscure
> > devices.
> 
> Ok.
> 
> So, how should we proceed? What I certainly would like to disable 
> completely or to 99% are remote controls and tuners. The rest are actually 
> disabled by default, which is great. Or at least I would like to have a 
> single switch "disable all," ideally active by default. One of the 
> possibilities would be to take the patch as is and _then_ begin to think, 
> which drivers we want enabled by default. I just think, that the correct 
> approach is to think, which drivers we need enabled by default - as 
> exceptions, instead of - which drivers we can afford to disable.

I would propose to start by reorganizing the menu. E.g. make a submenu for
old legacy bus drivers (parallel port, ISA), for platform drivers, and for
'rare' drivers (need a better name for that :-) ). For example the Hexium
PCI drivers are very rare, and few people have them.

Once that is done we can look at disabling those legacy/platform/rare drivers.

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
