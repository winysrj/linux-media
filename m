Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57558 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923Ab2DKTMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 15:12:15 -0400
Message-ID: <4F85D787.2050403@iki.fi>
Date: Wed, 11 Apr 2012 22:12:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: gennarone@gmail.com, linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com> <4F804CDC.3030306@gmail.com> <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com>
In-Reply-To: <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.04.2012 15:02, Thomas Mair wrote:
> thanks for your information. I did get in touch with Realtek and they
> provided me with the datasheet for the RTL2832U. So what I will try to
> do is write a demodulator driver for the RTL2832 demod chip following
> the information of the datasheet and the Realtek driver. I will follow
> Antti's RTL2830 driver structure.
>
> For now there is only one question left regarding the testing of the
> drivers. What is the best way to test and debug the drivers. Sould I
> compile the 3.4 kernel and use it, or is it safer to set up a
> structure like the one I already have to test the driver with a stable
> kernel?

I vote for cloning Mauro's latest staging Kernel 3.5 and use it.
http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.5


I have some old stubbed drivers that just works for one frequency using 
combination of RTL2832U + FC2580. Also I have rather well commented USB 
sniff from that device. I can sent those if you wish.

As general instruction try following. It is what I usually do and I 
think many other Linux developers too.

1) take USB sniffs. SniffUSB 2.0.
http://www.pcausa.com/Utilities/UsbSnoop/
2) parse those sniffs using parser.pl script
3) log is still too big due to video stream, remove it
sed -e 's/BULK\[00081\].*$/BULK\[00081\] MPEG2 TS packet data removed/g' 
log.org > log.new
4) now you should have small ~100kB sniff, open it in text editor
5) analyze sniff. find out tuner I2C messages, then demod messages, 
usb-controller messages, etc.
6) make python/perl script to generate C-code like write_regs(0xaa, 
0x12); copy paste that code to driver skeleton until it starts working
7) implement all correctly callback per callback until you are fine with 
code. Most important demod callbacks are .set_frontend() and 
.read_status(). Others are not required, I mean .read_snr(), 
.read_ber(), .read_ucblocks() and .read_signal_strength(). IIRC RTL2830 
.read_status() is similar as RTL2832 and it is already working.

You can copy directly from RTL2830 driver these functions as those are 
similar:
rtl2830_wr()
rtl2830_rd()
rtl2830_wr_regs()
rtl2830_rd_regs()
rtl2830_rd_regs() // oops wrong name
rtl2830_rd_reg()
rtl2830_wr_reg_mask()
rtl2830_rd_reg_mask()

Consider also making making routines for access those "virtual" 
registers as RTL2830/RTL2832 uses "virtual" bit based registers over 
real hardware registers. Some extra work but surely easy many things as 
you don't need to play with bits.
Representation can be made like that or make your own model:
#define REGISTER_NAME <reg page(bank)><physical reg><reg bit MSB><reg 
bit LSB>

regards
Antti
-- 
http://palosaari.fi/
