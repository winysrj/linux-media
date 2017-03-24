Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:41141 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752354AbdCXLPC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 07:15:02 -0400
Subject: Re: [PATCH 0/3] Handling of reduced FPS in V4L2
To: <linux-media@vger.kernel.org>
References: <cover.1490095965.git.joabreu@synopsys.com>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <linux-kernel@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <1939bd77-a74d-3ad6-06db-2b1eaa205aca@synopsys.com>
Date: Fri, 24 Mar 2017 11:03:15 +0000
MIME-Version: 1.0
In-Reply-To: <cover.1490095965.git.joabreu@synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 21-03-2017 11:49, Jose Abreu wrote:
> Hi all,
>
> This is a follow up patch from this discussion [1]. It should be
> seen more as a starting point to introduce better handling of
> time per frame in v4l2. Quoting Hans Verkuil from [1]:
>
> 1) "Add a flag V4L2_DV_FL_CAN_DETECT_REDUCED_FPS. If set,
> then the hw can detect the difference between regular fps
> and 1000/1001 fps. Note: this is only valid for timings of
> VIC codes with the V4L2_DV_FL_CAN_REDUCE_FPS flag set."
>
> 2) "Allow V4L2_DV_FL_REDUCED_FPS to be used for receivers
> if V4L2_DV_FL_CAN_DETECT_REDUCED_FPS is set."
>
> 3) "For standard VIC codes the pixelclock returned by
> query_dv_timings is that of the corresponding VIC timing,
> not what is measured. This will ensure fixed fps values"
>
> 4) "g_parm should calculate the fps based on the v4l2_bt_timings
> struct, looking at the REDUCES_FPS flags. For those receivers that
> cannot detect the difference, the fps will be 24/30/60 Hz, for
> those that can detect the difference g_parm can check if both
> V4L2_DV_FL_CAN_DETECT_REDUCED_FPS and V4L2_DV_FL_REDUCED_FPS are
> set and reduce the fps by 1000/1001."
>
> -----------
> In terms of implementation:
> 	- Point 1) is done in patch 1/3
> 	- Point 2) and 3) should be done by a HDMI Receiver driver
> 	(I think?).
> 	- Point 4) is done in patch 2/3.
> 	- The patch 3/3 is a simple implementation (which was not
> 	tested) in the cobalt driver
> -----------
> 	
> [1] https://patchwork.kernel.org/patch/9609441/
>
> Best regards,
> Jose Miguel Abreu
>
> Cc: Carlos Palminha <palminha@synopsys.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> Jose Abreu (3):
>   [media] videodev2.h: Add new DV flag CAN_DETECT_REDUCED_FPS
>   [media] v4l2-dv-timings: Introduce v4l2_calc_timeperframe helper
>   [media] cobalt: Use v4l2_calc_timeperframe helper
>
>  drivers/media/pci/cobalt/cobalt-v4l2.c    |  9 +++++--
>  drivers/media/v4l2-core/v4l2-dv-timings.c | 39 +++++++++++++++++++++++++++++++
>  include/media/v4l2-dv-timings.h           | 11 +++++++++
>  include/uapi/linux/videodev2.h            |  7 ++++++
>  4 files changed, 64 insertions(+), 2 deletions(-)
>

Can you please review this series, when possible? And if you
could test it on cobalt it would be great :)

Best regards,
Jose Miguel Abreu
