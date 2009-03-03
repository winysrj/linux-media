Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1986 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbZCCHSs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 02:18:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
Date: Tue, 3 Mar 2009 08:19:01 +0100
Cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
References: <200903022218.24259.hverkuil@xs4all.nl> <Pine.LNX.4.58.0903021351370.24268@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903021351370.24268@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903030819.01420.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 02 March 2009 23:47:31 Trent Piepho wrote:
> On Mon, 2 Mar 2009, Hans Verkuil wrote:
> > There are good reasons as a developer for keeping backwards
> > compatibility with older kernels:
>
> Do you mean no backwards compatibility with any older kernels?  Or do you
> mean just dropping support for the oldest kernels now supported.  What
> you've said above sounds like the former.

This was about the advantages of having compat code at all to support 
kernels other than the bleeding edge git kernel.

> > 1) a larger testers base.
> > 2) that warm feeling you get when users can get their new card to work
> > with just v4l-dvb without having to upgrade their kernel.
> > 3) as a developer you do not need to update to the latest kernel as
> > well. Very useful if the latest kernel introduces a regression on your
> > hardware as happened to me in the past.
>
> It's also very useful for working on/testing multiple trees.  I can test
> your zoran tree, switch to a different tree for some cx88 work, and then
> switch back to a know good tree to record some tv shows tonight.  I can
> switch back and forth between your zoran tree and a months older one in
> *seconds* to check differences in behavior.  Without having to reboot two
> dozen times a day to a half dozen different kernels.
>
> For the most part the v4l-dvb compat system works behind the scenes very
> well.  I'm sure there have been cases where a developer who doesn't
> reboot hourly to the latest git kernel produced a patch that wouldn't
> have worked on the kernel they were themselves using if the compat system
> hadn't made it work automatically without the developer even knowing.
>
> > 2) as time goes by the code becomes ever harder to maintain due to the
> > accumulated kernel checks.
>
> Unless you want to maintain backwards compat forever, the idea is to
> reach some kind of equilibrium were old compat code is removed at the
> same rate new compat code is added.

Right.

> > 3) the additional complication of backwards compatibility code might
> > deter new developers.
>
> But needing to run today's kernel and have your closed source video card
> driver stop working might deter developers who just want to produce a few
> small patches.
>
> > There has to be a balance here. Currently it is my opinion that I'm
> > spending too much time on the backwards compat stuff. And that once all
> > the i2c modules are converted to the new framework both the
> > maintainability and the effort required to maintain the compat code
> > will be improved considerably by dropping support for kernels <2.6.22.
>
> Will you allow drivers to use a combination of probe based and detect
> based i2c using the new i2c api?  It's my understanding that you only
> support the new i2c api for probe-only drivers.  Probe/detect or ever
> detect-only drivers for the new i2c api haven't been done?  I think much
> of the difficulty of supporting <2.6.22 will be solved once there is a
> way to allow drivers to use both probe and detect with the new api.

The difficulties are not with probe or detect, but with the fact that with 
the new API the adapter driver has to initiate the probe instead of the 
autoprobing that happened in the past by just loading the i2c module. The 
compat issues are for the most part limited to the i2c modules themselves, 
since those changed the most because of this.

I don't think we have to use the detect() functionality at all in i2c 
modules, although I need to look at bttv more closely to see whether that 
is a true statement. I'm at this moment opposed to the use of detect() 
since I fear it can lead to pretty much the same problems as autoprobing 
does when you start to rely on it. It's meant for legacy code where proper 
device/address information is not present. In the case of v4l-dvb the only 
driver that might qualify is bttv.

> I think I would have gone about it from the other side.  Convert bttv to
> use detect and then make that backward compatible.  That compatibility
> should be much easier and less invasive.

This wouldn't have made any difference at all.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
