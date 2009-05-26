Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37503 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZEZLu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 07:50:27 -0400
Message-ID: <4A1BD76E.4020603@redhat.com>
Date: Tue, 26 May 2009 13:50:06 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	moinejf@free.fr
Subject: Re: gspca: Logitech QuickCam Messenger worked last with external
 gspcav1-20071224
References: <Pine.LNX.4.64.0905261335050.4810@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0905261335050.4810@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/26/2009 01:44 PM, Guennadi Liakhovetski wrote:
> Hi all
>
> I think it would be agood time now to get my Logitech QuickCam Messenger
> camera working with the current gspca driver. It used to work with
> gspcav1-20071224, here's dmesg output:
>
> /tmp/gspcav1-20071224/gspca_core.c: USB GSPCA camera found.(ZC3XX)
> /tmp/gspcav1-20071224/gspca_core.c: [spca5xx_probe:4275] Camera type JPEG
> /tmp/gspcav1-20071224/Vimicro/zc3xx.h: [zc3xx_config:669] Find Sensor HV7131R(c)
>
> with more USB related messages following. Now dmesg with some debug turned
> on looks like
>
> gspca: probing 046d:08da
> zc3xx: probe 2wr ov vga 0x0000
> zc3xx: probe sensor ->  11
> zc3xx: Find Sensor HV7131R(c)
> gspca: probe ok
> usbcore: registered new interface driver zc3xx
> zc3xx: registered
>
> and the camera is not working, the light on its case doesn't go on. If I
> try "force_sensor=15" to match sensor tas5130cxx, as was detected by the
> old driver, dmesg reports
>
> gspca: probing 046d:08da
> zc3xx: probe 2wr ov vga 0x0000
> zc3xx: probe sensor ->  11
> zc3xx: sensor forced to 15
> gspca: probe ok
> usbcore: registered new interface driver zc3xx
> zc3xx: registered
>
> and otherwise nothing changes. I could spend some time trying to find the
> problem, but I would prefer if someone could suggest some debugging, I am
> not familiar with gspca internals. Ideas anyone?
>

First of all, which app are you using to test the cam ? And are you using that
app in combination with libv4l ?

Also why do you say the original driver used to identify it as a tas5130cxx,
the dmesg lines you pasted from gspcav1 also say it is a HV7131R

Regards,

Hans
