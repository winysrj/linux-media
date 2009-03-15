Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:43639 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZCOR2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 13:28:46 -0400
Date: Sun, 15 Mar 2009 10:28:42 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
In-Reply-To: <200903151753.52663.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903151001040.28292@shell2.speakeasy.net>
References: <200903151324.00784.hverkuil@xs4all.nl>
 <Pine.LNX.4.58.0903150859300.28292@shell2.speakeasy.net>
 <200903151753.52663.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009, Hans Verkuil wrote:
> On Sunday 15 March 2009 17:04:43 Trent Piepho wrote:
> > On Sun, 15 Mar 2009, Hans Verkuil wrote:
> > > Hi Mauro,
> > >
> > > Can you review my ~hverkuil/v4l-dvb-bttv2 tree?
> >
> > It would be a lot easier if you would provide patch descriptions.
>
> Here it is:
>
> - bttv: convert to v4l2_subdev.

You aren't even trying.  I could easily write two pages on this patch.

What new module parameters did you add?  Why?  What module parameters did
you delete?  Why?  How does one translate a existing modprobe.conf file?

Why are the i2c addresses from various i2c chips moved into the bttv
driver?  Doesn't it make more sense that the addresses for chip X should be
in the driver for chip X?

How has module loading changed?  Can one no longer *not* autoload modules if
you are trying to test drivers that are not installed in /lib/modules?

What fields did you add to the card database?  Why?  How much did the size
increase?  What is the never set has_saa6588 field in tvcards needed for?

What are the parameters to bttv_call_all?

How did you change the probing sequence?  What was it before?  What is it
now?

Where do the subdevs you created get deleted?
