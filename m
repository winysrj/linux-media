Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:47973 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbZGIRrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2009 13:47:00 -0400
Subject: Re: regression : saa7134  with Pinnacle PCTV 50i (analog) can not
	tune anymore
From: hermann pitton <hermann-pitton@arcor.de>
To: eric.paturage@orange.fr
Cc: linux-media@vger.kernel.org
In-Reply-To: <200907081908.n68J84c04245@neptune.localwarp.net>
References: <200907081908.n68J84c04245@neptune.localwarp.net>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 19:46:11 +0200
Message-Id: <1247161571.4329.13.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 08.07.2009, 21:07 +0200 schrieb
eric.paturage@orange.fr:
> > Hi Eric,
> > 
> > yes, arbitration lost on i2c is an error condition.
> > 
> > As far I know we did not change the bus speed or anything, but some
> > cards need and i2c quirk to work correctly with the clients.
> > 
> > Mike recently changed the old quirk with good reasons and it was widely
> > tested, also by me, without any negative effect seen.
> > 
> > Maybe your card is a rare case needing the old quirk.
> > 
> > You could try to change the quirk in saa7134-i2c.c
> > 
> > static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
> > 			    struct i2c_msg *msgs, int num)
> > {
> > 	struct saa7134_dev *dev = i2c_adap->algo_data;
> > 	enum i2c_status status;
> > 	unsigned char data;
> > 	int addr,rc,i,byte;
> > 
> > 	status = i2c_get_status(dev);
> > 	if (!i2c_is_idle(status))
> > 		if (!i2c_reset(dev))
> > 			return -EIO;
> > 
> > 	d2printk("start xfer\n");
> > 	d1printk(KERN_DEBUG "%s: i2c xfer:",dev->name);
> > 	for (i = 0; i < num; i++) {
> > 		if (!(msgs[i].flags & I2C_M_NOSTART) || 0 == i) {
> > 			/* send address */
> > 			d2printk("send address\n");
> > 			addr  = msgs[i].addr << 1;
> > 			if (msgs[i].flags & I2C_M_RD)
> > 				addr |= 1;
> > 			if (i > 0 && msgs[i].flags & I2C_M_RD && msgs[i].addr != 0x40) {
> > 				/* workaround for a saa7134 i2c bug
> > 				 * needed to talk to the mt352 demux
> > 				 * thanks to pinnacle for the hint */
> > 				int quirk = 0xfe;    <--------------------------------------
> > 				d1printk(" [%02x quirk]",quirk);
> > 				i2c_send_byte(dev,START,quirk);
> > 				i2c_recv_byte(dev);
> > 			}
> > 
> > back to 0xfd.
> > 
> > Cheers,
> > Hermann
> > 
> 
> H Hermann 
> 
> thanks for your suggestion .
> No  improvement with changing the quirk to 0xfd , 
> I still get the same error messages : 
> i2c-adapter i2c-1: Invalid 7-bit address 0x7a
> saa7133[0]: i2c xfer: < 8e >
> input: i2c IR (Pinnacle PCTV) as /class/input/input4
> ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-1/1-0047/ir0 [saa7133[0]]
> saa7133[0]: i2c xfer: < 8f ERROR: ARB_LOST
> saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 86 ERROR: ARB_LOST
> saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < 96 ERROR: ARB_LOST
> saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c4 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c6 ERROR: NO_DEVICE
> saa7133[0]: i2c xfer: < c8 ERROR: NO_DEVICE      
> 
> 
> Regards 
> 

Hi Eric,

thanks for your time and testing.

Before we need to start with v4l-dvb bisecting.

There have only been a few changes for the saa7134 driver since what
Mauro did send for 2.6.30.

Mostly for ir-kbd-i2c and for your remote was no tester found.

All i2c errors seem to start from the remote and that i2c remote stuff I
don't have and can't fake.

Did you try with options saa7134 disable_ir=1 already too?

Cheers,
Hermann




