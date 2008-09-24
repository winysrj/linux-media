Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8O2WVNb020991
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 22:32:32 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8O2WK7q017015
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 22:32:20 -0400
From: Andy Walls <awalls@radix.net>
To: Dale Pontius <DEPontius@edgehp.net>
In-Reply-To: <48D99C67.90503@edgehp.net>
References: <48D4D5FE.60507@edgehp.net>
	<1221961427.6151.43.camel@palomino.walls.org>
	<48D6FAA1.8080303@edgehp.net>
	<1222217875.2652.73.camel@morgan.walls.org> <48D99C67.90503@edgehp.net>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 22:31:14 -0400
Message-Id: <1222223474.2652.145.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: HVR-1600 - unable to find tuner
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, 2008-09-23 at 21:48 -0400, Dale Pontius wrote:
> Andy Walls wrote:
> > On Sun, 2008-09-21 at 21:53 -0400, Dale Pontius wrote:
> >> Andy Walls wrote:
> >>> On Sat, 2008-09-20 at 06:52 -0400, Dale Pontius wrote:
> >>>
> >>>> A week back I posted a "newby question," and eventually it became
> >>>> apparent that I can't find my tuner.
> >>>>  I loaded the module with:
> >>>> "modprobe cx18 mmio_ndelay=61"
> >>> You can always try higher numbers to see if things get better at some
> >>> higher value.  Use multiples of 30.3.
> >>>
> >> Things look a litte different with "modprobe cx18 mmio_ndelay=182 debug=67",
> >> and I've also added the other debug parameters you suggest later.  With that,
> >> here's my dmesg:
> >> ---------------------------------------------------------------------------
> >> cx18-0: Autodetected Hauppauge HVR-1600
> >> cx18-0 info: NTSC tuner detected
> > 
> > This message means the driver has likely parsed the EEPROM properly and
> > thinks you have an NTSC tuner (which you should).
> snip
> > 
> > Well there should be only one tuner (mixer/oscillator) chip on that 2nd
> > i2c bus on the HVR-1600 bus.  The output of i2cdetect, assuming you
> > queried the correct bus, says that no chip is responding anywhere on
> > that bus, nor has any address on that bus been claimed by a driver.
> > 
> > This could be because the tuner's actually bad, or simply not responding
> > for some reason (i.e. the reset sequence with mdelay()'s at the end of
> > cx18-i2c.c didn't work), or the CX23418 chip is not responding properly
> > on the PCI bus when querying it's I2C control registers for the second
> > I2C bus (weird since everything else looks to be working).
> > 
> > 
> > For reference, here's output from my working HVR-1600
> > 
> > # modprobe i2c-dev
> > # i2cdetect -l
> > i2c-1	smbus     	SMBus PIIX4 adapter at 0b00     	SMBus adapter
> > i2c-0	i2c       	cx18 i2c driver #0-0            	I2C adapter
> > i2c-2	i2c       	cx18 i2c driver #0-1            	I2C adapter
> > 
> > # i2cdetect -y 0
> >      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> > 00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
> > 10: -- -- -- -- -- -- -- -- -- 19 -- -- -- -- -- -- 
> > 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> > 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> > 40: -- -- -- -- -- -- -- -- -- -- -- -- UU -- -- -- 
> > 50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> > 60: -- -- -- 63 -- -- -- -- -- -- -- -- -- -- -- -- 
> > 70: 70 71 72 73 -- -- -- --                        
> > 
> > (IIRC
> >  19 = cx25447
> >  4c = cs5345
> >  UU = device has been claimed by a driver
> >  50 = ATMEL eeprom
> >  63 = mxl5005s
> >  70-73 = Z8F0811 IR microcontroller)
> > 
> 
> Now comes something I think might be truly interesting.  Tonight when I tried
> modprobing my card, I put in an even longer delay, but there was no significant
> difference.
> 
> However in every case, even with the default delay, it takes at least 30 seconds,
> possibly as long as a minute before modprobe returns.

That's not right.  The i2c-algo-bit module implements a driver specific
timeout whenever it is waiting for the I2C bus clock line (SCL) to go
high (slaves on the bus are allowed to stretch the clock).  For the cx18
driver that time is specified in cx18-i2c.c as 

	#define CX18_ALGO_BIT_TIMEOUT (2) /* seconds */

This long delay you are experiencing is a very good indicator that the
SCL line on the second I2C bus on the card is stuck low.  AFAIK, there
are only two devices on that bus and the tuner chip and the CX23418
itself (and probably a pullup resistor).



>   I think I need to repeat
> this with "tail -f messages" and see if there is any particular breakpoint.
> 
> The reason I bring this up is that I just tried running i2cdetect against i2c-6,
> and it was done in less than a second.  Running i2cdetect against i2c-7 takes
> minutes.  I guess I figured those "--"s were all timeouts, but that didn't stop
> the first bus from running fast.  This is the first time I've probed the first
> bus, and saw the difference in time.  Incidentally, my results on the first bus
> match yours.

Good.


> Just started a timed run on modprobe.  I get to "cx18-0 i2c: i2c client register"
> within 5 seconds, and then get to "cx18:  End initialization" after 50-55 seconds.

That's too long.


> It's chewing its fat on the i2c bus for 45-50 seconds, which is consistent with
> my very long "i2cdetect -y 7" times.

Yup.

> Is this significant?

Yes in that it indicates the SCL line appears to be stuck low on that
bus, indicating bad hardware, hardware that isn't getting reset, or bad
CPU host to CX23418 communications (but only for resetting devices or
the 2nd I2C bus and nothing else, which doesn't seem plausible).


The i2c modules do having debugging switches, but they aren't compiled
in by default.  The i2c-algo-bit module does have one compiled-in
default module parameter called 'bit_test', when set to 1 causes the
module to check for stuck I2C bus lines.  Add that option to
your /etc/modprobe.conf, reboot, and the watch the i2c-algo-bit module
gripe when you modprobe cx18.


> Thanks,
> Dale
> one more note... I'll have to see what I can do about a Windows system.  I have
> one system that dual-boots Win98SE, so I'll have to read the manual and see if
> it's supported. 

I suspect the Windows driver doesn't support Win98SE.  Steve Toth
(stoth) hangs out on the linux-dvb list and on the IRC channels (not
sure if he's on this list too).  You can ask him; he'd know.

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
