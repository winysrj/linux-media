Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48381 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbeKOJMy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 04:12:54 -0500
Date: Wed, 14 Nov 2018 23:07:36 +0000
From: Sean Young <sean@mess.org>
To: "martin.konopka@mknetz.de" <martin.konopka@mknetz.de>
Cc: linux-media@vger.kernel.org
Subject: Re: TechnoTrend CT2-4500 remote not working
Message-ID: <20181114230736.x4uigczm45slcgdr@gofer.mess.org>
References: <236ee34e-3052-f511-36c4-5dd48c6b433b@mknetz.de>
 <20181111214536.q2mplhfb5luzl5mg@gofer.mess.org>
 <64464af6-a85e-b03a-27e6-42cea34424d8@mknetz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64464af6-a85e-b03a-27e6-42cea34424d8@mknetz.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin,

On Wed, Nov 14, 2018 at 09:51:38PM +0100, martin.konopka@mknetz.de wrote:
> > It would be interesting to see what the device is sending. Please can you turn
> > on dynamic debug for ir-kbd-i2c.c:
> > 
> > echo "file ir-kbd-i2.c +p" > /sys/kernel/debug/dynamic_debug/control
> > 
> > Try the remote again and report what in the kernel messages.
> > 
> > Sean
> > 
> 
> I turned on dynamic debug and got the following messages in the kernel log:
> 
> [  837.160992] rc rc0: get_key_fusionhdtv: ff ff ff ff
> [  837.263927] rc rc0: ir_key_poll
> [  837.264528] rc rc0: get_key_fusionhdtv: ff ff ff ff
> [  837.367840] rc rc0: ir_key_poll
> [  837.368441] rc rc0: get_key_fusionhdtv: ff ff ff ff
> 
> Pressing a key on the remote did not change the pattern. I rechecked the
> connection of the IR receiver to the card but it was firmly plugged in.

Hmm, either the IR signal is not getting to the device, or this is not
where the IR is reported. I guess also the firmware could be incorrect
or out of date.

Certainly a logic analyser would help here to see if the signal is arriving,
and where it goes (e.g. directly to a gpio pin).

What's the output of the lspci -vvv? Maybe it's reported via gpio and not
i2c.

Thanks
Sean
