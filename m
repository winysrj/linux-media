Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38198 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3AaTlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 14:41:00 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so2268734wgh.31
        for <linux-media@vger.kernel.org>; Thu, 31 Jan 2013 11:40:59 -0800 (PST)
MIME-Version: 1.0
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Thu, 31 Jan 2013 17:40:38 -0200
Message-ID: <CAJRKTVq-dgT2yMViBY=ZCbTHmV7m_9KN+mGXfCeqf1myL5tsWg@mail.gmail.com>
Subject: omap3isp omap3isp: CCDC stop timeout!
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm trying capture images from an ov5640 sensor on parallel mode. The
sensor output format is UYVY8_2X8.
And the CCDC input is configured as  UYVY8_2X8 too. I can do it, after
I applied the Laurent's patches:
"[PATCH 0/6] YUV input support for the OMAP3 ISP".

I have my sensor configured:
{
.subdevs = cm-t35_ov5640_primary_subdevs,
.interface = ISP_INTERFACE_PARALLEL,
.bus = {
     .parallel = {
     .data_lane_shift = 2,
     .clk_pol = 0,
     .hs_pol = 1,
     .vs_pol = 1,
     .data_pol = 1,
},
},

I defined ISP_ISR_DEBUG and DEBUG in the isp.c
Then, I configure the media-controller pipeline and try to capture:

media-ctl -v -r -l '"ov5640 3-003c":0->"OMAP3 ISP CCDC":0[1]'
media-ctl -v  -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
media-ctl -v -V '"ov5640 3-003c":0 [UYVY2X8 640x480]'
media-ctl -v -V '"OMAP3 ISP CCDC":0 [UYVY2X8 640x480]'
yavta -f UYVY -s 640x480 --capture=5 --file=image# /dev/video2

In this point, it hangs, and I need hit ctrol-c.
I get this message:
[ 1640.308807] omap3isp omap3isp: CCDC stop timeout!

I have observed that I don't get any interrupt messages. However, the
DATA0:7, PCLK, HSYNC and VSYNC is working fine, I guess.

NOTE: the sensor has externel 24 MHz oscillator, and the signals never
stop into CCDC:

Somebody can help me?

Thanks

Regards
Adriano Martins
