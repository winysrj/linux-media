Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:35009 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1JMPi1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 11:38:27 -0400
Message-ID: <4E9705F0.1070607@mlbassoc.com>
Date: Thu, 13 Oct 2011 09:38:24 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: Enrico <ebutera@users.berlios.de>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>,
	laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP ghosting
References: <4E9442A9.1060202@mlbassoc.com> <4E9609E3.3000902@mlbassoc.com> <CA+2YH7v+wV4Kz=gLkACiE0fRHu2BCLLvNj8q=ipLDVy_GztXjw@mail.gmail.com> <4E96CF04.7000100@mlbassoc.com> <CA+2YH7vaN5Q+AJZp8b9E=7Jumaz-cB191CnYDDXF6ZOt7mZocg@mail.gmail.com> <4E96DF19.8080702@mlbassoc.com> <CAAwP0s1ZkLypztwNYjFEMd3vFxtQ3i2Gc_BXimrsVEvbgdfpag@mail.gmail.com>
In-Reply-To: <CAAwP0s1ZkLypztwNYjFEMd3vFxtQ3i2Gc_BXimrsVEvbgdfpag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-13 07:47, Javier Martinez Canillas wrote:
> On Thu, Oct 13, 2011 at 2:52 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> On 2011-10-13 06:32, Enrico wrote:
>>>
>>> On Thu, Oct 13, 2011 at 1:44 PM, Gary Thomas<gary@mlbassoc.com>    wrote:
>>>>
>>>> On 2011-10-13 02:42, Enrico wrote:
>>>>>
>>>>> On Wed, Oct 12, 2011 at 11:42 PM, Gary Thomas<gary@mlbassoc.com>
>>>>>   wrote:
>>>>>>
>>>>>> Any ideas on this?  My naive attempt (diffs attached) just hangs up.
>>>>>> These changes disable BT-656 mode in the CCDC and tell the TVP5150
>>>>>> to output raw YUV 4:2:2 data including all SYNC signals.
>>>>>
>>>>> I tried that too, you will need to change many of the is_bt656 into
>>>>> is_fldmode. For isp configuration it seems that the only difference
>>>>> between the two is (more or less) just the REC656 register. I made a
>>>>> hundred attempts and in the end i had a quite working capture (just
>>>>> not centered) but ghosting always there.
>>>>>
>>>>> I made another test and by luck i got a strange thing, look at the
>>>>> following image:
>>>>>
>>>>> http://postimage.org/image/2d610pjk4/
>>>>>
>>>>> (It's noisy because of a hardware problem)
>>>>>
>>>>> I made it with these changes:
>>>>>
>>>>> //ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 1);
>>>>> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 1);
>>>>> //ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 1);
>>>>> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
>>>>>
>>>>> So you have an image with a field with no offset, and a field with
>>>>> offsets.
>>>>>
>>>>> Now if you look between my thumb and my forefinger behind them there's
>>>>> a monoscope picture and in one field you can see 2 black squares, in
>>>>> the other one you can see 3 black squares. So the two field that will
>>>>> be composing a single image differ very much.
>>>>>
>>>>> Now the questions are: is this expected to happen on an analogue video
>>>>> source and we can't do anything (apart from software deinterlacing)?
>>>>> is this a problem with tvp5150? Is this a problem with the isp?
>>>>
>>>> Yes, there does seem to be significant movement/differences between these
>>>> two images.  Are you saying that these should be the two halves of one
>>>> frame
>>>> that would be stitched together by de-interlacing?  Perhaps the halves
>>>> are
>>>> out of sync and the bottom one of this image really goes with the top of
>>>> the next (frame13)?
>>>
>>> They are two fields that normally will be "merged" into a frame, but
>>> with those settings i made the isp "expand" (SDOFST) just one of the
>>> fields.
>>>
>>> One possible thing is that, as you say, "the bottom one of this image
>>> really goes with the top of the next".
>>>
>>> But one thing to consider is that it is normal for interlaced video to
>>> have such "effects", that's why progressive scan was invented.
>>>
>>>
>>>> The ghosting problem is still evident, even in this split image.  Notice
>>>> that every other scan line is really poor - basically junk.  When this
>>>> gets
>>>> merged as part of the de-interlace, the ghosts appear.
>>>
>>> I don't think so. The bottom part is "expanded" by the isp, so it's ok
>>> to have green half lines, that's where the top part will go if it is
>>> "expanded" by the isp.
>>>
>>> Looking at the single images (top and bottom) i don't see ghosting
>>> artifacts (not only in that image but in a sequence of 16 frames),
>>> just a little blurry in moving parts but that's expected in an
>>> interlaced video. So it seems to me that the images arrive correctly
>>> at the isp and the deinterlacing causes ghosting.
>>
>
> Hello,
>
> Yes, I noticed that the images arrive correctly but disabling the
> interlaced mode fldmode == 0 and not setting an offset to copy the
> odd/even fields
>
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 0);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 0);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 0);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 0);
>
> If you do so, you will see a image that is composed of both odd and
> even frames each of them half the size of the deinterlaced image. So
> the TVP is producing the correct YUV data and also the ISP is decoding
> correctly using the BT.656 embedded sync info.

I tried these changes and what I get is the top of each frame looks quite
good, but the bottom is always blank.  Have a look at
   http://www.mlbassoc.com/misc/test-static.mp4
   http://www.mlbassoc.com/misc/test-movement.mp4

Any ideas about how to get the other 1/2 of the frames?

The one thing I see is that in the 'test-movement' file, there doesn't seem
to be any ghosting (or tearing) even though this is from a pretty low quality
camera.  I'm hopeful that I can get the remainder of the data and attempt
the software interlace and come up with really good image.

>
> My guess is that has to do with the buffers. I guess there are two
> ways to probe this.
>
> 1- Hack yavta to memset to 0 every buffer before passing to V4L2 layer.
>
>> Is there any way to prove this by doing the de-interlacing in software?
>
> 2- Deinterlace by software.
>
> As I said before deactivate the interlaced mode and get the two
> frames, then you can copy 1440 bytes (one line) from the first
> sub-frame (lines[0]) and then copy one line of the second sub-frame
> (lines[height/2-1]), and so on.
>
> Since YUV data is RAW you can manipulate this way.
>
> Best regards,
>

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
