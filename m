Return-path: <mchehab@pedra>
Received: from gelbbaer.kn-bremen.de ([78.46.108.116]:43466 "EHLO
	smtp.kn-bremen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab1FDOsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 10:48:39 -0400
From: Juergen Lock <nox@jelal.kn-bremen.de>
Date: Sat, 4 Jun 2011 16:34:09 +0200
To: Steinel Andreas <a.steinel@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Remote control TechnoTrend S2-3650 CI not working
Message-ID: <20110604143409.GA75613@triton8.kn-bremen.de>
References: <6C4E9A3B-EDC2-487B-90F9-734A0C349A4B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6C4E9A3B-EDC2-487B-90F9-734A0C349A4B@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, May 29, 2011 at 02:31:31PM +0200, Steinel Andreas wrote:
> Hi everybody,
> 
> I use the aforementioned USB DVB-S2 box and watching works fine. In the wiki (http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI) is stated (and also some posts on the mailing list suggest) that the remote should work too, yet I unfortunately cannot get it to work.
> 
> I'm running Debian Squeeze (default kernel - 2.6.32-5-amd64) with a recent S2 checkout
> 
> 
> $ hg summary
> parent: 15387:41388e396e0f tip
>  dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked
> Zweig: default
> Übernehme: 1 modifiziert, 2 unbekannt
> Aktualisiere: (aktuell)
> 
> 
> $ hg log | head -4 
> Änderung:        15387:41388e396e0f
> Marke:           tip
> Nutzer:          Igor M. Liplianin <liplianin@me.by>
> Datum:           Mon May 23 00:50:21 2011 +0300
> 
> 
> $ hg diff   
> diff -r 41388e396e0f linux/drivers/media/dvb/dvb-usb/pctv452e.c
> --- a/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Mon May 23 00:50:21 2011 +0300
> +++ b/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun May 29 13:55:34 2011 +0200
> @@ -1353,7 +1353,7 @@
>  	.rc_key_map		= tt_connect_s2_3600_rc_key,
>  	.rc_key_map_size	= ARRAY_SIZE(tt_connect_s2_3600_rc_key),
>  	.rc_query		= pctv452e_rc_query,
> -	.rc_interval		= 500,
> +	.rc_interval		= 100,
>  
>  	.num_adapters		= 1,
>  	.adapter = {{
> 
Does this patch fix your remote or is it just something you tested?
(btw I agree with the patch :)
> 
> The device is recognized (dmesg):
> [ 7849.369145] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-1/input/input10
> 
> 
> The input device is created as expected:
> $ cat /sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/input/input10/event8/uevent
> MAJOR=13
> MINOR=72
> DEVNAME=input/event8
> 
> 
> $ ls -l /dev/input/event8 
> crw-rw-r-- 1 root video 13, 72 29. Mai 13:37 /dev/input/event8
> 
> 
> $ cat /etc/default/inputlirc 
> # Options to be passed to inputlirc.
> EVENTS="/dev/input/by-path/pci-0000:00:12.2-event-ir"
> OPTIONS="-m 0 -g"
> 
> 
> $ ls -l /dev/input/by-path/pci-0000:00:12.2-event-ir
> lrwxrwxrwx 1 root root 9 29. Mai 13:37 /dev/input/by-path/pci-0000:00:12.2-event-ir -> ../event8
> 
> 
> irw /dev/lircd does not show any input from the remote. I also checked the remote with a camera and it does emit infra red light.

Ok let me try...

1. Your remote is the same as in this (googled) picture?

	http://4.bp.blogspot.com/_B0OTxmaxXPU/SfL1yGqvGjI/AAAAAAAAABU/GFOklS4R9GM/s320/tt_s2_3650.jpg

2. Do you see remote events logged in dmesg when you modprobe the
   pctv452e driver with debug=3 and then test the remote?

3. You can also test for events coming in on /dev/input/event8 using
   evtest, or (if you have up-to-date v4l-utils) using ir-keytable:

	ir-keytable -d /dev/input/event8 -t

4. Do you use the lirc devinput driver and the lircd.conf.devinput
   config?  Maybe this post helps:

	http://forum.xbmc.org/showthread.php?t=101151

 HTH,
	Juergen
