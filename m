Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58772 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab1CXTGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 15:06:21 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinYHzCgXe9yw1rGHZA0uM=-VrY+Mktpn-HvfRyR@mail.gmail.com>
References: <1300815176-21206-1-git-send-email-mythripk@ti.com>
	<AANLkTim61Xdo6ED7mr_SvpLuotso89RdR6Qaz-GCXOmJ@mail.gmail.com>
	<AANLkTinMUCbaEVjwZsHG9BxFVjx0YxS=Sw+3gViDJXhg@mail.gmail.com>
	<20110323081820.5b37d169@jbarnes-desktop>
	<AANLkTinYHzCgXe9yw1rGHZA0uM=-VrY+Mktpn-HvfRyR@mail.gmail.com>
Date: Thu, 24 Mar 2011 12:06:19 -0700
Message-ID: <AANLkTi=Yc0Pg9uCZcTei45PLbERutoRc7XyoFghwS=KV@mail.gmail.com>
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
From: Corbin Simpson <mostawesomedude@gmail.com>
To: "K, Mythri P" <mythripk@ti.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 24, 2011 at 2:51 AM, K, Mythri P <mythripk@ti.com> wrote:
> Hi Jesse,
>
> On Wed, Mar 23, 2011 at 8:48 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Wed, 23 Mar 2011 18:58:27 +0530
>> "K, Mythri P" <mythripk@ti.com> wrote:
>>
>>> Hi Dave,
>>>
>>> On Wed, Mar 23, 2011 at 6:16 AM, Dave Airlie <airlied@gmail.com> wrote:
>>> > On Wed, Mar 23, 2011 at 3:32 AM, Mythri P K <mythripk@ti.com> wrote:
>>> >> Adding support for common EDID parsing in kernel.
>>> >>
>>> >> EDID - Extended display identification data is a data structure provided by
>>> >> a digital display to describe its capabilities to a video source, This a
>>> >> standard supported by CEA and VESA.
>>> >>
>>> >> There are several custom implementations for parsing EDID in kernel, some
>>> >> of them are present in fbmon.c, drm_edid.c, sh_mobile_hdmi.c, Ideally
>>> >> parsing of EDID should be done in a library, which is agnostic of the
>>> >> framework (V4l2, DRM, FB)  which is using the functionality, just based on
>>> >> the raw EDID pointer with size/segment information.
>>> >>
>>> >> With other RFC's such as the one below, which tries to standardize HDMI API's
>>> >> It would be better to have a common EDID code in one place.It also helps to
>>> >> provide better interoperability with variety of TV/Monitor may be even by
>>> >> listing out quirks which might get missed with several custom implementation
>>> >> of EDID.
>>> >> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30401
>>> >>
>>> >> This patch tries to add functions to parse some portion EDID (detailed timing,
>>> >> monitor limits, AV delay information, deep color mode support, Audio and VSDB)
>>> >> If we can align on this library approach i can enhance this library to parse
>>> >> other blocks and probably we could also add quirks from other implementation
>>> >> as well.
>>> >>
>>> >
>>> > If you want to take this approach, you need to start from the DRM EDID parser,
>>> > its the most well tested and I can guarantee its been plugged into more monitors
>>> > than any of the others. There is just no way we would move the DRM parser to a
>>> > library one that isn't derived from it + enhancements, as we'd throw away the
>>> > years of testing and the regression count would be way too high.
>>> >
>>> I had a look at the DRM EDID code, but for quirks it looks pretty much the same.
>>> yes i could take quirks and other DRM tested code and enhance, but
>>> still the code has to do away with struct drm_display_mode
>>> which is very much custom to DRM.
>>
>> If that's the only issue you have, we could easily rename that
>> structure or add conversion funcs to a smaller structure if that's what
>> you need.
>>
>> Dave's point is that we can't ditch the existing code without
>> introducing a lot of risk; it would be better to start a library-ized
>> EDID codebase from the most complete one we have already, i.e. the DRM
>> EDID code.
>>
> This sounds good. If we can remove the DRM dependent portion to have a
> library-ized EDID code,
> That would be perfect. The main Intention to have a library is,
> Instead of having several different Implementation in kernel, all
> doing the same EDID parsing , if we could have one single
> implementation , it would help in better testing and interoperability.
>
>> Do you really think the differences between your code and the existing
>> DRM code are irreconcilable?
>>
> On the contrary if there is a library-ized  EDID parsing using the
> drm_edid, and there is any delta / fields( Parsing the video block in
> CEA extension for Short Video Descriptor, Vendor block for AV delay
> /Deep color information etc) that are parsed with the RFC i posted i
> would be happy to add.

Something just occurred to me. Why do video input drivers need EDID?
Perhaps I'm betraying my youth here, but none of my TV tuners have the
ability to read EDIDs in from the other side of the coax/RCA jack, and
IIUC they really only care about whether they're receiving NTSC or
PAL. The only drivers that should be parsing EDIDs are FB and KMS
drivers, right?

So why should this be a common library? Most kernel code doesn't need
it. Or is there a serious need for video input to parse EDIDs?

~ C.

-- 
When the facts change, I change my mind. What do you do, sir? ~ Keynes

Corbin Simpson
<MostAwesomeDude@gmail.com>
