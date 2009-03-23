Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36343 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbZCWXNC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 19:13:02 -0400
Received: by fxm2 with SMTP id 2so2034961fxm.37
        for <linux-media@vger.kernel.org>; Mon, 23 Mar 2009 16:12:59 -0700 (PDT)
Subject: [question] about open/release and vidioc_g_input/vidioc_s_input
 functions
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 02:14:07 +0300
Message-Id: <1237850047.31041.162.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, all

After last convertion of radio drivers to use v4l2_device we have such
code in many radio drivers:
(it's radio-terratec.c for example)

...
 static int terratec_open(struct file *file)
{
        return 0;
}

static int terratec_release(struct file *file)
{
        return 0;
}
...

and

...
static int vidioc_g_input(struct file *filp, void *priv, unsigned int
*i)
{
        *i = 0;
        return 0;
}

static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
{
        return i ? -EINVAL : 0;
}
...

Such code used in many radio-drivers as i understand.

Is it good to place this empty and almost empty functions in:
(here i see two variants)

1) In header file that be in linux/drivers/media/radio/ directory.
Later, we can move some generic/or repeating code in this header.

2) In any v4l header. What header may contain this ? 

?

For what ? Well, as i understand we can decrease amount of lines and
provide this simple generic functions. It's like
video_device_release_empty function behaviour. Maybe not only radio
drivers can use such vidioc_g_input and vidioc_s_input.

Is it worth ?

-- 
Best regards, Klimov Alexey

