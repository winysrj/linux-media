Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53719 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab2LPQUu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:20:50 -0500
Date: Sun, 16 Dec 2012 09:20:48 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 08/15] [media] marvell-ccic: switch to resource
 managed allocation and request
Message-ID: <20121216092048.3ea98dc3@hpe.lwn.net>
In-Reply-To: <1355565484-15791-9-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-9-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:57 +0800
Albert Wang <twang13@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch switchs to resource managed allocation and request in mmp-driver.
> It can remove free resource operations.

But that takes away half the challenge of getting all this stuff
right! :)

Acked-by: Jonathan Corbet <corbet@lwn.net>


jon
