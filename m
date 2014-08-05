Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34600 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaHEQaK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 12:30:10 -0400
Message-ID: <1407256205.4760.5.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 8/8] [media] coda: move BIT specific functions into
 separate file
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Fabio Estevam' <fabio.estevam@freescale.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Date: Tue, 05 Aug 2014 18:30:05 +0200
In-Reply-To: <0c3d01cfb0c3$11d81980$35884c80$%debski@samsung.com>
References: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
	 <1406129325-10771-9-git-send-email-p.zabel@pengutronix.de>
	 <0c3d01cfb0c3$11d81980$35884c80$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Am Dienstag, den 05.08.2014, 17:36 +0200 schrieb Kamil Debski:
> Hi Philipp,
> 
> I have some errors from checkpatch for this patch. Please fix them.
> 
> ERROR: return is not a function, parentheses are not required
> #86: FILE: drivers/media/platform/coda/coda-bit.c:40:
> +	return (coda_read(dev, CODA_REG_BIT_CUR_PC) != 0);
> 
> WARNING: quoted string split across lines
> #681: FILE: drivers/media/platform/coda/coda-bit.c:635:
> +		v4l2_err(&dev->v4l2_dev, "Wrong firmware. Hw: %s, Fw: %s,"
> +			 " Version: %u.%u.%u\n",
> WARNING: quoted string split across lines
> #695: FILE: drivers/media/platform/coda/coda-bit.c:649:
> +		v4l2_warn(&dev->v4l2_dev, "Unsupported firmware version: "
> +			  "%u.%u.%u\n", major, minor, releas

In my opinion this is not a problem. It is quite clear that the version
number(s) are generated, and the rest of the string is greppable.

> And many, many following warnings: "WARNING: line over 80 characters".
> Please check if these lines *REALLY* need to be such long.

This patch only moves code around. I strongly prefer not to make
formatting changes at the same time.

If you insist, I'll prepend a checkpatch cleanup series, but I'd be
happier if you'd let me do this after the move.

regards
Philipp

