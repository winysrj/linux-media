Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41882 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJEDLF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:11:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id 23-v6so3651136pgc.8
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 13:16:14 -0700 (PDT)
Subject: Re: [PATCH v4 00/11] imx-media: Fixes for interlaced capture
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <20181004185401.15751-1-slongerbeam@gmail.com>
 <4e521c80-7041-e5d8-cfa6-c05af07d5cf1@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <0a65391a-66dc-c7f7-2240-b4bfc5642875@gmail.com>
Date: Thu, 4 Oct 2018 13:16:07 -0700
MIME-Version: 1.0
In-Reply-To: <4e521c80-7041-e5d8-cfa6-c05af07d5cf1@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/04/2018 12:34 PM, Hans Verkuil wrote:
> On 10/04/2018 08:53 PM, Steve Longerbeam wrote:
>> A set of patches that fixes some bugs with capturing from an
>> interlaced source, and incompatibilites between IDMAC interlace
>> interweaving and 4:2:0 data write reduction.
>>
>> History:
>> v4:
>> - rebased to latest media-tree master branch.
>> - Make patch author and SoB email addresses the same.
>>
>> v3:
>> - add support for/fix interweaved scan with YUV planar output.
>> - fix bug in 4:2:0 U/V offset macros.
>> - add patch that generalizes behavior of field swap in
>>    ipu_csi_init_interface().
>> - add support for interweaved scan with field order swap.
>>    Suggested by Philipp Zabel.
>> - in v2, inteweave scan was determined using field types of
>>    CSI (and PRPENCVF) at the sink and source pads. In v3, this
>>    has been moved one hop downstream: interweave is now determined
>>    using field type at source pad, and field type selected at
>>    capture interface. Suggested by Philipp.
>> - make sure to double CSI crop target height when input field
>>    type in alternate.
>> - more updates to media driver doc to reflect above.
>>
>> v2:
>> - update media driver doc.
>> - enable idmac interweave only if input field is sequential/alternate,
>>    and output field is 'interlaced*'.
>> - move field try logic out of *try_fmt and into separate function.
>> - fix bug with resetting crop/compose rectangles.
>> - add a patch that fixes a field order bug in VDIC indirect mode.
>> - remove alternate field type from V4L2_FIELD_IS_SEQUENTIAL() macro
>>    Suggested-by: Nicolas Dufresne <nicolas@ndufresne.ca>.
>> - add macro V4L2_FIELD_IS_INTERLACED().
>>
>>
>> Steve Longerbeam (11):
>>    media: videodev2.h: Add more field helper macros
>>    gpu: ipu-csi: Swap fields according to input/output field types
>>    gpu: ipu-v3: Add planar support to interlaced scan
> What should I do with these patches? Do they go through us? Or the drm
> subsystem (or whoever handles this)?
>
> If it goes through another subsystem, then I can Ack them.

Hi Hans, sorry you are right. Philipp Zabel needs to merge these
to his imx-drm/fixes tree. Then we need to wait for them to filter
over to media-tree. Same old slow process, I wish this were faster,
but that is the drawback of changes that span subsystems.

I will submit the above patches to dri-devel ML. And resubmit this
series once they hit media-tree.

Steve


>
>>    media: imx: Fix field negotiation
>>    media: imx-csi: Double crop height for alternate fields at sink
>>    media: imx: interweave and odd-chroma-row skip are incompatible
>>    media: imx-csi: Allow skipping odd chroma rows for YVU420
>>    media: imx: vdic: rely on VDIC for correct field order
>>    media: imx-csi: Move crop/compose reset after filling default mbus
>>      fields
>>    media: imx: Allow interweave with top/bottom lines swapped
>>    media: imx.rst: Update doc to reflect fixes to interlaced capture
>>
>>   Documentation/media/v4l-drivers/imx.rst       |  93 ++++++----
>>   drivers/gpu/ipu-v3/ipu-cpmem.c                |  26 ++-
>>   drivers/gpu/ipu-v3/ipu-csi.c                  | 132 ++++++++++----
>>   drivers/staging/media/imx/imx-ic-prpencvf.c   |  48 +++--
>>   drivers/staging/media/imx/imx-media-capture.c |  14 ++
>>   drivers/staging/media/imx/imx-media-csi.c     | 166 ++++++++++++------
>>   drivers/staging/media/imx/imx-media-vdic.c    |  12 +-
>>   include/uapi/linux/videodev2.h                |   7 +
>>   include/video/imx-ipu-v3.h                    |   6 +-
>>   9 files changed, 359 insertions(+), 145 deletions(-)
>>
