Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp27.orange.fr ([80.12.242.96]:19383 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZGJFvL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 01:51:11 -0400
Message-Id: <200907100551.n6A5p9i03931@neptune.localwarp.net>
Date: Fri, 10 Jul 2009 07:50:48 +0200 (CEST)
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

On  9 Jul, hermann pitton wrote:
> 
> 
> Am Mittwoch, den 08.07.2009, 21:07 +0200 schrieb
> eric.paturage@orange.fr:
>> > Hi Eric,
>> > 
>> > yes, arbitration lost on i2c is an error condition.
>> > 
>> > As far I know we did not change the bus speed or anything, but some
>> > cards need and i2c quirk to work correctly with the clients.
>> > 
>> > Mike recently changed the old quirk with good reasons and it was widely
>> > tested, also by me, without any negative effect seen.
>> > 
>> > Maybe your card is a rare case needing the old quirk.
>> > 
>> > You could try to change the quirk in saa7134-i2c.c
>> > 
>> > static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
>> > 			    struct i2c_msg *msgs, int num)
>> > {
>> > 	struct saa7134_dev *dev = i2c_adap->algo_data;
>> > 	enum i2c_status status;
>> > 	unsigned char data;
>> > 	int addr,rc,i,byte;
>> > 
>> > 	status = i2c_get_status(dev);
>> > 	if (!i2c_is_idle(status))
>> > 		if (!i2c_reset(dev))
>> > 			return -EIO;
>> > 
>> > 	d2printk("start xfer\n");
>> > 	d1printk(KERN_DEBUG "%s: i2c xfer:",dev->name);
>> > 	for (i = 0; i < num; i++) {
>> > 		if (!(msgs[i].flags & I2C_M_NOSTART) || 0 == i) {
>> > 			/* send address */
>> > 			d2printk("send address\n");
>> > 			addr  = msgs[i].addr << 1;
>> > 			if (msgs[i].flags & I2C_M_RD)
>> > 				addr |= 1;
>> > 			if (i > 0 && msgs[i].flags & I2C_M_RD && msgs[i].addr != 0x40) {
>> > 				/* workaround for a saa7134 i2c bug
>> > 				 * needed to talk to the mt352 demux
>> > 				 * thanks to pinnacle for the hint */
>> > 				int quirk = 0xfe;    <--------------------------------------
>> > 				d1printk(" [%02x quirk]",quirk);
>> > 				i2c_send_byte(dev,START,quirk);
>> > 				i2c_recv_byte(dev);
>> > 			}
>> > 
>> > back to 0xfd.
>> > 
>> > Cheers,
>> > Hermann
>> > 
>> 
>> H Hermann 
>> 
>> thanks for your suggestion .
>> No  improvement with changing the quirk to 0xfd , 
>> I still get the same error messages : 
>> i2c-adapter i2c-1: Invalid 7-bit address 0x7a
>> saa7133[0]: i2c xfer: < 8e >
>> input: i2c IR (Pinnacle PCTV) as /class/input/input4
>> ir-kbd-i2c: i2c IR (Pinnacle PCTV) detected at i2c-1/1-0047/ir0 [saa7133[0]]
>> saa7133[0]: i2c xfer: < 8f ERROR: ARB_LOST
>> saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
>> saa7133[0]: i2c xfer: < 86 ERROR: ARB_LOST
>> saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
>> saa7133[0]: i2c xfer: < 96 ERROR: ARB_LOST
>> saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
>> saa7133[0]: i2c xfer: < c2 ERROR: NO_DEVICE
>> saa7133[0]: i2c xfer: < c4 ERROR: NO_DEVICE
>> saa7133[0]: i2c xfer: < c6 ERROR: NO_DEVICE
>> saa7133[0]: i2c xfer: < c8 ERROR: NO_DEVICE      
>> 
>> 
>> Regards 
>> 
> 
> Hi Eric,
> 
> thanks for your time and testing.
> 
> Before we need to start with v4l-dvb bisecting.
> 
> There have only been a few changes for the saa7134 driver since what
> Mauro did send for 2.6.30.
> 
> Mostly for ir-kbd-i2c and for your remote was no tester found.
> 
> All i2c errors seem to start from the remote and that i2c remote stuff I
> don't have and can't fake.
> 
> Did you try with options saa7134 disable_ir=1 already too?
> 
> Cheers,
> Hermann
> 
> 

Hi Hermann 

I  tried this morning with the option disable_ir=1 (mercurial from 7/7/2009)
there is some progress :

case 1 : modprobe saa7134 
the tuner does not load any submodule 
message Jul 10 06:49:04 neptune kernel: TUNER: Unable to find symbol tda829x_probe()
Jul 10 06:49:05 neptune kernel: DVB: Unable to find symbol tda9887_attach()
Jul 10 06:51:21 neptune kernel: TUNER: Unable to find symbol tda829x_probe()
Jul 10 06:51:21 neptune kernel: DVB: Unable to find symbol tda9887_attach()
Jul 10 06:55:01 neptune kernel: TUNER: Unable to find symbol tda829x_probe()

message" neptune kernel: tuner 1-004b: Tuner has no way to set tv freq
equency " in /var/log/message 

no pic with xawtv 
xdtv hangs badly 

tried with quirk at both values (0xfe and 0xfd )

----------------------------------------------------------------------------------------

case 2 :  modprobe saa7134  with having before manualy preloaded  tda827x and tda8290
xawtv give a picture after maybe 10 sec  , it is very very slow to tune (about 6 or 7 sec ) .
xdtv hangs completely  , no picture , no channel change (time out and try reset). 

tried with quirk at both values (0xfe and 0xfd )

Jul 10 07:29:16 neptune kernel: tuner 1-004b: chip found @ 0x96 (saa7133[0])
Jul 10 07:29:16 neptune kernel: tda829x 1-004b: setting tuner address to 61
Jul 10 07:29:16 neptune kernel: tda829x 1-004b: type set to tda8290+75a
Jul 10 07:29:19 neptune kernel: saa7133[0]: registered device video0 [v4l2]
Jul 10 07:29:19 neptune kernel: saa7133[0]: registered device vbi0
Jul 10 07:29:19 neptune kernel: saa7133[0]: registered device radio0
Jul 10 07:29:19 neptune kernel: saa7134 ALSA driver for DMA sound loaded
Jul 10 07:29:19 neptune kernel: IRQ 11/saa7133[0]: IRQF_DISABLED is not guarante
ed on shared IRQs
Jul 10 07:29:19 neptune kernel: saa7133[0]/alsa: saa7133[0] at 0xed800000 irq 11
 registered as card -1
Jul 10 07:29:52 neptune kernel: 
Jul 10 07:29:52 neptune kernel:  01 20 >
Jul 10 07:30:02 neptune kernel: 
Jul 10 07:30:57 neptune last message repeated 23 times
Jul 10 07:31:19 neptune last message repeated 29 times
Jul 10 07:34:40 neptune kernel: INFO: task xdtv:3912 blocked for more than 120 s
econds.


I can provide  more detailed dmesg , if needed . 

regards 


