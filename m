Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57849 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaJEHdE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 03:33:04 -0400
Date: Sun, 5 Oct 2014 09:33:01 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: m.chehab@samsung.com, p.zabel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 2/3] [media] coda: Unregister v4l2 upon alloc_workqueue()
 error
Message-ID: <20141005073301.GB5694@pengutronix.de>
References: <1412451652-27220-1-git-send-email-festevam@gmail.com>
 <1412451652-27220-2-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412451652-27220-2-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 04, 2014 at 04:40:51PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> If alloc_workqueue() fails, we should go to the 'err_v4l2_register' label, which
> will unregister the v4l2 device.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
