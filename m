Return-path: <linux-media-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbZLKDen (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 22:34:43 -0500
Date: Thu, 10 Dec 2009 19:32:25 -0800
From: Greg KH <greg@kroah.com>
To: Brandon Philips <brandon@ifup.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, stable@kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [stable] [PATCH] ov511: fix probe() hang due to double
	mutex_lock
Message-ID: <20091211033225.GA2596@kroah.com>
References: <20091211010449.GV3387@jenkins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211010449.GV3387@jenkins>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 10, 2009 at 05:04:49PM -0800, Brandon Philips wrote:
> Commit 163fe744c3283fd267268629afff4cfc846ed0e0 added a double
> mutex_lock which hangs ov51x_probe(). This was clearly a typo.
> 
> Change final mutex_lock() -> mutex_unlock()
> 
> Signed-off-by: Brandon Philips <bphilips@suse.de>

Brandon, when you want patches to be added to the stable tree, just add
a:
	Cc: stable <stable@kernel.org>
to the signed-off-by area of the patch.  That way, when they get merged
into Linus's tree eventually, they will be automagically sent to the
stable@kernel.org alias, so I know to add it to the tree at that time.

It saves you time, and me time, so I don't have to go hunt for this
upstream sometime in the future.

thanks,

greg "i need more time saved" k-h
