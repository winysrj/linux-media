Return-path: <linux-media-owner@vger.kernel.org>
Received: from eumx.net ([91.82.101.43]:47573 "EHLO owm.eumx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbcISOiC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 10:38:02 -0400
Subject: Re: [PATCH v4 0/8] adv7180 subdev fixes, v4
To: Steve Longerbeam <slongerbeam@gmail.com>, lars@metafoo.de
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Jack Mitchell <ml@embed.me.uk>
Message-ID: <13d4da12-f0e2-6e3b-9fc2-a081cfc7014c@embed.me.uk>
Date: Mon, 19 Sep 2016 15:19:38 +0100
MIME-Version: 1.0
In-Reply-To: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/08/16 19:03, Steve Longerbeam wrote:
> Steve Longerbeam (8):
>   media: adv7180: fix field type
>   media: adv7180: define more registers
>   media: adv7180: add support for NEWAVMODE
>   media: adv7180: add power pin control
>   media: adv7180: implement g_parm
>   media: adv7180: change mbus format to UYVY
>   v4l: Add signal lock status to source change events
>   media: adv7180: enable lock/unlock interrupts
>
>  .../devicetree/bindings/media/i2c/adv7180.txt      |   8 +
>  Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   9 +
>  Documentation/media/videodev2.h.rst.exceptions     |   1 +
>  drivers/media/i2c/Kconfig                          |   2 +-
>  drivers/media/i2c/adv7180.c                        | 200 +++++++++++++++++----
>  include/uapi/linux/videodev2.h                     |   1 +
>  6 files changed, 183 insertions(+), 38 deletions(-)
>

Did anything come of this patchset, I see a few select patches from the 
original (full imx6) series have been merged in but only seems partial?

Cheers,
Jack.
