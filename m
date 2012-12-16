Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53856 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2LPQhT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 11:37:19 -0500
Date: Sun, 16 Dec 2012 09:37:17 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2
 parts for soc_camera support
Message-ID: <20121216093717.4be8feff@hpe.lwn.net>
In-Reply-To: <1355565484-15791-11-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-11-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 15 Dec 2012 17:57:59 +0800
Albert Wang <twang13@marvell.com> wrote:

> This patch splits mcam-core into 2 parts to prepare for soc_camera support.
> 
> The first part remains in mcam-core.c. This part includes the HW operations
> and vb2 callback functions.
> 
> The second part is moved to mcam-core-standard.c. This part is relevant with
> the implementation of using V4L2.

OK, I'll confess I'm still not 100% sold on this part.  Can I repeat
the questions I raised before?

 - Is the soc_camera mode necessary?  Is there something you're trying
   to do that can't be done without it?  Or, at least, does it add
   sufficient benefit to be worth this work?  It would be nice if the
   reasoning behind this change were put into the changelog.

 - If the soc_camera change is deemed to be worthwhile, is there
   anything preventing you from doing it 100% so it's the only mode
   used?

The split as you've done it here is an improvement over what came
before, but it still results in a lot of duplicated code; it also adds
a *lot* of symbols to the global namespace.  If this is really the only
way then we'll find a way to make it work, but I'd like to be sure that
we can't do something better.

Thanks,

jon
