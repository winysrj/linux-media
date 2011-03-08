Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64193 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1CGN5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 08:57:11 -0500
Received: by vws12 with SMTP id 12so3653006vws.19
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 05:57:10 -0800 (PST)
From: Vivek Periaraj <vivek.periaraj@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge WinTV USB 2
Date: Mon, 7 Mar 2011 19:26:58 -0500
References: <201102240116.18770.Vivek.Periaraj@gmail.com> <4D658C78.2080907@gmail.com> <201102250219.37637.Vivek.Periaraj@gmail.com>
In-Reply-To: <201102250219.37637.Vivek.Periaraj@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201103071926.58500.Vivek.Periaraj@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Folks,

I am having hardtime capturing video from this card.

Last two weeks I spent on getting signal from my DTH box. It's a single analog 
signal from the DTH set up box.

>From windows, I scan this signal and I am able to see video through this card. 
So the card is working and signal is there!

Also, zeroed in on Zapping for TV viewing as many of the other applications 
didn't work properly. But other scanners (tvtime-scanner) and zapping's own TV 
scanner is not able to find this signal. Is there a way?

I am not sure the tuner is working correctly or not. Last few lines in the 
logs before the actual scan start are the following:

kernel: [22630.244052] xc2028 1-0061: Loading firmware for type=BASE F8MHZ 
(3), id 0000000000000000.
[22705.056058] xc2028 1-0061: Loading firmware for type=(0), id 
0000000000000007.
kernel: [22706.316042] xc2028 1-0061: Loading SCODE for type=MONO SCODE 
HAS_IF_5320 (60008000), id 0000000000000007

And lots of following messages in dmesg:

[24529.394089] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[24529.399854] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[24529.405641] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)

Any ideas?

Thanks,
Vivek.


On Thursday 24 February 2011 15:49:37 you wrote:
> On Thursday 24 February 2011 04:08:48 Mauro Carvalho Chehab wrote:
> > Although I know that some Hauppauge devices are supported by tm6010, I'm
> > not sure if someone added the tm6010 USB ID's for The model you have to
> > the tm6000 driver.
> 
> Some good news! I compiled the latest kernel (as available in debian repo)
> which had tm6000 in the staging directory. And now my card is being
> detected. I was expecting the module would be auto-detected but it wasn't.
> I had to modprobe it. No complaints though :) I have not yet connected the
> card to the cable, so can't comment on the quality of the video capture. I
> will do that and comment in couple of days time.
> 
> Thanks Devin/Mauro!!
> 
> If anyone is interested in testing the card, I would be more than willing
> to do that.
> 
> Here's the output from the logs:
> 
> Feb 25 02:06:31 kaddappa kernel: [  330.788092] usb 5-7: new high speed USB
> device using ehci_hcd and address 8
> Feb 25 02:06:31 kaddappa kernel: [  330.926110] usb 5-7: New USB device
> found, idVendor=2040, idProduct=6610
> Feb 25 02:06:31 kaddappa kernel: [  330.926118] usb 5-7: New USB device
> strings: Mfr=16, Product=32, SerialNumber=64
> Feb 25 02:06:31 kaddappa kernel: [  330.926123] usb 5-7: Product: WTV910
> Feb 25 02:06:31 kaddappa kernel: [  330.926127] usb 5-7: SerialNumber:
> 12502365
> Feb 25 02:07:06 kaddappa kernel: [  365.641255] Linux video capture
> interface: v2.00
> Feb 25 02:07:06 kaddappa kernel: [  365.692765] IR NEC protocol handler
> initialized
> Feb 25 02:07:06 kaddappa kernel: [  365.704001] IR RC5(x) protocol handler
> initialized
> Feb 25 02:07:06 kaddappa kernel: [  365.719226] tm6000: module is from the
> staging directory, the quality is unknown, you have been warned.
> Feb 25 02:07:06 kaddappa kernel: [  365.724790] tm6000 v4l2 driver version
> 0.0.2 loaded
> Feb 25 02:07:06 kaddappa kernel: [  365.725827] tm6000: alt 0, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725830] tm6000: alt 0, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725832] tm6000: Bulk IN endpoint:
> 0x82 (max size=512 bytes)
> Feb 25 02:07:06 kaddappa kernel: [  365.725835] tm6000: alt 0, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725837] tm6000: alt 1, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725840] tm6000: ISOC IN endpoint:
> 0x81 (max size=3072 bytes)
> Feb 25 02:07:06 kaddappa kernel: [  365.725842] tm6000: alt 1, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725844] tm6000: alt 1, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725847] tm6000: INT IN endpoint:
> 0x83 (max size=4 bytes)
> Feb 25 02:07:06 kaddappa kernel: [  365.725849] tm6000: alt 2, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725851] tm6000: alt 2, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725854] tm6000: alt 2, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725856] tm6000: alt 3, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725858] tm6000: alt 3, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725860] tm6000: alt 3, interface 0,
> class 255
> Feb 25 02:07:06 kaddappa kernel: [  365.725863] tm6000: New video device @
> 480 Mbps (2040:6610, ifnum 0)
> Feb 25 02:07:06 kaddappa kernel: [  365.725865] tm6000: Found Hauppauge
> WinTV HVR-900H / WinTV USB2-Stick
> Feb 25 02:07:06 kaddappa kernel: [  365.734061] IR RC6 protocol handler
> initialized
> Feb 25 02:07:06 kaddappa kernel: [  365.736042] Found tm6010
> Feb 25 02:07:06 kaddappa kernel: [  365.739714] IR JVC protocol handler
> initialized
> Feb 25 02:07:06 kaddappa kernel: [  365.746152] IR Sony protocol handler
> initialized
> Feb 25 02:07:06 kaddappa kernel: [  365.753539] lirc_dev: IR Remote Control
> driver registered, major 249
> Feb 25 02:07:06 kaddappa kernel: [  365.755547] IR LIRC bridge handler
> initialized
> Feb 25 02:07:07 kaddappa kernel: [  367.120060] tm6000 #0: i2c eeprom 00:
> 01 59 54 45 12 01 00 02 00 00 00 40 40 20 10 66  .YTE.......@@ .f
> Feb 25 02:07:07 kaddappa kernel: [  367.312039] tm6000 #0: i2c eeprom 10:
> 6f 00 10 20 40 01 02 03 41 00 6e 00 61 00 6c 00  o.. @...A.n.a.l.
> Feb 25 02:07:08 kaddappa kernel: [  367.504081] tm6000 #0: i2c eeprom 20:
> ff 00 67 ff ff ff ff ff ff ff ff ff ff ff ff ff  ..g.............
> Feb 25 02:07:08 kaddappa kernel: [  367.700080] tm6000 #0: i2c eeprom 30:
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> Feb 25 02:07:08 kaddappa kernel: [  367.892053] tm6000 #0: i2c eeprom 40:
> 10 03 57 00 54 00 56 00 39 00 31 00 30 00 20 00  ..W.T.V.9.1.0. .
> Feb 25 02:07:08 kaddappa kernel: [  368.084065] tm6000 #0: i2c eeprom 50:
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> Feb 25 02:07:08 kaddappa kernel: [  368.280734] tm6000 #0: i2c eeprom 60:
> 30 ff ff ff 0f ff ff ff ff ff 0a 03 32 00 2e 00  0...........2...
> Feb 25 02:07:09 kaddappa kernel: [  368.472101] tm6000 #0: i2c eeprom 70:
> 3f 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ?...............
> Feb 25 02:07:09 kaddappa kernel: [  368.664100] tm6000 #0: i2c eeprom 80:
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> Feb 25 02:07:09 kaddappa kernel: [  368.856107] tm6000 #0: i2c eeprom 90:
> 38 ff ff ff 12 03 31 00 32 00 35 00 30 00 32 00  8.....1.2.5.0.2.
> Feb 25 02:07:09 kaddappa kernel: [  369.049162] tm6000 #0: i2c eeprom a0:
> 33 00 36 00 35 00 00 00 00 00 ff ff ff ff ff ff  3.6.5...........
> Feb 25 02:07:09 kaddappa kernel: [  369.240116] tm6000 #0: i2c eeprom b0:
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> Feb 25 02:07:10 kaddappa kernel: [  369.432109] tm6000 #0: i2c eeprom c0:
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> Feb 25 02:07:10 kaddappa kernel: [  369.628052] tm6000 #0: i2c eeprom d0:
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> Feb 25 02:07:10 kaddappa kernel: [  369.820080] tm6000 #0: i2c eeprom e0:
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> Feb 25 02:07:10 kaddappa kernel: [  370.012071] tm6000 #0: i2c eeprom f0:
> ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> Feb 25 02:07:10 kaddappa kernel: [  370.192164]   ................
> Feb 25 02:07:10 kaddappa kernel: [  370.220816] i2c-core: driver [tuner]
> using legacy suspend method
> Feb 25 02:07:10 kaddappa kernel: [  370.220819] i2c-core: driver [tuner]
> using legacy resume method
> Feb 25 02:07:10 kaddappa kernel: [  370.220981] tuner 1-0061: chip found @
> 0xc2 (tm6000 #0)
> Feb 25 02:07:10 kaddappa kernel: [  370.280955] xc2028 1-0061: creating new
> instance
> Feb 25 02:07:10 kaddappa kernel: [  370.280959] xc2028 1-0061: type set to
> XCeive xc2028/xc3028 tuner
> Feb 25 02:07:10 kaddappa kernel: [  370.280962] Setting firmware parameters
> for xc2028
> Feb 25 02:07:10 kaddappa kernel: [  370.345220] tm6000 #0: registered
> device video0
> Feb 25 02:07:10 kaddappa kernel: [  370.345223] Trident TVMaster
> TM5600/TM6000/TM6010 USB2 board (Load status: 0)
> Feb 25 02:07:10 kaddappa kernel: [  370.345244] usbcore: registered new
> interface driver tm6000
> Feb 25 02:07:10 kaddappa kernel: [  370.347237] tm6000: open called
> (dev=video0)
> Feb 25 02:07:12 kaddappa kernel: [  371.939121] tm6000: open called
> (dev=video0)
