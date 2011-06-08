Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35206 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1FHUyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 16:54:00 -0400
Date: Wed, 8 Jun 2011 22:53:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH] Revert "[media] v4l2: vb2: one more fix for REQBUFS()"
Message-ID: <20110608205357.GB15070@pengutronix.de>
References: <1307525150-10876-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307525150-10876-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Marek,

On Wed, Jun 08, 2011 at 11:25:50AM +0200, Marek Szyprowski wrote:
> This reverts commit 31901a078af29c33c736dcbf815656920e904632.
> 
> Queue should be reinitialized on each REQBUFS() call even if the memory
> access method and buffer count have not been changed. The user might have
> changed the format and if we go the short path introduced in that commit,
> the memory buffer will not be reallocated to fit with new format.
> 
> The previous patch was just over-engineered optimization, which just
> introduced a bug to videobuf2.
> 
> Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
Didn't see your patch before I posted mine. (I only checked my inbox, not
the linux-media folder). So take it as an Ack.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
