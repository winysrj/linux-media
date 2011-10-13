Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:56999 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1JMLoI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 07:44:08 -0400
Message-ID: <4E96CF04.7000100@mlbassoc.com>
Date: Thu, 13 Oct 2011 05:44:04 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Enrico <ebutera@users.berlios.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: OMAP3 ISP ghosting
References: <4E9442A9.1060202@mlbassoc.com> <4E9609E3.3000902@mlbassoc.com> <CA+2YH7v+wV4Kz=gLkACiE0fRHu2BCLLvNj8q=ipLDVy_GztXjw@mail.gmail.com>
In-Reply-To: <CA+2YH7v+wV4Kz=gLkACiE0fRHu2BCLLvNj8q=ipLDVy_GztXjw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-13 02:42, Enrico wrote:
> On Wed, Oct 12, 2011 at 11:42 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> Any ideas on this?  My naive attempt (diffs attached) just hangs up.
>> These changes disable BT-656 mode in the CCDC and tell the TVP5150
>> to output raw YUV 4:2:2 data including all SYNC signals.
>
> I tried that too, you will need to change many of the is_bt656 into
> is_fldmode. For isp configuration it seems that the only difference
> between the two is (more or less) just the REC656 register. I made a
> hundred attempts and in the end i had a quite working capture (just
> not centered) but ghosting always there.
>
> I made another test and by luck i got a strange thing, look at the
> following image:
>
> http://postimage.org/image/2d610pjk4/
>
> (It's noisy because of a hardware problem)
>
> I made it with these changes:
>
> //ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 1);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 1);
> //ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 1);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
>
> So you have an image with a field with no offset, and a field with offsets.
>
> Now if you look between my thumb and my forefinger behind them there's
> a monoscope picture and in one field you can see 2 black squares, in
> the other one you can see 3 black squares. So the two field that will
> be composing a single image differ very much.
>
> Now the questions are: is this expected to happen on an analogue video
> source and we can't do anything (apart from software deinterlacing)?
> is this a problem with tvp5150? Is this a problem with the isp?

Yes, there does seem to be significant movement/differences between these
two images.  Are you saying that these should be the two halves of one frame
that would be stitched together by de-interlacing?  Perhaps the halves are
out of sync and the bottom one of this image really goes with the top of
the next (frame13)?

The ghosting problem is still evident, even in this split image.  Notice
that every other scan line is really poor - basically junk.  When this gets
merged as part of the de-interlace, the ghosts appear.


-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
