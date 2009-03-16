Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:54378 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbZCPWrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 18:47:20 -0400
Date: Mon, 16 Mar 2009 15:47:17 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
In-Reply-To: <20090316224040.7672176a@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0903161533090.28292@shell2.speakeasy.net>
References: <200903151344.01730.hverkuil@xs4all.nl> <20090315181207.36d951ac@hyperion.delvare>
 <Pine.LNX.4.58.0903151038210.28292@shell2.speakeasy.net>
 <20090315185313.4c15702c@hyperion.delvare> <20090316063402.1b0da1f3@gaivota.chehab.org>
 <20090316121801.1c03d747@hyperion.delvare> <20090316095237.21775418@gaivota.chehab.org>
 <20090316152802.7492dd20@hyperion.delvare> <Pine.LNX.4.58.0903161202330.28292@shell2.speakeasy.net>
 <20090316224040.7672176a@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009, Jean Delvare wrote:
> On Mon, 16 Mar 2009 12:43:33 -0700 (PDT), Trent Piepho wrote:
> > On Mon, 16 Mar 2009, Jean Delvare wrote:
> > > Come on, just look at ir-kbd-i2c and tvaudio again, see how great are
> > > these drivers which have been "designed" on top of the legacy i2c
> > > binding model. Look at the bttv mess. Look at the zoran driver
> > > conversion done by Hans a few weeks ago, which killed what, 3000 lines
> > > of code? The old binding model was so bad that DVB doesn't even use it.
> >
> > IIRC, the zoran patch removed more like 1000 lines.
>
> You don't remember correctly:
>  37 files changed, 4570 insertions(+), 7404 deletions(-)
> That's 2834 lines. 1570 of which is for the removal of the saa7111 and
> saa7114 and I agree this shouldn't count, so we're down to 1264 lines
> removed. The removal of some "features" also shouldn't count but I
> doubt it amounts to more than a few hundred lines.

1264 lines is "more like 1000 lines" than it is like 3000 lines!

> In fact, to get a more accurate figure you can just look at the result
> of my own conversion. There were two patches:
>  13 files changed, 510 insertions(+), 625 deletions(-)
>  11 files changed, 549 deletions(-)
> This is -664 lines total. The exact number doesn't really matter. The
> bottom line is that the new binding model requires significantly less
> glue code than the legacy model. If you think some more about it, it
> means a lot.

Then how come the bttv patch added lines of code and a couple kB to the
compiled driver size?

> > But it also deleted
> > v4l1 support, highmem support, and bigphys_area support.  Maybe other
> > things, Hans doesn't decribe his patches, so there's really no way to know
> > what the zoran patch really did other than to weed through 10,000+ lines of
> > diff which is mostly but not entirely moving blocks of code from one space
> > to another and reindenting them.
>
> You are unfair. The pull request came with a short log of all the
> changes.

"short" log.  His entire series was decribed with fewer words than I would
use on a single patch that changes ten lines.

> > If one includes the v4l1-compat module that is now providing v4l1 support
> > (though it doesn't work correctly for zoran), the driver and the compat
> > module are larger than the old driver was.  Of course one can now turn off
> > v4l1 support and get a smaller driver than before.  And the v4l1 compat
> > already existed and can be shared.  But I think it's more correct to say
> > the size reduction of the zoran driver was from removing features and not
> > from v4l2_subdev.  It seems like more of the the other subdev conversions
> > have overall added more code than they removed.
>
> I am not familiar enough with this part of the code to say. But I guess
> it doesn't really matter, as it wasn't my point anyway.

It seems like your point was that conversions to v4l2_subdev allow drivers
to be more efficient remove lots of code.  The numbers I see just don't
support that claim.
