Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2153 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab2E1SA5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 14:00:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH v3 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
Date: Mon, 28 May 2012 20:00:52 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
References: <2396617.gGNm1rAEoQ@avalon> <201205281910.48876.hverkuil@xs4all.nl> <CALF0-+X80fLz5XrP3dJwoKH+MZ+2ykTfAt9Mk-6mS50693FTHQ@mail.gmail.com>
In-Reply-To: <CALF0-+X80fLz5XrP3dJwoKH+MZ+2ykTfAt9Mk-6mS50693FTHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205282000.52971.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 28 2012 19:25:41 Ezequiel Garcia wrote:
> On Mon, May 28, 2012 at 2:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> I may be missing something, but I don't see any relation between
> >> video buffer queue and selected input.
> >> (Perhaps this is OT and we should discuss this in another thread)
> >
> > Well, this particular API was intended to let the hardware switch from one input
> > to another automatically: e.g. the first frame is from input 1, the second from
> > input 2, etc. until it has gone through all inputs and goes back to input 1.
> >
> > This requires hardware support and if the stk1160 can't do that, then you can
> > forget about all this.
> 
> I did some tests earlier this morning and apparently the input
> switching is done
> through some stk1160 GPIO port setting.
> However, I'll have to figure this out reading easycap staging driver
> and trying different values over and over.
> Plus, saa7115 driver supports "s_routing" function, but couldn't make
> it work: it looked like saa7115 input
> setting was fixed and stk1160 handles the input switching.
> 
> Also, I'm not sure if saa7115 "s_stream" to enable/disable capture is
> also working.
> Sounds a bit weird to me.
> 
> One last query: I found *no* way to distinguish between one device
> (one composite input)
> and the other (four composite input). What do you suggest? Just
> implement all of them always?

If you can't tell them apart, then that would be your only option. You
might also add a 'model' module option so users can tell the driver which model
it is.

Another might be (I don't know if that will work) to try all inputs and see
if you can detect a difference in the saa7115: however, I suspect you can't
tell the difference between 'I have only one input' and 'I have four but I
haven't hooked up anything to my inputs'.

I *hate* it when they don't bother to change the USB IDs.
 
> Looks like I'm on the right path anyway :)

Yup!

Regards,

	Hans
