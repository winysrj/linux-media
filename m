Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54105 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981Ab1JFQFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 12:05:34 -0400
Received: by yxl31 with SMTP id 31so2741250yxl.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 09:05:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7sdNxfeJvwMOq0zTVKJCQbsR6NekdjU1VW9sJPOUYw6tw@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
 <CAAwP0s0Z+EaRfY_9c0QLm0ZpyfG5Dy1qb9pFq=PRxzOOTwKTJw@mail.gmail.com>
 <CAAwP0s1tK5XjmJmtvRFJ2+ADvoMP1ihf3z0UaJAfXOoJ=UrVqg@mail.gmail.com> <CA+2YH7sdNxfeJvwMOq0zTVKJCQbsR6NekdjU1VW9sJPOUYw6tw@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Thu, 6 Oct 2011 18:05:12 +0200
Message-ID: <CAAwP0s3RFoyV6-RtLxh8amFZh1qpWhF7dMD46OoMQ7CY8-1AfA@mail.gmail.com>
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

On Thu, Oct 6, 2011 at 5:25 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Thu, Oct 6, 2011 at 9:51 AM, Javier Martinez Canillas
> <martinez.javier@gmail.com> wrote:
>> Since the patches are not against mainline I can't post for reviewing
>> but can be found in one of our development trees [1]. Comments are
>> highly appreciated.
>>
>> The tree is a 2.6.37 that already contain Deepthy patch. I rebased my
>> changes on top of that to correctly support both BT656 an non-BT656
>> video data processing.
>>
>> [1]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=shortlog;h=refs/heads/linux-2.6.37.y-next
>
> Some random comments from a quick view at [1]:
>
> - i don't see Deepthy patches, it seems to be based on the
> pre-Deepthy-patches driver and fixed (not that this is a bad thing!);
> i say this because, like Gary, i'm interested in a possible forward
> porting to a more recent kernel so i was searching for a starting
> point
>

I didn't know there was a more recent version of Deepthy patches,
Since they are not yet in mainline we should decide if we work on top
of that or on top of mainline. Deepthy patches are very good to
separate bt656 and non-bt656 execution inside the ISP, also add a
platform data variable to decide which mode has to be used.

But reading the documentation and from my experimental validation I
think that there are a few things that can be improved.

First the assumption that we can use FLDSTAT to check if a frame is
ODD or EVEN I find to not always be true. Also I don't know who sets
this value since in the TRM always talks as it is only used with
discrete syncs.

Also, I don't think that we should change the ISP CCDC configuration
inside the VD0 interrupt handler. Since the shadowed registers only
can be accessed during a frame processing, or more formally the new
values are taken at the beginning of a frame execution.

By the time we change for example the output address memory for the
next buffer in the VD0 handler, the next frame is already being
processed so that value won't be used for the CCDC until that frame
finish. So It is not behaving as the code expect, since for 3 frames
the CCDC output memory address will be the same.

That is why I move most of the logic to the VD1 interrupt since there
the current frame didn't finish yet and we can configure the CCDC for
the next frame.

But to do that the buffer for the next frame and the releasing of the
last buffer can't happen simultaneously, that is why I decouple these
two actions.

Again, this is my own observations and what I understood from the TRM
and I could be wrong.

> - i don't think that adding the "priv" field in v4l2-mediabus.h will
> be accepted, and since it is related to the default cropping you added
> i think it can be dropped and just let the user choose the appropriate
> cropping
>

Yes, probably is too much of a hack, but I didn't know of another way
that the subdev could report to the ISP of the standard and since
v4l2_pix_format has also a priv field, I think it could be at least a
temporary solution (remember that we want this to work first and then
we plan to do it right for upstream submission).

> - because of the previous point, i think the
> PAL(NTSC)_NUM_ACTIVE_LINES can stay to 625(525)
>
> - we really need some comments from someone that is not me, you and Gary
>
> [1]: http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=history;f=drivers/media/video/isp;hb=refs/heads/linux-2.6.37.y-next
>
>
>>> Right now I have a working the tvp5151 with the ISP. I can capture
>>> ITU-R BT656 video both in PAL-M and NTSC standard. Also, the whole
>>> pipeline is configured automatically with the video standard detected
>>> by the tvp5151. Also, I'm using the CCDC to crop the frames and only
>>> capture the active lines for each standard (576 for PAL and 480 for
>>> NTSC) using the CCDC to crop the image.
>>>
>>
>> As I told you before video capturing is working for both PAL and NTSC
>> using standard V4L2 application (i.e: gstreamer) but the video still
>> shows some motion artifacts. Capturing YUV frames and looking at them
>> I realized that there does exist a pattern, the sequence 2 frames
>> correct and 3 frames with interlacing effects always repeats.
>
> Yes i've seen that too, i was planning to do some tests when things
> will settle down.
>
> Enrico
>

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
