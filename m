Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59514 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1JHPvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 11:51:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: omap3-isp status
Date: Sat, 8 Oct 2011 17:51:37 +0200
Cc: Enrico <ebutera@users.berlios.de>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com> <CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com> <CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
In-Reply-To: <CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110081751.38953.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 07 October 2011 11:31:46 Javier Martinez Canillas wrote:
> On Fri, Oct 7, 2011 at 10:54 AM, Enrico wrote:
> > On Thu, Oct 6, 2011 at 6:05 PM, Javier Martinez Canillas wrote:
> >> On Thu, Oct 6, 2011 at 5:25 PM, Enrico wrote:
> >>> - i don't see Deepthy patches, it seems to be based on the
> >>> pre-Deepthy-patches driver and fixed (not that this is a bad thing!);
> >>> i say this because, like Gary, i'm interested in a possible forward
> >>> porting to a more recent kernel so i was searching for a starting
> >>> point
> >> 
> >> I didn't know there was a more recent version of Deepthy patches,
> >> Since they are not yet in mainline we should decide if we work on top
> >> of that or on top of mainline. Deepthy patches are very good to
> >> separate bt656 and non-bt656 execution inside the ISP, also add a
> >> platform data variable to decide which mode has to be used.
> >> 
> >> But reading the documentation and from my experimental validation I
> >> think that there are a few things that can be improved.
> >> 
> >> First the assumption that we can use FLDSTAT to check if a frame is
> >> ODD or EVEN I find to not always be true. Also I don't know who sets
> >> this value since in the TRM always talks as it is only used with
> >> discrete syncs.
> > 
> > Yes about FLDSTAT i noticed the same thing. And that's why we need
> > someone that knows the ISP better to help us....
> 
> Great, good to know that I'm not the only one that noticed this behavior.
> 
> >> Also, I don't think that we should change the ISP CCDC configuration
> >> inside the VD0 interrupt handler. Since the shadowed registers only
> >> can be accessed during a frame processing, or more formally the new
> >> values are taken at the beginning of a frame execution.
> >> 
> >> By the time we change for example the output address memory for the
> >> next buffer in the VD0 handler, the next frame is already being
> >> processed so that value won't be used for the CCDC until that frame
> >> finish. So It is not behaving as the code expect, since for 3 frames
> >> the CCDC output memory address will be the same.
> >> 
> >> That is why I move most of the logic to the VD1 interrupt since there
> >> the current frame didn't finish yet and we can configure the CCDC for
> >> the next frame.
> >> 
> >> But to do that the buffer for the next frame and the releasing of the
> >> last buffer can't happen simultaneously, that is why I decouple these
> >> two actions.
> >> 
> >> Again, this is my own observations and what I understood from the TRM
> >> and I could be wrong.
> > 
> > I can't comment on that, i hope Laurent or Deepthy will join the
> > discussion...
> 
> I second you on that, we need someone who knows the ISP better than we
> do. I have to fix this anyway, so it is better if I can do it the
> right way and the code gos upstream, so we don't have to internally
> maintain a separate patch-set and forward port for each kernel release
> we do.

Two quick comments, as I haven't had time to look into this recently.

1. I've updated the omap3isp-omap3isp-yuv branch with a new CCDC YUV support 
patch which should (hopefully) configure the bridge automatically and report 
correct formats at the CCDC output. The patch hasn't been tested as I still 
don't have access to YUV hardware.

2. Could you guys please rebase all your patches on top of the omap3isp-
omap3isp-yuv branch ? I will then review them.

> >>> - i don't think that adding the "priv" field in v4l2-mediabus.h will
> >>> be accepted, and since it is related to the default cropping you added
> >>> i think it can be dropped and just let the user choose the appropriate
> >>> cropping
> >> 
> >> Yes, probably is too much of a hack, but I didn't know of another way
> >> that the subdev could report to the ISP of the standard and since
> >> v4l2_pix_format has also a priv field, I think it could be at least a
> >> temporary solution (remember that we want this to work first and then
> >> we plan to do it right for upstream submission).
> > 
> > ...and my hope continues here.

-- 
Regards,

Laurent Pinchart
