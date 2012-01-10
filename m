Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:5528 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab2AJJxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 04:53:23 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH] s5p-mfc: Fix volatile controls setup
Date: Tue, 10 Jan 2012 10:53:20 +0100
Cc: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, mchehab@redhat.com,
	"'Hans Verkuil'" <hans.verkuil@cisco.com>
References: <1324994844-9883-1-git-send-email-k.debski@samsung.com> <201201030214.07855.laurent.pinchart@ideasonboard.com> <008201ccc9f9$d17558b0$74600a10$%debski@samsung.com>
In-Reply-To: <008201ccc9f9$d17558b0$74600a10$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201101053.20113.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Sorry for the delay, I've been on vacation.

On Tuesday 03 January 2012 10:26:43 Kamil Debski wrote:
> Hi Laurent,
> 
> Thanks for pointing this out, my comment is below.
> Hans, I would be grateful if you could also read this and comment :)
> 
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > Sent: 03 January 2012 02:14
> > 
> > Hi Kamil,
> > 
> > On Tuesday 27 December 2011 15:07:24 Kamil Debski wrote:
> > > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > > 
> > >  drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> > > b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c index 844a4d7..c25ec02
> > > 100644 --- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> > > +++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> > > @@ -165,7 +165,7 @@ static struct mfc_control controls[] = {
> > > 
> > >  		.maximum = 32,
> > >  		.step = 1,
> > >  		.default_value = 1,
> > > 
> > > -		.flags = V4L2_CTRL_FLAG_VOLATILE,
> > > +		.is_volatile = 1,
> > > 
> > >  	},
> > >  
> > >  };
> > 
> > Why so ? is_volatile got removed in commit
> > 88365105d683187e02a4f75220eaf51fd0c0b6e0.
> 
> Yep, this commit broke MFC, as after it has been applied volatile flag was
> not set for any of the controls.
> 
> From 88365105d683187e02a4f75220eaf51fd0c0b6e0.
> ------------------ drivers/media/video/s5p-mfc/s5p_mfc_dec.c
> ------------------ index 32f8989..bfbe084 100644
> @@ -165,7 +165,7 @@ static struct mfc_control controls[] = {
>  		.maximum = 32,
>  		.step = 1,
>  		.default_value = 1,
> -		.is_volatile = 1,
> +		.flags = V4L2_CTRL_FLAG_VOLATILE,
>  	},
>  };

Hmm, this change should be reverted. 'is_volatile' is a field of your own 
struct, so there is no need to replace it. My mistake.

> 
> @@ -1020,7 +1020,7 @@ int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx)
>  			return ctx->ctrl_handler.error;
>  		}
>  		if (controls[i].is_volatile && ctx->ctrls[i])
> -			ctx->ctrls[i]->is_volatile = 1;
> +			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
>  	}
>  	return 0;
>  }

This change is fine.

> 
> See? In the controls array the is_volatile field was no longer set, but it
> was used
> in the s5p_mfc_dec_ctrls_setup. Thus is was always 0.
> 
> The v4l2_ctrl_new_custom/v4l2_ctrl_new_std functions set the flags field
> (which is done in v4l2_ctrl_fill).
> It is also possible to |= the flag with the current contents of the field.
> 
> -		if (controls[i].is_volatile && ctx->ctrls[i])
> +		if (ctx->ctrls[i])
> -			ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +			ctx->ctrls[i]->flags |= controls[i].flags;
> This is possible, as it would set all the flags set in controls[] array.

This is also an option, but then the is_volatile field should also be removed
from the mfc_control struct.

> 
> Also checking for V4L2_CTRL_FLAG_VOLATILE in controls[x].flags and then
> setting ctx->ctrls[i]->flags |= V4L2_CTRL_FLAG_VOLATILE is possible, but I
> think it is not
> necessary. The above solution should work fine as well.
> 
> The thing is that I did not notice Hans's commit and thought that it was my
> mistake in MFC.
> Thus I have fixed it in the simplest way. (It would be nice if I had been
> added to CC of that patch)

Will try to remember for the next time :-)

> Hans, if you could comment on which from the aforementioned solutions do
> you find the best?
> The one from my commit, or the proposed above?

Looking at it some more I would go for your commit to get it fixed quickly,
but I would recommend reworking the code in the longer term.

You have two types of controls: device specific, for which you can use 
v4l2_ctrl_new_custom() and struct v4l2_ctrl_config (no need for struct 
mfc_control), or standard controls for which you can use v4l2_ctrl_new_std.

So I would make an array of struct v4l2_ctrl_config containing the custom 
controls, and call v4l2_ctrl_new_std() in the control setup function for the 
standard controls. That way v4l2_ctrl_new_std() will fill in all the non-range 
fields for you (thus ensuring consistency). For the volatile control you will 
have to set the volatile flag manually.


> 
> Also - maybe VOLATILE flag for V4L2_CID_MIN_BUFFERS_FOR_CAPTURE should be
> set in v4l2_ctrl_fill?
> Though I am not sure it would be the case for all devices.

I think it shouldn't be set (yet). When we get more devices in the future we 
can reconsider.

Regards,

	Hans

> 
> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
