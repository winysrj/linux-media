Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40946 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaJEHhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 03:37:32 -0400
Date: Sun, 5 Oct 2014 09:37:28 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: m.chehab@samsung.com, p.zabel@pengutronix.de,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 3/3] [media] coda: Remove devm_kzalloc() error message
Message-ID: <20141005073728.GC5694@pengutronix.de>
References: <1412451652-27220-1-git-send-email-festevam@gmail.com>
 <1412451652-27220-3-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412451652-27220-3-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Sat, Oct 04, 2014 at 04:40:52PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Core code already prints on OOM errors, so no need to keep this here.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

I already have sent this patch:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg80093.html

regards
Philipp
