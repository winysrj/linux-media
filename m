Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47971 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbZK1Gfk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 01:35:40 -0500
Subject: Re: cx25840: GPIO settings wrong for HVR-1850 IR Tx
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, mkrufky@kernellabs.com, hverkuil@xs4all.nl
In-Reply-To: <1259356232.2353.13.camel@localhost>
References: <1259356232.2353.13.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 01:35:26 -0500
Message-Id: <1259390126.26617.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-11-27 at 16:11 -0500, Andy Walls wrote:


> Steve and Hans,
> 
> Any ideas?
> 
> I know on the list I had bantered around a configure, enable, set, get
> etc v4l2_subdev ops for gpio, but I can't remember the details nor the
> requirements.
> 
> The cx25840 module really needs a way for the cx23885 bridge driver to
> set GPIOs cleanly.

Nevermind, I've slapped something together at 

	http://linuxtv.org/hg/~awalls/cx23885-ir

for setting up the IO pin multiplexing in the CX23888 A/V core from the
bridge driver.

It does what I need.  Reading GPIOs or setting GPIOs without setting up
the pin config isn't implemented, as I didn't need it.  However, it
should be easier to implement that now. 

Regards,
Andy

