Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:28029 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZDDVhp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 17:37:45 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1864456qwh.37
        for <linux-media@vger.kernel.org>; Sat, 04 Apr 2009 14:37:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D4CC5F.9030101@linuxtv.org>
References: <e3538fbd0904012216g48da5006hb170974530bdcea3@mail.gmail.com>
	 <49D4CC5F.9030101@linuxtv.org>
Date: Sat, 4 Apr 2009 16:37:42 -0500
Message-ID: <e3538fbd0904041437ic34e1bdvc798ab500be53457@mail.gmail.com>
Subject: Re: Broken ioctls for the mpeg encoder on the HVR-1800
From: Joseph Yasi <joe.yasi@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 2, 2009 at 9:31 AM, Steven Toth <stoth@linuxtv.org> wrote:
> Most of the ioctls I tested were against the preview device, although some
> do work on the encoder device itself (bitrate etc).

Changing the bitrate doesn't work anymore either.  The video_ioctl2
hook got dropped from the cx23885-417 driver when v4l2_file_operations
was introduced in changeset d615e9cdfbdd.  Is there a reason this was
dropped?

Thanks,
Joe Yasi

diff -r 4c7466ea8d64 linux/drivers/media/video/cx23885/cx23885-417.c
--- a/linux/drivers/media/video/cx23885/cx23885-417.c   Wed Apr 01
07:36:31 2009 -0300
+++ b/linux/drivers/media/video/cx23885/cx23885-417.c   Sat Apr 04
16:33:29 2009 -0500
@@ -1683,6 +1683,7 @@
        .read          = mpeg_read,
        .poll          = mpeg_poll,
        .mmap          = mpeg_mmap,
+       .ioctl         = video_ioctl2,
 };

 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
