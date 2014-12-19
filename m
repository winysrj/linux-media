Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42353 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaLSK5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 05:57:00 -0500
Message-ID: <1418986616.3165.60.camel@pengutronix.de>
Subject: Re: [PATCH] coda: use VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	hverkuil@xs4all.nl, nicolas.dufresne@collabora.com
Date: Fri, 19 Dec 2014 11:56:56 +0100
In-Reply-To: <1418985387-16580-1-git-send-email-k.debski@samsung.com>
References: <1418985387-16580-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Am Freitag, den 19.12.2014, 11:36 +0100 schrieb Kamil Debski:
> The coda driver interprets a buffer with bytesused equal to 0 as a special
> case indicating end-of-stream. After vb2: fix bytesused == 0 handling
> (8a75ffb) patch videobuf2 modified the value of bytesused if it was 0.
> The VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag was added to videobuf2 to keep
> backward compatibility.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

