Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:43505 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbdJLAuJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 20:50:09 -0400
Received: by mail-qt0-f195.google.com with SMTP id a43so10670951qta.0
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 17:50:08 -0700 (PDT)
Message-ID: <1507769407.2736.10.camel@gmail.com>
Subject: Re: [PATCH v3 04/26] media: lirc_zilog: remove receiver
From: Andy Walls <awalls.cx18@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Sean Young <sean@mess.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Wed, 11 Oct 2017 20:50:07 -0400
In-Reply-To: <CAGoCfixQ6uLwbs7pQv5SzNkhP_Au18WrdNnM=Odi4JpbAn174w@mail.gmail.com>
References: <cover.1507618840.git.sean@mess.org>
         <176506027db4255239dc8ce192dc6652af75bd52.1507618840.git.sean@mess.org>
         <1507750996.2479.11.camel@gmail.com>
         <20171011210237.bpbfuhpf7om26ldi@gofer.mess.org>
         <0D74D058-EE11-4BFF-974C-16DB6910D2CF@gmail.com>
         <CAGoCfixQ6uLwbs7pQv5SzNkhP_Au18WrdNnM=Odi4JpbAn174w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean and Devin:

On Wed, 2017-10-11 at 20:25 -0400, Devin Heitmueller wrote:
> > There's an ir_lock mutex in the driver to prevent simultaneous
> > access to the Rx and Tx functions of the z8.  Accessing Rx and Tx
> > functions of the chip together can cause it to do the wrong thing
> > (sometimes hang?), IIRC.
> > 
> > I'll see if I can dig up my old disassembly of the z8's firmware to
> > see if that interlock is strictly necessary.

Following up on this:

1. The I2C bus command and response buffers inside the Z8 appear to be
independent and non-overlapping (ignore the garbage assembly
mnemonics):

; I2C data buffer addresses
01bf srp   #%00   ; 01 00 ; Buffer pointer I2C addr E0 (70w) IR Tx  - 160 bytes
01c1 add   r0,@r0 ; 03 00 ; Buffer pointer I2C addr E1 (70r) IR Tx  -   4 bytes
01c3 add   r1,@r5 ; 03 15 ; Buffer pointer I2C addr E2 (71w) IR Rx  -   5 bytes
01c5 add   r1,@r0 ; 03 10 ; Buffer pointer I2C addr E3 (71r) IR Rx  -   5 bytes
01c7 add   r0,@r10; 03 0a ; Buffer pointer I2C addr E4 (72w) IR PB1 -   4 bytes
01c9 add   r1,@r10; 03 1a ; Buffer pointer I2C addr E5 (72r) IR PB1 -   4 bytes
01cb add   r0,@r5 ; 03 05 ; Buffer pointer I2C addr E6 (73w) IR Lrn -   1 bytes
01cd add   r0,r0  ; 02 00 ; Buffer pointer I2C addr E7 (73r) IR Lrn - 256 bytes

and the I2C handling routines appear to do the right thing in waiting
for "full" buffers before operating on them.

2. Z8 Port B is used by both Tx and Rx functions, but the functions
each only use 1 line of the I/O port and they use different lines.

3. Z8 Port C is unused.

4. Z8 Port A is used by both Tx functions, Rx functions, the I2C
interface.  If something inside the Z8 screws up the I2C bus comms with
the chip, it's likely the errant misconfiguration of Port A during
certain Rx and Tx operations.

5. Rx and IR Learn both use the same external hardware.  Not
coordinating Rx with Learn mode in the same driver, will prevent Learn
operation from working.  That is, if Learn mode is ever implemented. 
(Once upon a time, I was planning on doing that.  But I have no time
for that anymore.)  

> > Yes I know ir-kbd-i2c is in mainline, but as I said, I had reasons
> > for avoiding it when using Tx operation of the chip.  It's been 7
> > years, and I'm getting too old to remember the reasons. :P
> 
> Yeah, you definitely don't want to be issuing requests to the Rx and
> Tx addresses at the same time.  Very bad things will happen.
> 
> Also, what is the polling interval for ir-kbd-i2c?  If it's too high
> you can wedge the I2C bus (depending on the hardware design).
> Likewise, many people disable IR RX entirely (which is trivial to do
> with lirc_zilog through a modprobe optoin).  This is because early
> versions of the HDPVR had issues where polling too often can
> interfere
> with traffic that configures the component receiver chip.  This was
> improved in later versions of the design, but many people found it
> was
> just easiest to disable RX since they don't use it (i.e. they would
> use the blaster for controlling their STB but use a separate IR
> receiver).
> 
> Are you testing with video capture actively in use?  If you're
> testing
> the IR interface without an active HD capture in progress you're
> likely to miss some of these edge cases (in particular those which
> would hang the encoder).

I'm glad someone remembers all this stuff.  I'm assuming you had more
pain with this than I ever did.  I never owned an HD-PVR.

Regards,
Andy

> I'm not against the removal of duplicate code in general, but you
> have
> to tread carefully because there are plenty of non-obvious edge cases
> to consider.
> 
> Devin
> 
