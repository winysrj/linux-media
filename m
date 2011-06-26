Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <eddie@lania.nl>) id 1Qalvj-0005X6-JM
	for linux-dvb@linuxtv.org; Sun, 26 Jun 2011 11:47:03 +0200
Received: from edla.lania.nl ([84.245.4.170])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-1) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1Qalvj-000728-JR; Sun, 26 Jun 2011 11:47:03 +0200
Received: from apollo.lania-intra.net (apollo.lania-intra.net [192.168.169.2])
	by edla.lania.nl (8.14.4/8.14.4) with ESMTP id p5Q9kvAx002076
	for <linux-dvb@linuxtv.org>; Sun, 26 Jun 2011 11:46:58 +0200
From: Eddie Lania <eddie@lania.nl>
To: "E.John Brown" <eddie500@bigpond.com>
Date: Sun, 26 Jun 2011 11:46:57 +0200
In-Reply-To: <4E06F037.1050509@bigpond.com>
References: <4E06F037.1050509@bigpond.com>
Message-ID: <1309081617.1912.11.camel@e2800fedora.lania-intra.net>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Elgato eyetb usb tv tuner
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hi John,

dmesg does not show anything useful. That's because the device is not
supported yet.

lsusb only shows there is a device with ID 0df9:0018
>From what i found on the internet, the device's specs are:
Model: EU 2008
USB Controller: Empia EM2884
Stereo A/V Decoder: Micronas AVF 49x08
Hybrid Channel Decoder: Micronas DRX-K DRX3926K:A1 0.9.0

I spoke to a few people on the IRC linuxtv channel @freenode and it
appears to be a 2884/drxk/avfb combo.
Micronas has allowed a GPL driver to be released.  But nobody has been
willing to do the work to get it upstream.
It still needs a couple dozen hours worth of work to get up and running,
and deal with all the codingstyle issues, etc.

I hope that someone is willing to do this somewhere in the nearby
future.

It's a great device; it can do dvb-c and dvb-t but also has an analogue
tuner for tv and radio, and it can capture video/audio from
composite/s-video connected devices as well.

I'd love to see this device working in Linux in the future.

Regards,

Eddie.


On Sun, 2011-06-26 at 16:39 +0800, E.John Brown wrote:
> Dear Eddie,
>                    Have you tried running dmesg in a terminal it will 
> give you a list of what hardware is running in the kernel and if it has 
> a driver and or firmware.
>                    See my output sample.
>      7.646537] ivtv: Start initialization, version 1.4.2
> [    7.646634] ivtv0: Initializing card 0
> [    7.646636] ivtv0: Autodetected Hauppauge card (cx23416 based)
> [    7.646693] ivtv 0000:01:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> [    7.647485] ivtv i2c driver #0: Test OK
> [    7.702997] tveeprom 0-0050: Hauppauge model 25019, rev C589, serial# 
> 10495999
> [    7.702999] tveeprom 0-0050: tuner model is TCL MFPE05 2 (idx 89, 
> type 38)
> [    7.703014] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') 
> PAL(D/D1/K) (eeprom
> This is a Hauppauge card
> Notice that the output tells you the driver details (ivtv i2c driver #0 
> Test OK)
> 
> Another command is lsusb will show usb devices connected
> Check if your tuner needs firmware and that its in the right place ie 
> /libs/firmware


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
