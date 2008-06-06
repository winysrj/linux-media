Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.movial.fi ([62.236.91.34])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dennis.noordsij@movial.fi>) id 1K4Y8R-00082Y-RW
	for linux-dvb@linuxtv.org; Fri, 06 Jun 2008 11:21:26 +0200
Message-ID: <4849016A.8050607@movial.fi>
Date: Fri, 06 Jun 2008 11:20:42 +0200
From: Dennis Noordsij <dennis.noordsij@movial.fi>
MIME-Version: 1.0
To: Nicolas Christener <lists@0x17.ch>
References: <1212736555.4264.12.camel@oipunk.loozer.local>
In-Reply-To: <1212736555.4264.12.camel@oipunk.loozer.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy Piranha
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

Nicolas Christener schreef:
> Hello
> according to [1] i should contact this list, because I own a currently
> unsupported DVB-T USB device and want to support development :)
> The device I got is labeled 'Terratec Cinergy Piranha'.
> 
> output of `dmesg':
> kernel: hub 5-0:1.0: unable to enumerate USB device on port 5
> kernel: usb 3-1: new full speed USB device using uhci_hcd and address 6
> kernel: usb 3-1: configuration #1 chosen from 1 choice
> kernel: usb 3-1: New USB device found, idVendor=187f, idProduct=0010
> kernel: usb 3-1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> kernel: usb 3-1: Product: SMS 1000
> kernel: usb 3-1: Manufacturer: Siano
> 
> Although I can probably not help to write code for this device I'd be
> happy, if I could help in any other way to get this device supported by
> linux.
> 
> [1] http://linuxtv.org/wiki/index.php/DVB-T_USB_Devices
> 
> kind regards
> Nicolas

Hi Nicolas,

You're in luck :-) That device works very well.

The driver is not in the official tree (yet) so if you would like to use
it you will need to compile it yourself, there are some instructions on
linuxtv.org, and use the following tree:

http://linuxtv.org/hg/~mkrufky/siano

You will also need to take the firmware file "SMS100x_Dvbt.inp" (from
the installation CD or windows, or download the drivers from
terratec.net) and copy it to your \lib\firmware or \lib\firmware\`uname
-r` as "dvbt_stellar_usb.inp".

I hope those instructions make sense :-)

Dennis

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
