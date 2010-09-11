Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33256 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621Ab0IKQj3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Sep 2010 12:39:29 -0400
Subject: Re: [GIT PATCHES FOR 2.6.37] Documentation fixes & updates
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201009111711.05528.hverkuil@xs4all.nl>
References: <201009111711.05528.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 12:39:24 -0400
Message-ID: <1284223164.2053.79.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Sat, 2010-09-11 at 17:11 +0200, Hans Verkuil wrote:
> The following changes since commit 57fef3eb74a04716a8dd18af0ac510ec4f71bc05:
>   Richard Zidlicky (1):
>         V4L/DVB: dvb: fix smscore_getbuffer() logic
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git misc1
> 
> Hans Verkuil (5):
>       V4L Doc: removed duplicate link
>       V4L Doc: fix DocBook syntax errors.
>       V4L Doc: document V4L2_CAP_RDS_OUTPUT capability.
>       V4L Doc: clarify the V4L spec.
>       V4L Doc: correct the documentation for VIDIOC_QUERYMENU.
> 
>  Documentation/DocBook/v4l/common.xml               |   93 +++++--------------
>  Documentation/DocBook/v4l/controls.xml             |    3 -
>  Documentation/DocBook/v4l/pixfmt-packed-rgb.xml    |    2 +-
>  Documentation/DocBook/v4l/pixfmt.xml               |    4 +-
>  Documentation/DocBook/v4l/vidioc-g-dv-preset.xml   |    3 +-
>  Documentation/DocBook/v4l/vidioc-g-dv-timings.xml  |    3 +-
>  .../DocBook/v4l/vidioc-query-dv-preset.xml         |    2 +-
>  Documentation/DocBook/v4l/vidioc-querycap.xml      |    7 ++-
>  Documentation/DocBook/v4l/vidioc-queryctrl.xml     |   18 +++--
>  9 files changed, 49 insertions(+), 86 deletions(-)
> 

"Even though V4L2 devices can be opened multiple times,
+only one device at a time can be used for streaming video."


Hmm.  Maybe something like this instead?

"Even though a V4L2 device node can be opened multiple times,
             ^^^^^^^^^^^^^^^^^^
only one open file descriptor should be used for streaming."
         ^^^^^^^^^^^^^^^^^^^^ ^^^^^^

Regards,
Andy

