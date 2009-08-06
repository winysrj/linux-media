Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3359 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbZHFPQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 11:16:11 -0400
Message-ID: <eee1636b2ae21fc4189b27b511e7d22f.squirrel@webmail.xs4all.nl>
In-Reply-To: <200908061709.41211.laurent.pinchart@ideasonboard.com>
References: <200908061709.41211.laurent.pinchart@ideasonboard.com>
Date: Thu, 6 Aug 2009 17:16:08 +0200
Subject: Re: [PATCH,RFC] Drop non-unlocked ioctl support in v4l2-dev.c
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> Hi everybody,
>
> this patch moves the BKL one level down by removing the non-unlocked ioctl
> in
> v4l2-dev.c and calling lock_kernel/unlock_kernel in the unlocked_ioctl
> handler
> if the driver only supports locked ioctl.
>
> Opinions/comments/applause/kicks ?

I've been thinking about this as well, and my idea was to properly
implement this by letting the v4l core serialize ioctls if the driver
doesn't do its own serialization (either through mutexes or lock_kernel).

The driver can just set a flag in video_device if it wants to do
serialization manually, otherwise the core will serialize using a mutex
and we should be able to completely remove the BKL from all v4l drivers.

I was actually planning an RFC for this myself, but you've beaten me to it
:-)

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

