Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60484 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab2EKTyR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 15:54:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SSvuq-0007GF-8p
	for linux-media@vger.kernel.org; Fri, 11 May 2012 21:54:16 +0200
Received: from 89-69-21-174.dynamic.chello.pl ([89.69.21.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 21:54:16 +0200
Received: from arekm by 89-69-21-174.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 21:54:16 +0200
To: linux-media@vger.kernel.org
From: Arkadiusz =?ISO-8859-2?Q?Mi=B6kiewicz?= <arekm@maven.pl>
Subject: Re: IT9135 on kernel 3.3.4 and frequent firmware loading problems
Date: Fri, 11 May 2012 21:54:06 +0200
Message-ID: <jojqou$sj2$1@dough.gmane.org>
References: <jojps1$mei$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 8Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arkadiusz Mi¶kiewicz wrote:

> 
> Hello.
> 
> I'm trying to use it9135 v1 device on 3.3.4 kernel.
> 
> Unfortunately most of the time there are problems with loading firmware
> (udev 182).
> 
> Firmware file is there:
> -rw-r--r-- 1 root root 8128 05-03 21:31 /lib/firmware/dvb-usb-it9135-01.fw
> 
> In most cases dmesg log below shows what happens. Sometimes udev also
> logs:
> 
> May 11 21:33:23 serarm udevd[13078]: error: can not open
> '/sys/devices/pci0000:00/0000:00:13.2/usb2/2-1/firmware/2-1/loading'
> 
> Rarely it succeeds. Both logs below. Any ideas/patches to test?

Just figured out that after reloading dvb_usb_it913x and it913x_fe things 
started to work! Not sure if reloading both drivers was required - I 
reloaded both and noticed.

[691819.504534] usb 2-1: USB disconnect, device number 9
[691819.730964] usb 2-1: new high-speed USB device number 10 using ehci_hcd
[691819.862773] usb 2-1: New USB device found, idVendor=048d, idProduct=9005
[691819.862788] usb 2-1: New USB device strings: Mfr=1, Product=0, 
SerialNumber=3
[691819.862797] usb 2-1: Manufacturer: ITE Technologies, Inc.
[691819.862804] usb 2-1: SerialNumber: AF0102020700001
[691819.866632] it913x: Chip Version=01 Chip Type=9135
[691819.874190] it913x: Dual mode=0 Remote=5 Tuner Type=0
[691819.875804] dvb-usb: found a 'ITE 9135(9005) Generic' in cold state, 
will try to load a firmware
[691880.304615] dvb-usb: did not find the firmware file. (dvb-usb-
it9135-01.fw) Please see linux/Documentation/dvb/ for more details on 
firmware-problems. (-2)
[691880.304623] it913x: DEV it913x Error
[692002.417084] usbcore: deregistering interface driver it913x
[692014.227789] it913x: Chip Version=00 Chip Type=0000
[692014.229766] it913x: Dual mode=0 Remote=5 Tuner Type=0
[692014.230972] dvb-usb: found a 'ITE 9135(9005) Generic' in cold state, 
will try to load a firmware
[692014.250426] dvb-usb: downloading firmware from file 'dvb-usb-
it9135-01.fw'
[692014.252269] it913x: FRM Starting Firmware Download
[692014.784323] it913x: FRM Firmware Download Completed - Resetting Device
[692014.784985] it913x: Chip Version=01 Chip Type=9135
[692014.785484] it913x: Firmware Version 204869120
[692014.819723] dvb-usb: found a 'ITE 9135(9005) Generic' in warm state.
[692014.819854] dvb-usb: will use the device's hardware PID filter (table 
count: 31).
[692014.820254] DVB: registering new adapter (ITE 9135(9005) Generic)
[692014.825878] it913x-fe: ADF table value      :00
[692014.830000] it913x-fe: Crystal Frequency :12000000 Adc Frequency 
:20250000 ADC X2: 01
[692014.879249] it913x-fe: Tuner LNA type :38
[692014.938472] DVB: registering adapter 0 frontend 0 (ITE 9135(9005) 
Generic_1)...
[692014.938968] Registered IR keymap rc-msi-digivox-iii
[692014.939210] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:13.2/usb2/2-1/rc/rc2/input14
[692014.941686] rc2: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:13.2/usb2/2-1/rc/rc2
[692014.941702] dvb-usb: schedule remote query interval to 250 msecs.
[692014.941714] dvb-usb: ITE 9135(9005) Generic successfully initialized and 
connected.
[692014.941721] it913x: DEV registering device driver
[692014.941814] usbcore: registered new interface driver it913x

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

