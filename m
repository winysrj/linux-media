Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54345 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1JMMc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 08:32:28 -0400
Received: by ggnv2 with SMTP id v2so1749975ggn.19
        for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 05:32:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E96CF04.7000100@mlbassoc.com>
References: <4E9442A9.1060202@mlbassoc.com>
	<4E9609E3.3000902@mlbassoc.com>
	<CA+2YH7v+wV4Kz=gLkACiE0fRHu2BCLLvNj8q=ipLDVy_GztXjw@mail.gmail.com>
	<4E96CF04.7000100@mlbassoc.com>
Date: Thu, 13 Oct 2011 14:32:27 +0200
Message-ID: <CA+2YH7vaN5Q+AJZp8b9E=7Jumaz-cB191CnYDDXF6ZOt7mZocg@mail.gmail.com>
Subject: Re: OMAP3 ISP ghosting
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2011 at 1:44 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2011-10-13 02:42, Enrico wrote:
>>
>> On Wed, Oct 12, 2011 at 11:42 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>>>
>>> Any ideas on this?  My naive attempt (diffs attached) just hangs up.
>>> These changes disable BT-656 mode in the CCDC and tell the TVP5150
>>> to output raw YUV 4:2:2 data including all SYNC signals.
>>
>> I tried that too, you will need to change many of the is_bt656 into
>> is_fldmode. For isp configuration it seems that the only difference
>> between the two is (more or less) just the REC656 register. I made a
>> hundred attempts and in the end i had a quite working capture (just
>> not centered) but ghosting always there.
>>
>> I made another test and by luck i got a strange thing, look at the
>> following image:
>>
>> http://postimage.org/image/2d610pjk4/
>>
>> (It's noisy because of a hardware problem)
>>
>> I made it with these changes:
>>
>> //ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 1);
>> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 1);
>> //ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 1);
>> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
>>
>> So you have an image with a field with no offset, and a field with
>> offsets.
>>
>> Now if you look between my thumb and my forefinger behind them there's
>> a monoscope picture and in one field you can see 2 black squares, in
>> the other one you can see 3 black squares. So the two field that will
>> be composing a single image differ very much.
>>
>> Now the questions are: is this expected to happen on an analogue video
>> source and we can't do anything (apart from software deinterlacing)?
>> is this a problem with tvp5150? Is this a problem with the isp?
>
> Yes, there does seem to be significant movement/differences between these
> two images.  Are you saying that these should be the two halves of one frame
> that would be stitched together by de-interlacing?  Perhaps the halves are
> out of sync and the bottom one of this image really goes with the top of
> the next (frame13)?

They are two fields that normally will be "merged" into a frame, but
with those settings i made the isp "expand" (SDOFST) just one of the
fields.

One possible thing is that, as you say, "the bottom one of this image
really goes with the top of the next".

But one thing to consider is that it is normal for interlaced video to
have such "effects", that's why progressive scan was invented.


> The ghosting problem is still evident, even in this split image.  Notice
> that every other scan line is really poor - basically junk.  When this gets
> merged as part of the de-interlace, the ghosts appear.

I don't think so. The bottom part is "expanded" by the isp, so it's ok
to have green half lines, that's where the top part will go if it is
"expanded" by the isp.

Looking at the single images (top and bottom) i don't see ghosting
artifacts (not only in that image but in a sequence of 16 frames),
just a little blurry in moving parts but that's expected in an
interlaced video. So it seems to me that the images arrive correctly
at the isp and the deinterlacing causes ghosting.

Enrico
