Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:41532 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752266AbeEQJYH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 05:24:07 -0400
Subject: Re: [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <645869ce-3cad-29e9-72ed-297a9e787c48@zonque.org>
Date: Thu, 17 May 2018 11:24:04 +0200
MIME-Version: 1.0
In-Reply-To: <20180517085405.10104-1-maxime.ripard@bootlin.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday, May 17, 2018 10:53 AM, Maxime Ripard wrote:
> Here is a "small" series that mostly cleans up the ov5640 driver code,
> slowly getting rid of the big data array for more understandable code
> (hopefully).
> 
> The biggest addition would be the clock rate computation at runtime,
> instead of relying on those arrays to setup the clock tree
> properly. As a side effect, it fixes the framerate that was off by
> around 10% on the smaller resolutions, and we now support 60fps.
> 
> This also introduces a bunch of new features.

I'd like to give this a try. What tree should this patch set be applied 
on? I had no luck with media_tree/for-4.18-6.

Thanks,
Daniel


> 
> Let me know what you think,
> Maxime
> 
> Changes from v2:
>    - Rebased on latest Sakari PR
>    - Fixed the issues reported by Hugues: improper FPS returned for
>      formats, improper rounding of the FPS, some with his suggestions,
>      some by simplifying the logic.
>    - Expanded the clock tree comments based on the feedback from Samuel
>      Bobrowicz and Loic Poulain
>    - Merged some of the changes made by Samuel Bobrowicz to fix the
>      MIPI rate computation, fix the call sites of the
>      ov5640_set_timings function, the auto-exposure calculation call,
>      etc.
>    - Split the patches into smaller ones in order to make it more
>      readable (hopefully)
> 
> Changes from v1:
>    - Integrated Hugues' suggestions to fix v4l2-compliance
>    - Fixed the bus width with JPEG
>    - Dropped the clock rate calculation loops for something simpler as
>      suggested by Sakari
>    - Cache the exposure value instead of using the control value
>    - Rebased on top of 4.17
> 
> Maxime Ripard (11):
>    media: ov5640: Adjust the clock based on the expected rate
>    media: ov5640: Remove the clocks registers initialization
>    media: ov5640: Remove redundant defines
>    media: ov5640: Remove redundant register setup
>    media: ov5640: Compute the clock rate at runtime
>    media: ov5640: Remove pixel clock rates
>    media: ov5640: Enhance FPS handling
>    media: ov5640: Make the return rate type more explicit
>    media: ov5640: Make the FPS clamping / rounding more extendable
>    media: ov5640: Add 60 fps support
>    media: ov5640: Remove duplicate auto-exposure setup
> 
> Samuel Bobrowicz (1):
>    media: ov5640: Fix timings setup code
> 
>   drivers/media/i2c/ov5640.c | 701 +++++++++++++++++++++----------------
>   1 file changed, 392 insertions(+), 309 deletions(-)
> 
