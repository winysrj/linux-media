Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:28617 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2ACJ0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 04:26:50 -0500
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LX7001FPU8M8XD0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Jan 2012 18:26:49 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LX7001LIU8KYC70@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Tue, 03 Jan 2012 18:26:49 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, mchehab@redhat.com,
	'Hans Verkuil' <hans.verkuil@cisco.com>
References: <1324994844-9883-1-git-send-email-k.debski@samsung.com>
 <201201030214.07855.laurent.pinchart@ideasonboard.com>
In-reply-to: <201201030214.07855.laurent.pinchart@ideasonboard.com>
Subject: RE: [PATCH] s5p-mfc: Fix volatile controls setup
Date: Tue, 03 Jan 2012 10:26:43 +0100
Message-id: <008201ccc9f9$d17558b0$74600a10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for pointing this out, my comment is below.
Hans, I would be grateful if you could also read this and comment :)

> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: 03 January 2012 02:14
> 
> Hi Kamil,
> 
> On Tuesday 27 December 2011 15:07:24 Kamil Debski wrote:
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> > b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c index 844a4d7..c25ec02 100644
> > --- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> > +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> > @@ -165,7 +165,7 @@ static struct mfc_control controls[] = {
> >  		.maximum = 32,
> >  		.step = 1,
> >  		.default_value = 1,
> > -		.flags = V4L2_CTRL_FLAG_VOLATILE,
> > +		.is_volatile = 1,
> >  	},
> >  };
> 
> Why so ? is_volatile got removed in commit
> 88365105d683187e02a4f75220eaf51fd0c0b6e0.
> 

Yep, this commit broke MFC, as after it has been applied volatile flag was not
set for any of the controls. 

>From 88365105d683187e02a4f75220eaf51fd0c0b6e0.
------------------ drivers/media/video/s5p-mfc/s5p_mfc_dec.c ------------------
index 32f8989..bfbe084 100644
@@ -165,7 +165,7 @@ static struct mfc_control controls[] = {
 		.maximum = 32,
 		.step = 1,
 		.default_value = 1,
-		.is_volatile = 1,
+		.flags = V4L2_CTRL_FLAG_VOLATILE,
 	},
 };
 
@@ -1020,7 +1020,7 @@ int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx)
 			return ctx->ctrl_handler.error;
 		}
 		if (controls[i].is_volatile && ctx->ctrls[i])
-			ctx->ctrls[i]->is_volatile = 1;
+			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
 	}
 	return 0;
 }

See? In the controls array the is_volatile field was no longer set, but it was
used
in the s5p_mfc_dec_ctrls_setup. Thus is was always 0.

The v4l2_ctrl_new_custom/v4l2_ctrl_new_std functions set the flags field
(which is done in v4l2_ctrl_fill).
It is also possible to |= the flag with the current contents of the field.

-		if (controls[i].is_volatile && ctx->ctrls[i])
+		if (ctx->ctrls[i])
-			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
+			ctx->ctrls[i]->flags |= controls[i].flags;
This is possible, as it would set all the flags set in controls[] array.

Also checking for V4L2_CTRL_FLAG_VOLATILE in controls[x].flags and then setting
ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE is possible, but I think it is
not
necessary. The above solution should work fine as well. 

The thing is that I did not notice Hans's commit and thought that it was my
mistake in MFC.
Thus I have fixed it in the simplest way. (It would be nice if I had been added
to CC of that patch)

Hans, if you could comment on which from the aforementioned solutions do you find
the best?
The one from my commit, or the proposed above?

Also - maybe VOLATILE flag for V4L2_CID_MIN_BUFFERS_FOR_CAPTURE should be set in
v4l2_ctrl_fill?
Though I am not sure it would be the case for all devices.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

