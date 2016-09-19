Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37397 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932237AbcISSc0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 14:32:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 06/13] v4l: vsp1: Disable cropping on WPF sink pad
Date: Mon, 19 Sep 2016 21:33:13 +0300
Message-ID: <15522801.GRSqLoE04r@avalon>
In-Reply-To: <20160919152615.4b321a61@vento.lan>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <6925382.EfY6pk391A@avalon> <20160919152615.4b321a61@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 19 Sep 2016 15:26:15 Mauro Carvalho Chehab wrote:
> Em Mon, 19 Sep 2016 20:59:56 +0300 Laurent Pinchart escreveu:
> > On Monday 19 Sep 2016 14:55:43 Mauro Carvalho Chehab wrote:
> >> Em Wed, 14 Sep 2016 02:16:59 +0300 Laurent Pinchart escreveu:
> >>> Cropping on the WPF sink pad restricts the left and top coordinates to
> >>> 0-255. The same result can be obtained by cropping on the RPF without
> >>> any such restriction, this feature isn't useful. Disable it.
> >>> 
> >>> Signed-off-by: Laurent Pinchart
> >>> <laurent.pinchart+renesas@ideasonboard.com>
> >>> ---
> >>> 
> >>>  drivers/media/platform/vsp1/vsp1_rwpf.c | 37 ++++++++++++------------
> >>>  drivers/media/platform/vsp1/vsp1_wpf.c  | 18 +++++++---------
> >>>  2 files changed, 26 insertions(+), 29 deletions(-)
> >>> 
> >>> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c
> >>> b/drivers/media/platform/vsp1/vsp1_rwpf.c index
> >>> 8cb87e96b78b..a3ace8df7f4d 100644
> >>> --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> >>> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c

[snip]

> >>> @@ -129,8 +132,10 @@ static int vsp1_rwpf_get_selection(struct
> >>> v4l2_subdev *subdev,
> >>>  	struct v4l2_mbus_framefmt *format;
> >>>  	int ret = 0;
> >>> 
> >>> -	/* Cropping is implemented on the sink pad. */
> >>> -	if (sel->pad != RWPF_PAD_SINK)
> >>> +	/* Cropping is only supported on the RPF and is implemented on
> >>> the sink
> >>> +	 * pad.
> >>> +	 */
> >> 
> >> Please read CodingStyle and run checkpatch before sending stuff
> >> upstream.
> >> 
> >> This violates the CodingStyle: it should be, instead:
> >> 	/*
> >> 	 * foo
> >> 	 * bar
> >> 	 */
> > 
> > But it's consistent with the coding style of this driver. I'm OK fixing
> > it, but it should be done globally in that case.
> 
> There are inconsistencies inside the driver too on multi-line
> comments even without fixing the ones introduced on this series,
> as, on several places, multi-line comments are correct:
> 
> drivers/media/platform/vsp1/vsp1_bru.c:/*
> drivers/media/platform/vsp1/vsp1_bru.c- * The BRU can't perform format
> conversion, all sink and source formats must be
> drivers/media/platform/vsp1/vsp1_bru.c- * identical. We pick the format on
> the first sink pad (pad 0) and propagate it
> drivers/media/platform/vsp1/vsp1_bru.c- * to all other pads.
> drivers/media/platform/vsp1/vsp1_bru.c- */
> 
> drivers/media/platform/vsp1/vsp1_dl.c:/*
> drivers/media/platform/vsp1/vsp1_dl.c- * Initialize a display list body
> object and allocate DMA memory for the body
> drivers/media/platform/vsp1/vsp1_dl.c- * data. The display list body object
> is expected to have been initialized to
> drivers/media/platform/vsp1/vsp1_dl.c- * 0 when allocated.
> drivers/media/platform/vsp1/vsp1_dl.c- */
> 
> ...
> 
> I'll address the ones only the CodingStyle violation introduced by this
> series. I'll leave for the vsp1 maintainers/developers.

OK, I'll address that.

> Btw, there are several kernel-doc tags that use just:
> 	/*
> 	 ...
> 	 */
> 
> instead of:
> 
> 	/**
> 	 ...
> 	 */
> 
> I suggest you to add the files/headers with kernel-doc markups on
> a Documentation/media/v4l-drivers/vsp1.rst file, to be created.
> 
> This way, you can validate that such documentation is correct,
> and produce an auto-generated documentation for this driver.

I've thought about it, but I don't think those comments should become part of 
the kernel documentation. They're really about driver internals, and meant for 
the driver developers. In particular only a subset of the driver is documented 
that way, when I've considered that the code or structures were complex enough 
to need proper documentation. A generated doc would then be quite incomplete 
and not very useful, the comments are meant to be read while working on the 
code.

-- 
Regards,

Laurent Pinchart

