Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34054 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbbCZQYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 12:24:13 -0400
Received: by lbbsy1 with SMTP id sy1so44878161lbb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Mar 2015 09:24:11 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 26 Mar 2015 17:23:51 +0100
Message-ID: <CAPybu_1vgJ3t8GnKDk02SH0KkuEQH-Q-6Ym6gNX7a5H5OekAuA@mail.gmail.com>
Subject: RFC: New format V4L2_PIX_FMT_Y16_BE ?
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

While debugging a v4l2<->gstreamer interaction problem, I have
realized that we were implementing Y16 wrong in our cameras :S. What
we were implementing was a big endian version of the format.

If I want to add support for our Y16_BE format to the kernel, would it
be enough to change videodev2.h, add the documentation for the format
and update libv4lconvert?


Regards!


-- 
Ricardo Ribalda
