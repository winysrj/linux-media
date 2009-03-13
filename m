Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZCMDOr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 23:14:47 -0400
Date: Fri, 13 Mar 2009 00:14:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	"Sri Deevi via Mercurial" <srinivasa.deevi@conexant.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Add cx231xx USB driver
Message-ID: <20090313001435.74cb11f0@pedra.chehab.org>
In-Reply-To: <200903130153.42738.hverkuil@xs4all.nl>
References: <60934.62.70.2.252.1236856462.squirrel@webmail.xs4all.nl>
	<20090312102011.2f5672e1@pedra.chehab.org>
	<200903130153.42738.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I've summarized your comments into a few answers, to avoid repeating myself.

On Fri, 13 Mar 2009 01:53:42 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Mauro,
> 
> Just one last reply, and than we can close this discussion. Luckily the 
> conversion of this driver to v4l2_device/subdev is a lot simpler than I 
> feared initially. So no harm done in that respect.

Good!

> Please announce this in the future. I checked the linux-media list and there 
> is no mention of this whatsoever. Just putting it up in a tree is not 
> sufficient, you have to tell people about it as well.

I always request the developers to submit their work at the public ML.
Unfortunately, a few don't do it due to some random reasons.

It is much better for the Linux users if I merge such drivers or patches than
to just nack a driver due to that reason.

Anyway, after the merge, the community can still review the driver and/or the
patches, as announced by the hg mailbomb script. 

> It's not v4l2_device/v4l2_subdev that's at stake here. It's the removal of 
> the old i2c autoprobing behavior. v4l2_device/v4l2_subdev is just the 
> fastest way to do this for v4l drivers. As you can see here:
> 
> http://i2c.wiki.kernel.org/index.php/Legacy_drivers_to_be_converted
> 
> the conversion is almost done. This weekend I hope to finish cx88, cx23885 
> and bttv. Hopefully Douglas Landgraf can convert em28xx and I know Mike 
> Isely only needs to do some final tweaks for pvrusb2.

Good to know. We still need testing from the users for those drivers, since
there are risks of regressions when converting from the automatic probe method,
to a manual binding one. If a i2c bind for a needed driver is forgot (or bad coded),
some board variants will break.

Since nobody ever cared to document all those I2C driver alternatives, I
suspect that we'll have some regressions, that will likely be identified only
when the kernel reaches the distros.

> I do not expect newly submitted drivers to use v4l2_device/subdev. I know it 
> is a very recent development. But it is very easy to implement and all I 
> need is a chance to review and help them with that to ensure that dropping 
> the old i2c API isn't blocked by a new driver. Not in the least because it 
> is likely that the i2c core maintainer will block such a new driver if it 
> is the only driver preventing the removal of the old i2c API.
> 
> In addition, once a driver is in the v4l-dvb tree I cannot just drop the old 
> i2c API support in v4l-dvb since that will just break any driver that uses 
> it. So whether it goes to the git tree or not, that doesn't matter for me.

This will just mean that those drivers won't compile against 2.6.30 during
2.6.30-rc cycle. You can always disable it via make menuconfig if needed, until
it would be converted to the new i2c methods.

Since just the core developers compile kernels against the latest -rc cycle,
This is for sure a much minor problem that can be easily solved by a .config
file, than letting a driver to grow out of the tree.

-- 

Cheers,
Mauro
