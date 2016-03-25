Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40608 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbcCYI3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 04:29:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 00/51] R-Car VSP improvements for v4.6
Date: Fri, 25 Mar 2016 10:29:45 +0200
Message-ID: <4370353.kdHmKTOgsC@avalon>
In-Reply-To: <CAMuHMdUAtZAP+oeKgD_ufvfgR6ieOohMpaP9gT+asuypENbjYg@mail.gmail.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAMuHMdUAtZAP+oeKgD_ufvfgR6ieOohMpaP9gT+asuypENbjYg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Friday 25 Mar 2016 09:08:14 Geert Uytterhoeven wrote:
> On Fri, Mar 25, 2016 at 12:26 AM, Laurent Pinchart wrote:
> > This patch series contains all the pending vsp1 driver improvements for
> > v4.6.
>
> v4.6 or v4.7?

My bad, it's of course v4.7. That what you get when posting patches late in 
the night, time blurs and the past, present and future all become one.

(I'll refrain from quoting Doctor Who here, although the influence of a TARDIS 
on kernel development would be an interesting subject to study.)

> > In particular, it enables display list usage in non-DRM pipelines (24/51)
> > and adds support for multi-body display lists (48/51) and the R-Car Gen3
> > RPF alpha multiplier (50/51) and Z-order control (51/51).
> > 
> > The other patches are cleanups, bug fixes and refactoring to support the
> > four features listed above.
> > 
> > The code is based on top of the "[PATCH v6 0/2] media: Add entity types"
> > patch series. For convenience I've pushed a branch that contains all the
> > necessary patches on top of the latest Linux media master branch to
> > 
> >         git://linuxtv.org/pinchartl/media.git vsp1/next
> > 
> > Note that while patch 51/51 enables support for Z-order control in the
> > vsp1 driver, enabling the feature for userspace requires an additional
> > patch for the rcar-du-drm driver. I have pushed a branch that includes the
> > rcar-du-drm changes and platform enablements to
> > 
> >         git://linuxtv.org/pinchartl/media.git drm/du/vsp1-kms/boards
> 
> I assume this is the branch to be included by renesas-drivers?

That's correct. I'll update the branch with more patches in the very near 
future, likely today. I'll keep you informed.

-- 
Regards,

Laurent Pinchart

