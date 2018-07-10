Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:43499 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732205AbeGJVL5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 17:11:57 -0400
Subject: Re: [PATCH v2 0/2] media: i2c: ov5640: Re-work MIPI startup sequence
To: Jacopo Mondi <jacopo@jmondi.org>, <mchehab@kernel.org>,
        <laurent.pinchart@ideasonboard.com>, <maxime.ripard@bootlin.com>,
        <sam@elite-embedded.com>, <jagan@amarulasolutions.com>,
        <festevam@gmail.com>, <pza@pengutronix.de>,
        <hugues.fruchet@st.com>, <loic.poulain@linaro.org>,
        <daniel@zonque.org>
CC: <linux-media@vger.kernel.org>
References: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <e9057214-2e1a-df78-8983-c63c80448cb1@mentor.com>
Date: Tue, 10 Jul 2018 14:10:54 -0700
MIME-Version: 1.0
In-Reply-To: <1531247768-15362-1-git-send-email-jacopo@jmondi.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Sorry to report my testing on SabreSD has same result
as last time. This series fixes the LP-11 timeout at stream
on but captured images are still blank. I tried the 640x480
mode with UYVY2X8. Here is the pad config:

# media-ctl --get-v4l2 "'ov5640 1-003c':0"
         [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb 
xfer:srgb ycbcr:601 quantization:full-range]

Steve

On 07/10/2018 11:36 AM, Jacopo Mondi wrote:
> Hello,
>     this series fixes capture operations on i.MX6Q platforms (and possible other
> platforms reported not working) using MIPI CSI-2 interface.
>
> This iteration expands the v1 version with an additional fix, initially
> submitted by Maxime in his series:
> [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
> https://www.spinics.net/lists/linux-media/msg134436.html
>
> The original patch has been reported not fully fixing the issues by Daniel Mack
> in his comment here below (on a Qualcomm platform if I'm not wrong):
> https://www.spinics.net/lists/linux-media/msg134524.html
> On my i.MX6Q testing platform that patch alone does not fix MIPI capture
> neither.
>
> The version I'm sending here re-introduces some of the timings parameters in the
> initial configuration blob (not in the single mode ones), which apparently has
> to be at least initially programmed to allow the driver to later program them
> singularly in the 'set_timings()' function. Unfortunately I do not have a real
> rationale behind this which explains why it has to be done this way :(
>
> For the MIPI startup sequence re-work patch, no changes compared to v1.
> Steve reported he has verified the LP-11 timout issue is solved on his testing
> platform too. For more details, please refer to the v1 cover letter:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133352.html
>
> Thanks
>     j
>
> Jacopo Mondi (1):
>    media: i2c: ov5640: Re-work MIPI startup sequence
>
> Samuel Bobrowicz (1):
>    media: ov5640: Fix timings setup code
>
>   drivers/media/i2c/ov5640.c | 107 ++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 82 insertions(+), 25 deletions(-)
>
> --
> 2.7.4
>
