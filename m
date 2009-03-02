Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:35746 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZCBWre (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2009 17:47:34 -0500
Date: Mon, 2 Mar 2009 14:47:31 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
In-Reply-To: <200903022218.24259.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903021351370.24268@shell2.speakeasy.net>
References: <200903022218.24259.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Mar 2009, Hans Verkuil wrote:
> There are good reasons as a developer for keeping backwards compatibility
> with older kernels:

Do you mean no backwards compatibility with any older kernels?  Or do you
mean just dropping support for the oldest kernels now supported.  What
you've said above sounds like the former.

> 1) a larger testers base.
> 2) that warm feeling you get when users can get their new card to work with
> just v4l-dvb without having to upgrade their kernel.
> 3) as a developer you do not need to update to the latest kernel as well.
> Very useful if the latest kernel introduces a regression on your hardware
> as happened to me in the past.

It's also very useful for working on/testing multiple trees.  I can test
your zoran tree, switch to a different tree for some cx88 work, and then
switch back to a know good tree to record some tv shows tonight.  I can
switch back and forth between your zoran tree and a months older one in
*seconds* to check differences in behavior.  Without having to reboot two
dozen times a day to a half dozen different kernels.

For the most part the v4l-dvb compat system works behind the scenes very
well.  I'm sure there have been cases where a developer who doesn't reboot
hourly to the latest git kernel produced a patch that wouldn't have worked
on the kernel they were themselves using if the compat system hadn't made
it work automatically without the developer even knowing.

> 2) as time goes by the code becomes ever harder to maintain due to the
> accumulated kernel checks.

Unless you want to maintain backwards compat forever, the idea is to reach
some kind of equilibrium were old compat code is removed at the same rate
new compat code is added.

> 3) the additional complication of backwards compatibility code might deter
> new developers.

But needing to run today's kernel and have your closed source video card
driver stop working might deter developers who just want to produce a few
small patches.

> There has to be a balance here. Currently it is my opinion that I'm spending
> too much time on the backwards compat stuff. And that once all the i2c
> modules are converted to the new framework both the maintainability and the
> effort required to maintain the compat code will be improved considerably
> by dropping support for kernels <2.6.22.

Will you allow drivers to use a combination of probe based and detect based
i2c using the new i2c api?  It's my understanding that you only support the
new i2c api for probe-only drivers.  Probe/detect or ever detect-only
drivers for the new i2c api haven't been done?  I think much of the
difficulty of supporting <2.6.22 will be solved once there is a way to
allow drivers to use both probe and detect with the new api.

I think I would have gone about it from the other side.  Convert bttv to
use detect and then make that backward compatible.  That compatibility
should be much easier and less invasive.
