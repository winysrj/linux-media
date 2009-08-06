Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:59825 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbZHFUPg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 16:15:36 -0400
Date: Thu, 6 Aug 2009 21:15:27 +0100
From: Jamie Lokier <jamie@shareable.org>
To: David Xiao <dxiao@broadcom.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090806201527.GA8725@shareable.org>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090806114619.GW2080@trinity.fluff.org> <200908061506.23874.laurent.pinchart@ideasonboard.com> <1249584374.29182.20.camel@david-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249584374.29182.20.camel@david-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Xiao wrote:
> Another approach is working from a different direction: the kernel
> allocates the non-cached buffer and then mmap() into user space. I have
> done that in similar situation to try to achieve "zero-copy". 

open(O_DIRECT) does DMA to arbitrary pages allocated by userspace, and
O_DIRECT is used by some important applications, so the problem still
needs to be solved in general.

-- Jamie
