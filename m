Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.openhardware.ru ([84.19.182.172]:47027 "EHLO
	ns.openhardware.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab0CJECV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Mar 2010 23:02:21 -0500
Date: Wed, 10 Mar 2010 13:02:25 +0900
From: Dmitri Belimov <dimon@openhardware.ru>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	"Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: [IR RC, REGRESSION] Didn't work IR RC
Message-ID: <20100310130225.75d2bca4@glory.loctelecom.ru>
In-Reply-To: <20100309115748.5ec7fd7a@hyperion.delvare>
References: <20100301153645.5d529766@glory.loctelecom.ru>
	<1267442919.3110.20.camel@palomino.walls.org>
	<4B8BC332.6060303@infradead.org>
	<1267503595.3269.21.camel@pc07.localdom.local>
	<20100302134320.748ac292@glory.loctelecom.ru>
	<20100302163634.31c934e4@glory.loctelecom.ru>
	<4B8CD10D.2010009@infradead.org>
	<20100309115748.5ec7fd7a@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean

> Hi Mauro, Dmitri,
> 
> On Tue, 02 Mar 2010 05:49:17 -0300, Mauro Carvalho Chehab wrote:
> > Dmitri Belimov wrote:
> > > When I add 
> > > 
> > > diff -r 37ff78330942 linux/drivers/media/video/ir-kbd-i2c.c
> > > --- a/linux/drivers/media/video/ir-kbd-i2c.c	Sun Feb 28
> > > 16:59:57 2010 -0300 +++
> > > b/linux/drivers/media/video/ir-kbd-i2c.c	Tue Mar 02
> > > 10:31:31 2010 +0900 @@ -465,6 +519,11 @@ ir_type     =
> > > IR_TYPE_OTHER; ir_codes    = &ir_codes_avermedia_cardbus_table;
> > >  		break;
> > > +	case 0x2d:
> > > +		/* Handled by saa7134-input */
> > > +		name        = "SAA713x remote";
> > > +		ir_type     = IR_TYPE_OTHER;
> > > +		break;
> > >  	}
> > >  
> > >  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> > > 
> > > The IR subsystem register event device. But for get key code use
> > > ir_pool_key function.
> > > 
> > > For our IR RC need use our special function. How I can do it?
> > 
> > Just add your get_key callback to "ir->get_key". If you want to do
> > this from saa7134-input, please take a look at the code at
> > em28xx_register_i2c_ir(). It basically fills the platform_data.
> > 
> > While you're there, I suggest you to change your code to work with
> > the full scancode (e. g. address + command), instead of just
> > getting the command. Currently, em28xx-input has one I2C IR already
> > changed to this mode (seek for full_code for the differences).
> > 
> > You'll basically need to change the IR tables to contain
> > address+command, and inform the used protocol (RC5/NEC) on it. The
> > getkey function will need to return the full code as well.
> 
> Sorry for the late reply. Is the problem solved by now, or is my help
> still needed?

Yes. I found what happens and solve this regression. Patch already comitted.

diff -r 37ff78330942 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Feb 28 16:59:57 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Thu Mar 04 08:35:15 2010 +0900
@@ -947,6 +947,7 @@
 		dev->init_data.name = "BeholdTV";
 		dev->init_data.get_key = get_key_beholdm6xx;
 		dev->init_data.ir_codes = &ir_codes_behold_table;
+		dev->init_data.type = IR_TYPE_NEC;
 		info.addr = 0x2d;
 #endif
 		break;


With my best regards, Dmitry.
