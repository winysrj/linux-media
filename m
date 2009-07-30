Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:44742 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751385AbZG3Ljx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 07:39:53 -0400
Date: Thu, 30 Jul 2009 06:39:51 -0500
From: Robin Holt <holt@sgi.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-kernel@vger.kernel.org,
	v4l2_linux <linux-media@vger.kernel.org>
Subject: Re: Is get_user_pages() enough to prevent pages from being swapped
	out ?
Message-ID: <20090730113951.GA2763@sgi.com>
References: <200907291123.12811.laurent.pinchart@skynet.be> <Pine.LNX.4.64.0907291551050.16769@sister.anvils> <200907291741.52783.laurent.pinchart@skynet.be> <Pine.LNX.4.64.0907291653510.20238@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907291653510.20238@sister.anvils>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > On Wednesday 29 July 2009 17:26:11 Hugh Dickins wrote:
...
> > > On the other hand, despite the raised reference count, under memory
> > > pressure that page might get unmapped from the user pagetable, and
> > > might even be written out to swap in its half-dirty state (though

One thing you did not mention in the above description is that the page
is marked clean by the write-out to swap.  I am not sure I recall the
method of mapping involved here, but it is necessary to ensure the page
is marked dirty again before the driver releases it.  If the page is
not marked dirty as part of your method of releasing it, the changes
you have made between when the page was first written out and when you
are freeing it will get lost.

Thanks,
Robin
