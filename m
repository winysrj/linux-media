Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42146 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab3JJS5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Oct 2013 14:57:24 -0400
Received: by mail-ea0-f176.google.com with SMTP id q16so1372135ead.35
        for <linux-media@vger.kernel.org>; Thu, 10 Oct 2013 11:57:23 -0700 (PDT)
Message-ID: <5256F8A6.1020202@googlemail.com>
Date: Thu, 10 Oct 2013 20:57:42 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx + ov2640 and v4l2-clk
References: <520E76E7.30201@googlemail.com> <74016946-c59e-4b0b-a25b-4c976f60ae43.maildroid@localhost> <5210B2A9.1030803@googlemail.com> <20130818122008.38fac218@samsung.com> <52543116.60509@googlemail.com> <Pine.LNX.4.64.1310081834030.31629@axis700.grange> <5256ACB9.6030800@googlemail.com> <Pine.LNX.4.64.1310101539500.20787@axis700.grange> <5256E0C4.8060102@googlemail.com> <Pine.LNX.4.64.1310101919580.20787@axis700.grange> <5256F40A.20503@googlemail.com>
In-Reply-To: <5256F40A.20503@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.10.2013 20:38, schrieb Frank Schäfer:

[...]
>>>> "Hmm... your patch didn't change this, but:
>>>> Why do we call these functions only in case of V4L2_BUF_TYPE_VIDEO_CAPTURE ?
>>>> Isn't it needed for VBI capturing, too ?
>>>> em28xx_wake_i2c() is probably also needed for radio mode..."
>>>>
>>>> Right, my patch doesn't change this, so, this is unrelated.
>>> Ok, I have to admit that I wasn't clear enough in this case:
>>> IMHO these are bugs that should be fixed, but I'm not 100% sure.
>>> In that case, there is no need to split the if-caluse containing the
>>> V4L2_BUF_TYPE_VIDEO_CAPTURE check, just remove this check while you're
>>> at it.
>> No! It shouldn't be changed "while at it." If it should be changed, it 
>> _certainly_ has to be a separate patch! And it is unrelated.
> If you want the fix as a separate patch, then it would make sense to do
> this before the s_power change.
> IMHO it doesn't make sense to complicate the code just to keep a bug
> which can be fixed easily.
Looking into the code again, I think there are even more things which
need to be fixed. :(
Will try to send a patch tomorrow.

Regards,
Frank

