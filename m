Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57844 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaJEHce (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 03:32:34 -0400
Date: Sun, 5 Oct 2014 09:32:28 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: m.chehab@samsung.com, p.zabel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/3] [media] coda: Call v4l2_device_unregister() from a
 single location
Message-ID: <20141005073228.GA5694@pengutronix.de>
References: <1412451652-27220-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412451652-27220-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 04, 2014 at 04:40:50PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Instead of calling v4l2_device_unregister() in multiple locations within the
> error paths, let's call it from a single location to make the error handling
> simpler.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
