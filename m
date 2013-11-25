Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49992 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3KYO5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 09:57:14 -0500
MIME-Version: 1.0
In-Reply-To: <20131123011037.GO10036@intel.com>
References: <1385093524-22276-1-git-send-email-keithp@keithp.com>
	<20131122102632.GQ27344@phenom.ffwll.local>
	<86d2lsem3m.fsf@miki.keithp.com>
	<CAKMK7uEqHKOmMFXZLKno1q08X1B=U7XcJiExHaHbO9VdMeCihQ@mail.gmail.com>
	<20131122221213.GA3234@tokamak.local>
	<20131122230504.GK10036@intel.com>
	<86pppsvw8e.fsf@miki.keithp.com>
	<20131123011037.GO10036@intel.com>
Date: Mon, 25 Nov 2013 15:57:13 +0100
Message-ID: <CAMuHMdW8-BqchN2MfErwEL8Re00fLGZE=zCRQYzVaHi0TFuJFA@mail.gmail.com>
Subject: Re: [Intel-gfx] [Mesa-dev] [PATCH] dri3, i915, i965: Add __DRI_IMAGE_FOURCC_SARGB8888
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Keith Packard <keithp@keithp.com>,
	=?UTF-8?Q?Kristian_H=C3=B8gsberg?= <hoegsberg@gmail.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Mesa Dev <mesa-dev@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 23, 2013 at 2:10 AM, Ville Syrjälä
<ville.syrjala@linux.intel.com> wrote:
> On Fri, Nov 22, 2013 at 03:43:13PM -0800, Keith Packard wrote:
>> Ville Syrjälä <ville.syrjala@linux.intel.com> writes:
>>
>> > What is this format anyway? -ENODOCS
>>
>> Same as MESA_FORMAT_SARGB8 and __DRI_IMAGE_FORMAT_SARGB8 :-)
>>
>> > If its just an srgb version of ARGB8888, then I wouldn't really want it
>> > in drm_fourcc.h. I expect colorspacy stuff will be handled by various
>> > crtc/plane properties in the kernel so we don't need to encode that
>> > stuff into the fb format.
>>
>> It's not any different from splitting YUV codes from RGB codes;
>
> Not really. Saying something is YUV (or rather Y'CbCr) doesn't
> actually tell you the color space. It just tells you whether the
> information is encoded as R+G+B or Y+Cb+Cr. How you convert between
> them is another matter. You need to know the gamma, color primaries,
> chroma siting for sub-sampled YCbCr formats, etc.

Yep. Fbdev has a separation of type (how pixel values are laid out in memory),
fb_bitfield structs (how tuples are formed into pixels), and visual (how to
interprete the tuples).

The fb_bitfield structs do have RGB-centric names, but you could use them
for e.g. Y, Cb, Cr, and alpha, giving a proper visual. Unfortunately the
YCbCr visuals haven't made it into mainline.

FOURCC unifies all of that in (not so) unique 32-bit IDs.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
