Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:35709 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752494Ab1ETWbm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 18:31:42 -0400
Message-ID: <4DD6EC1E.4090702@gmx.de>
Date: Fri, 20 May 2011 22:33:02 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [RFC] Standardize YUV support in the fbdev API
References: <201105180007.21173.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105180007.21173.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 05/17/2011 10:07 PM, Laurent Pinchart wrote:
> Hi everybody,
>
> I need to implement support for a YUV frame buffer in an fbdev driver. As the
> fbdev API doesn't support this out of the box, I've spent a couple of days
> reading fbdev (and KMS) code and thinking about how we could cleanly add YUV
> support to the API. I'd like to share my findings and thoughts, and hopefully
> receive some comments back.

Thanks. I think you did already a good job, hope we can get it done this time.

> Given the overlap between the KMS, V4L2 and fbdev APIs, the need to share data
> and buffers between those subsystems, and the planned use of V4L2 FCCs in the
> KMS overlay API, I believe using V4L2 FCCs to identify fbdev formats would be
> a wise decision.

I agree.

> To select a frame buffer YUV format, the fb_var_screeninfo structure will need
> to be extended with a format field. The fbdev API and ABI must not be broken,
> which prevents us from changing the current structure layout and replacing the
> existing format selection mechanism (through the red, green, blue and alpha
> bitfields) completely.

I agree.

> - Other solutions are possible, such as adding new ioctls. Those solutions are
> more intrusive, and require larger changes to both userspace and kernelspace
> code.

I'm against (ab)using the nonstd field (probably the only sane thing we can do 
with it is declare it non-standard which interpretation is completely dependent 
on the specific driver) or requiring previously unused fields to have a special 
value so I'd like to suggest a different method:

I remembered an earlier discussion:
[ http://marc.info/?l=linux-fbdev&m=129896686208130&w=2 ]

On 03/01/2011 08:07 AM, Geert Uytterhoeven wrote:
 > On Tue, Mar 1, 2011 at 04:13, Damian<dhobsong@igel.co.jp>  wrote:
 >> On 2011/02/24 15:05, Geert Uytterhoeven wrote:
 >>> For YUV (do you mean YCbCr?), I'm inclined to suggest adding a new
 >>> FB_VISUAL_*
 >>> type instead, which indicates the fb_var_screeninfo.{red,green,blue}
 >>> fields are
 >>> YCbCr instead of RGB.
 >>> Depending on the frame buffer organization, you also need new
 >>> FB_TYPE_*/FB_AUX_*
 >>> types.
 >>
 >> I just wanted to clarify here.  Is your comment about these new flags in
 >> specific reference to this patch or to Magnus' "going forward" comment?  It
 >
 > About new flags.
 >
 >> seems like the beginnings of a method to standardize YCbCr support in fbdev
 >> across all platforms.
 >> Also, do I understand correctly that FB_VISUAL_ would specify the colorspace
 >
 > FB_VISUAL_* specifies how pixel values (which may be tuples) are mapped to
 > colors on the screen, so to me it looks like the sensible way to set up YCbCr.
 >
 >> (RGB, YCbCr), FB_TYPE_* would be a format specifier (i.e. planar,
 >> semiplanar, interleaved, etc)?  I'm not really sure what you are referring
 >> to with the FB_AUX_* however.
 >
 > Yep, FB_TYPE_* specifies how pixel values/tuples are laid out in frame buffer
 > memory.
 >
 > FB_AUX_* is only used if a specific value of FB_TYPE_* needs an additional
 > parameter (e.g. the interleave value for interleaved bitplanes).

Adding new standard values for these fb_fix_screeninfo fields would solve the 
issue for framebuffers which only support a single format. If you have the need 
to switch I guess it would be a good idea to add a new flag to the vmode 
bitfield in fb_var_screeninfo which looks like a general purpose modifier for 
the videomode. You could than reuse any RGB-specific field you like to pass more 
information.
Maybe we should also use this chance to declare one of the fix_screeninfo 
reserved fields to be used for capability flags or an API version as we can 
assume that those are 0 (at least in sane drivers).


Good luck,

Florian Tobias Schandinat
