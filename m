Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:59630 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbcHKOgy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 10:36:54 -0400
Date: Thu, 11 Aug 2016 08:36:52 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/4] doc: dma-buf: sphinx conversion and cleanup
Message-ID: <20160811083652.55371952@lwn.net>
In-Reply-To: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Aug 2016 16:17:56 +0530
Sumit Semwal <sumit.semwal@linaro.org> wrote:

> Convert dma-buf documentation over to sphinx; also cleanup to
> address sphinx warnings.
> 
> While at that, convert dma-buf-sharing.txt as well, and make it the
> dma-buf API guide.

Thanks for working to improve the documentation!  I do have a few overall
comments...

 - The two comment fixes are a separate thing that should go straight to
   the dma-buf maintainer, who is ... <looks> ... evidently somebody
   familiar to you :)  I assume you'll merge those two directly?

 - It looks like you create a new RST document but leave the old one in
   place.  Having two copies of the document around can only lead to
   confusion, so I think the old one should go.

 - I really wonder if we want to start carving pieces out of
   device-drivers.tmpl in this way.  I guess I would rather see the
   conversion of that book and the better integration of the other docs
   *into* it.  One of the goals of this whole thing is to unify our
   documentation, not to reinforce the silos.

Does that make sense?

Thanks,

jon
