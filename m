Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60867 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbdJLLki (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 07:40:38 -0400
Date: Thu, 12 Oct 2017 12:40:37 +0100
From: Sean Young <sean@mess.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls.cx18@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 04/26] media: lirc_zilog: remove receiver
Message-ID: <20171012114036.qftrtmil6hpkczs4@gofer.mess.org>
References: <cover.1507618840.git.sean@mess.org>
 <176506027db4255239dc8ce192dc6652af75bd52.1507618840.git.sean@mess.org>
 <1507750996.2479.11.camel@gmail.com>
 <20171011210237.bpbfuhpf7om26ldi@gofer.mess.org>
 <0D74D058-EE11-4BFF-974C-16DB6910D2CF@gmail.com>
 <CAGoCfixQ6uLwbs7pQv5SzNkhP_Au18WrdNnM=Odi4JpbAn174w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGoCfixQ6uLwbs7pQv5SzNkhP_Au18WrdNnM=Odi4JpbAn174w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 11, 2017 at 08:25:12PM -0400, Devin Heitmueller wrote:
> > There's an ir_lock mutex in the driver to prevent simultaneous access to the Rx and Tx functions of the z8.  Accessing Rx and Tx functions of the chip together can cause it to do the wrong thing (sometimes hang?), IIRC.
> >
> > I'll see if I can dig up my old disassembly of the z8's firmware to see if that interlock is strictly necessary.
> >
> > Yes I know ir-kbd-i2c is in mainline, but as I said, I had reasons for avoiding it when using Tx operation of the chip.  It's been 7 years, and I'm getting too old to remember the reasons. :P
> 
> Yeah, you definitely don't want to be issuing requests to the Rx and
> Tx addresses at the same time.  Very bad things will happen.

Right, ok. That's good to know. I'll have to merge the Tx code with 
ir-kbd-i2c or port lirc_zilog Rx to rc-core.

> Also, what is the polling interval for ir-kbd-i2c?

lirc_zilog polls every 260ms and ir-kbd-i2c polls every 100ms.

>  If it's too high
> you can wedge the I2C bus (depending on the hardware design).
> Likewise, many people disable IR RX entirely (which is trivial to do
> with lirc_zilog through a modprobe optoin).

Yes, lirc_zilog has a tx_only option.

>  This is because early
> versions of the HDPVR had issues where polling too often can interfere
> with traffic that configures the component receiver chip.  This was
> improved in later versions of the design, but many people found it was
> just easiest to disable RX since they don't use it (i.e. they would
> use the blaster for controlling their STB but use a separate IR
> receiver).

That's very interesting.

> Are you testing with video capture actively in use?  If you're testing
> the IR interface without an active HD capture in progress you're
> likely to miss some of these edge cases (in particular those which
> would hang the encoder).

I had not, but I'll do that now.

> I'm not against the removal of duplicate code in general, but you have
> to tread carefully because there are plenty of non-obvious edge cases
> to consider.

Absolutely, thank you for your insights. 

Rather than relying on ir-kbd-i2c for receive, I can port lirc_zilog
to rc-core and leave much of it in place.

Thanks

Sean
