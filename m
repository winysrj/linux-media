Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39440 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeBVSpa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 13:45:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4] v4l: vsp1: Fix video output on R8A77970
Date: Thu, 22 Feb 2018 20:46:14 +0200
Message-ID: <3820953.2gBQCZcdRS@avalon>
In-Reply-To: <1b9689ae-487e-312f-a881-b97f140cb6a2@cogentembedded.com>
References: <11341738.DVmQoThvsb@avalon> <20180222163200.3900-1-laurent.pinchart+renesas@ideasonboard.com> <1b9689ae-487e-312f-a881-b97f140cb6a2@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Thursday, 22 February 2018 20:34:37 EET Sergei Shtylyov wrote:
> On 02/22/2018 07:32 PM, Laurent Pinchart wrote:
> > From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> > 
> > Commit d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL,
> > and VSP2-D instances") added support for the VSP2-D found in the R-Car
> > V3M (R8A77970) but the video output that VSP2-D sends to DU has a greenish
> > garbage-like line repeated every 8 screen rows. It turns out that R-Car
> > V3M has the LIF0 buffer attribute register that you need to set to a non-
> > default value in order to get rid of the output artifacts.
> > 
> > Based on the original (and large) patch by Daisuke Matsushita
> > <daisuke.matsushita.ns@hitachi.com>.
> > 
> > Fixes: d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and
> > VSP2-D instances") Signed-off-by: Sergei Shtylyov
> > <sergei.shtylyov@cogentembedded.com> Reviewed-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com> [Removed braces, added
> > VI6_IP_VERSION_MASK to improve readabiliy]
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> [...]
> 
> > diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
> > b/drivers/media/platform/vsp1/vsp1_regs.h index
> > b1912c83a1da..dae0c1901297 100644
> > --- a/drivers/media/platform/vsp1/vsp1_regs.h
> > +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> 
> [...]
> 
> > @@ -705,6 +710,7 @@
> >   */
> >  
> >  #define VI6_IP_VERSION			0x3f00
> > 
> > +#define VI6_IP_VERSION_MASK		(0xffff << 0)
> 
> Perhaps (VI6_IP_VERSION_MODEL_MASK | VI6_IP_VERSION_SOC_MASK) would be 
> clearer?

I thought about it and the line length went over 80 characters so I went for 
an easy solution. I can change it if you want.

-- 
Regards,

Laurent Pinchart
