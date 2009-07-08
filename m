Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.orange.fr ([80.12.242.46]:63797 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbZGHTII (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Jul 2009 15:08:08 -0400
Message-Id: <200907081908.n68J84c04245@neptune.localwarp.net>
Date: Wed, 8 Jul 2009 21:07:43 +0200 (CEST)
From: eric.paturage@orange.fr
Reply-To: eric.paturage@orange.fr
Subject: Re: regression : saa7134  with Pinnacle PCTV 50i (analog) can not
 tune anymore
To: hermann-pitton@arcor.de
cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Eric,
> 
> yes, arbitration lost on i2c is an error condition.
> 
> As far I know we did not change the bus speed or anything, but some
> cards need and i2c quirk to work correctly with the clients.
> 
> Mike recently changed the old quirk with good reasons and it was widely
> tested, also by me, without any negative effect seen.
> 
> Maybe your card is a rare case needing the old quirk.
> 
> You could try to change the quirk in saa7134-i2c.c
> 
> static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
> 			    struct i2c_msg *msgs, int num)
> {
> 	struct saa7134_dev *dev = i2c_adap->algo_data;
> 	enum i2c_status status;
> 	unsigned char data;
> 	int addr,rc,i,byte;
> 
> 	status = i2c_get_status(dev);
> 	if (!i2c_is_idle(status))
> 		if (!i2c_reset(dev))
> 			return -EIO;
> 
> 	d2printk("start xfer\n");
> 	d1printk(KERN_DEBUG "%s: i2c xfer:",dev->name);
> 	for (i = 0; i < num; i++) {
> 		if (!(msgs[i].flags & I2C_M_NOSTART) || 0 == i) {
> 			/* send address */
> 			d2printk("send address\n");
> 			addr  = msgs[i].addr << 1;
> 			if (msgs[i].flags & I2C_M_RD)
> 				addr |= 1;
> 			if (i > 0 && msgs[i].flags & I2C_M_RD && msgs[i].addr != 0x40) {
> 				/* workaround for a saa7134 i2c bug
> 				 * needed to talk to the mt352 demux
> 				 * thanks to pinnacle for the hint */
> 				int quirk = 0xfe;    <--------------------------------------
> 				d1printk(" [%02x quirk]",quirk);
> 				i2c_send_byte(dev,START,quirk);
> 				i2c_recv_byte(dev);
> 			}
> 
> back to 0xfd.
> 
> Cheers,
> Hermann
> 

H Hermann 

thanks for your suggestion .
No  improvement with changing the quirk to 0xfd , 
I still get the same error messages : 
i2c-adapter i2c-1: Invalid 7-bit address 0x7a
saa7133[0]: i2c xfer: < 8e >
input: i2c IR (Pinnacle PCTV) as /class/input/input4
ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-1/1-0047/ir0 [saa7133[0]]
saa7133[0]: i2c xfer: < 8f ERROR: ARB_LOST
saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 86 ERROR: ARB_LOST
saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 96 ERROR: ARB_LOST
saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c4 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c6 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c8 ERROR: NO_DEVICE      


Regards 




