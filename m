Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65050 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab0BVVoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 16:44:06 -0500
Received: by bwz1 with SMTP id 1so473586bwz.21
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 13:44:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002222241.22456.hverkuil@xs4all.nl>
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com>
	 <4B828D9C.50303@redhat.com>
	 <829197381002221317p42dda715lbd7ea1193c40d45c@mail.gmail.com>
	 <201002222241.22456.hverkuil@xs4all.nl>
Date: Mon, 22 Feb 2010 16:43:58 -0500
Message-ID: <829197381002221343u7001cff2t59bfe3ef735db5fc@mail.gmail.com>
Subject: Re: Chroma gain configuration
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Walls <awalls@radix.net>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 22, 2010 at 4:41 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> I am still planning to continue my work for a general control handling
> framework. I know how to do it and it's just time that I lack.
>
> Converting all drivers to support the extended control API is quite complicated
> since the API is fairly complex (esp. with regard to atomicity). In this case
> my advice would be to support extended controls only where needed and wait for
> this framework before converting all the other drivers.

Hans,

I have no objection to holding off if that's what you recommend.  The
only reason we got onto this thread was because the v4l2-dbg
application seems to implicitly assume that *all* private controls
using V4L2_CID_PRIVATE_BASE can only be accessed via the extended
control interface, meaning you cannot use the utility in conjunction
with a driver that has a private control defined in the the
VIDIOC_G_CTRL function.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
