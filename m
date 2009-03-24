Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2706 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZCXHGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 03:06:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [question] about open/release and vidioc_g_input/vidioc_s_input functions
Date: Tue, 24 Mar 2009 08:06:39 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
References: <1237850047.31041.162.camel@tux.localhost>
In-Reply-To: <1237850047.31041.162.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903240806.39540.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 24 March 2009 00:14:07 Alexey Klimov wrote:
> Hello, all
>
> After last convertion of radio drivers to use v4l2_device we have such
> code in many radio drivers:
> (it's radio-terratec.c for example)
>
> ...
>  static int terratec_open(struct file *file)
> {
>         return 0;
> }
>
> static int terratec_release(struct file *file)
> {
>         return 0;
> }
> ...
>
> and
>
> ...
> static int vidioc_g_input(struct file *filp, void *priv, unsigned int
> *i)
> {
>         *i = 0;
>         return 0;
> }
>
> static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
> {
>         return i ? -EINVAL : 0;
> }
> ...
>
> Such code used in many radio-drivers as i understand.
>
> Is it good to place this empty and almost empty functions in:
> (here i see two variants)
>
> 1) In header file that be in linux/drivers/media/radio/ directory.
> Later, we can move some generic/or repeating code in this header.
>
> 2) In any v4l header. What header may contain this ?
>
> ?
>
> For what ? Well, as i understand we can decrease amount of lines and
> provide this simple generic functions. It's like
> video_device_release_empty function behaviour. Maybe not only radio
> drivers can use such vidioc_g_input and vidioc_s_input.
>
> Is it worth ?

I don't think it is worth doing this for g/s_input. I think it is useful to 
have them here: it makes it very clear that there is just a single input 
and the overhead in both lines and actual bytes is minimal.

But for the empty open and release functions you could easily handle that in 
v4l2-dev.c: if you leave the open and release callbacks to NULL, then 
v4l2_open and v4l2_release can just return 0. That would be nice.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
