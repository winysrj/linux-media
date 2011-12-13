Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52886 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab1LMLqM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 06:46:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 0/3] fbdev: Add FOURCC-based format configuration API
Date: Tue, 13 Dec 2011 12:46:26 +0100
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org
References: <1322562419-9934-1-git-send-email-laurent.pinchart@ideasonboard.com> <201112130140.45045.laurent.pinchart@ideasonboard.com> <CAMuHMdVggt5wqKjBFjHYT4GH5M8rFUG_sOMB2aH5YrzEGH_VSA@mail.gmail.com>
In-Reply-To: <CAMuHMdVggt5wqKjBFjHYT4GH5M8rFUG_sOMB2aH5YrzEGH_VSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112131246.28062.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Tuesday 13 December 2011 11:47:02 Geert Uytterhoeven wrote:
> On Tue, Dec 13, 2011 at 01:40, Laurent Pinchart wrote:
> >> I think you also want to do something with red, green, blue, transp when
> >> entering FOURCC mode, at least setting them to zero or maybe even
> >> requiring that they are zero to enter FOURCC mode (as additional safety
> >> barrier).
> > 
> > Agreed. The FOURCC mode documentation already requires those fields to be
> > set to 0 by applications.
> > 
> > I'll enforce this in fb_set_var() if info->fix has the FB_CAP_FOURCC
> > capability flag set.
> 
> So when info->fix has the FB_CAP_FOURCC capability flag set, you can no
> longer enter legacy mode?

No, when info->fix has the FB_CAP_FOURCC capability, you can no longer enter 
legacy mode with grayscale > 1. You can still use grayscale = 0 and grayscale 
= 1 for legacy mode. The grayscale field should not have values greater than 1 
in legacy mode anyway, so that should be safe.

-- 
Regards,

Laurent Pinchart
