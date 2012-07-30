Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445Ab2G3QNY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 12:13:24 -0400
Message-ID: <5016B29F.4080605@redhat.com>
Date: Mon, 30 Jul 2012 13:13:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: set default protocol for  TerraTec Cinergy XXS  to "nec"
References: <50047814.20701@gmx.de>
In-Reply-To: <50047814.20701@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-07-2012 17:22, Toralf Förster escreveu:
> For a TerraTec Cinergy XXS USB stick (Bus 001 Device 008: ID 0ccd:00ab TerraTec Electronic GmbH )
> I've to switch the protocol every time after plugin to get (at least few) keys working :
> 
> $> sudo ir-keytable --protocol=nec --sysdev=`ir-keytable 2>&1 | head -n 1 | cut -f5 -d'/'`
> 
> /me wonders whether "nec" should be set as the default for this key in kernel or not

It makes sense to patch it to use the nec protocol. If not all keys are working, it also makes
sense to fix the kernel table to handle all codes, or to point to a new table where all
Terratec keys are defined.

Could you please write such patch?

Thank you!
Mauro

> 
> 
>  From the syslog :
> 2012-07-16T22:12:53.357+02:00 n22 kernel: usb 1-1: new high-speed USB device number 7 using ehci_hcd
> 2012-07-16T22:12:53.460+02:00 n22 kernel: ehci_hcd 0000:00:1a.7: dma_pool_free ehci_qh, f60cd4e0/fffff4e0 (bad dma)
> 2012-07-16T22:12:53.471+02:00 n22 kernel: usb 1-1: New USB device found, idVendor=0ccd, idProduct=00ab
> 2012-07-16T22:12:53.471+02:00 n22 kernel: usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> 2012-07-16T22:12:53.471+02:00 n22 kernel: usb 1-1: Product: Cinergy T XXS
> 2012-07-16T22:12:53.471+02:00 n22 kernel: usb 1-1: Manufacturer: TerraTec GmbH
> 2012-07-16T22:12:53.471+02:00 n22 kernel: usb 1-1: SerialNumber: 0000000001
> 2012-07-16T22:12:53.639+02:00 n22 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in cold state, will try to load a firmware
> 2012-07-16T22:12:53.650+02:00 n22 kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
> 2012-07-16T22:12:53.854+02:00 n22 kernel: dib0700: firmware started successfully.
> 2012-07-16T22:12:54.355+02:00 n22 kernel: dvb-usb: found a 'Terratec Cinergy T USB XXS (HD)/ T3' in warm state.
> 2012-07-16T22:12:54.355+02:00 n22 kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> 2012-07-16T22:12:54.355+02:00 n22 kernel: DVB: registering new adapter (Terratec Cinergy T USB XXS (HD)/ T3)
> 2012-07-16T22:12:54.560+02:00 n22 kernel: DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> 2012-07-16T22:12:54.763+02:00 n22 kernel: DiB0070: successfully identified
> 2012-07-16T22:12:54.801+02:00 n22 kernel: Registered IR keymap rc-dib0700-rc5
> 2012-07-16T22:12:54.801+02:00 n22 kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/rc/rc0/input15
> 2012-07-16T22:12:54.801+02:00 n22 kernel: rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/rc/rc0
> 2012-07-16T22:12:54.801+02:00 n22 kernel: dvb-usb: schedule remote query interval to 50 msecs.
> 2012-07-16T22:12:54.801+02:00 n22 kernel: dvb-usb: Terratec Cinergy T USB XXS (HD)/ T3 successfully initialized and connected.
> 2012-07-16T22:12:54.801+02:00 n22 kernel: usbcore: registered new interface driver dvb_usb_dib0700
> 2012-07-16T22:12:55.000+02:00 n22 sudo: tfoerste : TTY=pts/2 ; PWD=/home/tfoerste/tmp ; USER=root ; COMMAND=/usr/bin/ir-keytable --protocol=nec --sysdev=rc0
> 

