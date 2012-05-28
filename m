Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40367 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2E1Lwp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 07:52:45 -0400
Received: by obbtb18 with SMTP id tb18so5271230obb.19
        for <linux-media@vger.kernel.org>; Mon, 28 May 2012 04:52:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205281227.46866.hverkuil@xs4all.nl>
References: <2396617.gGNm1rAEoQ@avalon>
	<1335962403-20706-1-git-send-email-sakari.ailus@iki.fi>
	<201205281227.46866.hverkuil@xs4all.nl>
Date: Mon, 28 May 2012 08:52:44 -0300
Message-ID: <CALF0-+WuL=b8OXARVkzqdd5dhe9_tvqb=Rh0kqTk78_co9JpYg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] v4l: drop v4l2_buffer.input and V4L2_BUF_FLAG_INPUT
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, May 28, 2012 at 7:27 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Ezequiel,
>
> I'm just bringing this proposal to your attention as I am wondering how your driver (and
> the old easycap driver that your driver will replace) handle the easycap device with
> multiple inputs? Is it cycling through all inputs? In that case we might need the input
> field.
>

I've been delaying the multiple input device handling because:
1) I wanted to understand the simpler case first, and
2) I didn't actually own the device (I've bought it a few days ago).

So, I'm gonna take a look at it and let you all now, as soon
as possible.

Thanks,
Ezequiel.
