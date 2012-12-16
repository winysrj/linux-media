Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53983 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2LPQ5j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:57:39 -0500
Date: Sun, 16 Dec 2012 09:57:37 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Subject: Re: [PATCH V3 00/15] [media] marvell-ccic: add soc camera support
 on marvell-ccic
Message-ID: <20121216095737.12c52c00@hpe.lwn.net>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:49 +0800
Albert Wang <twang13@marvell.com> wrote:

> The following patches series will add soc_camera support on marvell-ccic

Overall, this patch set has come a long way - great work!

As I commented on the specific patches, I still have some concerns
about the soc_camera part of it.  There's various quibbles with the
rest, but mostly not much that's serious.  I think this work is getting
close to being ready.

Thanks,

jon


Jonathan Corbet / LWN.net / corbet@lwn.net
