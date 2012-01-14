Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33166 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2ANXoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 18:44:39 -0500
Received: by eekd4 with SMTP id d4so1486344eek.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 15:44:37 -0800 (PST)
Message-ID: <4F121361.2050403@gmail.com>
Date: Sun, 15 Jan 2012 00:44:33 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: RazzaList <razzalist@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Hauppage Nova: doesn't know how to handle a DVBv3 call to delivery
 system 0
References: <008301ccd316$0be6d440$23b47cc0$@gmail.com>
In-Reply-To: <008301ccd316$0be6d440$23b47cc0$@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 15/01/2012 00:41, RazzaList ha scritto:
> I have followed the build instructions for the Hauppauge MyTV.t device here
> - http://linuxtv.org/wiki/index.php/Hauppauge_myTV.t and built the drivers
> as detailed here -
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_D
> evice_Drivers on a CentOS 6.2 i386 build. 
> 
> When I use dvbscan, nothing happens. dmesg shows "
> dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
> delivery system 0"
> 
> [root@cos6 ~]# cd /usr/bin
> [root@cos6 bin]# ./dvbscan /usr/share/dvb/dvb-t/uk-Hannington >
> /usr/share/dvb/dvb-t/channels.conf
> [root@cos6 bin]# dmesg | grep dvb
> dvb-usb: found a 'Hauppauge Nova-T MyTV.t' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> dvb-usb: schedule remote query interval to 50 msecs.
> dvb-usb: Hauppauge Nova-T MyTV.t successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_dib0700
> dvb_frontend_ioctl_legacy: doesn't know how to handle a DVBv3 call to
> delivery system 0
> 
> I have searched but can't locate a fix. Any pointers?
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi,
this patch will likely fix your problem:

http://patchwork.linuxtv.org/patch/9492/

Best regards,
Gianluca
