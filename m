Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53620 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2LPQQe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:16:34 -0500
Date: Sun, 16 Dec 2012 09:16:33 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 06/15] [media] marvell-ccic: add new formats support
 for marvell-ccic driver
Message-ID: <20121216091633.1b9c1799@hpe.lwn.net>
In-Reply-To: <1355565484-15791-7-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-7-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:55 +0800
Albert Wang <twang13@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the new formats support for marvell-ccic.

Once again, just one second-order comment:

> +static bool mcam_fmt_is_planar(__u32 pfmt)
> +{
> +	switch (pfmt) {
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		return true;
> +	}
> +	return false;
> +}

This seems like the kind of thing that would be useful in a number of
places; I'd be tempted to push it up a level and make it available to all
V4L2 drivers.  Of course, that means making it work for *all* formats,
which would be a pain.  

But, then, I can see some potential future pain if somebody adds a new
format and forgets to tweak this function here.  Rather than adding a new
switch, could you put a "planar" flag into struct mcam_format_struct
instead?  That would help to keep all this information together.

jon
