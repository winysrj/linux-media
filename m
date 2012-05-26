Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2752 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2EZTTn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 May 2012 15:19:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: Re: [RFC/PATCH] media: Add stk1160 new driver
Date: Sat, 26 May 2012 21:19:37 +0200
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	hdegoede@redhat.com
References: <201205261950.06022.hverkuil@xs4all.nl> <CALF0-+UbhYq7fPYsJLQZ+phuTtv4WEdQ9BwbCGA_5XUKHONCXw@mail.gmail.com>
In-Reply-To: <CALF0-+UbhYq7fPYsJLQZ+phuTtv4WEdQ9BwbCGA_5XUKHONCXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205262119.37644.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat May 26 2012 20:38:00 Ezequiel Garcia wrote:
> Hi Hans,
> 
> Thanks for your review (I'm a bit amazed at how fast you went through
> the code :).
> I'll address your excellent comments soon.
> 
> I'm still unsure about a numbre of things. Two of them:
> 
> 1. It seems to mee tracing is not too nice and
> I wasn't really sure how to handle it: dev_xxx, pr_xxx, v4l2_xxx.
> What's the current trend?

dev_xxx with v4l2_xxx as a second option. If you don't need a driver/device
prefix, then pr_xxx is best.

It's messy and it's on my TODO list to simplify this. Unfortunately it's quite
low on that list.

> 2. The original driver allowed to set frame size, but it seemed to me that
> could be done at userspace.

You mean that the original driver allowed hardware resizing? It would be nice
to keep support for that. For a first version you don't have to, though.

> Hence, my implementation says:
> 
> V4L2_STD_625_50 is 720x756 and V4L2_STD_525_60 is 720x480.
> 
> (This is related to the way the video decoder saa711x also assuming that sizes.)
> So userspace is supposed to get frame size, right after changing video standard
> and handle buffer of appropriate size.
> 
> What do you think?

After the video standard is changed that framesize should always be set to the
default size for that standard. An application can then change it to another
size if there is a hardware scaler.

Regards,

	Hans

> 
> 
> On Sat, May 26, 2012 at 2:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > (Ezequiel, your original CC list was mangled, so I'm reposting this)
> >
> Sorry about this :(
> I'll check my git-send-mail config.
> 
> Thanks again,
> Ezequiel.
> 
