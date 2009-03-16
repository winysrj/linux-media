Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4588 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCPHPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 03:15:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
Date: Mon, 16 Mar 2009 08:15:24 +0100
Cc: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <200903151324.00784.hverkuil@xs4all.nl> <1237146899.3314.52.camel@palomino.walls.org> <Pine.LNX.4.58.0903151616540.28292@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903151616540.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903160815.24613.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 March 2009 00:25:44 Trent Piepho wrote:
> On Sun, 15 Mar 2009, Andy Walls wrote:
> > On Sun, 2009-03-15 at 10:28 -0700, Trent Piepho wrote:
> > > Why are the i2c addresses from various i2c chips moved into the bttv
> > > driver?  Doesn't it make more sense that the addresses for chip X
> > > should be in the driver for chip X?
> >
> > One reason that this may be undesirable is that the devices can be set
> > to slightly different addresses via external straps (probably a corner
> > case, I know).  The bridge driver has the best chance of knowing what
> > chips are where with certainty.
>
> If one knows that some card has a certain chip at a certain address, then
> it makes the most sense to store that with the rest of the card's data,
> i.e. in the bridge driver.
>
> But the bttv code looks like (I don't know what Hans intended, since he
> didn't feel anyone else needed to know what, why, or how his code does
> whatever it is that it does) it is probing all known address that a given
> chip could be at to see if the chip is there.  In that case what's really
> being used is an address list from the I2C chip's datasheet and any
> bridge driver that wants to probe like that will use the same list, which
> IMHO, makes more sense to put in the driver of the I2C chip rather than
> every driver that uses the I2C chip.

Sadly the bttv driver doesn't have the knowledge of where chips are, or even 
which chips there are. This information was never recorded. So I have to 
replicate the original behavior here, i.e. probe for all possible 
addresses. And I agree that those list of addresses should be stored with 
the driver (using a static inline function in the header as I proposed), 
but I want to wait with that until all drivers are converted to v4l2_subdev 
and I have a complete overview of the needs of each driver.

And if I leave information out, just ask politely and I'll answer. I've been 
working on this for so long that I sometimes forget that not everyone is 
aware of all the subtleties.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
