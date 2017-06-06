Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f170.google.com ([209.85.213.170]:34541 "EHLO
        mail-yb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750755AbdFFEbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 00:31:04 -0400
Received: by mail-yb0-f170.google.com with SMTP id 4so12551687ybl.1
        for <linux-media@vger.kernel.org>; Mon, 05 Jun 2017 21:31:04 -0700 (PDT)
Received: from mail-yb0-f174.google.com (mail-yb0-f174.google.com. [209.85.213.174])
        by smtp.gmail.com with ESMTPSA id x2sm15898573ywj.75.2017.06.05.21.31.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Jun 2017 21:31:02 -0700 (PDT)
Received: by mail-yb0-f174.google.com with SMTP id 4so12551557ybl.1
        for <linux-media@vger.kernel.org>; Mon, 05 Jun 2017 21:31:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5B6LiWgX+=-HJnO480FF-AXDa+UqtSs+SYUG=S+kGgNVg@mail.gmail.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-2-git-send-email-yong.zhi@intel.com> <CAAFQd5B6LiWgX+=-HJnO480FF-AXDa+UqtSs+SYUG=S+kGgNVg@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 6 Jun 2017 13:30:41 +0900
Message-ID: <CAAFQd5DpzAGBi_kevEBp05yC4ytM3Q8WU2owZucsE3AZ=s=OoA@mail.gmail.com>
Subject: Re: [PATCH 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer format
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Uhm, +Laurent. Sorry for the noise.

On Tue, Jun 6, 2017 at 1:30 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> Hi Yong,
>
> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>> Add the IPU3 specific processing parameter format
>> V4L2_META_FMT_IPU3_PARAMS and metadata formats
>> for 3A and other statistics:
>
> Please see my comments inline.
>
>>
>>   V4L2_META_FMT_IPU3_PARAMS
>>   V4L2_META_FMT_IPU3_STAT_3A
>>   V4L2_META_FMT_IPU3_STAT_DVS
>>   V4L2_META_FMT_IPU3_STAT_LACE
>>
>> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++++
>>  include/uapi/linux/videodev2.h       | 6 ++++++
>>  2 files changed, 10 insertions(+)
> [snip]
>> +/* Vendor specific - used for IPU3 camera sub-system */
>> +#define V4L2_META_FMT_IPU3_PARAMS      v4l2_fourcc('i', 'p', '3', 'p') /* IPU3 params */
>> +#define V4L2_META_FMT_IPU3_STAT_3A     v4l2_fourcc('i', 'p', '3', 's') /* IPU3 3A statistics */
>> +#define V4L2_META_FMT_IPU3_STAT_DVS    v4l2_fourcc('i', 'p', '3', 'd') /* IPU3 DVS statistics */
>> +#define V4L2_META_FMT_IPU3_STAT_LACE   v4l2_fourcc('i', 'p', '3', 'l') /* IPU3 LACE statistics */
>
> We had some discussion about this with Laurent and if I remember
> correctly, the conclusion was that it might make sense to define one
> FourCC for a vendor specific format, ('v', 'n', 'd', 'r') for example,
> and then have a V4L2-specific enum within the v4l2_pix_format(_mplane)
> struct that specifies the exact vendor data type. It seems saner than
> assigning a new FourCC whenever a new hardware revision comes out,
> especially given that FourCCs tend to be used outside of the V4L2
> world as well and being kind of (de facto) standardized (with existing
> exceptions, unfortunately).
>
> Best regards,
> Tomasz
