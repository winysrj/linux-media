Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:47561 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751455AbdCXOGK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 10:06:10 -0400
Subject: Re: [PATCH v7 0/9] Qualcomm video decoder/encoder driver
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0e340ba9-9ed8-3930-2d52-800301f6e49e@xs4all.nl>
Date: Fri, 24 Mar 2017 15:06:02 +0100
MIME-Version: 1.0
In-Reply-To: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/13/17 17:37, Stanimir Varbanov wrote:
> Hi all,
> 
> Here is seventh version of the patch-set - no functional changes in
> v4l2 APIs.
> 
> The changes since v6 are.
>   * changes in DT binding document - moved memory-region DT property
>     in video-codec node - see 2/9.
>   * improved recovery mechanism. 
>   * fixed various issues found during testing.
> 
> Build dependencies:
>   - qcom_scm_set_remote_state is merged in Linux 4.11-rc1
>   - qcom mdt_loader is merged in Linux 4.11-rc1
> 
> regards,
> Stan
>   
> Stanimir Varbanov (9):
>   media: v4l2-mem2mem: extend m2m APIs for more accurate buffer
>     management

I don't see this patch on linux-media. Can you post that one again?

Can you also post the v4l2-compliance test results? Make sure you compile
v4l2-compliance straight from the git repo to avoid testing with an old
version.

Thanks!

	Hans

>   doc: DT: venus: binding document for Qualcomm video driver
>   MAINTAINERS: Add Qualcomm Venus video accelerator driver
>   media: venus: adding core part and helper functions
>   media: venus: vdec: add video decoder files
>   media: venus: venc: add video encoder files
>   media: venus: hfi: add Host Firmware Interface (HFI)
>   media: venus: hfi: add Venus HFI files
>   media: venus: enable building of Venus video driver
> 
>  .../devicetree/bindings/media/qcom,venus.txt       |  107 ++
>  MAINTAINERS                                        |    8 +
>  drivers/media/platform/Kconfig                     |   14 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/qcom/venus/Makefile         |   11 +
>  drivers/media/platform/qcom/venus/core.c           |  386 +++++
>  drivers/media/platform/qcom/venus/core.h           |  306 ++++
>  drivers/media/platform/qcom/venus/firmware.c       |  107 ++
>  drivers/media/platform/qcom/venus/firmware.h       |   22 +
>  drivers/media/platform/qcom/venus/helpers.c        |  632 ++++++++
>  drivers/media/platform/qcom/venus/helpers.h        |   41 +
>  drivers/media/platform/qcom/venus/hfi.c            |  520 +++++++
>  drivers/media/platform/qcom/venus/hfi.h            |  174 +++
>  drivers/media/platform/qcom/venus/hfi_cmds.c       | 1256 ++++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_cmds.h       |  304 ++++
>  drivers/media/platform/qcom/venus/hfi_helper.h     | 1050 +++++++++++++
>  drivers/media/platform/qcom/venus/hfi_msgs.c       | 1058 +++++++++++++
>  drivers/media/platform/qcom/venus/hfi_msgs.h       |  283 ++++
>  drivers/media/platform/qcom/venus/hfi_venus.c      | 1570 ++++++++++++++++++++
>  drivers/media/platform/qcom/venus/hfi_venus.h      |   23 +
>  drivers/media/platform/qcom/venus/hfi_venus_io.h   |  113 ++
>  drivers/media/platform/qcom/venus/vdec.c           | 1091 ++++++++++++++
>  drivers/media/platform/qcom/venus/vdec.h           |   23 +
>  drivers/media/platform/qcom/venus/vdec_ctrls.c     |  149 ++
>  drivers/media/platform/qcom/venus/venc.c           | 1231 +++++++++++++++
>  drivers/media/platform/qcom/venus/venc.h           |   23 +
>  drivers/media/platform/qcom/venus/venc_ctrls.c     |  258 ++++
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |   37 +
>  include/media/v4l2-mem2mem.h                       |   92 ++
>  29 files changed, 10891 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
>  create mode 100644 drivers/media/platform/qcom/venus/Makefile
>  create mode 100644 drivers/media/platform/qcom/venus/core.c
>  create mode 100644 drivers/media/platform/qcom/venus/core.h
>  create mode 100644 drivers/media/platform/qcom/venus/firmware.c
>  create mode 100644 drivers/media/platform/qcom/venus/firmware.h
>  create mode 100644 drivers/media/platform/qcom/venus/helpers.c
>  create mode 100644 drivers/media/platform/qcom/venus/helpers.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_cmds.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_cmds.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_helper.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_msgs.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_msgs.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.c
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus.h
>  create mode 100644 drivers/media/platform/qcom/venus/hfi_venus_io.h
>  create mode 100644 drivers/media/platform/qcom/venus/vdec.c
>  create mode 100644 drivers/media/platform/qcom/venus/vdec.h
>  create mode 100644 drivers/media/platform/qcom/venus/vdec_ctrls.c
>  create mode 100644 drivers/media/platform/qcom/venus/venc.c
>  create mode 100644 drivers/media/platform/qcom/venus/venc.h
>  create mode 100644 drivers/media/platform/qcom/venus/venc_ctrls.c
> 
