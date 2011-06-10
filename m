Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55606 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1FJQbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 12:31:42 -0400
Date: Fri, 10 Jun 2011 18:31:41 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH] media: vb2: reset queued_count value during queue
 reinitialization
Message-ID: <20110610163141.GJ15070@pengutronix.de>
References: <1307707479-16189-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307707479-16189-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 10, 2011 at 02:04:38PM +0200, Marek Szyprowski wrote:
> queued_count variable was left untouched during the queue reinitialization
> in __vb2_queue_cancel, what might lead to mismatch between the real number
> of queued buffers and queued_count variable.
> 
> Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
Half-acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

As mentioned in the original report, the setup routine should initialize
queued_count, too, so only a half ack.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
