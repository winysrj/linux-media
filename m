Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54506 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEKI5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 04:57:14 -0400
Date: Sun, 11 May 2014 10:57:07 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] ARM: i.MX: Remove excess symbols ARCH_MX1, ARCH_MX25 and
 MACH_MX27
Message-ID: <20140511085707.GB29070@pengutronix.de>
References: <1399798206-17565-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399798206-17565-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 11, 2014 at 12:50:06PM +0400, Alexander Shiyan wrote:
> This patch removes excess symbols ARCH_MX1, ARCH_MX25 and MACH_MX27.
> Instead we use SOC_IMX*.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
