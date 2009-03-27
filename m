Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:34648 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZC0I1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 04:27:09 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1134279rvb.1
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 01:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903270824.28092.hverkuil@xs4all.nl>
References: <b64afca20903262320g1bd35163lcce41724dd5db965@mail.gmail.com>
	 <200903270824.28092.hverkuil@xs4all.nl>
Date: Fri, 27 Mar 2009 17:27:04 +0900
Message-ID: <5e9665e10903270127x339359e6o4b62573179503054@mail.gmail.com>
Subject: Re: how about adding FOCUS mode?
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Kim, Heung Jun" <riverful@gmail.com>, bill@thedirks.org,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans, and Laurent

On Fri, Mar 27, 2009 at 4:24 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Friday 27 March 2009 07:20:51 Kim, Heung Jun wrote:
>> Hello, Hans & everyone.
>>
>> I'm trying to adapt the various FOCUS MODE int the NEC ISP driver.
>> NEC ISP supports 4 focus mode, AUTO/MACRO/MANUAL/FULL or NORMAL.
>> but, i think that it's a little insufficient to use V4L2 FOCUS Feature.
>>
>> so, suggest that,
>>
>> - change V4L2_CID_FOCUS_AUTO's type from boolean to interger, and add
>> the following enumerations for CID values.
>>
>> enum v4l2_focus_mode {
>>     V4L2_FOCUS_AUTO            = 0,
>>     V4L2_FOCUS_MACRO        = 1,
>>     V4L2_FOCUS_MANUAL        = 2,
>>     V4L2_FOCUS_NORMAL        = 3,
>>     V4L2_FOCUS_LASTP        = 3,
>> };
>>
>> how about this usage? i wanna get some advice about FOCUS MODE.
>
> This seems more logical to me:
>
> enum v4l2_focus_mode {
>    V4L2_FOCUS_MANUAL = 0,
>    V4L2_FOCUS_AUTO_NORMAL = 1,
>    V4L2_FOCUS_AUTO_MACRO = 2,
> };

I think it could be more than that. Because some ISP devices support
much more presets like "AF-S" and "AF-C".
I mean AF Static? or something for AF-S and AF continuous for AF-C...


>
> At least this maps the current boolean values correctly. I'm not sure from
> your decription what the fourth auto focus mode is supposed to be.
>
> But I think it might be better to have a separate control that allows you to
> set the auto-focus mode. I can imagine that different devices might have
> different auto-focus modes.

You are right. But on the other hand, it seems to be not bad using API
in same way as EXPOSURE CID (V4L2_CID_EXPOSURE_AUTO) to avoid
confusion.

Cheers,

Nate
>
> I've CC-ed Laurent since this is more his field than mine.
>
> Regards,
>
>        Hans
>
>>
>> Thanks,
>> Riverful
>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
