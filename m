Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53229 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2LPPhB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 10:37:01 -0500
Date: Sun, 16 Dec 2012 08:36:59 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 01/15] [media] marvell-ccic: use internal variable
 replace global frame stats variable
Message-ID: <20121216083659.5ef9317d@hpe.lwn.net>
In-Reply-To: <1355565484-15791-2-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-2-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:50 +0800
Albert Wang <twang13@marvell.com> wrote:

> This patch replaces the global frame stats variables by using
> internal variables in mcam_camera structure.

This one seems fine.  Someday it might be nice to have proper stats
rather than my debugging hack, complete with a nice sysfs interface and
all that.  

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
