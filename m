Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47164 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1H2LEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 07:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <201108291209.08349.laurent.pinchart@ideasonboard.com>
References: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<201108291050.59109.laurent.pinchart@ideasonboard.com>
	<CAMuHMdW9KPBJpTPYmCTmFG=G_7_tiFti-b3wzTM9Q5J7U9+JWg@mail.gmail.com>
	<201108291209.08349.laurent.pinchart@ideasonboard.com>
Date: Mon, 29 Aug 2011 13:04:15 +0200
Message-ID: <CAMuHMdU3eO34zmGVejUj4B7Z5JWiwM_pieoycfinSspSiL1reQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 1/3] fbdev: Add FOURCC-based format configuration API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Aug 29, 2011 at 12:09, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Monday 29 August 2011 11:36:07 Geert Uytterhoeven wrote:
>> On Mon, Aug 29, 2011 at 10:50, Laurent Pinchart wrote:

[...]

> If my understanding is now correct, a V4L2 planar YUV type where Y, U and V
> components are stored in separate byte-oriented planes, with each plane
> storing Y, U or V components packed (such as http://linuxtv.org/downloads/v4l-
> dvb-apis/V4L2-PIX-FMT-YUV422P.html), would be of neither FB_TYPE_PLANES nor
> FB_TYPE_PACKED. The same would be true for an RGB format where each component
> is stored in a separate plane with each plane sotring R, G or B packed.

Indeed. Currently this cannot be represented.
For ideas from the past, see e.g.
http://comments.gmane.org/gmane.linux.fbdev.devel/10951.

> If the above is correct, what FB_TYPE_* should a driver report when using
> FB_VISUAL_FOURCC with V4L2_PIX_FMT_YUV422P (http://linuxtv.org/downloads/v4l-
> dvb-apis/V4L2-PIX-FMT-YUV422P.html) or V4L2_PIX_FMT_NV12
> (http://linuxtv.org/downloads/v4l-dvb-apis/re25.html) for instance ?

We need new types for those. Or always use FOURCC for them.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
