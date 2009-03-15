Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:55116 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbZCOXZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 19:25:51 -0400
Date: Sun, 15 Mar 2009 16:25:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
In-Reply-To: <1237146899.3314.52.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0903151616540.28292@shell2.speakeasy.net>
References: <200903151324.00784.hverkuil@xs4all.nl>
 <Pine.LNX.4.58.0903150859300.28292@shell2.speakeasy.net>
 <200903151753.52663.hverkuil@xs4all.nl>  <Pine.LNX.4.58.0903151001040.28292@shell2.speakeasy.net>
 <1237146899.3314.52.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009, Andy Walls wrote:
> On Sun, 2009-03-15 at 10:28 -0700, Trent Piepho wrote:
>
> > Why are the i2c addresses from various i2c chips moved into the bttv
> > driver?  Doesn't it make more sense that the addresses for chip X should be
> > in the driver for chip X?
>
> One reason that this may be undesirable is that the devices can be set
> to slightly different addresses via external straps (probably a corner
> case, I know).  The bridge driver has the best chance of knowing what
> chips are where with certainty.

If one knows that some card has a certain chip at a certain address, then
it makes the most sense to store that with the rest of the card's data,
i.e. in the bridge driver.

But the bttv code looks like (I don't know what Hans intended, since he
didn't feel anyone else needed to know what, why, or how his code does
whatever it is that it does) it is probing all known address that a given
chip could be at to see if the chip is there.  In that case what's really
being used is an address list from the I2C chip's datasheet and any bridge
driver that wants to probe like that will use the same list, which IMHO,
makes more sense to put in the driver of the I2C chip rather than
every driver that uses the I2C chip.
