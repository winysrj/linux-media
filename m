Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55595 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbbDFFvg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2015 01:51:36 -0400
Message-ID: <55221EB8.7080403@ti.com>
Date: Mon, 6 Apr 2015 11:20:48 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>,
	<alsa-devel@alsa-project.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-sh@vger.kernel.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
	Tony Lindgren <tony@atomide.com>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 03/14] clkdev: get rid of redundant clk_add_alias() prototype
 in linux/clk.h
References: <20150403171149.GC13898@n2100.arm.linux.org.uk> <E1Ye593-0001B1-W4@rmk-PC.arm.linux.org.uk>
In-Reply-To: <E1Ye593-0001B1-W4@rmk-PC.arm.linux.org.uk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 03 April 2015 10:42 PM, Russell King wrote:
> clk_add_alias() is provided by clkdev, and is not part of the clk API.
> Howver, it is prototyped in two locations: linux/clkdev.h and
> linux/clk.h.  This is a mess.  Get rid of the redundant and unnecessary
> version in linux/clk.h.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/mach-davinci/da850.c        |  1 +

For the DaVinci change:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar

