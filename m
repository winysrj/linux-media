Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:59238 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753665AbeGBIBQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 04:01:16 -0400
Subject: Re: [PATCH 00/32] Qualcomm Camera Subsystem driver - 8x96 support
To: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6cffd2ac-d241-1653-1afa-bc623375442d@xs4all.nl>
Date: Mon, 2 Jul 2018 10:01:13 +0200
MIME-Version: 1.0
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On 22/06/18 17:33, Todor Tomov wrote:
> This patchset adds support for the Qualcomm Camera Subsystem found
> on Qualcomm MSM8996 and APQ8096 SoC to the existing driver which
> used to support MSM8916 and APQ8016.
> 
> The camera subsystem hardware on 8x96 is similar to 8x16 but
> supports more cameras and features. More details are added in the
> driver document by the last patch.
> 
> The first 3 patches are dependencies which have already been on
> the mainling list but I'm adding them here for completeness.
> 
> The following 11 patches add general updates and fixes to the driver.
> Then the rest add the support for the new hardware.
> 
> The driver is tested on Dragonboard 410c (APQ8016) and Dragonboard 820c
> (APQ8096) with OV5645 camera sensors. media-ctl [1], yavta [2] and
> GStreamer were used for testing.
> 
> [1] https://git.linuxtv.org//v4l-utils.git
> [2] http://git.ideasonboard.org/yavta.git

I did a quick review of this series and it looked good to me. So once I
have Acked-by's for the bindings changes I can make a pull request.

One thing I would like to have before I do that is the output of
'v4l2-compliance -m /dev/mediaX -v' (probably media0) for both 8x16 and
the new 8x96. Make sure you use the latest v4l2-compliance since I have
been adding new tests for the media controller.

Thanks!

	Hans

> 
> 
> Sakari Ailus (1):
>   doc-rst: Add packed Bayer raw14 pixel formats
> 
> Todor Tomov (31):
>   media: v4l: Add new 2X8 10-bit grayscale media bus code
>   media: v4l: Add new 10-bit packed grayscale format
>   media: Rename CAMSS driver path
>   media: camss: Use SPDX license headers
>   media: camss: Fix OF node usage
>   media: camss: csiphy: Ensure clock mux config is done before the rest
>   media: camss: Unify the clock names
>   media: camss: csiphy: Update settle count calculation
>   media: camss: csid: Configure data type and decode format properly
>   media: camss: vfe: Fix to_vfe() macro member name
>   media: camss: vfe: Get line pointer as container of video_out
>   media: camss: vfe: Do not disable CAMIF when clearing its status
>   media: dt-bindings: media: qcom,camss: Fix whitespaces
>   media: dt-bindings: media: qcom,camss: Add 8996 bindings
>   media: camss: Add 8x96 resources
>   media: camss: Add basic runtime PM support
>   media: camss: csiphy: Split to hardware dependent and independent
>     parts
>   media: camss: csiphy: Unify lane handling
>   media: camss: csiphy: Add support for 8x96
>   media: camss: csid: Add support for 8x96
>   media: camss: ispif: Add support for 8x96
>   media: camss: vfe: Split to hardware dependent and independent parts
>   media: camss: vfe: Add support for 8x96
>   media: camss: Format configuration per hardware version
>   media: camss: vfe: Different format support on source pad
>   media: camss: vfe: Add support for UYVY output from VFE on 8x96
>   media: camss: csid: Different format support on source pad
>   media: camss: csid: MIPI10 to Plain16 format conversion
>   media: camss: Add support for RAW MIPI14 on 8x96
>   media: camss: Add support for 10-bit grayscale formats
>   media: doc: media/v4l-drivers: Update Qualcomm CAMSS driver document
>     for 8x96
> 
>  .../devicetree/bindings/media/qcom,camss.txt       |  128 +-
>  Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
>  Documentation/media/uapi/v4l/pixfmt-srggb14p.rst   |  127 +
>  Documentation/media/uapi/v4l/pixfmt-y10p.rst       |   33 +
>  Documentation/media/uapi/v4l/subdev-formats.rst    |   72 +
>  Documentation/media/uapi/v4l/yuv-formats.rst       |    1 +
>  Documentation/media/v4l-drivers/qcom_camss.rst     |   93 +-
>  .../media/v4l-drivers/qcom_camss_8x96_graph.dot    |  104 +
>  MAINTAINERS                                        |    2 +-
>  drivers/media/platform/Kconfig                     |    2 +-
>  drivers/media/platform/Makefile                    |    2 +-
>  drivers/media/platform/qcom/camss-8x16/Makefile    |   11 -
>  .../media/platform/qcom/camss-8x16/camss-csid.c    | 1094 -------
>  .../media/platform/qcom/camss-8x16/camss-csid.h    |   82 -
>  .../media/platform/qcom/camss-8x16/camss-csiphy.c  |  893 ------
>  .../media/platform/qcom/camss-8x16/camss-csiphy.h  |   77 -
>  .../media/platform/qcom/camss-8x16/camss-ispif.c   | 1178 --------
>  .../media/platform/qcom/camss-8x16/camss-ispif.h   |   85 -
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 3093 --------------------
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  123 -
>  .../media/platform/qcom/camss-8x16/camss-video.c   |  859 ------
>  .../media/platform/qcom/camss-8x16/camss-video.h   |   70 -
>  drivers/media/platform/qcom/camss-8x16/camss.c     |  751 -----
>  drivers/media/platform/qcom/camss-8x16/camss.h     |  106 -
>  drivers/media/platform/qcom/camss/Makefile         |   15 +
>  drivers/media/platform/qcom/camss/camss-csid.c     | 1376 +++++++++
>  drivers/media/platform/qcom/camss/camss-csid.h     |   77 +
>  .../platform/qcom/camss/camss-csiphy-2ph-1-0.c     |  177 ++
>  .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     |  256 ++
>  drivers/media/platform/qcom/camss/camss-csiphy.c   |  761 +++++
>  drivers/media/platform/qcom/camss/camss-csiphy.h   |   89 +
>  drivers/media/platform/qcom/camss/camss-ispif.c    | 1367 +++++++++
>  drivers/media/platform/qcom/camss/camss-ispif.h    |   78 +
>  drivers/media/platform/qcom/camss/camss-vfe-4-1.c  | 1018 +++++++
>  drivers/media/platform/qcom/camss/camss-vfe-4-7.c  | 1140 ++++++++
>  drivers/media/platform/qcom/camss/camss-vfe.c      | 2341 +++++++++++++++
>  drivers/media/platform/qcom/camss/camss-vfe.h      |  183 ++
>  drivers/media/platform/qcom/camss/camss-video.c    |  958 ++++++
>  drivers/media/platform/qcom/camss/camss-video.h    |   62 +
>  drivers/media/platform/qcom/camss/camss.c          | 1027 +++++++
>  drivers/media/platform/qcom/camss/camss.h          |  115 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    1 +
>  include/uapi/linux/media-bus-format.h              |    3 +-
>  include/uapi/linux/videodev2.h                     |    6 +
>  44 files changed, 11530 insertions(+), 8507 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
>  create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10p.rst
>  create mode 100644 Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/Makefile
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csid.c
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csid.h
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-ispif.c
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-ispif.h
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.c
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-video.c
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-video.h
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss.c
>  delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss.h
>  create mode 100644 drivers/media/platform/qcom/camss/Makefile
>  create mode 100644 drivers/media/platform/qcom/camss/camss-csid.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-csid.h
>  create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy.h
>  create mode 100644 drivers/media/platform/qcom/camss/camss-ispif.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-ispif.h
>  create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-1.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-7.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-vfe.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-vfe.h
>  create mode 100644 drivers/media/platform/qcom/camss/camss-video.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss-video.h
>  create mode 100644 drivers/media/platform/qcom/camss/camss.c
>  create mode 100644 drivers/media/platform/qcom/camss/camss.h
> 
