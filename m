Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49148 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2EZSiB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 14:38:01 -0400
Received: by obbtb18 with SMTP id tb18so2956265obb.19
        for <linux-media@vger.kernel.org>; Sat, 26 May 2012 11:38:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205261950.06022.hverkuil@xs4all.nl>
References: <201205261950.06022.hverkuil@xs4all.nl>
Date: Sat, 26 May 2012 15:38:00 -0300
Message-ID: <CALF0-+UbhYq7fPYsJLQZ+phuTtv4WEdQ9BwbCGA_5XUKHONCXw@mail.gmail.com>
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	hdegoede@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your review (I'm a bit amazed at how fast you went through
the code :).
I'll address your excellent comments soon.

I'm still unsure about a numbre of things. Two of them:

1. It seems to mee tracing is not too nice and
I wasn't really sure how to handle it: dev_xxx, pr_xxx, v4l2_xxx.
What's the current trend?

2. The original driver allowed to set frame size, but it seemed to me that
could be done at userspace.

Hence, my implementation says:

V4L2_STD_625_50 is 720x756 and V4L2_STD_525_60 is 720x480.

(This is related to the way the video decoder saa711x also assuming that sizes.)
So userspace is supposed to get frame size, right after changing video standard
and handle buffer of appropriate size.

What do you think?


On Sat, May 26, 2012 at 2:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> (Ezequiel, your original CC list was mangled, so I'm reposting this)
>
Sorry about this :(
I'll check my git-send-mail config.

Thanks again,
Ezequiel.
