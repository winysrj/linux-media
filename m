Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:60336 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423279Ab3FURCa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 13:02:30 -0400
Date: Fri, 21 Jun 2013 11:02:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: <lbyang@marvell.com>
Cc: <g.liakhovetski@gmx.de>, <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>
Subject: Re: [PATCH 2/7] marvell-ccic: add clock tree support for
 marvell-ccic driver
Message-ID: <20130621110224.6adf7492@lwn.net>
In-Reply-To: <1370324564.26072.22.camel@younglee-desktop>
References: <1370324564.26072.22.camel@younglee-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 4 Jun 2013 13:42:44 +0800
lbyang <lbyang@marvell.com> wrote:

> +static void mcam_clk_enable(struct mcam_camera *mcam)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < NR_MCAM_CLK; i++) {
> +		if (!IS_ERR_OR_NULL(mcam->clk[i]))
> +			clk_prepare_enable(mcam->clk[i]);
> +	}
> +}

It seems I already acked this patch, and I won't take that back.  I
will point out, though, that IS_ERR_OR_NULL has become a sort of
lightning rod and that its use is probably best avoided.

	http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/140543.html

This relates to the use of ERR_PTR with that particular pointer value;
I still think just using NULL is better, but maybe I'm missing
something.

jon
