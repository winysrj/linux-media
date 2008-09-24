Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8O1mIE4008682
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 21:48:18 -0400
Received: from mho-01-bos.mailhop.org (mho-01-bos.mailhop.org [63.208.196.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8O1m6J7028356
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 21:48:06 -0400
Message-ID: <48D99C67.90503@edgehp.net>
Date: Tue, 23 Sep 2008 21:48:23 -0400
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <48D4D5FE.60507@edgehp.net>
	<1221961427.6151.43.camel@palomino.walls.org>
	<48D6FAA1.8080303@edgehp.net>
	<1222217875.2652.73.camel@morgan.walls.org>
In-Reply-To: <1222217875.2652.73.camel@morgan.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Andy Walls wrote:
> On Sun, 2008-09-21 at 21:53 -0400, Dale Pontius wrote:
>> Andy Walls wrote:
>>> On Sat, 2008-09-20 at 06:52 -0400, Dale Pontius wrote:
>>>
>>>> A week back I posted a "newby question," and eventually it became
>>>> apparent that I can't find my tuner.
>>>>  I loaded the module with:
>>>> "modprobe cx18 mmio_ndelay=61"
>>> You can always try higher numbers to see if things get better at some
>>> higher value.  Use multiples of 30.3.
>>>
>> Things look a litte different with "modprobe cx18 mmio_ndelay=182 debug=67",
>> and I've also added the other debug parameters you suggest later.  With that,
>> here's my dmesg:
>> ---------------------------------------------------------------------------
>> cx18-0: Autodetected Hauppauge HVR-1600
>> cx18-0 info: NTSC tuner detected
> 
> This message means the driver has likely parsed the EEPROM properly and
> thinks you have an NTSC tuner (which you should).
snip
> 
> Well there should be only one tuner (mixer/oscillator) chip on that 2nd
> i2c bus on the HVR-1600 bus.  The output of i2cdetect, assuming you
> queried the correct bus, says that no chip is responding anywhere on
> that bus, nor has any address on that bus been claimed by a driver.
> 
> This could be because the tuner's actually bad, or simply not responding
> for some reason (i.e. the reset sequence with mdelay()'s at the end of
> cx18-i2c.c didn't work), or the CX23418 chip is not responding properly
> on the PCI bus when querying it's I2C control registers for the second
> I2C bus (weird since everything else looks to be working).
> 
> 
> For reference, here's output from my working HVR-1600
> 
> # modprobe i2c-dev
> # i2cdetect -l
> i2c-1	smbus     	SMBus PIIX4 adapter at 0b00     	SMBus adapter
> i2c-0	i2c       	cx18 i2c driver #0-0            	I2C adapter
> i2c-2	i2c       	cx18 i2c driver #0-1            	I2C adapter
> 
> # i2cdetect -y 0
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- 19 -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- -- -- -- -- -- -- -- -- UU -- -- -- 
> 50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 60: -- -- -- 63 -- -- -- -- -- -- -- -- -- -- -- -- 
> 70: 70 71 72 73 -- -- -- --                        
> 
> (IIRC
>  19 = cx25447
>  4c = cs5345
>  UU = device has been claimed by a driver
>  50 = ATMEL eeprom
>  63 = mxl5005s
>  70-73 = Z8F0811 IR microcontroller)
> 

Now comes something I think might be truly interesting.  Tonight when I tried
modprobing my card, I put in an even longer delay, but there was no significant
difference.

However in every case, even with the default delay, it takes at least 30 seconds,
possibly as long as a minute before modprobe returns.  I think I need to repeat
this with "tail -f messages" and see if there is any particular breakpoint.

The reason I bring this up is that I just tried running i2cdetect against i2c-6,
and it was done in less than a second.  Running i2cdetect against i2c-7 takes
minutes.  I guess I figured those "--"s were all timeouts, but that didn't stop
the first bus from running fast.  This is the first time I've probed the first
bus, and saw the difference in time.  Incidentally, my results on the first bus
match yours.

Just started a timed run on modprobe.  I get to "cx18-0 i2c: i2c client register"
within 5 seconds, and then get to "cx18:  End initialization" after 50-55 seconds.
It's chewing its fat on the i2c bus for 45-50 seconds, which is consistent with
my very long "i2cdetect -y 7" times.

Is this significant?

Thanks,
Dale
one more note... I'll have to see what I can do about a Windows system.  I have
one system that dual-boots Win98SE, so I'll have to read the manual and see if
it's supported.  I also have a friend who might have an XP system we can check
it out in, so I'll check that.
> # i2cdetect -y 2
>      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
> 00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 60: -- UU -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
> 70: -- -- -- -- -- -- -- --             
> 
> 61 = simple tuner mixer/oscillator chip
> UU = device has been claimed by a driver
> 
> 
>> I'm wondering if either my bttv card is interfering somehow,
> 
> If you got all '--' on the i2cdetect of the correct i2c bus on the
> HVR-1600, then it really can't be the bttv driver, AFAICT.
> 
> For testing, I'm going to try to implement another, agressive PCI bus
> access algorithm for accessing the CX23418 instead of using simple
> delays with mmio_ndelay.  I don't have a definite schedule on this yet.
> I'm not hopeful that it will help though, seeing as your CX23418 seems
> to behaving well otherwise (no -121 errors, can always read the eeprom,
> always loads the firmware, always can init the ATSC side of the card,
> etc.).
> 
> 
>>  or if this card
>> needs to be RMA'ed. 
> 
> Try it in a Windows installation first.
> 
> 
>>  I have another identical card in an unopened box, if it's
>> time to try that.
> 
> I suspect it may behave differently (manufacturing variations).  If your
> second card works, it doesn't mean your first card is broken though.  It
> may mean the cx18 driver needs to do something differently.  Make sure
> the first card doesn't work in Windows as well before returning (if
> possible).
> 
> 
>> Thanks,
>> Dale Pontius
> 
> Regards,
> Andy
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
