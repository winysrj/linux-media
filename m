Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:55225 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab3KEQLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 11:11:10 -0500
Date: Tue, 5 Nov 2013 09:11:09 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: lbyang@marvell.com
Cc: <linux-media@vger.kernel.org>, <u.kleine-koenig@pengutronix.de>,
	<linux@arm.linux.org.uk>
Subject: Re: [RFC] [PATCH] media: marvell-ccic: use devm to release clk
Message-ID: <20131105091109.3bb89cc4@lwn.net>
In-Reply-To: <1383643996.30496.3.camel@younglee-desktop>
References: <1383643996.30496.3.camel@younglee-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 5 Nov 2013 17:33:16 +0800
lbyang <lbyang@marvell.com> wrote:

> This patch uses devm to release the clks instead of releasing
> manually.
> And it adds enable/disable mipi_clk when getting its rate.

I can't really test this, so I'll have to assume it works :)

Acked-by: Jonathan Corbet <corbet@lwn.net>

However: it seems that crediting Uwe Kleine-König with a Reported-by would
be the right thing to do.

Thanks,

jon
