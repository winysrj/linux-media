Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40072 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbZCOTx4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 15:53:56 -0400
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
From: Andy Walls <awalls@radix.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0903151001040.28292@shell2.speakeasy.net>
References: <200903151324.00784.hverkuil@xs4all.nl>
	 <Pine.LNX.4.58.0903150859300.28292@shell2.speakeasy.net>
	 <200903151753.52663.hverkuil@xs4all.nl>
	 <Pine.LNX.4.58.0903151001040.28292@shell2.speakeasy.net>
Content-Type: text/plain
Date: Sun, 15 Mar 2009 15:54:59 -0400
Message-Id: <1237146899.3314.52.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-03-15 at 10:28 -0700, Trent Piepho wrote:

> Why are the i2c addresses from various i2c chips moved into the bttv
> driver?  Doesn't it make more sense that the addresses for chip X should be
> in the driver for chip X?

One reason that this may be undesirable is that the devices can be set
to slightly different addresses via external straps (probably a corner
case, I know).  The bridge driver has the best chance of knowing what
chips are where with certainty.

Regards,
Andy



