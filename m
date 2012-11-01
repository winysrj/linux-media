Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:43052 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2KARwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 13:52:23 -0400
Message-ID: <5092B6D3.8040501@wwwdotorg.org>
Date: Thu, 01 Nov 2012 11:52:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, kernel@pengutronix.de
Subject: Re: [PATCH v7 2/8] of: add helper to parse display timings
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de> <1351675689-26814-3-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1351675689-26814-3-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/31/2012 03:28 AM, Steffen Trumtrar wrote:

Patch description? The patch defines the DT binding as well, which isn't
mentioned in the patch subject.

> new file mode 100644
> index 0000000..04c94a3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/display-timings.txt

> +Usage in backend
> +================

Everything before this point in the binding docs looks reasonable to me.
Everything after this point is Linux-specific/internal implementation
detail, and hence shouldn't be in the binding document.

I only read the DT binding.

