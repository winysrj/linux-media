Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35483 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1CWOJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 10:09:55 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimqkA7GGdT52Ys0b+346Pxr3A=PtDpY0nJ+ycVO@mail.gmail.com>
References: <AANLkTimJWpebAskcjA+qQUDWXjiH6aHta4fri9z6OxRN@mail.gmail.com>
	<20110321110040.6f1ea6d3@jbarnes-desktop>
	<AANLkTimjOs8ZuKRUt1aOizhbRw2-Ni4bTPty-dKpZ-rz@mail.gmail.com>
	<20110321122518.6b7ec7e4@jbarnes-desktop>
	<AANLkTikAeQ=z-M3kW2zPgVRK-bmoiTeA5ktjjTokEybW@mail.gmail.com>
	<AANLkTimqkA7GGdT52Ys0b+346Pxr3A=PtDpY0nJ+ycVO@mail.gmail.com>
Date: Wed, 23 Mar 2011 15:09:54 +0100
Message-ID: <AANLkTi=fWKt=v5O9A7XivDiFaJyki6H90k1=Jfcmw2dN@mail.gmail.com>
Subject: Re: Future desktop on dumb frame buffers?
From: Robert Fekete <robert.fekete@linaro.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	dri-devel@lists.freedesktop.org,
	timofonic timofonic <timofonic@gmail.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	wayland-devel@lists.freedesktop.org, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 21 March 2011 21:08, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Mon, Mar 21, 2011 at 3:50 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Mon, Mar 21, 2011 at 20:25, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>> On Mon, 21 Mar 2011 19:19:43 +0000
>>> timofonic timofonic <timofonic@gmail.com> wrote:
>>>> So if KMS is so cool and provides many advantages over fbdev and
>>>> such... Why isn't more widely used intead of still relying on fbdev?
>>>> Why still using fbdev emulation (that is partial and somewhat broken,
>>>> it seems) instead using KMS directly?
>>>
>>> Used by what?  All three major GPU device classes have KMS support
>>> (Intel, ATI, and nVidia).  If you want it for a particular device, you
>>> can always port it over.
>>
>> The three major GPU device classes on PC...
>
> Sadly it gets worse.  A lot of the SoC vendors are adding an fbdev
> emulation layer on top of v4l rather than using fbdev directly or
> using KMS and v4l has grown it's own edid, hdmi, and cec handling.
>

I agree, it is sad that as a SoC vendor there are different
kernel/user API's(v4l2/fbdev/drm) to choose from when implementing say
a Display controller driver. One must also remember that there are big
differences between a desktop/PC multimedia/graphics system and the
ones present on an embedded SoC. It is two very different cultures and
HW designs now trying to merge into one Linux Kernel. Of course there
will be some overlaps but I believe it can be sorted out as soon as we
understand each others different possibilities/limitations. Doing
duplicate work like HDMI will not benefit any party.

Just to list some of the differences.

- Developments within V4L2 has mainly been driven by embedded devices
while DRM is a result of desktop Graphics cards. And for some extent
also solving different problems.
- Embedded devices usually have several different hw IP's managing
displays, hdmi, camera/ISP, video codecs(h264 accellerators), DSP's,
2D blitters, Open GL ES hw, all of which have a separate device/driver
in the kernel, while on a desktop nowadays all this functionality
usually resides on ONE graphics card, hence one DRM device for all.
- DRM is closely developed in conjunction with desktop/Xorg, while X11
on an embedded device is not very 2011...wayland on the other hand is
:-), but do wayland really need the full potential of DRM/DRI or just
parts of it.
- Copying buffers is really bad for embedded devices due to lower
memory bandwidth and power consumption while on a Desktop memory
bandwidth is from an other galaxy (copying still bad but accepted it
seems), AND embedded devices of today records and plays/displays 1080p
content as well.
- Not all embedded devices have MMU's for each IP requiring physical
contiguous memory, while on a desktop MMU's have been present for
ages.
- Embedded devices are usually ARM based SoCs while x86 dominates the
Desktop/Laptop market, and functionality provided is soon the very
same.
- yada yada....The list can grow very long....There are also
similarities of course.

The outcome is that SoC vendors likes the embedded friendliness of
v4l2 and fbdev while "we" also glance at the DRM part due to its
de-facto standard on desktop environments. But from an embedded point
of view DRM lacks the support for interconnecting multiple
devices/drivers mentioned above, GEM/TTM is valid within a DRM device,
the execution/context management is not needed,, no overlays(or
similar), the coupling to DRI/X11 not wanted. SoCs like KMS/GEM but
the rest of DRM will likely not be heavily used on SoCs unless running
X11 as well. Most likely this worked on as well within the DRI
community. I can see good features all over the place(sometimes
duplicated) but not find one single guideline/API that solves all the
embedded SoC problems (which involves use-cases optimized for no-copy
cross media/drivers).

Last but not least...

On Linaro there is already discussions ongoing to solve one of the
biggest issues from a SoC point of view and that is a "System Wide
Memory manager" which manages buffer sharing and resolves no-copy use
cases between devices/drivers. Read more on the following thread:
http://lists.linaro.org/pipermail/linaro-dev/2011-March/003053.html.

BR
/Robert Fekete
st-ericsson
