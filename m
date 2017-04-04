Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35185 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754624AbdDDPzn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 11:55:43 -0400
Received: by mail-wr0-f173.google.com with SMTP id k6so214414151wre.2
        for <linux-media@vger.kernel.org>; Tue, 04 Apr 2017 08:55:42 -0700 (PDT)
Subject: Re: [PATCH v6.1 0/4] drm: bridge: dw-hdmi: Add support for Custom
 PHYs
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org
References: <1491309119-24220-1-git-send-email-narmstrong@baylibre.com>
Cc: Jose.Abreu@synopsys.com, kieran.bingham@ideasonboard.com,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <2110eea1-00cd-250a-f13c-55981d3550cc@baylibre.com>
Date: Tue, 4 Apr 2017 17:55:40 +0200
MIME-Version: 1.0
In-Reply-To: <1491309119-24220-1-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/2017 02:31 PM, Neil Armstrong wrote:
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
> 
> Changes since v6 at [8] :
>  - Dropped already merged media patches in topic/synopsys-media-formats-2017-04-03 tag
>  - Reword the patch "Switch to V4L bus format and encodings" commit message
>  - Fix typo in patch "Switch to V4L bus format and encodings"
>  - Add Laurent Pinchart reviewed/acked-by's
>  - Rebased on drm-misc-next at 9c4ad466d1dd
> 
> Changes since v5.1 at [7] :
>  - Rework of the 48bit tables in V4L bus formats documentation
>  - Add Archit reviewed-by's
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
> [7] http://lkml.kernel.org/r/1490970319-24981-1-git-send-email-narmstrong@baylibre.com
> [8] http://lkml.kernel.org/r/1491230558-10804-1-git-send-email-narmstrong@baylibre.com
> 
> Laurent Pinchart (1):
>   drm: bridge: dw-hdmi: Extract PHY interrupt setup to a function
> 
> Neil Armstrong (3):
>   drm: bridge: dw-hdmi: Switch to V4L bus format and encodings
>   drm: bridge: dw-hdmi: Add Documentation on supported input formats
>   drm: bridge: dw-hdmi: Move HPD handling to PHY operations
> 
>  Documentation/gpu/bridge/dw-hdmi.rst      |  15 +
>  Documentation/gpu/index.rst               |   1 +
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 470 ++++++++++++++++++++----------
>  include/drm/bridge/dw_hdmi.h              |  68 +++++
>  4 files changed, 398 insertions(+), 156 deletions(-)
>  create mode 100644 Documentation/gpu/bridge/dw-hdmi.rst
> 

Applied to drm-misc-next

Thanks Daniel, Sean,
Neil
