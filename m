Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761331AbZAUBvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 20:51:17 -0500
Date: Tue, 20 Jan 2009 23:50:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: Confusion in usr/include/linux/videodev.h
Message-ID: <20090120235048.4f7200f9@caramujo.chehab.org>
In-Reply-To: <1232502038.3123.61.camel@localhost.localdomain>
References: <1232502038.3123.61.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Jan 2009 07:10:38 +0530
Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> usr/include/linux/videodev.h is giving 2 warnings in 'make headers_check':
>  usr/include/linux/videodev.h:19: leaks CONFIG_VIDEO to userspace where it is not valid
>  usr/include/linux/videodev.h:314: leaks CONFIG_VIDEO to userspace where it is not valid
> 
> Whole file is covered with #if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
> 
> It means this file is only valid for kernel mode if CONFIG_VIDEO_V4L1_COMPAT is defined but in user mode it is always valid.
> 		
> Can we choose some better alternative Or can we use this file as:
> 
> #ifdef CONFIG_VIDEO_V4L1_COMPAT
> #include <linux/videodev.h>
> #endif

This is somewhat like what we have on audio devices (where there are OSS and ALSA API's).

V4L1 is the old deprecated userspace API for video devices. It is still
required by some userspace applications. So, on userspace, it should be
included. Also, this allows that one userspace app to be compatible with both
V4L2 API (the current one) and the legacy V4L1 one.

It should be noticed that are still a few drivers using the legacy API yet to
be converted.

Cheers,
Mauro
