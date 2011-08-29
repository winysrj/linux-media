Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41893 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1H2MzJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 08:55:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH/RFC v2 1/3] fbdev: Add FOURCC-based format configuration API
Date: Mon, 29 Aug 2011 14:55:35 +0200
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com> <201108291308.50244.laurent.pinchart@ideasonboard.com> <CAMuHMdUheemZVb7cPAsyPrC9LLowr+XV_5A+H1EfWWbWHeCVFw@mail.gmail.com>
In-Reply-To: <CAMuHMdUheemZVb7cPAsyPrC9LLowr+XV_5A+H1EfWWbWHeCVFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291455.36145.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Monday 29 August 2011 13:20:44 Geert Uytterhoeven wrote:
> On Mon, Aug 29, 2011 at 13:08, Laurent Pinchart wrote:
> > On Monday 29 August 2011 13:04:15 Geert Uytterhoeven wrote:
> >> On Mon, Aug 29, 2011 at 12:09, Laurent Pinchart wrote:
> >> > On Monday 29 August 2011 11:36:07 Geert Uytterhoeven wrote:
> >> >> On Mon, Aug 29, 2011 at 10:50, Laurent Pinchart wrote:
> >> [...]
> >> 
> >> > If my understanding is now correct, a V4L2 planar YUV type where Y, U
> >> > and V components are stored in separate byte-oriented planes, with
> >> > each plane storing Y, U or V components packed (such as
> >> > http://linuxtv.org/downloads/v4l- dvb-apis/V4L2-PIX-FMT-YUV422P.html),
> >> > would be of neither FB_TYPE_PLANES nor FB_TYPE_PACKED. The same would
> >> > be true for an RGB format where each component is stored in a
> >> > separate plane with each plane sotring R, G or B packed.
> >> 
> >> Indeed. Currently this cannot be represented.
> > 
> > Good, at least I now understand the situation :-)
> > 
> >> For ideas from the past, see e.g.
> >> http://comments.gmane.org/gmane.linux.fbdev.devel/10951.
> >> 
> >> > If the above is correct, what FB_TYPE_* should a driver report when
> >> > using FB_VISUAL_FOURCC with V4L2_PIX_FMT_YUV422P
> >> > (http://linuxtv.org/downloads/v4l- dvb-apis/V4L2-PIX-FMT-YUV422P.html)
> >> > or V4L2_PIX_FMT_NV12
> >> > (http://linuxtv.org/downloads/v4l-dvb-apis/re25.html) for instance ?
> >> 
> >> We need new types for those. Or always use FOURCC for them.
> > 
> > My proposal currently defined FB_VISUAL_FOURCC. What about adding
> > FB_TYPE_FOURCC as well ?
> 
> That may make sense.
> When will the driver report FB_{TYPE,VISUAL}_FOURCC?
>   - When using a mode that cannot be represented in the legacy way,

Definitely.

>   - But what with modes that can be represented? Legacy software cannot
>     handle FB_{TYPE,VISUAL}_FOURCC.

My idea was to use FB_{TYPE,VISUAL}_FOURCC only when the mode is configured 
using the FOURCC API. If FBIOPUT_VSCREENINFO is called with a non-FOURCC 
format, the driver will report non-FOURCC types and visuals.

-- 
Regards,

Laurent Pinchart
