Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:36767 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdFSKmI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 06:42:08 -0400
Received: by mail-yb0-f180.google.com with SMTP id t7so26626412yba.3
        for <linux-media@vger.kernel.org>; Mon, 19 Jun 2017 03:42:08 -0700 (PDT)
Received: from mail-yb0-f169.google.com (mail-yb0-f169.google.com. [209.85.213.169])
        by smtp.gmail.com with ESMTPSA id m131sm4113792ywd.67.2017.06.19.03.42.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Jun 2017 03:42:06 -0700 (PDT)
Received: by mail-yb0-f169.google.com with SMTP id 84so26720661ybe.0
        for <linux-media@vger.kernel.org>; Mon, 19 Jun 2017 03:42:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1671392.uVPDOvjJsA@avalon>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <20170616082510.GH12407@valkosipuli.retiisi.org.uk> <CAAFQd5CDG0QYDaD=4ono0Yahz+7+TJ_KLsc+K-bgN82yFr6qmg@mail.gmail.com>
 <1671392.uVPDOvjJsA@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 19 Jun 2017 19:41:45 +0900
Message-ID: <CAAFQd5ConKk1KMdCvKnC5rOEi9tFPD0dj+=ktMsUpx8T=mMjWA@mail.gmail.com>
Subject: Re: [PATCH 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer format
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for looking at this!

On Mon, Jun 19, 2017 at 6:17 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Tomasz,
>
> On Friday 16 Jun 2017 17:35:52 Tomasz Figa wrote:
>> On Fri, Jun 16, 2017 at 5:25 PM, Sakari Ailus wrote:
>> > On Fri, Jun 16, 2017 at 02:52:07PM +0900, Tomasz Figa wrote:
>> >> On Tue, Jun 6, 2017 at 7:09 PM, Tomasz Figa wrote:
>> >>> On Tue, Jun 6, 2017 at 5:04 PM, Hans Verkuil wrote:
>> >>>> On 06/06/17 09:25, Sakari Ailus wrote:
>> >>>>> On Tue, Jun 06, 2017 at 01:30:41PM +0900, Tomasz Figa wrote:
>> >>>>>> On Tue, Jun 6, 2017 at 1:30 PM, Tomasz Figa wrote:
>> >>>>>>> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi wrote:
>> >>>>>>>> Add the IPU3 specific processing parameter format
>> >>>>>>>> V4L2_META_FMT_IPU3_PARAMS and metadata formats
>> >>>>>>>> for 3A and other statistics:
>> >>>>>>>
>> >>>>>>> Please see my comments inline.
>> >>>>>>>
>> >>>>>>>>   V4L2_META_FMT_IPU3_PARAMS
>> >>>>>>>>   V4L2_META_FMT_IPU3_STAT_3A
>> >>>>>>>>   V4L2_META_FMT_IPU3_STAT_DVS
>> >>>>>>>>   V4L2_META_FMT_IPU3_STAT_LACE
>> >>>>>>>>
>> >>>>>>>> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>> >>>>>>>> ---
>> >>>>>>>>
>> >>>>>>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++++
>> >>>>>>>>  include/uapi/linux/videodev2.h       | 6 ++++++
>> >>>>>>>>  2 files changed, 10 insertions(+)
>> >>>>>>>
>> >>>>>>> [snip]
>> >>>>>>>
>> >>>>>>>> +/* Vendor specific - used for IPU3 camera sub-system */
>> >>>>>>>> +#define V4L2_META_FMT_IPU3_PARAMS      v4l2_fourcc('i', 'p', '3',
>> >>>>>>>> 'p') /* IPU3 params */
>> >>>>>>>> +#define V4L2_META_FMT_IPU3_STAT_3A     v4l2_fourcc('i', 'p', '3',
>> >>>>>>>> 's') /* IPU3 3A statistics */
>> >>>>>>>> +#define V4L2_META_FMT_IPU3_STAT_DVS    v4l2_fourcc('i', 'p', '3',
>> >>>>>>>> 'd') /* IPU3 DVS statistics */
>> >>>>>>>> +#define V4L2_META_FMT_IPU3_STAT_LACE   v4l2_fourcc('i', 'p', '3',
>> >>>>>>>> 'l') /* IPU3 LACE statistics */
>
> This series is missing a documentation patch with a clear and detailed
> description of the buffer contents for each of these formats. I'm not very
> concerned about the three statistics formats (although that might change after
> reading the documentation), but the "IPU3 params" format makes me feel nervous
> already.

I guess this is a note addressed to patch authors. :)

>
>> >>>>>>> We had some discussion about this with Laurent and if I remember
>> >>>>>>> correctly, the conclusion was that it might make sense to define
>> >>>>>>> one FourCC for a vendor specific format, ('v', 'n', 'd', 'r') for
>> >>>>>>> example, and then have a V4L2-specific enum within the
>> >>>>>>> v4l2_pix_format(_mplane) struct that specifies the exact vendor data
>> >>>>>>> type.
>
> If I recall correctly, I mentioned that v4l2_format now has a struct
> v4l2_meta_format field that can be used to pass metadata-related parameters
> the same way that v4l2_pix_format passes image-related parameters. The only
> two metadata parameters currently defined are the data format (fourcc) and
> buffer size, and more can be added if needed. However, I don't think the
> v4l2_meta_format structure should be extended with vendor-specific fields.

Ah, then I got that wrong, sorry. But in general I believe we reached
exactly the same conclusion with Hans and Sakari after that.

Best regards,
Tomasz
