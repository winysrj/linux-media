Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout02.t-online.de ([194.25.134.17])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Ralf.Goos@t-online.de>) id 1KrIv7-00037Y-Sm
	for linux-dvb@linuxtv.org; Sat, 18 Oct 2008 23:01:11 +0200
From: Ralf Goos <Ralf.Goos@t-online.de>
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Date: Sat, 18 Oct 2008 23:00:52 +0200
References: <200809302001.24424.Ralf.Goos@t-online.de>
	<48EA8AB2.20201@hoogenraad.net>
In-Reply-To: <48EA8AB2.20201@hoogenraad.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810182300.53206.Ralf.Goos@t-online.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] auvisio DVB-T USB2.0 Pen Receiver "WhiteStar" and
	SUSE 10.3
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hallo Jan,

sorry for my late answer.

Here output of lsusb:
Bus 004 Device 001: ID 0000:0000  
Bus 001 Device 001: ID 0000:0000  
Bus 003 Device 001: ID 0000:0000  
Bus 002 Device 007: ID 15a4:9016  
Bus 002 Device 006: ID 03f0:0211 Hewlett-Packard 
Bus 002 Device 005: ID 045e:0039 Microsoft Corp. IntelliMouse Optical
Bus 002 Device 004: ID 2018:0402  
Bus 002 Device 003: ID 5986:0102  
Bus 002 Device 002: ID 05e3:0608 Genesys Logic, Inc. 
Bus 002 Device 001: ID 0000:0000  

and here part of lsusb -v:
Bus 002 Device 007: ID 15a4:9016  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x15a4 
  idProduct          0x9016 
  bcdDevice            2.00
  iManufacturer           1 Afatech
  iProduct                2 DVB-T
  iSerial                 0 
  bNumConfigurations      1

and part of dmesg:
usb 2-2: new high speed USB device using ehci_hcd and address 7
usb 2-2: new device found, idVendor=15a4, idProduct=9016
usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: DVB-T
usb 2-2: Manufacturer: Afatech
usb 2-2: configuration #1 chosen from 1 choice
input: Afatech DVB-T as /class/input/input9
input: USB HID v1.01 Keyboard [Afatech DVB-T] on usb-0000:00:02.1-2
ISO 9660 Extensions: Microsoft Joliet Level 3
ISOFS: changing to secondary root

This  auvisio DVB-T USB2.0 Pen Receiver "WhiteStar"seems to bee an AfaTech USB 
device.

I looked under windows "System" and found: 
AfaTech, AF9015 BDA Filter

On the original DVD is just an autorun.inf which starts setup.exe.



Ralf Goos

Am Dienstag, 7. Oktober 2008 00:01:22 schrieben Sie:
> Please post output of
> 	lsusb
> and
> 	lsusb -v
>
> Ralf Goos wrote:
> > Hi all,
> >
> > I bought an auvisio DVB-T USB2.0 Pen Receiver "WhiteStar" from Pearl.
> >
> > At my daughters Desktop PC with Windows XP it works fine with the
> > delivered Software "TV JUKEBOX Version 3.0".
> >
> > Now I try to get it at work at my system:
> >
> > Acer Aspire 7520G Laptop (AMD Turion 64 X2 TL56)
> > with 17" WXGA+  LCD and NVIDIA GeForce 8400M G witth 256MB VRAM
> > SUSE Linux 10.3 Kernel 2.6.22.18-0.2-default i686
> > KDE 3.5.9 "release 57.3"
> >
> > Several video software is running (xine, VLC media player, Kaffeine), so
> > I'm able to look some videos.
> >
> > I didn't find any information or diskussion about auvisio DVB-T USB2.0
> > Pen Receiver.
> >
> > Is their any chance to get it at work?
> >
> > If yes, what do I have to do?
> >
> > Thanks for help.
> >
> > Ralf Goos
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
