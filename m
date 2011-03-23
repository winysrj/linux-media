Return-path: <mchehab@pedra>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:45656 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932870Ab1CWPS0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 11:18:26 -0400
Date: Wed, 23 Mar 2011 08:18:20 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "K, Mythri P" <mythripk@ti.com>
Cc: Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
	linux-omap@vger.kernel.org,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
Message-ID: <20110323081820.5b37d169@jbarnes-desktop>
In-Reply-To: <AANLkTinMUCbaEVjwZsHG9BxFVjx0YxS=Sw+3gViDJXhg@mail.gmail.com>
References: <1300815176-21206-1-git-send-email-mythripk@ti.com>
	<AANLkTim61Xdo6ED7mr_SvpLuotso89RdR6Qaz-GCXOmJ@mail.gmail.com>
	<AANLkTinMUCbaEVjwZsHG9BxFVjx0YxS=Sw+3gViDJXhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 23 Mar 2011 18:58:27 +0530
"K, Mythri P" <mythripk@ti.com> wrote:

> Hi Dave,
> 
> On Wed, Mar 23, 2011 at 6:16 AM, Dave Airlie <airlied@gmail.com> wrote:
> > On Wed, Mar 23, 2011 at 3:32 AM, Mythri P K <mythripk@ti.com> wrote:
> >> Adding support for common EDID parsing in kernel.
> >>
> >> EDID - Extended display identification data is a data structure provided by
> >> a digital display to describe its capabilities to a video source, This a
> >> standard supported by CEA and VESA.
> >>
> >> There are several custom implementations for parsing EDID in kernel, some
> >> of them are present in fbmon.c, drm_edid.c, sh_mobile_hdmi.c, Ideally
> >> parsing of EDID should be done in a library, which is agnostic of the
> >> framework (V4l2, DRM, FB)  which is using the functionality, just based on
> >> the raw EDID pointer with size/segment information.
> >>
> >> With other RFC's such as the one below, which tries to standardize HDMI API's
> >> It would be better to have a common EDID code in one place.It also helps to
> >> provide better interoperability with variety of TV/Monitor may be even by
> >> listing out quirks which might get missed with several custom implementation
> >> of EDID.
> >> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30401
> >>
> >> This patch tries to add functions to parse some portion EDID (detailed timing,
> >> monitor limits, AV delay information, deep color mode support, Audio and VSDB)
> >> If we can align on this library approach i can enhance this library to parse
> >> other blocks and probably we could also add quirks from other implementation
> >> as well.
> >>
> >
> > If you want to take this approach, you need to start from the DRM EDID parser,
> > its the most well tested and I can guarantee its been plugged into more monitors
> > than any of the others. There is just no way we would move the DRM parser to a
> > library one that isn't derived from it + enhancements, as we'd throw away the
> > years of testing and the regression count would be way too high.
> >
> I had a look at the DRM EDID code, but for quirks it looks pretty much the same.
> yes i could take quirks and other DRM tested code and enhance, but
> still the code has to do away with struct drm_display_mode
> which is very much custom to DRM.

If that's the only issue you have, we could easily rename that
structure or add conversion funcs to a smaller structure if that's what
you need.

Dave's point is that we can't ditch the existing code without
introducing a lot of risk; it would be better to start a library-ized
EDID codebase from the most complete one we have already, i.e. the DRM
EDID code.

Do you really think the differences between your code and the existing
DRM code are irreconcilable?

-- 
Jesse Barnes, Intel Open Source Technology Center
