Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41120 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1K1QBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 11:01:22 -0500
Date: Mon, 28 Nov 2011 16:00:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
	josh.wu@atmel.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] V4L: atmel-isi: add code to enable/disable
	ISI_MCK clock
Message-ID: <20111128160055.GD11432@n2100.arm.linux.org.uk>
References: <1322487284-3381-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322487284-3381-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 28, 2011 at 02:34:44PM +0100, Nicolas Ferre wrote:
> From: Josh Wu <josh.wu@atmel.com>
> 
> This patch
> - add ISI_MCK clock enable/disable code.
> - change field name in isi_platform_data structure
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> [g.liakhovetski@gmx.de: fix label names]
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Guennadi,
> 
> Here is the pach form Josh and yourself about the Atmel ISI driver
> modifications. I have rebased it on top of 3.2-rc3 (and tested it on
> linux-next also).
> I plan to submit the board/device related patches (2-3/3 of this series) to
> the arm-soc tree real soon. Do you whant me to include this one or can you
> schedulle an inclusion in mainline for 3.3?

While you're doing this, why not also prepare for the common clk API by
adding support for clk_prepare()/clk_unprepare() to these drivers?

We are actually now at the point where we should be saying a firm no to
any new introductions of clk_enable()/clk_disable() without there being
corresponding clk_prepare()/clk_unprepare() calls for that clk.
