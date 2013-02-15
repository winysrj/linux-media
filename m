Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61402 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3BOLNn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 06:13:43 -0500
Received: by mail-wi0-f178.google.com with SMTP id o1so992362wic.11
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 03:13:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130214214953.GB24184@valkosipuli.retiisi.org.uk>
References: <CAJRKTVq-dgT2yMViBY=ZCbTHmV7m_9KN+mGXfCeqf1myL5tsWg@mail.gmail.com>
 <20130214214953.GB24184@valkosipuli.retiisi.org.uk>
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Fri, 15 Feb 2013 09:13:22 -0200
Message-ID: <CAJRKTVqb7ZnNifS5rHruqXqh+5Y8z8PzffmuudoNfk=Sk+MrZA@mail.gmail.com>
Subject: Re: omap3isp omap3isp: CCDC stop timeout!
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

2013/2/14 Sakari Ailus <sakari.ailus@iki.fi>:
> On Thu, Jan 31, 2013 at 05:40:38PM -0200, Adriano Martins wrote:
>> Hi all,
>>
>> I'm trying capture images from an ov5640 sensor on parallel mode. The
>> sensor output format is UYVY8_2X8.
>> And the CCDC input is configured as  UYVY8_2X8 too. I can do it, after
>> I applied the Laurent's patches:
>> "[PATCH 0/6] YUV input support for the OMAP3 ISP".
>>
>> I have my sensor configured:
>> {
>> .subdevs = cm-t35_ov5640_primary_subdevs,
>> .interface = ISP_INTERFACE_PARALLEL,
>> .bus = {
>>      .parallel = {
>>      .data_lane_shift = 2,
>>      .clk_pol = 0,
>>      .hs_pol = 1,
>>      .vs_pol = 1,
>>      .data_pol = 1,
>> },
>> },
>>
>> I defined ISP_ISR_DEBUG and DEBUG in the isp.c
>> Then, I configure the media-controller pipeline and try to capture:
>>
>> media-ctl -v -r -l '"ov5640 3-003c":0->"OMAP3 ISP CCDC":0[1]'
>> media-ctl -v  -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>> media-ctl -v -V '"ov5640 3-003c":0 [UYVY2X8 640x480]'
>> media-ctl -v -V '"OMAP3 ISP CCDC":0 [UYVY2X8 640x480]'
>> yavta -f UYVY -s 640x480 --capture=5 --file=image# /dev/video2
>>
>> In this point, it hangs, and I need hit ctrol-c.
>> I get this message:
>> [ 1640.308807] omap3isp omap3isp: CCDC stop timeout!
>
> The CCDC needs to receive a complete frames before it can stop.
>
>> I have observed that I don't get any interrupt messages. However, the
>
> This suggests that the ISP doesn't receive any data from the sensor. You
> should see at least the HS_VS interrupt.
>
> Do you see any ISP interrupts in /proc/interrupts?

I solved my problem. I couldn't see any interrups because I didn't the
mux settings in the pins camera.
Now, I can capture frames from ov5640.

>> DATA0:7, PCLK, HSYNC and VSYNC is working fine, I guess.
>>
>> NOTE: the sensor has externel 24 MHz oscillator, and the signals never
>> stop into CCDC:
>

Thanks

Regards
Adriano Martins
