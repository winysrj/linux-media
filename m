Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51115 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaFTIir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 04:38:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?utf-8?B?0JzQuNGF0LDQudC70L4g0J3QvtCy0L7RgtC90LjQuQ==?=
	<michael.novotnuy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: omap3-isp driver in CSI2 mode
Date: Fri, 20 Jun 2014 10:39:28 +0200
Message-ID: <3019615.VUrsMMGC6E@avalon>
In-Reply-To: <CAAT6_75JEX05GYaDni4Z1wuYH5rFRCXnh9SXoc4K+_y2AWR_NQ@mail.gmail.com>
References: <CAAT6_74xo5MSxfAVZNHoxXQPMWd_KRWCDTaKvUMx054BD9-9NQ@mail.gmail.com> <1934518.xtQnOJUCmU@avalon> <CAAT6_75JEX05GYaDni4Z1wuYH5rFRCXnh9SXoc4K+_y2AWR_NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Tuesday 17 June 2014 16:07:20 Михайло Новотний wrote:
> Hi Laurent.
> 
> In my case, I don't receive any interrupts from CSI2 module
> 
> My post on Ti forum:
> http://e2e.ti.com/support/dsp/davinci_digital_media_processors/f/537/p/33699
> 1/1182836.aspx#1182836

Quoting your post:

> I find that I used incorrect data in mux init:
> omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
> on my board DM3730CBP100,
> I changedmux init to  omap3_mux_init(board_mux, OMAP_PACKAGE_CBP);
> Now CSI2 interrupts occur.
> 
> But now I have another problem.
> When I start stream, I always recive error:
> [   83.435546] omap3isp omap3isp: CSI2: ComplexIO Error IRQ 10000
> [   83.491149] omap3isp omap3isp: CSI2: ComplexIO Error IRQ 30000
> [   83.544158] omap3isp omap3isp: CSI2: ComplexIO Error IRQ 10000
> [   83.600830] omap3isp omap3isp: CSI2: ComplexIO Error IRQ 20000

According to the OMAP3 TRM, bits 16 and 17 indicate a control error for lane 2 
and 3 respectively. How many lanes does your sensor use, how are they routed, 
and how have you specified the OMAP3 ISP platform data in your board file ?

-- 
Regards,

Laurent Pinchart

