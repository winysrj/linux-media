Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1294 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0KPP1S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 10:27:18 -0500
Message-ID: <ccc5d34bc1daa662da4af75127256505.squirrel@webmail.xs4all.nl>
In-Reply-To: <201011161613.12698.arnd@arndb.de>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
    <201011161522.19758.arnd@arndb.de>
    <b8ec38c9574d2b83b5e9bf9fd0bb45c1.squirrel@webmail.xs4all.nl>
    <201011161613.12698.arnd@arndb.de>
Date: Tue, 16 Nov 2010 16:27:01 +0100
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> On Tuesday 16 November 2010, Hans Verkuil wrote:
>> A pointer to this struct is available in vdev->v4l2_dev. However, not
>> all
>> drivers implement struct v4l2_device. But on the other hand, most
>> relevant
>> drivers do. So as a fallback we would still need a static mutex.
>
> Wouldn't that suffer the same problem as putting the mutex into videodev
> as I suggested? You said that there are probably drivers that need to
> serialize between multiple devices, so if we have a mutex per v4l2_device,
> you can still get races between multiple ioctl calls accessing the same
> per-driver data. To solve this, we'd have to put the lock into a
> per-driver
> structure like v4l2_file_operations or v4l2_ioctl_ops, which would add
> to the ugliness.

I think there is a misunderstanding. One V4L device (e.g. a TV capture
card, a webcam, etc.) has one v4l2_device struct. But it can have multiple
V4L device nodes (/dev/video0, /dev/radio0, etc.), each represented by a
struct video_device (and I really hope I can rename that to v4l2_devnode
soon since that's a very confusing name).

You typically need to serialize between all the device nodes belonging to
the same video hardware. A mutex in struct video_device doesn't do that,
that just serializes access to that single device node. But a mutex in
v4l2_device is at the right level.

      Hans

>
> 	Arnd
>


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

