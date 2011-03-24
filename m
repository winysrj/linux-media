Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:51443 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934180Ab1CXWni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 18:43:38 -0400
Message-ID: <4D8BC915.60400@gmx.de>
Date: Thu, 24 Mar 2011 23:43:33 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Corbin Simpson <mostawesomedude@gmail.com>
CC: "K, Mythri P" <mythripk@ti.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
References: <1300815176-21206-1-git-send-email-mythripk@ti.com>	<AANLkTim61Xdo6ED7mr_SvpLuotso89RdR6Qaz-GCXOmJ@mail.gmail.com>	<AANLkTinMUCbaEVjwZsHG9BxFVjx0YxS=Sw+3gViDJXhg@mail.gmail.com>	<20110323081820.5b37d169@jbarnes-desktop>	<AANLkTinYHzCgXe9yw1rGHZA0uM=-VrY+Mktpn-HvfRyR@mail.gmail.com> <AANLkTi=Yc0Pg9uCZcTei45PLbERutoRc7XyoFghwS=KV@mail.gmail.com>
In-Reply-To: <AANLkTi=Yc0Pg9uCZcTei45PLbERutoRc7XyoFghwS=KV@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Corbin Simpson schrieb:
> On Thu, Mar 24, 2011 at 2:51 AM, K, Mythri P <mythripk@ti.com> wrote:
>> Hi Jesse,
>>
>> On Wed, Mar 23, 2011 at 8:48 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>> On Wed, 23 Mar 2011 18:58:27 +0530
>>> "K, Mythri P" <mythripk@ti.com> wrote:
>>>
>>>> Hi Dave,
>>>>
>>>> On Wed, Mar 23, 2011 at 6:16 AM, Dave Airlie <airlied@gmail.com> wrote:
>>>>> On Wed, Mar 23, 2011 at 3:32 AM, Mythri P K <mythripk@ti.com> wrote:
>>>>>> Adding support for common EDID parsing in kernel.
>>>>>>
>>>>>> EDID - Extended display identification data is a data structure provided by
>>>>>> a digital display to describe its capabilities to a video source, This a
>>>>>> standard supported by CEA and VESA.
>>>>>>
>>>>>> There are several custom implementations for parsing EDID in kernel, some
>>>>>> of them are present in fbmon.c, drm_edid.c, sh_mobile_hdmi.c, Ideally
>>>>>> parsing of EDID should be done in a library, which is agnostic of the
>>>>>> framework (V4l2, DRM, FB)  which is using the functionality, just based on
>>>>>> the raw EDID pointer with size/segment information.
>>>>>>
>>>>>> With other RFC's such as the one below, which tries to standardize HDMI API's
>>>>>> It would be better to have a common EDID code in one place.It also helps to
>>>>>> provide better interoperability with variety of TV/Monitor may be even by
>>>>>> listing out quirks which might get missed with several custom implementation
>>>>>> of EDID.
>>>>>> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30401
>>>>>>
>>>>>> This patch tries to add functions to parse some portion EDID (detailed timing,
>>>>>> monitor limits, AV delay information, deep color mode support, Audio and VSDB)
>>>>>> If we can align on this library approach i can enhance this library to parse
>>>>>> other blocks and probably we could also add quirks from other implementation
>>>>>> as well.
>>>>>>
>>>>> If you want to take this approach, you need to start from the DRM EDID parser,
>>>>> its the most well tested and I can guarantee its been plugged into more monitors
>>>>> than any of the others. There is just no way we would move the DRM parser to a
>>>>> library one that isn't derived from it + enhancements, as we'd throw away the
>>>>> years of testing and the regression count would be way too high.
>>>>>
>>>> I had a look at the DRM EDID code, but for quirks it looks pretty much the same.
>>>> yes i could take quirks and other DRM tested code and enhance, but
>>>> still the code has to do away with struct drm_display_mode
>>>> which is very much custom to DRM.
>>> If that's the only issue you have, we could easily rename that
>>> structure or add conversion funcs to a smaller structure if that's what
>>> you need.
>>>
>>> Dave's point is that we can't ditch the existing code without
>>> introducing a lot of risk; it would be better to start a library-ized
>>> EDID codebase from the most complete one we have already, i.e. the DRM
>>> EDID code.
>>>
>> This sounds good. If we can remove the DRM dependent portion to have a
>> library-ized EDID code,
>> That would be perfect. The main Intention to have a library is,
>> Instead of having several different Implementation in kernel, all
>> doing the same EDID parsing , if we could have one single
>> implementation , it would help in better testing and interoperability.
>>
>>> Do you really think the differences between your code and the existing
>>> DRM code are irreconcilable?
>>>
>> On the contrary if there is a library-ized  EDID parsing using the
>> drm_edid, and there is any delta / fields( Parsing the video block in
>> CEA extension for Short Video Descriptor, Vendor block for AV delay
>> /Deep color information etc) that are parsed with the RFC i posted i
>> would be happy to add.
> 
> Something just occurred to me. Why do video input drivers need EDID?
> Perhaps I'm betraying my youth here, but none of my TV tuners have the
> ability to read EDIDs in from the other side of the coax/RCA jack, and
> IIUC they really only care about whether they're receiving NTSC or
> PAL. The only drivers that should be parsing EDIDs are FB and KMS
> drivers, right?

Traditional TV (PAL/NTSC) supports only a very limited amount of modes and 
furthermore within one country it's about 1 or 2 different ones that are 
typically needed. It looks like todays TVs support most of those but I've also 
seen some terrible cropping or a wrong aspect ratio on TVs. Let's say that had a 
relative simple job and they didn't do it always too well, so getting the 
information via EDID is better than forcing the user type the info in via a 
remote or doing it wrong.

> So why should this be a common library? Most kernel code doesn't need
> it. Or is there a serious need for video input to parse EDIDs?

It's true that most kernel code does not need it as it is only useful for 
display output systems (and only the ones that can be connected to something 
sending EDID data) but it would be good anyway.
Because sharing code that should fulfill the same purpose is always a good idea. 
But of course only if the scope is clearly limited as we don't want to end up 
with a mess that nobody dares touching again as it became to complex. So I 
totally agree that we should share the common stuff we all need and adding the 
extras one needs in the subsystem/driver.
This is good because it looks like we'll have 3 display subsystems within the 
kernel for a long future and with a common library the same patch would not need 
to be done 3 times but only once. Or even more often if drivers have there 
private EDID implementation which I just throw out of mine to replace it later 
with a common one.


Regards,

Florian Tobias Schandinat
