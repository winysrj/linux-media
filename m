Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39391 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2E1Q3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 12:29:12 -0400
Received: by gglu4 with SMTP id u4so1929759ggl.19
        for <linux-media@vger.kernel.org>; Mon, 28 May 2012 09:29:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+WuL=b8OXARVkzqdd5dhe9_tvqb=Rh0kqTk78_co9JpYg@mail.gmail.com>
References: <2396617.gGNm1rAEoQ@avalon>
	<1335962403-20706-1-git-send-email-sakari.ailus@iki.fi>
	<201205281227.46866.hverkuil@xs4all.nl>
	<CALF0-+WuL=b8OXARVkzqdd5dhe9_tvqb=Rh0kqTk78_co9JpYg@mail.gmail.com>
Date: Mon, 28 May 2012 13:29:11 -0300
Message-ID: <CALF0-+UEJg9O=9uyrbK3UwvkQ96EeKYm5_G_cGCV6k1nGTiCng@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

On Mon, May 28, 2012 at 8:52 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> I'm just bringing this proposal to your attention as I am wondering how your driver (and
>> the old easycap driver that your driver will replace) handle the easycap device with
>> multiple inputs? Is it cycling through all inputs? In that case we might need the input
>> field.

What do you mean by "cycling through all inputs"?

Do you mean registering one video node per video input
and support simultaneous streaming?

In that case, I don't have that in mind and I'm not sure if the hw
supports it.

On the contrary, I was thinking in registering just one video device
and let user select input through ioctl. All that's needed
it to set some stk1160 (and maybe saa711x) registers to route
the selected input.

I may be missing something, but I don't see any relation between
video buffer queue and selected input.
(Perhaps this is OT and we should discuss this in another thread)

Regards,
Ezequiel.
