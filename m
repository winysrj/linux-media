Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59378 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006AbZJDVFG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 17:05:06 -0400
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116  for newer kernels
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
In-Reply-To: <20091004113342.GC20457@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
	 <20091004105429.234acbc1@hyperion.delvare>  <20091004113342.GC20457@moon>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 17:07:14 -0400
Message-Id: <1254690434.3148.159.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-10-04 at 14:33 +0300, Aleksandr V. Piskunov wrote:
> > Patch #3.
> > 
> > > --- a/linux/drivers/media/video/ir-kbd-i2c.c	Sat Oct 03 11:23:00 2009 -0400
> > > +++ b/linux/drivers/media/video/ir-kbd-i2c.c	Sat Oct 03 11:27:19 2009 -0400
> > > @@ -730,6 +730,7 @@
> > >  	{ "ir_video", 0 },
> > >  	/* IR device specific entries should be added here */
> > >  	{ "ir_rx_z8f0811_haup", 0 },
> > > +	{ "ir_rx_em78p153s_aver", 0 },
> > >  	{ }
> > >  };
> > >  
> > 
> > I think we need to discuss this. I don't really see the point of adding
> > new entries if the ir-kbd-i2c driver doesn't do anything about it. This
> > makes device probing slower with no benefit. As long as you pass device
> > information with all the details, the ir-kbd-i2c driver won't care
> > about the device name.
> > 
> > So the question is, where are we going with the ir-kbd-i2c driver? Are
> > we happy with the current model where bridge drivers pass IR device
> > information? Or do we want to move to a model where they just pass a
> > device name and ir-kbd-i2c maps names to device information? In the
> > latter case, it makes sense to have many i2c_device_id entries in
> > ir-kbd-i2c, but in the former case it doesn't.
> > 
> > I guess the answer depends in part on how common IR devices and remote
> > controls are across adapters. If the same IR device is used on many
> > adapters then it makes some sense to move the definitions into
> > ir-kbd-i2c. But if devices are heavily adapter-dependent, and moving
> > the definitions into ir-kbd-i2c doesn't allow for any code refactoring,
> > then I don't quite see the point.
> 
> I believe when it comes to TV cards, IR RX devices and remotes are mostly
> vendor-dependent thing, hardware design is usually reused in different
> products of same vendor.
> 
> Did some research into Avermedia IR stuff while trying to get my M116 working.
> 
> For example during last ~10 years Avermedia had 6(?) remote unit models,
> covering entire range of its TV cards (models FP/KH, HR/KJ, HV, JX, KS, KV).
> Model name is clearly printed on the remote near the vendor label. There is
> no clear connection or logic in how remotes are assigned to product. Analog
> USB Volar AX stick has a bulky JX remote, while the more advanced hybrid
> Volar HX variant of same stick has a smaller/cheaper HR/KJ remote.
> 
> How IR RX part is handled also seems to be device specific, but generally
> there are several designs being repeated on different models.
> 
> Like the above mentioned 8-bit controller design, it either Elan EM78P153S
> or Sonix SN8P2501A on I2C bus, or perhaps other compatible 8-bit controller:
> * AVerTV Cardbus Plus (Cardbus, saa713x, SN8P2501A)
>   http://www.ixbt.com/monitor/images/aver-cardbus-plus/inside-front.jpg
> * AVerTV USB2.0 Plus (USB, tvp5150, SN8P2501A) (not supported?)
>   http://www.ixbt.com/monitor/images/aver-usb20-plus/inside-front.jpg
> * AVerTV MCE 116 Plus (PCI, ivtv, EM78P153S or SN8P2501A)
>   http://www.ixbt.com/monitor/images/aver-m116-plus/aver-m116-plus-front.jpg
> * AVerTV Studio 709 (PCI, saa713x, EM78P153S)
>   http://www.ixbt.com/monitor/images/aver-709/aver-709-front.jpg
> 
> So different buses, different bridge drivers, same IR RX controller design.

Aleksandr,

Good research!


Hauppauge did the same sort of thing with the

	PVR-150 (later models): PCI, ivtv, Z8F0811
	HVR-1600: PCI, cx18, Z8F0811
	HD-PVR: USB, hdpvr, Z8F0811

Also, I think the PVR-500, HVR-1200/1250/1700/1800 units may use this
microcontroller as well.

I have no idea about commonality of the remotes. 

So commonality really only happens within the products a vendor
supports.  What remains common appears to be:

- Microcontroller
- Vendor loaded microcontroller firmware
- Presence of an IR transmitter along with the receiver.

Regards,
Andy

