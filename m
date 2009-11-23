Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:56617 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815AbZKWLKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 06:10:24 -0500
Received: from smtpauth.cluster.uni-frankfurt.de ([10.2.22.4] helo=smtpauth2.rz.uni-frankfurt.de)
	by mailout.rz.uni-frankfurt.de with esmtp (Exim 4.69)
	(envelope-from <mbachman@stud.uni-frankfurt.de>)
	id 1NCWoQ-0005Jn-1C
	for linux-media@vger.kernel.org; Mon, 23 Nov 2009 12:10:30 +0100
Received: from p4fdd5c16.dip.t-dialin.net ([79.221.92.22] helo=duron.grafnetz)
	by smtpauth2.rz.uni-frankfurt.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <mbachman@stud.uni-frankfurt.de>)
	id 1NCWnX-0001tE-7r
	for linux-media@vger.kernel.org; Mon, 23 Nov 2009 12:09:40 +0100
Received: from x2.grafnetz ([192.168.0.4])
	by duron.grafnetz with esmtps (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <mbachman@stud.uni-frankfurt.de>)
	id 1NCWnN-0001nW-SZ
	for linux-media@vger.kernel.org; Mon, 23 Nov 2009 12:09:34 +0100
Date: Mon, 23 Nov 2009 12:03:10 +0100
From: Mario Bachmann <mbachman@stud.uni-frankfurt.de> (by way of Mario
	Bachmann <mbachman@stud.uni-frankfurt.de>)
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <20091123120310.5b10c9cc@x2.grafnetz>
In-Reply-To: <alpine.LRH.2.00.0911230947540.14263@pub1.ifh.de>
References: <20091107105614.7a51f2f5@x2.grafnetz>
 <alpine.LRH.2.00.0911191630250.12734@pub2.ifh.de>
 <20091121182514.61b39d23@x2.grafnetz>
 <alpine.LRH.2.00.0911230947540.14263@pub1.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: dibusb-common.c FE_HAS_LOCK problem
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 23 Nov 2009 10:01:36 +0100 (CET)
schrieb Patrick Boettcher <pboettcher@kernellabs.com>:

> Hi Mario,
> 
> On Sat, 21 Nov 2009, grafgrimm77@gmx.de wrote:
> 
> > Am Thu, 19 Nov 2009 16:37:18 +0100 (CET)
> > schrieb Patrick Boettcher <pboettcher@kernellabs.com>:
> >
> >> On Sat, 7 Nov 2009, Mario Bachmann wrote:
> >>
> >>> Hi there,
> >>>
> >>> I tried linux-2.6.31.5 and tuning still does not work:
> >>> tuning to 738000000 Hz
> >>> video pid 0x0131, audio pid 0x0132
> >>> status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> >>> status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> >>> status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> >>> status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> >>>
> >>> With some changes for the following file it works again:
> >>> /usr/src/linux/drivers/media/dvb/dvb-usb/dibusb-common.c
> >>>
> >>> diff -Naur dibusb-common.c-ORIGINAL dibusb-common.c
> >>>
> >>> --- dibusb-common.c-ORIGINAL	2009-11-07 10:30:43.705344308 +0100
> >>> +++ dibusb-common.c	2009-11-07 10:33:49.969345253 +0100
> >>> @@ -133,17 +133,14 @@
> >>>
> >>> 	for (i = 0; i < num; i++) {
> >>> 		/* write/read request */
> >>> -		if (i+1 < num && (msg[i].flags & I2C_M_RD) == 0
> >>> -					  && (msg[i+1].flags & I2C_M_RD)) {
> >>> +		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
> >>> 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,
> >>> 						msg[i+1].buf,msg[i+1].len) < 0)
> >>> 				break;
> >>> 			i++;
> >>> -		} else if ((msg[i].flags & I2C_M_RD) == 0) {
> >>> +		} else
> >>> 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
> >>> 				break;
> >>> -		} else
> >>> -			break;
> >>> 	}
> >>
> >> Doing it is reverting a fix which avoids that uncontrolled i2c-access from
> >> userspace is destroying the USB-eeprom.
> >>
> >> I understand that this is breaking the tuning for your board. I'm just not
> >> understanding why.
> >>
> >> If you have some time to debug this issue, could you please try the
> >> following:
> >>
> >> One of the devices for your board is trying to do an I2c access which is
> >> falling into the last 'else'-branch - can you add a printk to find out
> >> which one it is? The access must be wrongly constructed and must be fixed
> >> in that driver.
> >>
> >> thanks,
> >>
> >> PS: if you don't have time to do it, please tell so.
> >>
> >> --
> >>
> >> Patrick
> >> http://www.kernellabs.com/
> >
> > I do not understand exactly. printk what? Could you please give me a
> > complete piece of code with the printk command? Would be great!
> >
> > My printk-tries ends up in an "Oops".
> 
> There is a
>  	} else
>  		break;
> 
> sequence in dibusb_i2c_xfer
> 
> instead of break, please add something like
> 
> printk(KERN_ERR "----- hello stupid I2C access ----\n");
> 
> recompile and load the new module, then check whether the line is 
> appearing in /var/log/messages or /var/log/syslog when you tune the board.
> 
> If this is the case, try to identify which device is issuing the access by 
> printing the i2c-address of struct i2c_msg.
> 
> HTH,
> --
> 
> Patrick
> http://www.kernellabs.com/

Hello Patrick, 

I tried it with Kernel 2.6.31.6 (same as before). 

I made the printk-change, recompiled and reloaded the modules and pluged in my Twinhan Magic Box...
It definately jumps in the last else-branch and shows "hello stupid I2C access", but no KERN_ERR ?!

dmesg
usb 4-2: new full speed USB device using ohci_hcd and address 4
usb 4-2: configuration #1 chosen from 1 choice
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device' in cold state, will try to load a firmware
usb 4-2: firmware: requesting dvb-usb-dibusb-5.0.0.11.fw
dvb-usb: downloading firmware from file 'dvb-usb-dibusb-5.0.0.11.fw'
usbcore: registered new interface driver dvb_usb_dibusb_mb
usb 4-2: USB disconnect, address 4
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 4-2: new full speed USB device using ohci_hcd and address 5
usb 4-2: configuration #1 chosen from 1 choice
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device' in warm state.
dvb-usb: will use the device's hardware PID filter (table count: 16).
DVB: registering new adapter (TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device)
DVB: registering adapter 0 frontend 0 (DiBcom 3000M-B DVB-T)...
dibusb: This device has the Thomson Cable onboard. Which is default.
----- hello stupid I2C access ----
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:04.0/usb4/4-2/input/input5
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device successfully initialized and connected.

tail -30 /var/log/messages
Nov 23 11:49:46 x2 kernel: usb 4-2: new full speed USB device using ohci_hcd and address 4
Nov 23 11:49:46 x2 kernel: usb 4-2: configuration #1 chosen from 1 choice
Nov 23 11:49:46 x2 kernel: dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device' in cold state, will try to load a firmware
Nov 23 11:49:46 x2 kernel: usb 4-2: firmware: requesting dvb-usb-dibusb-5.0.0.11.fw
Nov 23 11:49:46 x2 kernel: dvb-usb: downloading firmware from file 'dvb-usb-dibusb-5.0.0.11.fw'
Nov 23 11:49:48 x2 kernel: usbcore: registered new interface driver dvb_usb_dibusb_mb
Nov 23 11:49:48 x2 kernel: usb 4-2: USB disconnect, address 4
Nov 23 11:49:48 x2 kernel: dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
Nov 23 11:49:50 x2 kernel: usb 4-2: new full speed USB device using ohci_hcd and address 5
Nov 23 11:49:50 x2 kernel: usb 4-2: configuration #1 chosen from 1 choice
Nov 23 11:49:50 x2 kernel: dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device' in warm state.
Nov 23 11:49:50 x2 kernel: dvb-usb: will use the device's hardware PID filter (table count: 16).
Nov 23 11:49:50 x2 kernel: DVB: registering new adapter (TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device)
Nov 23 11:49:50 x2 kernel: DVB: registering adapter 0 frontend 0 (DiBcom 3000M-B DVB-T)...
Nov 23 11:49:50 x2 kernel: dibusb: This device has the Thomson Cable onboard. Which is default.
Nov 23 11:49:50 x2 kernel: ----- hello stupid I2C access ----
Nov 23 11:49:50 x2 kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:04.0/usb4/4-2/input/input5
Nov 23 11:49:50 x2 kernel: dvb-usb: schedule remote query interval to 150 msecs.
Nov 23 11:49:50 x2 kernel: dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device successfully initialized and connected.

Hey, without the break-command, tuning seems to work:
$ tzap pro7 -r
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/grafrotz/.tzap/channels.conf'
tuning to 738000000 Hz
video pid 0x0131, audio pid 0x0132
status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff | 
status 1f | signal 0b20 | snr 008d | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
status 1f | signal f4dd | snr 0077 | ber 00000770 | unc 00000000 | FE_HAS_LOCK
status 1f | signal ffff | snr 008c | ber 00000770 | unc 00000000 | FE_HAS_LOCK

Greetings
Mario
