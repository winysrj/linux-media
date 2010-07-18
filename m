Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:21836 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754784Ab0GRMzr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jul 2010 08:55:47 -0400
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
From: Andy Walls <awalls@md.metrocast.net>
To: Kenney Phillisjr <kphillisjr@gmail.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
In-Reply-To: <1278707305.25199.6.camel@dandel-desktop>
References: <1278707305.25199.6.camel@dandel-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jul 2010 08:56:13 -0400
Message-ID: <1279457773.2451.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-09 at 15:28 -0500, Kenney Phillisjr wrote:
> I know this is an old thread, however i have an card that meets the
> requirements to be tested by the patches made by andy, and so far
> with what i've tried it's been doing really well for input.
> 
> I pretty much just downloaded and tested Andy's patch set...
> http://linuxtv.org/hg/~awalls/cx23885-ir2


I'll be porting most of these 32 patches forward to my v4l-dvb.git tree
(on the cx-ir branch) later today.  I need the I/O pin configuration
stuff for the CX23885 and CX23888 IR transmitter pin configuration.

Could you please provide a diff for the one change you mentioned on IRC
about fixing Rx on the HVR-1250?


> The tests where done on ubuntu 10.04 with kernel 2.6.32-23-generic
> (64-bit) and this appears to be working perfectly. (This even properly
> identifies the card I'm using down to the model)
> 
> card notes: Hauppauge WinTV-HVR1250 (Model: 79001)

I don't have an original HVR-1250 or any other card with a genuine
CX23885 chip anymore, so I'll be unable to test.

I will likely add a module parameter that end users will be required to
set explcitly to enable the IR integrated in the CX23885 chip.  Igor's
testing with the TeVii S470 resulted in the infinite IR interrupts
making his system unusable.

Regards,
Andy

> oh and the only change i made to the test is i commented out the
> 4 lines in the makefile that generate the firedtv module so i could
> compile the tests 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


