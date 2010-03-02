Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43082 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab0CBEnE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 23:43:04 -0500
Received: by bwz1 with SMTP id 1so803487bwz.21
        for <linux-media@vger.kernel.org>; Mon, 01 Mar 2010 20:43:01 -0800 (PST)
Date: Tue, 2 Mar 2010 13:43:20 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	"Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: [IR RC, REGRESSION] Didn't work IR RC
Message-ID: <20100302134320.748ac292@glory.loctelecom.ru>
In-Reply-To: <1267503595.3269.21.camel@pc07.localdom.local>
References: <20100301153645.5d529766@glory.loctelecom.ru>
	<1267442919.3110.20.camel@palomino.walls.org>
	<4B8BC332.6060303@infradead.org>
	<1267503595.3269.21.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

Not work I2C IR RC. GPIO RC I think works well.

This patch remove addr of our RC from switch-case

http://linuxtv.org/hg/v4l-dvb/rev/f700bce82813

When I set debug for ir-kbd-i2c I get 

ir-kbd-i2c: :Unsupported device at address 0x2d

People with broken IR RC what addr has your I2C IR RC?

With my best regards, Dmitry.

> Hi,
> 
> Am Montag, den 01.03.2010, 10:37 -0300 schrieb Mauro Carvalho Chehab: 
> > Andy Walls wrote:
> > > On Mon, 2010-03-01 at 15:36 +0900, Dmitri Belimov wrote:
> > >> Hi All
> > >>
> > >> After rework of the IR subsystem, IR RC no more work in our TV
> > >> cards. As I see 
> > >> call saa7134_probe_i2c_ir,
> > >>   configure i2c
> > >>   call i2c_new_device
> > >>
> > >> New i2c device not registred.
> > >>
> > >> The module kbd-i2c-ir loaded after i2c_new_device.
> > > 
> > > Jean,
> > > 
> > > There was also a problem reported with the cx23885 driver's I2C
> > > connected IR by Timothy Lenz:
> > > 
> > > http://www.spinics.net/lists/linux-media/msg15122.html
> > > 
> > > The failure mode sounds similar to Dmitri's, but maybe they are
> > > unrelated.
> > > 
> > > I worked a bit with Timothy on IRC and the remote device fails to
> > > be detected whether ir-kbd-i2c is loaded before the cx23885
> > > driver or after the cx23885 driver.  I haven't found time to do
> > > any folow-up and I don't have any of the hardware in question.
> > > 
> > > Do you have any thoughts or a suggested troubleshooting approach?
> > 
> > Andy/Dmitri,
> > 
> > With the current i2c approach, the bridge driver is responsible for
> > binding an i2c device into the i2c adapter. In other words, the
> > bridge driver should have some logic to know what devices use
> > ir-kbd-i2c, loading it at the right i2c address(es). Manually
> > loading IR shouldn't make any difference.
> 
> yes, we have info.addr at saa7134-input and Dmitri did add the
> Beholder IR address there recently.
> 
> > >From Andy's comment, I suspect that such logic is missing at
> > >cx23885 for the board
> > you're referring. Not sure if this is the same case of the boards
> > Dmitri is concerned about.
> 
> On a first look, Andy seems not to provide the IR addr from the bridge
> and without probing it can't work anymore.
> 
> > It should be noticed that the i2c redesign happened on 2.6.31 or
> > 2.6.32, so, if this is the case, a patch should be sent also to
> > -stable.
> > 
> > In the case of saa7134, Jean worked on a fix for some boards:
> > 	http://patchwork.kernel.org/patch/75883/
> > 
> > He is currently waiting for someone with the affected boards to
> > test it and give some return.
> 
> That fix should be unrelated and both variants of the patch are not
> anywhere yet.
> 
> We can fake this single board in question on a P7131 Dual, but my
> receiver is broken, else all looked O.K., and it seems not worth yet
> to ask Mauro to lose time on faking it, assuming his IR receiver does
> still work.
> 
> Here we can simply wait for Daro coming back from skiing, or can even
> apply already Jean's solution per this card without any risk.
> 
> Else, do we not check for kernels < 2.6.30 on hg v4l-dvb not using
> auto probing anymore? I tested only on two machines with some 2.6.30
> and one with 2.6.29 and recent hg v4l-dvb. There at least all was
> fine, also with the patch moving IR init1 to saa7134_input_init2 and
> also for ir-kbd-ic2 for a early Pinnacle 310i under all conditions.
> 
> Dmitri, on what kernel and/or SCM version of v4l-dvb you discover that
> flaw? Maybe I can reproduce it then.
> 
> Andy has reports, that ir-kbd-i2c is still fine on 2.6.31, but breaks
> on 2.6.32. Do we already run out of sync?
> 
> Cheers,
> Hermann
> 
> 
