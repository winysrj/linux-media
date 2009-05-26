Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55346 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752609AbZEZLoh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 07:44:37 -0400
Date: Tue, 26 May 2009 13:44:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: moinejf@free.fr
Subject: gspca: Logitech QuickCam Messenger worked last with external
 gspcav1-20071224
Message-ID: <Pine.LNX.4.64.0905261335050.4810@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

I think it would be agood time now to get my Logitech QuickCam Messenger 
camera working with the current gspca driver. It used to work with 
gspcav1-20071224, here's dmesg output:

/tmp/gspcav1-20071224/gspca_core.c: USB GSPCA camera found.(ZC3XX)
/tmp/gspcav1-20071224/gspca_core.c: [spca5xx_probe:4275] Camera type JPEG
/tmp/gspcav1-20071224/Vimicro/zc3xx.h: [zc3xx_config:669] Find Sensor HV7131R(c)

with more USB related messages following. Now dmesg with some debug turned 
on looks like

gspca: probing 046d:08da
zc3xx: probe 2wr ov vga 0x0000
zc3xx: probe sensor -> 11
zc3xx: Find Sensor HV7131R(c)
gspca: probe ok
usbcore: registered new interface driver zc3xx
zc3xx: registered

and the camera is not working, the light on its case doesn't go on. If I 
try "force_sensor=15" to match sensor tas5130cxx, as was detected by the 
old driver, dmesg reports

gspca: probing 046d:08da
zc3xx: probe 2wr ov vga 0x0000
zc3xx: probe sensor -> 11
zc3xx: sensor forced to 15
gspca: probe ok
usbcore: registered new interface driver zc3xx
zc3xx: registered

and otherwise nothing changes. I could spend some time trying to find the 
problem, but I would prefer if someone could suggest some debugging, I am 
not familiar with gspca internals. Ideas anyone?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
