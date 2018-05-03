Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:56085 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbeECNpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:45:38 -0400
Received: by mail-it0-f41.google.com with SMTP id 144-v6so21942710iti.5
        for <linux-media@vger.kernel.org>; Thu, 03 May 2018 06:45:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4411331.L07MOrSnxD@avalon>
References: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com> <4411331.L07MOrSnxD@avalon>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Thu, 3 May 2018 15:45:36 +0200
Message-ID: <CAKMK7uG_WBvAaRDy9Co=LLa6cUcLTuWYNu7ABkUxs-NzEXNRew@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] R-Car DU: Support CRC calculation
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 3, 2018 at 2:06 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Dave,
>
> Ping ?

Not aware of any crc core work going on in drm, so has my ack. Worst
case we do a topic branch or something like that (since I guess you'll
do a pull request anyway on the v4l side). Acked-by: me.
-Daniel

>
> On Saturday, 28 April 2018 23:50:19 EEST Laurent Pinchart wrote:
>> Hello,
>>
>> (Dave, there's a request for you below)
>>
>> This patch series adds support for CRC calculation to the rcar-du-drm
>> driver.
>>
>> CRC calculation is supported starting at the Renesas R-Car Gen3 SoCs, as
>> earlier versions don't have the necessary hardware. On Gen3 SoCs, the CRC is
>> computed by the DISCOM module part of the VSP-D and VSP-DL.
>>
>> The DISCOM is interfaced to the VSP through the UIF glue and appears as a
>> VSP entity with a sink pad and a source pad.
>>
>> The series starts with a switch to SPDX license headers in patch 1/8,
>> prompted by a checkpatch.pl warning for a later patch that complained about
>> missing SPDX license headers. It then continues with cleanup and
>> refactoring. Patches 2/8 and 3/8 prepare for DISCOM and UIF support by
>> extending generic code to make it usable for the UIF. Patch 4/8 documents a
>> structure that will receive new fields.
>>
>> Patch 5/8 then extends the API exposed by the VSP driver to the DU driver to
>> support CRC computation configuration and reporting. The patch
>> unfortunately needs to touch both the VSP and DU drivers, so the whole
>> series will need to be merged through a single tree.
>>
>> Patch 5/8 adds support for the DISCOM and UIF in the VSP driver, patch 7/8
>> integrates it in the DRM pipeline, and patch 8/8 finally implements the CRC
>> API in the DU driver to expose CRC computation to userspace.
>>
>> The hardware supports computing the CRC at any arbitrary point in the
>> pipeline on a configurable window of the frame. This patch series supports
>> CRC computation on input planes or pipeline output, but on the full frame
>> only. Support for CRC window configuration can be added later if needed but
>> will require extending the userspace API, as the DRM/KMS CRC API doesn't
>> support this feature.
>>
>> Compared to v1, the CRC source names for plane inputs are now constructed
>> from plane IDs instead of plane indices. This allows userspace to match CRC
>> sources with planes.
>>
>> Compared to v2, various small issues reported by reviewers have been fixed.
>> I believe the series to now be ready for upstream merge.
>>
>> Note that exposing the DISCOM and UIF though the V4L2 API isn't supported as
>> the module is only found in VSP-D and VSP-DL instances that are not exposed
>> through V4L2. It is possible to expose those instances through V4L2 with a
>> small modification to the driver for testing purpose. If the need arises to
>> test DISCOM and UIF with such an out-of-tree patch, support for CRC
>> reporting through a V4L2 control can be added later without affecting how
>> CRC is exposed through the DRM/KMS API.
>>
>> The patches are based on top of the "[PATCH v2 00/15] R-Car VSP1:
>> Dynamically assign blend units to display pipelines" patch series, itself
>> based on top of the Linux media master branch and scheduled for merge in
>> v4.18. The new base caused heavy conflicts, requiring this series to be
>> merged through the V4L2 tree.
>>
>> Dave, I have verified that this series merges cleanly with your drm-next and
>> drm-fixes branches, with the drm-misc-next and drm-misc-fixes branches, and
>> with the R-Car DU patches I would like to get merged in v4.18 through your
>> tree. Could I get your ack to merge this through the V4L2 tree ?
>>
>> For convenience the patches are available at
>>
>>         git://linuxtv.org/pinchartl/media.git vsp1-discom-v3-20180428
>>
>> The code has been tested through the kms-test-crc.py script part of the DU
>> test suite available at
>>
>>         git://git.ideasonboard.com/renesas/kms-tests.git discom
>>
>> Laurent Pinchart (8):
>>   v4l: vsp1: Use SPDX license headers
>>   v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad operation code
>>   v4l: vsp1: Reset the crop and compose rectangles in the set_fmt helper
>>   v4l: vsp1: Document the vsp1_du_atomic_config structure
>>   v4l: vsp1: Extend the DU API to support CRC computation
>>   v4l: vsp1: Add support for the DISCOM entity
>>   v4l: vsp1: Integrate DISCOM in display pipeline
>>   drm: rcar-du: Add support for CRC computation
>>
>>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c    | 156 ++++++++++++++++-
>>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h    |  15 ++
>>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c     |  12 +-
>>  drivers/media/platform/vsp1/Makefile      |   2 +-
>>  drivers/media/platform/vsp1/vsp1.h        |  10 +-
>>  drivers/media/platform/vsp1/vsp1_brx.c    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_brx.h    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_clu.c    |  71 ++------
>>  drivers/media/platform/vsp1/vsp1_clu.h    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_dl.c     |   8 +-
>>  drivers/media/platform/vsp1/vsp1_dl.h     |   6 +-
>>  drivers/media/platform/vsp1/vsp1_drm.c    | 127 ++++++++++++--
>>  drivers/media/platform/vsp1/vsp1_drm.h    |  15 +-
>>  drivers/media/platform/vsp1/vsp1_drv.c    |  26 ++-
>>  drivers/media/platform/vsp1/vsp1_entity.c | 103 +++++++++++-
>>  drivers/media/platform/vsp1/vsp1_entity.h |  13 +-
>>  drivers/media/platform/vsp1/vsp1_hgo.c    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_hgo.h    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_hgt.c    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_hgt.h    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_histo.c  |  65 +------
>>  drivers/media/platform/vsp1/vsp1_histo.h  |   6 +-
>>  drivers/media/platform/vsp1/vsp1_hsit.c   |   6 +-
>>  drivers/media/platform/vsp1/vsp1_hsit.h   |   6 +-
>>  drivers/media/platform/vsp1/vsp1_lif.c    |  71 ++------
>>  drivers/media/platform/vsp1/vsp1_lif.h    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_lut.c    |  71 ++------
>>  drivers/media/platform/vsp1/vsp1_lut.h    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_pipe.c   |   6 +-
>>  drivers/media/platform/vsp1/vsp1_pipe.h   |   6 +-
>>  drivers/media/platform/vsp1/vsp1_regs.h   |  46 ++++-
>>  drivers/media/platform/vsp1/vsp1_rpf.c    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_rwpf.c   |   6 +-
>>  drivers/media/platform/vsp1/vsp1_rwpf.h   |   6 +-
>>  drivers/media/platform/vsp1/vsp1_sru.c    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_sru.h    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_uds.c    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_uds.h    |   6 +-
>>  drivers/media/platform/vsp1/vsp1_uif.c    | 271 +++++++++++++++++++++++++++
>>  drivers/media/platform/vsp1/vsp1_uif.h    |  32 ++++
>>  drivers/media/platform/vsp1/vsp1_video.c  |   6 +-
>>  drivers/media/platform/vsp1/vsp1_video.h  |   6 +-
>>  drivers/media/platform/vsp1/vsp1_wpf.c    |   6 +-
>>  include/media/vsp1.h                      |  45 ++++-
>>  44 files changed, 892 insertions(+), 417 deletions(-)
>>  create mode 100644 drivers/media/platform/vsp1/vsp1_uif.c
>>  create mode 100644 drivers/media/platform/vsp1/vsp1_uif.h
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
