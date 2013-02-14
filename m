Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43350 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934909Ab3BNVt7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 16:49:59 -0500
Date: Thu, 14 Feb 2013 23:49:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Adriano Martins <adrianomatosmartins@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: omap3isp omap3isp: CCDC stop timeout!
Message-ID: <20130214214953.GB24184@valkosipuli.retiisi.org.uk>
References: <CAJRKTVq-dgT2yMViBY=ZCbTHmV7m_9KN+mGXfCeqf1myL5tsWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJRKTVq-dgT2yMViBY=ZCbTHmV7m_9KN+mGXfCeqf1myL5tsWg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adriano,

(Cc Laurent.)

On Thu, Jan 31, 2013 at 05:40:38PM -0200, Adriano Martins wrote:
> Hi all,
> 
> I'm trying capture images from an ov5640 sensor on parallel mode. The
> sensor output format is UYVY8_2X8.
> And the CCDC input is configured as  UYVY8_2X8 too. I can do it, after
> I applied the Laurent's patches:
> "[PATCH 0/6] YUV input support for the OMAP3 ISP".
> 
> I have my sensor configured:
> {
> .subdevs = cm-t35_ov5640_primary_subdevs,
> .interface = ISP_INTERFACE_PARALLEL,
> .bus = {
>      .parallel = {
>      .data_lane_shift = 2,
>      .clk_pol = 0,
>      .hs_pol = 1,
>      .vs_pol = 1,
>      .data_pol = 1,
> },
> },
> 
> I defined ISP_ISR_DEBUG and DEBUG in the isp.c
> Then, I configure the media-controller pipeline and try to capture:
> 
> media-ctl -v -r -l '"ov5640 3-003c":0->"OMAP3 ISP CCDC":0[1]'
> media-ctl -v  -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> media-ctl -v -V '"ov5640 3-003c":0 [UYVY2X8 640x480]'
> media-ctl -v -V '"OMAP3 ISP CCDC":0 [UYVY2X8 640x480]'
> yavta -f UYVY -s 640x480 --capture=5 --file=image# /dev/video2
> 
> In this point, it hangs, and I need hit ctrol-c.
> I get this message:
> [ 1640.308807] omap3isp omap3isp: CCDC stop timeout!

The CCDC needs to receive a complete frames before it can stop.

> I have observed that I don't get any interrupt messages. However, the

This suggests that the ISP doesn't receive any data from the sensor. You
should see at least the HS_VS interrupt.

Do you see any ISP interrupts in /proc/interrupts?

> DATA0:7, PCLK, HSYNC and VSYNC is working fine, I guess.
> 
> NOTE: the sensor has externel 24 MHz oscillator, and the signals never
> stop into CCDC:

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
