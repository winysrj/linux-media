Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34361 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbbDUQEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 12:04:15 -0400
Received: by wgso17 with SMTP id o17so218980677wgs.1
        for <linux-media@vger.kernel.org>; Tue, 21 Apr 2015 09:04:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
In-Reply-To: <2148230.ZhqY8UHqWD@avalon>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com>
	<1885047.DP4uMGgtdr@avalon>
	<CABcw_Om0fujOR+-O+zw6z_aor8ZgOpJiLUJ0pq4hrHP7v_tKCA@mail.gmail.com>
	<2148230.ZhqY8UHqWD@avalon>
Date: Tue, 21 Apr 2015 11:04:14 -0500
Message-ID: <CABcw_O=HtCQkVnHk-ERCRKFbp0X7tSGQcU7L5133RQmD50yqsA@mail.gmail.com>
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
From: Chris Whittenburg <whittenburg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 17, 2015 at 4:39 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Chris,
>
> On Thursday 16 April 2015 13:05:30 Chris Whittenburg wrote:
>> On Tue, Apr 7, 2015 at 10:51 AM, Laurent Pinchart wrote:
>> > Black level compensation is applied by the CCDC before writing raw frames
>> > to memory. If your raw frames are correct BLC is probably not to blame.
>> >
>> > The default contrast is x1.0 and the default brightness is +0.0, so I
>> > don't think those should be blame either.
>> >
>> > I suspect the RGB2RGB conversion matrix to be wrong. The default setting
>> > is supposed to handle fluorescent lighting. You could try setting the
>> > RGB2RGB matrix to the identity matrix and see if this helps. See
>> > http://git.ideasonboard.org/omap3-isp-live.git/blob/HEAD:/isp/controls.c#l
>> > 184 for sample code.
>> >
>> > Another matrix that could be worth being reprogrammed is the RGB2YUV
>> > matrix, which also defaults to fluorescent lighting. Sample code to
>> > reprogram it is available in the same location.
>>
>> I tried changing the rgb2rgb matrx to the identity matrix:
>>
>> {0x0100, 0x0000, 0x0000},
>> {0x0000, 0x0100, 0x0000},
>> {0x0000, 0x0000, 0x0100}
>>
>> And the csc (rgb2yuv) to this:
>> {256, 0, 0},
>> {0, 0, 0},
>> {0, 0, 0}
>>
>> But I couldn't see much, if any, difference.
>>
>> However, when I forced the gamma correction to be bypassed, it seemed to fix
>> it.
>>
>> Does that make sense?  I guess I don't understand it enough to understand if
>> gamma correction would have compressed all my luma values.
>
> Yes, it makes sense. Gamma correction applies a non-linear transformation to
> the pixel values and can explain the problems you were seeing.
>
> I've checked the default rgb2rgb matrix, and it should work fine for your case
> as all lines add up to 1.0. The default rgb2yuv matrix, however, limits Y
> values to 220, so you should modify it.

I believe the formula used is:
Y = CSCRY*Rin + CSCGY*Gin + CSCBY*Bin +Yoffset

If CSCRY=1.0, and Rin is in the range 0 to 255, then the resulting Y
would be in the range [0, 255] as well, so why would the matrix limit
Y values to 220?  Is it because Rin, Gin, and Bin have already been
limited to the YCbCr range of [16, 240]?
