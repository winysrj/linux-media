Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:36607 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753381Ab1EWWzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 18:55:38 -0400
Message-ID: <4DDAE63A.3070203@gmx.de>
Date: Mon, 23 May 2011 22:56:58 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [RFC] Standardize YUV support in the fbdev API
References: <201105180007.21173.laurent.pinchart@ideasonboard.com> <4DD6EC1E.4090702@gmx.de> <201105232300.27087.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105232300.27087.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On 05/23/2011 09:00 PM, Laurent Pinchart wrote:
> On Saturday 21 May 2011 00:33:02 Florian Tobias Schandinat wrote:
>> On 05/17/2011 10:07 PM, Laurent Pinchart wrote:
>>> - Other solutions are possible, such as adding new ioctls. Those
>>> solutions are more intrusive, and require larger changes to both
>>> userspace and kernelspace code.
>>
>> I'm against (ab)using the nonstd field (probably the only sane thing we can
>> do with it is declare it non-standard which interpretation is completely
>> dependent on the specific driver) or requiring previously unused fields to
>> have a special value so I'd like to suggest a different method:
>>
>> I remembered an earlier discussion:
>> [ http://marc.info/?l=linux-fbdev&m=129896686208130&w=2 ]
>>
>> On 03/01/2011 08:07 AM, Geert Uytterhoeven wrote:
>>   >  On Tue, Mar 1, 2011 at 04:13, Damian<dhobsong@igel.co.jp>   wrote:
>>   >>  On 2011/02/24 15:05, Geert Uytterhoeven wrote:
>>   >>>  For YUV (do you mean YCbCr?), I'm inclined to suggest adding a new
>>   >>>  FB_VISUAL_*
>>   >>>  type instead, which indicates the fb_var_screeninfo.{red,green,blue}
>>   >>>  fields are
>>   >>>  YCbCr instead of RGB.
>>   >>>  Depending on the frame buffer organization, you also need new
>>   >>>  FB_TYPE_*/FB_AUX_*
>>   >>>  types.
>>   >>
>>   >>  I just wanted to clarify here.  Is your comment about these new flags
>>   >>  in specific reference to this patch or to Magnus' "going forward"
>>   >>  comment?  It
>>   >
>>   >  About new flags.
>>   >
>>   >>  seems like the beginnings of a method to standardize YCbCr support in
>>   >>  fbdev across all platforms.
>>   >>  Also, do I understand correctly that FB_VISUAL_ would specify the
>>   >>  colorspace
>>   >
>>   >  FB_VISUAL_* specifies how pixel values (which may be tuples) are mapped
>>   >  to colors on the screen, so to me it looks like the sensible way to set
>>   >  up YCbCr.
>>   >
>>   >>  (RGB, YCbCr), FB_TYPE_* would be a format specifier (i.e. planar,
>>   >>  semiplanar, interleaved, etc)?  I'm not really sure what you are
>>   >>  referring to with the FB_AUX_* however.
>>   >
>>   >  Yep, FB_TYPE_* specifies how pixel values/tuples are laid out in frame
>>   >  buffer memory.
>>   >
>>   >  FB_AUX_* is only used if a specific value of FB_TYPE_* needs an
>>   >  additional parameter (e.g. the interleave value for interleaved
>>   >  bitplanes).
>>
>> Adding new standard values for these fb_fix_screeninfo fields would solve
>> the issue for framebuffers which only support a single format.
>
> I've never liked changing fixed screen information :-) It would be consistent
> with the API though.

Fixed does only mean that it can't be directly manipulated by applications. The 
driver has to modify it anyway on about every mode change (line_length). Yes 
perhaps some of these fields would be in var today and certainly others 
shouldn't exist at all but I do not blame anyone for not being capable to look 
into the future.

>> If you have the need to switch
>
> Yes I need that. This requires an API to set the mode through
> fb_var_screeninfo, which is why I skipped modifying fb_fix_screeinfo.
>
> A new FB_TYPE_* could be used to report that we use a 4CC-based mode, with the
> exact mode reported in one of the fb_fix_screeninfo reserved fields (or the
> type_aux field). This would duplicate the information passed through
> fb_var_screeninfo though. Do you think it's worth it ?

I think it's more like a FB_VISUAL_FOURCC as you want to express how the color 
<-> pixel mapping is. The FB_TYPE_* is more about whether pixel are packed or 
represented as planes (the 2 format groups mentioned on fourcc.org).
That's certainly something I'd introduce as it would (hopefully) work to prevent 
old applications which don't know your extension manipulating a FOURCC format 
thinking that it is RGB.
So I think we should
fix.visual = FB_VISUAL_FOURCC;
fix.type = FB_TYPE_PACKED_PIXELS | FB_TYPE_PLANES; /* (?) */
or maybe add a FB_TYPE_FOURCC and rely only on the information in FOURCC (as 
things like UYVY could become confusing as macropixel!=pixel)

>> I guess it would be a good idea to add a new flag to the vmode bitfield in
>> fb_var_screeninfo which looks like a general purpose modifier for the
>> videomode. You could than reuse any RGB-specific field you like to pass more
>> information.
>
> That looks good to me. The grayscale field could be reused to pass the 4CC.

var.grayscale = <FOURCC_FORMAT>;
var.vmode = FB_VMODE_FOURCC;
and if this vmode flag is not set it means traditional mode (based on RGBA).

>> Maybe we should also use this chance to declare one of the fix_screeninfo
>> reserved fields to be used for capability flags or an API version as we can
>> assume that those are 0 (at least in sane drivers).
>
> That's always good, although it's not a hard requirement for the purpose of
> YUV support.

Sure. But it's good to let the application know whether you support the new 
extension or whether you just ignore the flag. So I'm voting for a
fix.caps = FB_CAP_FOURCC;


Best regards,

Florian Tobias Schandinat
