Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53566 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab2LPQG7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:06:59 -0500
Date: Sun, 16 Dec 2012 09:06:58 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 05/15] [media] marvell-ccic: refine
 mcam_set_contig_buffer function
Message-ID: <20121216090658.3a75c8fe@hpe.lwn.net>
In-Reply-To: <1355565484-15791-6-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-6-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:54 +0800
Albert Wang <twang13@marvell.com> wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch refines mcam_set_contig_buffer() in mcam core

It might be nice if the changelog said *why* this was being done -
don't worry about insulting my ugly code :)  But no biggie...

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
