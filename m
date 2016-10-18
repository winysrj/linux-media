Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59500 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755573AbcJROOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 10:14:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg KH <greg@kroah.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        stable@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] v4l: rcar-fcp: Don't force users to check for disabled FCP support
Date: Tue, 18 Oct 2016 17:14:03 +0300
Message-ID: <3662992.dtXaQ41t4g@avalon>
In-Reply-To: <20161018140521.GA5102@kroah.com>
References: <1476797060-8535-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20161018140521.GA5102@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Tuesday 18 Oct 2016 16:05:21 Greg KH wrote:
> On Tue, Oct 18, 2016 at 04:24:20PM +0300, Laurent Pinchart wrote:
> > commit fd44aa9a254b18176ec3792a18e7de6977030ca8 upstream.
> > 
> > The rcar_fcp_enable() function immediately returns successfully when the
> > FCP device pointer is NULL to avoid forcing the users to check the FCP
> > device manually before every call. However, the stub version of the
> > function used when the FCP driver is disabled returns -ENOSYS
> > unconditionally, resulting in a different API contract for the two
> > versions of the function.
> > 
> > As a user that requires FCP support will fail at probe time when calling
> > rcar_fcp_get() if the FCP driver is disabled, the stub version of the
> > rcar_fcp_enable() function will only be called with a NULL FCP device.
> > We can thus return 0 unconditionally to align the behaviour with the
> > normal version of the function.
> > 
> > Fixes: 94fcdf829793 ("[media] v4l: vsp1: Add FCP support")
> > Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> > 
> >  include/media/rcar-fcp.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> What stable kernel(s) do you want this applied to?

That's for v4.8, sorry for not having mentioned it.

-- 
Regards,

Laurent Pinchart

