Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43188 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbZKWAQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 19:16:13 -0500
Received: by bwz27 with SMTP id 27so4619389bwz.21
        for <linux-media@vger.kernel.org>; Sun, 22 Nov 2009 16:16:18 -0800 (PST)
To: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Matthias Fechner <idefix@fechner.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: Re: IR Receiver on an Tevii S470
Content-Disposition: inline
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Mon, 23 Nov 2009 02:15:33 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911230215.33644.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23 ноября 2009, "Igor M. Liplianin" <liplianin@me.by> wrote:
> On Mon, 2009-11-23 at 00:29 +0200, Igor M. Liplianin wrote:
> > On 22 ноября 2009 22:11:47 Andy Walls wrote:
> > > On Sun, 2009-11-22 at 19:08 +0100, Matthias Fechner wrote:
> > > > Hi Andy,
> > > >
> > > > Andy Walls wrote:
> > > > > Thank you.  I will probably need you for testing when ready.
> > > > >
> > > > >
> > > > > I was planning to do step 1 above for HVR-1800 IR anyway.
> > > > >
> > > > > I will estimate that I may have something ready by about Christmas
> > > > > (25 December 2009), unless work becomes very busy.
> > > >
> > > > thanks a lot for your answer.
> > > > I uploaded two pictures I did from the card, you can find it here:
> > > > http://fechner.net/tevii-s470/
> > > >
> > > > It is a CX23885.
> > > > The driver I use is the ds3000.
> > > > lspci says:
> > >
> > > [snip]
> > >
> > > Matthias,
> > >
> > > Thanks for the pictures.  OK so of the two other interesting chips on
> > > the S470:
> > >
> > > U4 is an I2C connected EEPROM - we don't care about that for IR.
> > >
> > > U10 appears to perhaps be a Silicon Labs C8051F300 microcontroller or
> > > similar:
> > >
> > > http://www.silabs.com/products/mcu/smallmcu/Pages/C8051F30x.aspx
> > >
> > > Since the 'F300 has an A/D convertor and has an SMBus interface
> > > (compatable with the I2C bus), I suspect this chip could be the IR
> > > controller on the TeVii S470.
> > >
> > > Could you as root:
> > >
> > > # modprobe cx23885
> > > # modprobe i2c-dev
> > > # i2c-detect -l
> > > (to list all the i2c buses, including cx23885 mastered i2c buses)
> > > # i2c-detect -y N
> > > (to show the addresses in use on bus # N: only query the cx23885 buses)
> > >
> > >
> > > i2c-detect was in the lm-sensors package last I checked.  (Jean can
> > > correct me if I'm wrong.)
> > >
> > > With that information, I should be able to figure out what I2C address
> > > that microcontroller is listening to.
> > >
> > > Then we can work out how to read and decode it's data and add it to
> > > ir-kbd-i2c at least.  Depending on how your kernel and LIRC versions
> > > LIRC might still work with I2C IR chips too.
> > >
> > >
> > > All presupposing of course that that 'F300 chip is for IR...
> >
> > Receiver connected to cx23885 IR_RX(pin 106). It is not difficult to
> > track.
>
> Igor,
>
> Thank you.  I did not have a board to trace.  I will then stick with my
> original plan since the F300 doesn't do the IR.
I have cx23885 based Compro E650F DVB-T card. It shipped with RC6 type remote.
So I can test RC6 too... And I will.

>
> > F300 is for LNB power control.
> > It connected to cx23885 GPIO pins:
> > GPIO0 - data - P0.3 F300
> > GPIO1 - reset - P0.2 F300
> > GPIO2 - clk - P0.1 F300
> > GPIO3 - busy - P0.0 F300
> >
> > Interface seems not I2C/SMBUS.
> >
> > Source code from TeVii:
> > http://mercurial.intuxication.org/hg/s2-
> > liplianin/file/d0dfe416e0f6/linux/drivers/media/video/cx23885/tevii_pwr.c
>
> Interesting....
>
>    static void Delay1mS(void)
>    {
> 	   udelay(800);
>    }
>
> :D
Your link to datasheet helps me a lot :)
I will clear all that out and will commit to linuxtv soon.

BR
Igor
>
> Regards,
> Andy
>
> > BR
> > Igor
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

