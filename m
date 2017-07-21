Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36674 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdGUKrC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 06:47:02 -0400
Received: by mail-wm0-f67.google.com with SMTP id 184so3930085wmo.3
        for <linux-media@vger.kernel.org>; Fri, 21 Jul 2017 03:47:01 -0700 (PDT)
Date: Fri, 21 Jul 2017 11:46:48 +0100
From: Javi Merino <javi.merino@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH] Revert "[media] v4l: async: make v4l2 coexist with
 devicetree nodes in a dt overlay"
Message-ID: <20170721104648.GA2297@ct-lt-587>
References: <20170720220622.21470-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170720220622.21470-1-robh@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 20, 2017 at 05:06:22PM -0500, Rob Herring wrote:
> This reverts commit d2180e0cf77dc7a7049671d5d57dfa0a228f83c1.
> 
> The commit was flawed in that if the device_node pointers are different,
> then in fact a different device is present and the device node could be
> different in ways other than full_name.
> 
> As Frank Rowand explained:
> 
> "When an overlay (1) is removed, all uses and references to the nodes and
> properties in that overlay are no longer valid.  Any driver that uses any
> information from the overlay _must_ stop using any data from the overlay.
> Any driver that is bound to a new node in the overlay _must_ unbind.  Any
> driver that became bound to a pre-existing node that was modified by the
> overlay (became bound after the overlay was applied) _must_ adjust itself
> to account for any changes to that node when the overlay is removed.  One
> way to do this is to unbind when notified that the overlay is about to
> be removed, then to re-bind after the overlay is completely removed.
> 
> If an overlay (2) is subsequently applied, a node with the same
> full_name as from overlay (1) may exist.  There is no guarantee
> that overlay (1) and overlay (2) are the same overlay, even if
> that node has the same full_name in both cases."
> 
> Also, there's not sufficient overlay support in mainline to actually
> remove and re-apply an overlay to hit this condition as overlays can
> only be applied from in kernel APIs.
> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Javi Merino <javi.merino@kernel.org>
> Cc: Javier Martinez Canillas <javier@osg.samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Frank Rowand <frowand.list@gmail.com>
> Signed-off-by: Rob Herring <robh@kernel.org>

I've been trying to reproduce the original issues that I had for a
couple of hours and I am not able to any more, so I can't object to
the patch.  The explanation from Frank Rowand is sound so:

Acked-by: Javi Merino <javi.merino@kernel.org>

> ---
> Mauro, please apply this for 4.13. It could be marked for stable, too, 
> but it's not going to apply cleanly with the fwnode changes.
> 
> Rob
> 
>  drivers/media/v4l2-core/v4l2-async.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
