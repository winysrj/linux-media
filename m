Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33797 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbFNK3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 06:29:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: Re: [PATCH v2 6/6] staging: media: omap4iss: ipipe: Expose the RGB2RGB blending matrix
Date: Sun, 14 Jun 2015 13:30:16 +0300
Message-ID: <1879561.VjzCEG2LFt@avalon>
In-Reply-To: <109421334.Lm3XXHQ8EE@avalon>
References: <1422436639-18292-1-git-send-email-laurent.pinchart@ideasonboard.com> <54C8B976.3090908@xs4all.nl> <109421334.Lm3XXHQ8EE@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 28 January 2015 14:18:20 Laurent Pinchart wrote:
> On Wednesday 28 January 2015 11:27:02 Hans Verkuil wrote:
> > On 01/28/15 10:17, Laurent Pinchart wrote:
> >> Expose the module as two controls, one for the 3x3 multiplier matrix and
> >> one for the 3x1 offset vector.
> >> 
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> ---
> >> 
> >>  drivers/staging/media/omap4iss/iss_ipipe.c | 129 +++++++++++++++++++++-
> >>  drivers/staging/media/omap4iss/iss_ipipe.h |  17 ++++
> >>  2 files changed, 144 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c
> >> b/drivers/staging/media/omap4iss/iss_ipipe.c index 73b165e..624c5d2
> >> 100644
> >> --- a/drivers/staging/media/omap4iss/iss_ipipe.c
> >> +++ b/drivers/staging/media/omap4iss/iss_ipipe.c
> >> @@ -119,6 +119,105 @@ static void ipipe_configure(struct
> >> iss_ipipe_device *ipipe)
> >>  }
> >>  
> >>  /* --------------------------------------------------------------------
> >> + * V4L2 controls
> >> + */
> >> +
> >> +#define OMAP4ISS_IPIPE_CID_BASE			(V4L2_CID_USER_BASE | 0xf000)
> > 
> > Private control ranges should be reserved in uapi/linux/v4l2-controls.h.
> > 
> > See e.g. V4L2_CID_USER_SAA7134_BASE.
> 
> My bad, I'll fix that.
> 
> >> +#define OMAP4ISS_IPIPE_CID_RGB2RGB_MULT		(OMAP4ISS_IPIPE_CID_BASE
> >> + 0)
> >> +#define OMAP4ISS_IPIPE_CID_RGB2RGB_OFFSET	(OMAP4ISS_IPIPE_CID_BASE
> >> + 1)
> 
> > Can you give some information how the values are interpreted? That should
> > be documented anyway, but I would like to see how this compares to the
> > adv drivers. This is something that we might want to make available as
> > standard controls. I will have to think about that a bit more.
> 
> Sure.
> 
> http://www.ti.com/lit/pdf/swpu235, section 8.3.3.4.6, page 1863.
> 
> /       \   /                         \   /      \   /          \
> | R_out |   | gain_RR gain_GR gain_BR |   | R_in |   | offset_R |
> | G_out | = | gain_RG gain_GG gain_BG | x | G_in | + | offset_G |
> | B_out |   | gain_RB gain_GB gain_BB |   | B_in |   | offset_B |
> \       /   \                         /   \      /   \          /
> 
> The two controls correspond to the multiplication matrix and offset vector.
> Coefficients are stored in 16 bits each and expressed as S3.8 (-4 to +3.996)
> for the gains and S11 (-1024 to 1023) for the offsets.
> 
> Note that the ISS IPIPE has two RGB to RGB blending matrices as shown on
> figure 8-132, page 1859. This patch implements support for the first one
> only. We should probably consider how to expose the second one as well.

Have you had a chance to compare this to the ADV* drivers ?

-- 
Regards,

Laurent Pinchart

