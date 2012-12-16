Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53632 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab2LPQTR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:19:17 -0500
Date: Sun, 16 Dec 2012 09:19:15 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 07/15] [media] marvell-ccic: add SOF / EOF pair check
 for marvell-ccic driver
Message-ID: <20121216091915.08c4ba80@hpe.lwn.net>
In-Reply-To: <1355565484-15791-8-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-8-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:56 +0800
Albert Wang <twang13@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the SOFx/EOFx pair check for marvell-ccic.
> 
> When switching format, the last EOF may not arrive when stop streamning.
> And the EOF will be detected in the next start streaming.
> 
> Must ensure clear the obsolete frame flags before every really start streaming.

"obsolete" doesn't quite read right; it suggests that the flags only
apply to older hardware.  I'd suggest "left over" or some such (in the
code comment too).  Otherwise seems fine.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
