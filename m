Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48102 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab1JNUjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 16:39:18 -0400
Received: by gyb13 with SMTP id 13so1509047gyb.19
        for <linux-media@vger.kernel.org>; Fri, 14 Oct 2011 13:39:18 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Oct 2011 21:39:17 +0100
Message-ID: <CAMLZHHTyxbwAGqHYx72tCA4FU8tFAJ7u1+0D8gCHesiVVQ-pXQ@mail.gmail.com>
Subject: via-camera: scaling and RGB modes
From: Daniel Drake <dsd@laptop.org>
To: corbet@lwn.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

We're dealing with a via-camera issue from the Scratch application.
The latest version of scratch uses libv4l2 and requests RGB24 images
as that is what it uses internally.

via-camera/ov7670 doesn't support RGB24 but libv4l2 kicks in with its
format conversion and chooses RGB565, which we do support.

The catch is that Scratch requests 320x240 video. You probably recall
that you made via-camera only ever request 640x480 from ov7670, but
you also made via-camera offer discontinuous sizes and you used the
via-camera hardware to scale the image to the appropriate size
(viacam_set_scale).

This scaling seems to work fine with YUYV, but fails with RGBA. Test case:
gst-launch v4l2src ! video/x-raw-rgb,bpp=16,width=320,height=240 !
ffmpegcolorspace ! xvimagesink

The colours in the resultant image wrong (lots of green). Change to
640x480, everything fine.

The only documentation I can find on this is the "Chrome9 HCM Graphics
Processor Programming Manual" which really doesn't explain much about
the camera hardware apart from a bare set of register descriptions.
What algorithm does that scaling functionality use, how does it know
which format the image is in? Is there further documentation or are we
stuck with this?

If we're stuck with it, we have the options of solving this either by
disabling everything other than YUYV (which scales fine), or just by
disabling the scaling and locking to 640x480. Thoughts/other ideas?

Unless I'm missing something, there doesn't seem a way to express in
the V4L2 API that RGB is only available at 640x480 while YUYV is
available at a range of sizes.

Thanks,
Daniel
