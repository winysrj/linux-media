Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33543 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab1JFHvc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 03:51:32 -0400
Received: by gyg10 with SMTP id 10so2327758gyg.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 00:51:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s0Z+EaRfY_9c0QLm0ZpyfG5Dy1qb9pFq=PRxzOOTwKTJw@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
 <CAAwP0s0Z+EaRfY_9c0QLm0ZpyfG5Dy1qb9pFq=PRxzOOTwKTJw@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 6 Oct 2011 09:51:11 +0200
Message-ID: <CAAwP0s1tK5XjmJmtvRFJ2+ADvoMP1ihf3z0UaJAfXOoJ=UrVqg@mail.gmail.com>
Subject: Re: omap3-isp status
To: Enrico <ebutera@users.berlios.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 5, 2011 at 7:43 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> On Wed, Oct 5, 2011 at 6:28 PM, Enrico <ebutera@users.berlios.de> wrote:
>> Hi all,
>>
>> since we are all interested in this driver (and tvp5150) i'll try to
>> make a summary of the current situation and understand what is needed
>> to finally get it into the main tree instead of having to apply a
>> dozen patches manually.
>>
>> The current status of git repositories/branches is:
>>
>> - main tree: working (i suppose) but no support for bt656 input
>>
>> - pinchartl/media:
>>  * omap3isp-omap3isp-next: i think it's in sync with linuxtv master
>> (for the omap3-isp parts)
>>  * omap3isp-omap3isp-yuv: like ..next but with some additional format patches
>>
>> "Floating" patches:
>>
>> - Deepthy: sent patches (against mainline) to add bt656 support
>>
>> Laurent made some comments, i haven't seen a v2 to be applied
>>
>> - Javier: sent patches for tvp5150, currently discussed on
>> linux-media; possible patches/fixes for omap3-isp
>>

Hello,

Since the patches are not against mainline I can't post for reviewing
but can be found in one of our development trees [1]. Comments are
highly appreciated.

The tree is a 2.6.37 that already contain Deepthy patch. I rebased my
changes on top of that to correctly support both BT656 an non-BT656
video data processing.

[1]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=shortlog;h=refs/heads/linux-2.6.37.y-next

>
> I will find some free time slots to resolve the issues called out by
> Sakari, Hans and Mauro and resend the patch-set for the tvp5151.
>
> Also I can send the patches of the modifications I made to the ISP
> driver. Right now I'm working on top of Deepthy patches.
>
> I can either send on top of that patch or rebase to mainline, whatever
> you think is better for reviewing.
>
>> Now what can we all do to converge to a final solution? I think this
>> is also blocking the possible development/test of missing features,
>> like the recently-discussed resizer and cropping ones.
>>
>> Enrico
>>
>
> Right now I have a working the tvp5151 with the ISP. I can capture
> ITU-R BT656 video both in PAL-M and NTSC standard. Also, the whole
> pipeline is configured automatically with the video standard detected
> by the tvp5151. Also, I'm using the CCDC to crop the frames and only
> capture the active lines for each standard (576 for PAL and 480 for
> NTSC) using the CCDC to crop the image.
>

As I told you before video capturing is working for both PAL and NTSC
using standard V4L2 application (i.e: gstreamer) but the video still
shows some motion artifacts. Capturing YUV frames and looking at them
I realized that there does exist a pattern, the sequence 2 frames
correct and 3 frames with interlacing effects always repeats.

Hope it helps.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
