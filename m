Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50908 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaFXKPG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 06:15:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1WzNkl-0001Ls-UD
	for linux-media@vger.kernel.org; Tue, 24 Jun 2014 12:15:04 +0200
Received: from 80-218-111-224.dclient.hispeed.ch ([80.218.111.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 12:15:03 +0200
Received: from dave.mueller by 80-218-111-224.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 24 Jun 2014 12:15:03 +0200
To: linux-media@vger.kernel.org
From: Dave =?utf-8?b?TcO8bGxlcg==?= <dave.mueller@gmx.ch>
Subject: Re: [RFC PATCH 14/26] [media] Add i.MX SoC wide media device driver
Date: Tue, 24 Jun 2014 10:04:34 +0000 (UTC)
Message-ID: <loom.20140624T113538-892@post.gmane.org>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de> <1402592800-2925-15-git-send-email-p.zabel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Philipp Zabel <p.zabel@pengutronix.de> writes:

> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 8e9c26c..3fe7e28 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -35,6 +35,8 @@  source "drivers/media/platform/omap/Kconfig"
> 
>  source "drivers/media/platform/blackfin/Kconfig"
> 
> +source "drivers/media/platform/imx/Kconfig"
> +

This was added already in patch #8 of this serie.


