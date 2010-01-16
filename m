Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64249 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0APNGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 08:06:55 -0500
Received: by bwz27 with SMTP id 27so1194862bwz.21
        for <linux-media@vger.kernel.org>; Sat, 16 Jan 2010 05:06:53 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
Date: Sat, 16 Jan 2010 15:06:35 +0200
Cc: linux-media@vger.kernel.org,
	Andreas Tschirpke <andreas.tschirpke@gmail.com>,
	Matthias Fechner <idefix@fechner.net>, stoth@kernellabs.com
References: <1263614561.6084.15.camel@palomino.walls.org>
In-Reply-To: <1263614561.6084.15.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001161506.35580.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 января 2010 06:02:41 Andy Walls wrote:
> Hi,
>
> I've got reworked changes for the IR for the TeVii S470 and the HVR-1250
> at
>
> 	http://linuxtv.org/hg/~awalls/cx23885-ir2
>
> Thanks to loaner HVR-1250 hardware from Devin Heitmueller,
> I've solved the infinite interrupt problem with the CX23885 AV core and
> have reworked the change set against the latest v4l-dvb.
>
> Please test.
>
> Note
>
> 1. the parameters for the IR controller setup in
> linux/drivers/video/cx23885-input.c may need to be tweaked to set the
> proper "params.modulation" and "params.invert_level" before you get
> keypresses decoded.
>
> 2. I guessed at a reasonable set of remote keycodes for the TeVii S470,
> so don't be surprised if the button mapping isn't quite right.
>
> 3.  These module settings may be helpful for debug and test:
>
>        # modprobe cx25840 debug=2 ir_debug=2
>        # modprobe cx23885 debug=7
>
> Also directing "kern.*" messages to /var/log/messages
> in /etc/rsyslogd.conf and giving rsyslod a SIGHUP may be helpful for
> capturing the messages.
>
> 4.  In case I didn't fix the infinite interrupts problem for the TeVii
> S470: Before testing, blacklist the cx23885 module
> in /etc/modprobe.d/blacklist, so that when you reboot, the module
> doesn't automatically load.  If your system seems to be very busy with
> inifinite interrupts upon cx23885 module load, stop testing (and let me
> know).
>
> Regards,
> Andy
However, modprobe cx23885 card=3
and RC5 remote gives some events.

cx25840 3-0044: IRQ Status:  tsr rsr     ror     rby
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: IR receiver hardware FIFO overrun
cx25840 3-0044: AV Core IRQ status (exit):           
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr rsr     ror     rby
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: IR receiver hardware FIFO overrun
cx25840 3-0044: AV Core IRQ status (exit):           
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr rsr             rby
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: AV Core IRQ status (exit):           
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr rsr     ror     rby
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: IR receiver hardware FIFO overrun
cx25840 3-0044: AV Core IRQ status (exit):           
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr rsr rto            
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: AV Core IRQ status (exit):           
cx25840 3-0044: rx read:    1605444 ns  space
cx25840 3-0044: rx read:    1748852 ns  mark
cx25840 3-0044: rx read:    1618778 ns  space
cx25840 3-0044: rx read:    1713000 ns  mark
cx25840 3-0044: rx read: end of rx
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr rsr rto ror        
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: IR receiver hardware FIFO overrun
cx25840 3-0044: AV Core IRQ status (exit):           
cx25840 3-0044: rx read:     779667 ns  space
cx25840 3-0044: rx read:    1737741 ns  mark
cx25840 3-0044: rx read:    1618630 ns  space
cx25840 3-0044: rx read:    1737593 ns  mark
cx25840 3-0044: rx read:    1618630 ns  space
cx25840 3-0044: rx read:    1738481 ns  mark
cx25840 3-0044: rx read:    1617889 ns  space
cx25840 3-0044: rx read:    1738926 ns  mark
cx25840 3-0044: AV Core IRQ status (entry): ir        
cx25840 3-0044: IRQ Status:  tsr rsr rto ror        
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: IR receiver hardware FIFO overrun

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
