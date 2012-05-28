Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2849 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2E1RKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 13:10:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [PATCH v3 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
Date: Mon, 28 May 2012 19:10:48 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
References: <2396617.gGNm1rAEoQ@avalon> <CALF0-+WuL=b8OXARVkzqdd5dhe9_tvqb=Rh0kqTk78_co9JpYg@mail.gmail.com> <CALF0-+UEJg9O=9uyrbK3UwvkQ96EeKYm5_G_cGCV6k1nGTiCng@mail.gmail.com>
In-Reply-To: <CALF0-+UEJg9O=9uyrbK3UwvkQ96EeKYm5_G_cGCV6k1nGTiCng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205281910.48876.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon May 28 2012 18:29:11 Ezequiel Garcia wrote:
> Hi again,
> 
> On Mon, May 28, 2012 at 8:52 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> >> I'm just bringing this proposal to your attention as I am wondering how your driver (and
> >> the old easycap driver that your driver will replace) handle the easycap device with
> >> multiple inputs? Is it cycling through all inputs? In that case we might need the input
> >> field.
> 
> What do you mean by "cycling through all inputs"?
> 
> Do you mean registering one video node per video input
> and support simultaneous streaming?
> 
> In that case, I don't have that in mind and I'm not sure if the hw
> supports it.
> 
> On the contrary, I was thinking in registering just one video device
> and let user select input through ioctl. All that's needed
> it to set some stk1160 (and maybe saa711x) registers to route
> the selected input.
> 
> I may be missing something, but I don't see any relation between
> video buffer queue and selected input.
> (Perhaps this is OT and we should discuss this in another thread)

Well, this particular API was intended to let the hardware switch from one input
to another automatically: e.g. the first frame is from input 1, the second from
input 2, etc. until it has gone through all inputs and goes back to input 1.

This requires hardware support and if the stk1160 can't do that, then you can
forget about all this. I was just wondering about it since the easycap is sold
with surveillance applications in mind:

http://dx.com/p/easycap-4-channel-4-input-usb-2-0-dvr-video-capture-surveillance-dongle-11127?item=5

However, reading through the comments I realize that the software just switches
input every second or so, so this seems to be done by software, not hardware.

In other words, your approach is the right one :-)

Regards,

	Hans
