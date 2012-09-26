Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47255 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204Ab2IZQjM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 12:39:12 -0400
Date: Wed, 26 Sep 2012 10:40:07 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 1/5] media: ov7670: add support for ov7675.
Message-ID: <20120926104007.4de17d19@lwn.net>
In-Reply-To: <1348652877-25816-2-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-2-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is going to have to be quick, sorry...

On Wed, 26 Sep 2012 11:47:53 +0200
Javier Martin <javier.martin@vista-silicon.com> wrote:

> +static struct ov7670_win_size ov7670_win_sizes[2][4] = {
> +	/* ov7670 */

I must confess I don't like this; now we've got constants in an array that
was automatically sized before and ov7670_win_sizes[info->model]
everywhere.  I'd suggest a separate array for each device and an
ov7670_get_wsizes(model) function.

> +		/* CIF - WARNING: not tested for ov7675 */
> +		{

...and this is part of why I don't like it.  My experience with this
particular sensor says that, if it's not tested, it hasn't yet seen the
magic-number tweaking required to actually make it work.  Please don't
claim to support formats that you don't know actually work, or I'll get
stuck with the bug reports :)

> +			.width		= CIF_WIDTH,
> +			.height		= CIF_HEIGHT,
> +			.com7_bit	= COM7_FMT_CIF,
> +			.hstart		= 170,	/* Empirically determined */
> +			.hstop		=  90,
> +			.vstart		=  14,
> +			.vstop		= 494,
> +			.regs		= NULL,
> +		},

jon
