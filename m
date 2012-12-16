Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53892 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab2LPQuJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:50:09 -0500
Date: Sun, 16 Dec 2012 09:50:07 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 14/15] [media] marvell-ccic: use unsigned int type
 replace int type
Message-ID: <20121216095007.4b1a64e1@hpe.lwn.net>
In-Reply-To: <1355565484-15791-15-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-15-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:58:03 +0800
Albert Wang <twang13@marvell.com> wrote:

> This patch use unsigned int type replace int type in marvell-ccic.
> 
> These variables: frame number, buf number, irq... should be unsigned.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
