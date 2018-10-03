Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44832 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbeJDGMI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 02:12:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id 63-v6so7870158wra.11
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 16:21:37 -0700 (PDT)
Subject: Re: [PATCH v3 00/14] imx-media: Fixes for interlaced capture
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
 <db3940a6-d837-9b6a-1f1e-122dda1e1650@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <0701dea4-f3b7-fda9-0dd0-f717a868991d@gmail.com>
Date: Wed, 3 Oct 2018 16:21:31 -0700
MIME-Version: 1.0
In-Reply-To: <db3940a6-d837-9b6a-1f1e-122dda1e1650@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 10/01/2018 03:07 AM, Hans Verkuil wrote:
> Hi Steve,
>
> On 08/01/2018 09:12 PM, Steve Longerbeam wrote:
>> A set of patches that fixes some bugs with capturing from an
>> interlaced source, and incompatibilites between IDMAC interlace
>> interweaving and 4:2:0 data write reduction.
> I reviewed this series and it looks fine to me.

Cool.

>
> It appears that the ipu* patches are already merged, so can you rebase and
> repost?

Done. There are still two ipu* patches that still need a merge:

gpu: ipu-csi: Swap fields according to input/output field types
gpu: ipu-v3: Add planar support to interlaced scan

so those will still be included in the v4 submission.

>
> I would also like to see the 'v4l2-compliance -f' for an interlaced source,
> if at all possible.

Sure, I've run 'v4l2-compliance -f' on two configured pipelines: unprocessed
capture (no scaling, CSC, rotation using ipu), and a VDIC de-interlace 
pipeline.

I have the text output, the output is huge but here is the abbreviated 
results:

Unprocessed pipeline:

root@mx6q:/home/fu# v4l2-compliance -d4 -f
v4l2-compliance SHA   : 2d35de61ac90b030fe15439809b807014e9751fe
<snip>
test VIDIOC_G/S/ENUMINPUT: FAIL
<snip>
test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
<snip>

Total: 715, Succeeded: 713, Failed: 2, Warnings: 0


VDIC de-interlace pipeline:

root@mx6q:/home/fu# v4l2-compliance -d1 -f
v4l2-compliance SHA   : 2d35de61ac90b030fe15439809b807014e9751fe
<snip>
test VIDIOC_G/S/ENUMINPUT: FAIL
<snip>
test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
<snip>
test VIDIOC_G/S_PARM: FAIL
<snip>

Total: 50, Succeeded: 47, Failed: 3, Warnings: 1

I will send you the full output privately.


>
> For that matter, were you able to test all the field formats?

Yes. I've tested on imx6q SabreAuto with the ADV7180 alternate source,
all of the following are tested and produce good video:

ntsc alternate -> interlaced-tb
ntsc alternate -> interlaced-bt
ntsc alternate -> none (VDIC pipeline)
ntsc alternate -> none (VDIC pipeline)

pal alternate -> interlaced-tb
pal alternate -> interlaced-bt
pal alternate -> none (VDIC pipeline)
pal alternate -> none (VDIC pipeline)

Steve


>
>> History:
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
>> Philipp Zabel (1):
>>    gpu: ipu-v3: Allow negative offsets for interlaced scanning
>>
>> Steve Longerbeam (13):
>>    media: videodev2.h: Add more field helper macros
>>    gpu: ipu-csi: Check for field type alternate
>>    gpu: ipu-csi: Swap fields according to input/output field types
>>    gpu: ipu-v3: Fix U/V offset macros for planar 4:2:0
>>    gpu: ipu-v3: Add planar support to interlaced scan
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
>>   Documentation/media/v4l-drivers/imx.rst       |  93 ++++++++++-----
>>   drivers/gpu/ipu-v3/ipu-cpmem.c                |  45 ++++++-
>>   drivers/gpu/ipu-v3/ipu-csi.c                  | 136 ++++++++++++++-------
>>   drivers/staging/media/imx/imx-ic-prpencvf.c   |  48 ++++++--
>>   drivers/staging/media/imx/imx-media-capture.c |  14 +++
>>   drivers/staging/media/imx/imx-media-csi.c     | 166 ++++++++++++++++++--------
>>   drivers/staging/media/imx/imx-media-vdic.c    |  12 +-
>>   include/uapi/linux/videodev2.h                |   7 ++
>>   include/video/imx-ipu-v3.h                    |   6 +-
>>   9 files changed, 377 insertions(+), 150 deletions(-)
>>
