Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755921Ab3KWBKm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 20:10:42 -0500
Date: Sat, 23 Nov 2013 03:10:37 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Kristian =?iso-8859-1?Q?H=F8gsberg?= <hoegsberg@gmail.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Mesa Dev <mesa-dev@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Intel-gfx] [Mesa-dev] [PATCH] dri3, i915, i965: Add
 __DRI_IMAGE_FOURCC_SARGB8888
Message-ID: <20131123011037.GO10036@intel.com>
References: <1385093524-22276-1-git-send-email-keithp@keithp.com>
 <20131122102632.GQ27344@phenom.ffwll.local>
 <86d2lsem3m.fsf@miki.keithp.com>
 <CAKMK7uEqHKOmMFXZLKno1q08X1B=U7XcJiExHaHbO9VdMeCihQ@mail.gmail.com>
 <20131122221213.GA3234@tokamak.local>
 <20131122230504.GK10036@intel.com>
 <86pppsvw8e.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86pppsvw8e.fsf@miki.keithp.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 22, 2013 at 03:43:13PM -0800, Keith Packard wrote:
> Ville Syrjälä <ville.syrjala@linux.intel.com> writes:
> 
> > What is this format anyway? -ENODOCS
> 
> Same as MESA_FORMAT_SARGB8 and __DRI_IMAGE_FORMAT_SARGB8 :-)
> 
> > If its just an srgb version of ARGB8888, then I wouldn't really want it
> > in drm_fourcc.h. I expect colorspacy stuff will be handled by various
> > crtc/plane properties in the kernel so we don't need to encode that
> > stuff into the fb format.
> 
> It's not any different from splitting YUV codes from RGB codes;

Not really. Saying something is YUV (or rather Y'CbCr) doesn't
actually tell you the color space. It just tells you whether the
information is encoded as R+G+B or Y+Cb+Cr. How you convert between
them is another matter. You need to know the gamma, color primaries,
chroma siting for sub-sampled YCbCr formats, etc.

-- 
Ville Syrjälä
Intel OTC
