Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:43340 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220AbZG3LtB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 07:49:01 -0400
Date: Thu, 30 Jul 2009 12:48:56 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Robin Holt <holt@sgi.com>
cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-kernel@vger.kernel.org,
	v4l2_linux <linux-media@vger.kernel.org>
Subject: Re: Is get_user_pages() enough to prevent pages from being swapped
 out ?
In-Reply-To: <20090730113951.GA2763@sgi.com>
Message-ID: <Pine.LNX.4.64.0907301248090.27155@sister.anvils>
References: <200907291123.12811.laurent.pinchart@skynet.be>
 <Pine.LNX.4.64.0907291551050.16769@sister.anvils> <200907291741.52783.laurent.pinchart@skynet.be>
 <Pine.LNX.4.64.0907291653510.20238@sister.anvils> <20090730113951.GA2763@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 30 Jul 2009, Robin Holt wrote:
> > > On Wednesday 29 July 2009 17:26:11 Hugh Dickins wrote:
> ...
> > > > On the other hand, despite the raised reference count, under memory
> > > > pressure that page might get unmapped from the user pagetable, and
> > > > might even be written out to swap in its half-dirty state (though
> 
> One thing you did not mention in the above description is that the page
> is marked clean by the write-out to swap.  I am not sure I recall the
> method of mapping involved here, but it is necessary to ensure the page
> is marked dirty again before the driver releases it.  If the page is
> not marked dirty as part of your method of releasing it, the changes
> you have made between when the page was first written out and when you
> are freeing it will get lost.

Yes indeed: thanks, Robin.

Hugh
