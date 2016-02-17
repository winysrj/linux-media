Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:36549 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423400AbcBQO1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 09:27:32 -0500
Message-ID: <1455719247.3336.23.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: add support for native order firmware
 files with Freescale header
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Philipp Zabel <philipp.zabel@gmail.com>
Date: Wed, 17 Feb 2016 15:27:27 +0100
In-Reply-To: <20160217113515.19c0f87a@recife.lan>
References: <1455715270-23757-1-git-send-email-p.zabel@pengutronix.de>
	 <20160217113515.19c0f87a@recife.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am Mittwoch, den 17.02.2016, 11:35 -0200 schrieb Mauro Carvalho Chehab:
> Em Wed, 17 Feb 2016 14:21:10 +0100
> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
> 
> > Freescale distribute their VPU firmware files with a 16 byte header
> > in BIT processor native order. This patch allows to detect the header
> > and to reorder the firmware on the fly.
> > With this patch it should be possible to use the distributed
> > vpu_fw_imx{53,6q,6d}.bin files directly after renaming them to
> > v4l-coda*-imx{53,6q,6dl}.bin.
> 
> IMHO, the best would be to add another patch to support the files with
> their original names, falling back to v4l-coda*. We do this on other
> drivers where more than one firmware file could be used.

thank you for the suggestion. I'll follow up with another patch that
also supports the firmware file names as they are distributed.

regards
Philipp

