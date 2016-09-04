Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37490 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751539AbcIDTZk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Sep 2016 15:25:40 -0400
Date: Sun, 4 Sep 2016 22:25:38 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Oliver Collyer <ovcollyer@mac.com>
Cc: linux-media@vger.kernel.org
Subject: Re: uvcvideo error on second capture from USB device, leading to
 V4L2_BUF_FLAG_ERROR
Message-ID: <20160904192538.75czuv7c2imru6ds@zver>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!
Seems like weird error in V4L subsystem or in uvcvideo driver, in the
most standard usage scenario.
Please retry with kernel and FFmpeg as new as possible, best if compiled
from latest upstream sources.
For kernel please try release 4.7.2 or even linux-next
(git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git), for
FFmpeg please make a git clone from git://source.ffmpeg.org/ffmpeg.git
and there do "./configure && make" and run obtained "ffmpeg" binary.

Please CC me when you come back with your results.
