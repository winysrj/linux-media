Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53561 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab2LPQEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:04:54 -0500
Date: Sun, 16 Dec 2012 09:04:51 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 04/15] [media] marvell-ccic: reset ccic phy when stop
 streaming for stability
Message-ID: <20121216090451.6d3ccf7d@hpe.lwn.net>
In-Reply-To: <1355565484-15791-5-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-5-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:53 +0800
Albert Wang <twang13@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the reset ccic phy operation when stop streaming.
> 
> Without reset ccic phy, the next start streaming may be unstable.
> 
> Also need add CCIC2 definition when PXA688/PXA2128 support dual ccics.
> 
As with all of these, I've not been able to test it, but it looks OK to
me.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
