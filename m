Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp12.wxs.nl ([195.121.247.24]:47791 "EHLO psmtp12.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab0CDWwD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Mar 2010 17:52:03 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp12.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KYS00C9H4ULGB@psmtp12.wxs.nl> for linux-media@vger.kernel.org;
 Thu, 04 Mar 2010 23:52:02 +0100 (MET)
Date: Thu, 04 Mar 2010 23:51:49 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: [linux-dvb] Compro U80 Nearly there???
In-reply-to: <1267260444.4176.31.camel@lisa>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Message-id: <4B903985.3020404@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1267260444.4176.31.camel@lisa>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please see if there is more information on the tuner in the logging with 
debugging switched on:

	sudo modprobe -r dvb-usb-rtl2831u
	sudo modprobe dvb-usb-rtl2831u debug=1

The ~jhoogenraad/rtl2831-r2 has two tuners hard-coded in the driver (no 
separation of back-end and front-end), and logs the interactions with 
those tuners in debug mode.

I maintain the wiki with info on the driver:
http://www.linuxtv.org/wiki/index.php/Rtl2831_devices

Please also try the new driver (alas with no IR remote support) from
~anttip/rtl2831u

peter wrote:
> I'm running Ubuntu Karmic, and have a Compro U80 Device USB ID
> 185b:0150.
> 
> To get this close to working I have:
> 
> 1) Added 50-udev.rules which seem to allow the device to be recognised.
> 
> 2) Compiled the ~jhoogenraad/rtl2831-r2 version of the driver.
> 
> This gets me to the point where:
> - /dev/dvb exists.
> - my applications recognise the device
> 
> - In the log I see:
> 
> [   14.311735] dvb-usb: found a 'VideoMate U90' in warm state.
> [   14.311743] dvb-usb: will pass the complete MPEG2 transport stream to
> the software demuxer.
> [   14.312131] DVB: registering new adapter (VideoMate U90)
> [   14.312420] DVB: registering adapter 0 frontend 0 (Realtek RTL2831
> DVB-T)...
> [   14.312521] input: IR-receiver inside an USB DVB receiver
> as /devices/pci0000:00/0000:00:02.1/usb1/1-1/input/input5
> [   14.312552] dvb-usb: schedule remote query interval to 300 msecs.
> [   14.312558] dvb-usb: VideoMate U90 successfully initialized and
> connected.
> [   14.312589] usbcore: registered new interface driver dvb_usb_rtd2831u
> 
> So looking good so far.
> 
> 
> However, if i used scan, or an application like Kaffeine tuning fails. I
> know that the device works as I can get it to work on windows.
> 
> So I have been looking at the RTL2831U data sheets which I know from the
> windows driver that this is based on. (I don't know much about this
> hardware I am trying to figure it out ). So this chip is just doing the
> demodulating and the USB interface. It must therefore be paired with
> tuner.  It seems logical to me (but is possibly wrong ) that if the
> demodulator is working and I cant tune, then the issue is with the tuner
> part of the driver. The windows drivers refer to both the MT2060 and the
> QT1010, but I don't know which one is being used. (I have not had the
> guts to rip the thing apart yet). Docu in the code of for the driver
> implies that it can support the MT2060 but not the QT1010 so I guess
> with my luck it is the quantec one. 
> 
> Has any one got any advice as to where I should look next? Has anyone
> got this to work? It seems to be quite close. I any suggestions would be
> appreciated.
> Thanks
> Peter
> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
