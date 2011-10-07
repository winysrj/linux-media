Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39944 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1JGJcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 05:32:07 -0400
Received: by qyk7 with SMTP id 7so3422731qyk.19
        for <linux-media@vger.kernel.org>; Fri, 07 Oct 2011 02:32:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
 <CAAwP0s0Z+EaRfY_9c0QLm0ZpyfG5Dy1qb9pFq=PRxzOOTwKTJw@mail.gmail.com>
 <CAAwP0s1tK5XjmJmtvRFJ2+ADvoMP1ihf3z0UaJAfXOoJ=UrVqg@mail.gmail.com>
 <CA+2YH7sdNxfeJvwMOq0zTVKJCQbsR6NekdjU1VW9sJPOUYw6tw@mail.gmail.com>
 <CAAwP0s3RFoyV6-RtLxh8amFZh1qpWhF7dMD46OoMQ7CY8-1AfA@mail.gmail.com> <CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 7 Oct 2011 11:31:46 +0200
Message-ID: <CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
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

On Fri, Oct 7, 2011 at 10:54 AM, Enrico <ebutera@users.berlios.de> wrote:
> On Thu, Oct 6, 2011 at 6:05 PM, Javier Martinez Canillas
> <martinez.javier@gmail.com> wrote:
>> On Thu, Oct 6, 2011 at 5:25 PM, Enrico <ebutera@users.berlios.de> wrote:
>>> - i don't see Deepthy patches, it seems to be based on the
>>> pre-Deepthy-patches driver and fixed (not that this is a bad thing!);
>>> i say this because, like Gary, i'm interested in a possible forward
>>> porting to a more recent kernel so i was searching for a starting
>>> point
>>>
>>
>> I didn't know there was a more recent version of Deepthy patches,
>> Since they are not yet in mainline we should decide if we work on top
>> of that or on top of mainline. Deepthy patches are very good to
>> separate bt656 and non-bt656 execution inside the ISP, also add a
>> platform data variable to decide which mode has to be used.
>>
>> But reading the documentation and from my experimental validation I
>> think that there are a few things that can be improved.
>>
>> First the assumption that we can use FLDSTAT to check if a frame is
>> ODD or EVEN I find to not always be true. Also I don't know who sets
>> this value since in the TRM always talks as it is only used with
>> discrete syncs.
>
>
> Yes about FLDSTAT i noticed the same thing. And that's why we need
> someone that knows the ISP better to help us....
>

Great, good to know that I'm not the only one that noticed this behavior.

>
>> Also, I don't think that we should change the ISP CCDC configuration
>> inside the VD0 interrupt handler. Since the shadowed registers only
>> can be accessed during a frame processing, or more formally the new
>> values are taken at the beginning of a frame execution.
>>
>> By the time we change for example the output address memory for the
>> next buffer in the VD0 handler, the next frame is already being
>> processed so that value won't be used for the CCDC until that frame
>> finish. So It is not behaving as the code expect, since for 3 frames
>> the CCDC output memory address will be the same.
>>
>> That is why I move most of the logic to the VD1 interrupt since there
>> the current frame didn't finish yet and we can configure the CCDC for
>> the next frame.
>>
>> But to do that the buffer for the next frame and the releasing of the
>> last buffer can't happen simultaneously, that is why I decouple these
>> two actions.
>>
>> Again, this is my own observations and what I understood from the TRM
>> and I could be wrong.
>
>
> I can't comment on that, i hope Laurent or Deepthy will join the discussion...
>
>

I second you on that, we need someone who knows the ISP better than we
do. I have to fix this anyway, so it is better if I can do it the
right way and the code gos upstream, so we don't have to internally
maintain a separate patch-set and forward port for each kernel release
we do.

>>> - i don't think that adding the "priv" field in v4l2-mediabus.h will
>>> be accepted, and since it is related to the default cropping you added
>>> i think it can be dropped and just let the user choose the appropriate
>>> cropping
>>>
>>
>> Yes, probably is too much of a hack, but I didn't know of another way
>> that the subdev could report to the ISP of the standard and since
>> v4l2_pix_format has also a priv field, I think it could be at least a
>> temporary solution (remember that we want this to work first and then
>> we plan to do it right for upstream submission).
>
>
> ...and my hope continues here.
>
>
> Enrico
>

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
