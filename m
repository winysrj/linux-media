Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43695 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933676Ab1CXTWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 15:22:10 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1103242001460.21914@axis700.grange>
References: <1300815176-21206-1-git-send-email-mythripk@ti.com>
	<AANLkTim61Xdo6ED7mr_SvpLuotso89RdR6Qaz-GCXOmJ@mail.gmail.com>
	<AANLkTinMUCbaEVjwZsHG9BxFVjx0YxS=Sw+3gViDJXhg@mail.gmail.com>
	<20110323081820.5b37d169@jbarnes-desktop>
	<AANLkTinYHzCgXe9yw1rGHZA0uM=-VrY+Mktpn-HvfRyR@mail.gmail.com>
	<Pine.LNX.4.64.1103242001460.21914@axis700.grange>
Date: Thu, 24 Mar 2011 15:22:09 -0400
Message-ID: <AANLkTinsrboO32SsA1_REUf6SecviocHJ4mfj1x97NRA@mail.gmail.com>
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
From: Alex Deucher <alexdeucher@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "K, Mythri P" <mythripk@ti.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
	linux-omap@vger.kernel.org,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 24, 2011 at 3:13 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 24 Mar 2011, K, Mythri P wrote:
>
>> Hi Jesse,
>>
>> On Wed, Mar 23, 2011 at 8:48 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> > On Wed, 23 Mar 2011 18:58:27 +0530
>> > "K, Mythri P" <mythripk@ti.com> wrote:
>> >
>> >> Hi Dave,
>> >>
>> >> On Wed, Mar 23, 2011 at 6:16 AM, Dave Airlie <airlied@gmail.com> wrote:
>> >> > On Wed, Mar 23, 2011 at 3:32 AM, Mythri P K <mythripk@ti.com> wrote:
>> >> >> Adding support for common EDID parsing in kernel.
>> >> >>
>> >> >> EDID - Extended display identification data is a data structure provided by
>> >> >> a digital display to describe its capabilities to a video source, This a
>> >> >> standard supported by CEA and VESA.
>> >> >>
>> >> >> There are several custom implementations for parsing EDID in kernel, some
>> >> >> of them are present in fbmon.c, drm_edid.c, sh_mobile_hdmi.c, Ideally
>> >> >> parsing of EDID should be done in a library, which is agnostic of the
>> >> >> framework (V4l2, DRM, FB)  which is using the functionality, just based on
>> >> >> the raw EDID pointer with size/segment information.
>> >> >>
>> >> >> With other RFC's such as the one below, which tries to standardize HDMI API's
>> >> >> It would be better to have a common EDID code in one place.It also helps to
>> >> >> provide better interoperability with variety of TV/Monitor may be even by
>> >> >> listing out quirks which might get missed with several custom implementation
>> >> >> of EDID.
>> >> >> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30401
>> >> >>
>> >> >> This patch tries to add functions to parse some portion EDID (detailed timing,
>> >> >> monitor limits, AV delay information, deep color mode support, Audio and VSDB)
>> >> >> If we can align on this library approach i can enhance this library to parse
>> >> >> other blocks and probably we could also add quirks from other implementation
>> >> >> as well.
>> >> >>
>> >> >
>> >> > If you want to take this approach, you need to start from the DRM EDID parser,
>> >> > its the most well tested and I can guarantee its been plugged into more monitors
>> >> > than any of the others. There is just no way we would move the DRM parser to a
>> >> > library one that isn't derived from it + enhancements, as we'd throw away the
>> >> > years of testing and the regression count would be way too high.
>> >> >
>> >> I had a look at the DRM EDID code, but for quirks it looks pretty much the same.
>> >> yes i could take quirks and other DRM tested code and enhance, but
>> >> still the code has to do away with struct drm_display_mode
>> >> which is very much custom to DRM.
>> >
>> > If that's the only issue you have, we could easily rename that
>> > structure or add conversion funcs to a smaller structure if that's what
>> > you need.
>> >
>> > Dave's point is that we can't ditch the existing code without
>> > introducing a lot of risk; it would be better to start a library-ized
>> > EDID codebase from the most complete one we have already, i.e. the DRM
>> > EDID code.
>
> Does the DRM EDID-parser also process blocks beyond the first one and
> also parses SVD entries similar to what I've recently added to fbdev? Yes,
> we definitely need a common EDID parses, and maybe we'll have to collect
> various pieces from different implementations.

At the moment there is only limited support for looking up things like
the hdmi block and checking for audio.

Alex

>
> Thanks
> Guennadi
>
>> >
>> This sounds good. If we can remove the DRM dependent portion to have a
>> library-ized EDID code,
>> That would be perfect. The main Intention to have a library is,
>> Instead of having several different Implementation in kernel, all
>> doing the same EDID parsing , if we could have one single
>> implementation , it would help in better testing and interoperability.
>>
>> > Do you really think the differences between your code and the existing
>> > DRM code are irreconcilable?
>> >
>> On the contrary if there is a library-ized  EDID parsing using the
>> drm_edid, and there is any delta / fields( Parsing the video block in
>> CEA extension for Short Video Descriptor, Vendor block for AV delay
>> /Deep color information etc) that are parsed with the RFC i posted i
>> would be happy to add.
>>
>> Thanks and regards,
>> Mythri.
>> > --
>> > Jesse Barnes, Intel Open Source Technology Center
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
