Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:35978 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaGSA2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 20:28:03 -0400
Received: by mail-vc0-f170.google.com with SMTP id lf12so8693478vcb.15
        for <linux-media@vger.kernel.org>; Fri, 18 Jul 2014 17:28:01 -0700 (PDT)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Siano Rio problems (idVendor=187f, idProduct=0600)
From: Roberto Alcantara <roberto@eletronica.org>
In-Reply-To: <20140716141410.53d5fa5d@geo053104.klientdrift.uib.no>
Date: Fri, 18 Jul 2014 21:27:56 -0300
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <27ABA78A-FCBA-4DA3-B001-55026BE467DF@eletronica.org>
References: <20140716141410.53d5fa5d@geo053104.klientdrift.uib.no>
To: Johannes Werner <johannes.werner@physik.tu-darmstadt.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Johannes,

For now Mauro Chehab is the maintainer for Siano tuners. Guys from Siano stops to send patch a long time ago.

I’m using SMS2270 (Siano RIO) with ISDB-T. But your log shows "DVB-T Europe”.

Are you trying to tune ISDB-T Terrestrial stations as your firmware file name suggest?

Try to enable debug inserting these options inside some file in /etc/modprobe.d/

	options smsusb debug=3
	options smsmdtv debug=3 

and be sure your firmware is loaded.

regards,
 - Roberto


Em 16/07/2014, à(s) 09:14, Johannes Werner <johannes.werner@physik.tu-darmstadt.de> escreveu:

> Dear all,
> 
> I hope this is the right place to ask for help / clarification
> (linuxtv.org/ suggests it). I saw that Siano does indeed contribute to
> the media drivers in the kernel (so I hope somebody relevant is reading
> this). I have some questions about the Siano Rio chip that I could not
> answer by asking google...
> 
> First of all, the chip seems to be supported by the kernel (modules
> load), but the firmware isdbt_rio.inp is not distributed by Ubuntu. I
> could find a package at
> http://repo.huayra.conectarigualdad.gob.ar/huayra/pool/non-free/f/firmware-siano-rio/
> and this contains a file with this name. This is the only place I could
> find it on the interwebs.
> Anyway, below is the actual problem (assuming the firmware mentioned
> above is correct). I hope to get some hints on what I could try. I am
> not afraid of building kernels, but haven't done so in a while...
> Should I write a bug report? (where)?
> 
> Thanks in advance,
> Jo
> 
> 
> Description:
> Changes to the siano driver between 3.11 and 3.13 removed TERRESTRIAL
> support for Siano Rio chipset from the driver.
> 
> 
> Report:
> 
> On my Netbook (Ubuntu 14.04, kernel 3.13) inserting the USB stick
> results in
> 
> -- dmesg output --
> [] usb 1-1: new high-speed USB device number 5 using ehci-pci
> [] usb 1-1: New USB device found, idVendor=187f,idProduct=0600 
> [] usb 1-1: New USB device strings: Mfr=1,Product=2, SerialNumber=0
> [] usb 1-1: Product: MDTV Receiver
> [] usb 1-1: Manufacturer: MDTV Receiver
> [] DVB: registering new adapter (Siano Rio Digital Receiver)
> [] usb 1-1: DVB: registering adapter 0 frontend 0 (Siano Mobile Digital
> MDTV Receiver)...
> -- end dmesg --
> 
> and the modules being loaded.
> 
> -- lsmod output
> smsdvb                 18071  0 
> dvb_core              101206  1 smsdvb
> smsusb                 17531  0 
> smsmdtv                48244  2 smsdvb,smsusb
> rc_core                26724  1 smsmdtv
> -- end lsmod --
> 
> This looks promising. When trying to scan for station using w_scan
> however:
> 
> -- w_scan output --
> w_scan version 20130331 (compiled for DVB API 5.10)
> guessing country 'DE', use -c <country> to override
> using settings for GERMANY
> DVB aerial
> DVB-T Europe
> scan type TERRESTRIAL, channellist 4
> output format vdr-2.0
> output charset 'UTF-8', use -C <charset> to override
> Info: using DVB adapter auto detection.
> 	/dev/dvb/adapter0/frontend0 -> "Siano Mobile Digital MDTV
> Receiver" doesnt support TERRESTRIAL -> SEARCH NEXT ONE. main:3228:
> FATAL: ***** NO USEABLE TERRESTRIAL CARD FOUND. ***** Please check
> wether dvb driver is loaded and verify that no dvb application (i.e.
> vdr) is running.
> -- end w_scan --
> 
> even though this is a DVB-T receiver stick. Trying it on another machine
> (where I cannot install the firmware) using Ubuntu 12.04.4, kernel 3.11
> w_scan does indeed scan (but cannot find a signal because the firmware
> is not loaded), see below. REMARK: even when not loading a firmware the
> behaviour above (TERRESTRIAL not supported) persists.
> 
> -- wscan output on other machine --
> w_scan version 20111203 (compiled for DVB API 5.4)
> WARNING: could not guess your country. Falling back to 'DE'
> guessing country 'DE', use -c <country> to override
> using settings for GERMANY
> DVB aerial
> DVB-T Europe
> frontend_type DVB-T, channellist 4
> output format vdr-1.6
> WARNING: could not guess your codepage. Falling back to 'UTF-8'
> output charset 'UTF-8', use -C <charset> to override
> Info: using DVB adapter auto detection.
> 	/dev/dvb/adapter0/frontend0 -> DVB-T "Siano Mobile Digital MDTV
> Receiver": good :-) Using DVB-T frontend
> (adapter /dev/dvb/adapter0/frontend0) -_-_-_-_ Getting frontend
> capabilities-_-_-_-_ Using DVB API 5.a
> frontend 'Siano Mobile Digital MDTV Receiver' supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> FREQ (44.25MHz ... 867.25MHz)
> [...]
> -- end truncated wscan output --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

