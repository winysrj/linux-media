Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33369 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbZHBSNE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Aug 2009 14:13:04 -0400
Subject: Re: correct implementation of FE_READ_UNCORRECTED_BLOCKS
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090802175622.GB19034@moon>
References: <20090802174836.GA19034@moon>  <20090802175622.GB19034@moon>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 14:11:38 -0400
Message-Id: <1249236698.2981.18.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-08-02 at 20:56 +0300, Aleksandr V. Piskunov wrote:
> Oops, sent it way too fast. Anyway.
> 
> DVB API documentation says:
> "This ioctl call returns the number of uncorrected blocks detected by
> the device driver during its lifetime.... Note that the counter will
> wrap to zero after its maximum count has been reached."
> 
> Does it mean that correct implementation of frontend driver should
> keep its own counter of UNC blocks and increment it every time hardware
> reports such block?

No, but a frontend driver may wish to keep a software counter that is
wider than the hardware register counter, in case the hardware register
rolls over too frequently.


> >From what I see, a lot of current frontend drivers simply dump a value
> from some hardware register. For example zl10353 I got here reports 
> some N unc blocks and then gets back to reporting zero.

To support the use case of multiple user apps trying to collect UNC
block statistics, the driver should not zero out the UNC block counter
when read.  If the hardware zeros it automatically, then one probably
should maintain a software counter in the driver.

Regards,
Andy


