Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38437 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2E1RZm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 13:25:42 -0400
Received: by obbtb18 with SMTP id tb18so5607256obb.19
        for <linux-media@vger.kernel.org>; Mon, 28 May 2012 10:25:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205281910.48876.hverkuil@xs4all.nl>
References: <2396617.gGNm1rAEoQ@avalon>
	<CALF0-+WuL=b8OXARVkzqdd5dhe9_tvqb=Rh0kqTk78_co9JpYg@mail.gmail.com>
	<CALF0-+UEJg9O=9uyrbK3UwvkQ96EeKYm5_G_cGCV6k1nGTiCng@mail.gmail.com>
	<201205281910.48876.hverkuil@xs4all.nl>
Date: Mon, 28 May 2012 14:25:41 -0300
Message-ID: <CALF0-+X80fLz5XrP3dJwoKH+MZ+2ykTfAt9Mk-6mS50693FTHQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2012 at 2:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> I may be missing something, but I don't see any relation between
>> video buffer queue and selected input.
>> (Perhaps this is OT and we should discuss this in another thread)
>
> Well, this particular API was intended to let the hardware switch from one input
> to another automatically: e.g. the first frame is from input 1, the second from
> input 2, etc. until it has gone through all inputs and goes back to input 1.
>
> This requires hardware support and if the stk1160 can't do that, then you can
> forget about all this.

I did some tests earlier this morning and apparently the input
switching is done
through some stk1160 GPIO port setting.
However, I'll have to figure this out reading easycap staging driver
and trying different values over and over.
Plus, saa7115 driver supports "s_routing" function, but couldn't make
it work: it looked like saa7115 input
setting was fixed and stk1160 handles the input switching.

Also, I'm not sure if saa7115 "s_stream" to enable/disable capture is
also working.
Sounds a bit weird to me.

One last query: I found *no* way to distinguish between one device
(one composite input)
and the other (four composite input). What do you suggest? Just
implement all of them always?

Looks like I'm on the right path anyway :)

Thanks,
Ezequiel.
