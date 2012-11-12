Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34635 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555Ab2KLMjm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 07:39:42 -0500
Subject: Re: ir rremote support for TeVii S471
From: Andy Walls <awalls@md.metrocast.net>
To: Joakim Hernberg <jbh@alchemy.lu>
Cc: linux-media@vger.kernel.org
Date: Mon, 12 Nov 2012 07:39:34 -0500
In-Reply-To: <20121112100418.2fc61630@tor.valhalla.alchemy.lu>
References: <20121112100418.2fc61630@tor.valhalla.alchemy.lu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1352723975.2931.9.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-11-12 at 10:04 +0100, Joakim Hernberg wrote:
> Hello,
> 
> First of all, thanks a lot for adding the S471 support to the kernel.
> It appears to work very well on 3.6 which is what I'm running.
> 
> I am trying to get the included ir remote working.  Tried the
> enable_885_ir=1 module parameter (for cx23885) to no effect.
> 
> Any ideas?

You need to patch the cx23885 driver to teach it about the remote.

Here's a recent example of how to do this: 
http://www.spinics.net/lists/linux-media/msg56151.html
http://www.spinics.net/lists/linux-media/msg56152.html
http://www.spinics.net/lists/linux-media/msg56153.html

You can probably just use the RC_MAP_TEVII_NEC remote controller map and
not have to define a new one.

If the TeVii S471 has a CX23885 chip, just patch the driver similar to
what is already done for the TeVii S470 (load the cx25840 driver and use
the AV_CORE interrupt).

If the TeVii S471 uses a CX23888 chip, do something simlar for what is
done for the HVR-1270 (load the cx25840 driver and use the IR
interrupt), but still use setup paramaters that match the S470's NEC
remote.

Be warned: I never was able to get the CX23885 on the S470 to stop
producing an interrupt storm.  Blacklist the cx23885 module after you
have made you patches and load it manually, in case the same problem
happens with the S471.

-Andy 

