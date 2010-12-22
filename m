Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:60444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0LVRK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 12:10:27 -0500
Message-ID: <4D1230E6.9030804@infradead.org>
Date: Wed, 22 Dec 2010 15:09:58 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: daniele <daniel.pirani@libero.it>
CC: cavedon@sssup.it,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saschasommer@freenet.de
Subject: Re: pinnaclePCTVusb2
References: <1293021683.3229.6.camel@ubuntu>
In-Reply-To: <1293021683.3229.6.camel@ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Danielle,

Em 22-12-2010 10:41, daniele escreveu:
> lsusb
> Bus 002 Device 002: ID eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV
> Stick
> 
> Linux ubuntu 2.6.35-24-generic #42-Ubuntu SMP Thu Dec 2 02:41:37 UTC
> 2010 x86_64 GNU/Linux
> 
> I'm sorry to disturb, but it's an year I can resolve this question...
> My pinnacle pctv usb2 dvb-t was working very well with linux once, now i
> can't make it scans channels... it finds only five type of
> channels(RETECAPRI and similar cause I'm in italy).
> i'm using these modules
> http://jiemeb.free.fr/pinnacle/
> 
> ANY HELP appreciated.

Please post such questions to linux-media@vger.kernel.org.

> 
> dmesg
>  9.974305] em28xx v4l2 driver version 0.0.1 loaded

Hmm... this is not the latest driver. Probably, you're using an old, discontinued
fork of the driver. Please test your stick with the latest kernel.

> [    9.974544] em28xx: new video device (eb1a:2870): interface 0, class
> 255
> [    9.974547] em28xx: device is attached to a USB 2.0 bus
> [    9.974550] em28xx #0: Alternate settings: 8
> [    9.974553] em28xx #0: Alternate setting 0, max size= 0
> [    9.974555] em28xx #0: Alternate setting 1, max size= 0
> [    9.974557] em28xx #0: Alternate setting 2, max size= 1448
> [    9.974560] em28xx #0: Alternate setting 3, max size= 2048
> [    9.974562] em28xx #0: Alternate setting 4, max size= 2304
> [    9.974565] em28xx #0: Alternate setting 5, max size= 2580
> [    9.974568] em28xx #0: Alternate setting 6, max size= 2892
> [    9.974570] em28xx #0: Alternate setting 7, max size= 3072
> [   10.392961] input: em2880/em2870 remote control
> as /devices/virtual/input/input9
> [   10.393061] em28xx-input.c: remote control handler attached
> [   10.393065] em28xx #0: Found Pinnacle PCTV DVB-T
> [   10.393116] usbcore: registered new interface driver em28xx
> [   10.489638] em2880-dvb.c: DVB Init
> [   11.574050] DVB: registering new adapter (em2880 DVB-T)
> 
Cheers,
Mauro
