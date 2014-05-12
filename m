Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42417 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaELFUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 01:20:17 -0400
Date: Mon, 12 May 2014 07:20:13 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] media: mx1_camera: Remove driver
Message-ID: <20140512052013.GA5858@pengutronix.de>
References: <1399788551-8218-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399788551-8218-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 11, 2014 at 10:09:11AM +0400, Alexander Shiyan wrote:
> That driver hasn't been really maintained for a long time. It doesn't
> compile in any way, it includes non-existent headers, has no users,
> and marked as "broken" more than year. Due to these factors, mx1_camera
> is now removed from the tree.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

I remember this driver was in the way of further cleanups. We should
remove it.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
