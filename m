Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35964 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbbHCPl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2015 11:41:59 -0400
Message-ID: <1438616514.3844.15.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: drop zero payload bitstream buffers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com, hans.verkuil@cisco.com, kamil@wypas.org
Date: Mon, 03 Aug 2015 17:41:54 +0200
In-Reply-To: <7e7708ca44f36fe97ad032aa1eea0d64ff84665d.1438602940.git.zahari.doychev@linux.com>
References: <7e7708ca44f36fe97ad032aa1eea0d64ff84665d.1438602940.git.zahari.doychev@linux.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 03.08.2015, 13:57 +0200 schrieb Zahari Doychev:
> The buffers with zero payload are now dumped in coda_fill_bitstream and not
> passed to coda_bitstream_queue. This avoids unnecessary fifo addition and
> buffer sequence counter increment.
> 
> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>

Yes, that looks better.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

