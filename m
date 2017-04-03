Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42856 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdDCIqA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 04:46:00 -0400
Subject: Re: [PATCH v5.1 0/6] drm: bridge: dw-hdmi: Add support for Custom
 PHYs
To: Neil Armstrong <narmstrong@baylibre.com>, mchehab@kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com
References: <1490970319-24981-1-git-send-email-narmstrong@baylibre.com>
Cc: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org
From: Archit Taneja <architt@codeaurora.org>
Message-ID: <dcc349fc-887a-c8cc-f593-1b58f0974d81@codeaurora.org>
Date: Mon, 3 Apr 2017 14:15:51 +0530
MIME-Version: 1.0
In-Reply-To: <1490970319-24981-1-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/31/2017 07:55 PM, Neil Armstrong wrote:
> The Amlogic GX SoCs implements a Synopsys DesignWare HDMI TX Controller
> in combination with a very custom PHY.
>
> Thanks to Laurent Pinchart's changes, the HW report the following :
>  Detected HDMI TX controller v2.01a with HDCP (meson_dw_hdmi_phy)
>
> The following differs from common PHY integration as managed in the current
> driver :
>  - Amlogic PHY is not configured through the internal I2C link
>  - Amlogic PHY do not use the ENTMDS, SVSRET, PDDQ, ... signals from the controller
>  - Amlogic PHY do not export HPD ands RxSense signals to the controller
>
> And finally, concerning the controller integration :
>  - the Controller registers are not flat memory-mapped, and uses an
>     addr+read/write register pair to write all registers.
>  - Inputs only YUV444 pixel data
>
> Most of these uses case are implemented in Laurent Pinchart v5.1 patchset merged
> in drm-misc-next branch.
>
> This is why the following patchset implements :
>  - Configure the Input format from the plat_data
>  - Add PHY callback to handle HPD and RxSense out of the dw-hdmi driver
>
> To implement the input format handling, the Synopsys HDMIT TX Controller input
> V4L bus formats are used and missing formats + documentation are added.
>
> This patchset makes the Amlogic GX SoCs HDMI output successfully work, and is
> also tested on the RK3288 ACT8846 EVB Board.

Please feel free to add my Reviewed-by for all the patches.

Did we get an Ack from the v4l maintainers to take the media
changes via the drm-misc branch? If so, I guess we could go ahead
and push the series to drm-misc-next.

Thanks,
Archit

>
> Changes since v5 at [6] :
>  - Small addition in V4L YUV bus formats documentation
>
> Changes since v4 at [5] :
>  - Rebased on drm-misc-next at bd283d2f66c2
>  - Fix 4:2:0 bus formats naming
>  - Renamed function fd_registered to i2c_init in dw-hdmi.c
>
> Changes since v3 at [4] :
>  - Fix 4:2:0 bus formats naming
>  - Add separate 36bit and 48bit tables for bus formats documentation
>  - Added 4:2:0 bus config in hdmi_video_sample
>  - Moved dw_hdmi documentation in a "bridge" subdir
>  - Rebase on drm-misc-next at 62c58af32c93
>
> Changes since v2 at [3] :
>  - Rebase on laurent patch "Extract PHY interrupt setup to a function"
>  - Reduce phy operations
>  - Switch the V4L bus formats and encodings instead of custom enum
>
> Changes since v1 at [2] :
>  - Drop patches submitted by laurent
>
> Changes since RFC at [1] :
>  - Regmap fixup for 4bytes register access, tested on RK3288 SoC
>  - Move phy callbacks to phy_ops and move Synopsys PHY calls into default ops
>  - Move HDMI link data into shared header
>  - Move Pixel Encoding enum to shared header
>
> [1] http://lkml.kernel.org/r/1484656294-6140-1-git-send-email-narmstrong@baylibre.com
> [2] http://lkml.kernel.org/r/1485774318-21916-1-git-send-email-narmstrong@baylibre.com
> [3] http://lkml.kernel.org/r/1488468572-31971-1-git-send-email-narmstrong@baylibre.com
> [4] http://lkml.kernel.org/r/1488904944-14285-1-git-send-email-narmstrong@baylibre.com
> [5] http://lkml.kernel.org/r/1490109161-20529-1-git-send-email-narmstrong@baylibre.com
> [6] http://lkml.kernel.org/r/1490864675-17336-1-git-send-email-narmstrong@baylibre.com
>
> Laurent Pinchart (1):
>   drm: bridge: dw-hdmi: Extract PHY interrupt setup to a function
>
> Neil Armstrong (5):
>   media: uapi: Add RGB and YUV bus formats for Synopsys HDMI TX
>     Controller
>   documentation: media: Add documentation for new RGB and YUV bus
>     formats
>   drm: bridge: dw-hdmi: Switch to V4L bus format and encodings
>   drm: bridge: dw-hdmi: Add Documentation on supported input formats
>   drm: bridge: dw-hdmi: Move HPD handling to PHY operations
>
>  Documentation/gpu/bridge/dw-hdmi.rst            |  15 +
>  Documentation/gpu/index.rst                     |   1 +
>  Documentation/media/uapi/v4l/subdev-formats.rst | 874 +++++++++++++++++++++++-
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c       | 470 ++++++++-----
>  include/drm/bridge/dw_hdmi.h                    |  68 ++
>  include/uapi/linux/media-bus-format.h           |  13 +-
>  6 files changed, 1268 insertions(+), 173 deletions(-)
>  create mode 100644 Documentation/gpu/bridge/dw-hdmi.rst
>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
