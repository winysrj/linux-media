Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f175.google.com ([209.85.213.175]:35875 "EHLO
        mail-yb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdFPFwb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 01:52:31 -0400
Received: by mail-yb0-f175.google.com with SMTP id t7so9662144yba.3
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 22:52:31 -0700 (PDT)
Received: from mail-yb0-f172.google.com (mail-yb0-f172.google.com. [209.85.213.172])
        by smtp.gmail.com with ESMTPSA id x3sm580456ywf.46.2017.06.15.22.52.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jun 2017 22:52:29 -0700 (PDT)
Received: by mail-yb0-f172.google.com with SMTP id 84so9740732ybe.0
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 22:52:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5CY7jUJEicQ79QLTYP65cWqMhtTXJvZD-VCnKN134Ypeg@mail.gmail.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-2-git-send-email-yong.zhi@intel.com> <CAAFQd5B6LiWgX+=-HJnO480FF-AXDa+UqtSs+SYUG=S+kGgNVg@mail.gmail.com>
 <CAAFQd5DpzAGBi_kevEBp05yC4ytM3Q8WU2owZucsE3AZ=s=OoA@mail.gmail.com>
 <20170606072519.GF15419@paasikivi.fi.intel.com> <1d067ac0-6265-4262-e59b-089d6055550b@xs4all.nl>
 <CAAFQd5CY7jUJEicQ79QLTYP65cWqMhtTXJvZD-VCnKN134Ypeg@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 16 Jun 2017 14:52:07 +0900
Message-ID: <CAAFQd5C1PQkMgu3QMJ=_J2-FCiUzVwGft6-U3JQRQNy4=1CgRg@mail.gmail.com>
Subject: Re: [PATCH 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer format
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 6, 2017 at 7:09 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> On Tue, Jun 6, 2017 at 5:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 06/06/17 09:25, Sakari Ailus wrote:
>>> Hi Tomasz,
>>>
>>> On Tue, Jun 06, 2017 at 01:30:41PM +0900, Tomasz Figa wrote:
>>>> Uhm, +Laurent. Sorry for the noise.
>>>>
>>>> On Tue, Jun 6, 2017 at 1:30 PM, Tomasz Figa <tfiga@chromium.org> wrote:
>>>>> Hi Yong,
>>>>>
>>>>> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
>>>>>> Add the IPU3 specific processing parameter format
>>>>>> V4L2_META_FMT_IPU3_PARAMS and metadata formats
>>>>>> for 3A and other statistics:
>>>>>
>>>>> Please see my comments inline.
>>>>>
>>>>>>
>>>>>>   V4L2_META_FMT_IPU3_PARAMS
>>>>>>   V4L2_META_FMT_IPU3_STAT_3A
>>>>>>   V4L2_META_FMT_IPU3_STAT_DVS
>>>>>>   V4L2_META_FMT_IPU3_STAT_LACE
>>>>>>
>>>>>> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
>>>>>> ---
>>>>>>  drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++++
>>>>>>  include/uapi/linux/videodev2.h       | 6 ++++++
>>>>>>  2 files changed, 10 insertions(+)
>>>>> [snip]
>>>>>> +/* Vendor specific - used for IPU3 camera sub-system */
>>>>>> +#define V4L2_META_FMT_IPU3_PARAMS      v4l2_fourcc('i', 'p', '3', 'p') /* IPU3 params */
>>>>>> +#define V4L2_META_FMT_IPU3_STAT_3A     v4l2_fourcc('i', 'p', '3', 's') /* IPU3 3A statistics */
>>>>>> +#define V4L2_META_FMT_IPU3_STAT_DVS    v4l2_fourcc('i', 'p', '3', 'd') /* IPU3 DVS statistics */
>>>>>> +#define V4L2_META_FMT_IPU3_STAT_LACE   v4l2_fourcc('i', 'p', '3', 'l') /* IPU3 LACE statistics */
>>>>>
>>>>> We had some discussion about this with Laurent and if I remember
>>>>> correctly, the conclusion was that it might make sense to define one
>>>>> FourCC for a vendor specific format, ('v', 'n', 'd', 'r') for example,
>>>>> and then have a V4L2-specific enum within the v4l2_pix_format(_mplane)
>>>>> struct that specifies the exact vendor data type. It seems saner than
>>>>> assigning a new FourCC whenever a new hardware revision comes out,
>>>>> especially given that FourCCs tend to be used outside of the V4L2
>>>>> world as well and being kind of (de facto) standardized (with existing
>>>>> exceptions, unfortunately).
>>
>> I can't remember that discussion
>
> I think that was just a casual chat between Lauren, me and few more guys.
>
>> although I've had other discussions with
>> Laurent related to this on how to handle formats that have many variations
>> on a theme.
>>
>> But speaking for this specific case I see no reason to do something special.
>> There are only four new formats, which seems perfectly reasonable to me.
>>
>> I don't see the advantage of adding another layer of pixel formats. You still
>> need to define something for this, one way or the other. And this way doesn't
>> require API changes.
>>
>>> If we have four video nodes with different vendor specific formats, how does
>>> the user tell the formats apart? I presume the user space could use the
>>> entity names for instance, but that would essentially make them device
>>> specific.
>>
>> Well, they are. There really is no way to avoid that.
>>
>>> I'm not sure if there would be any harm from that in practice though: the
>>> user will need to find the device nodes somehow and that will be very likely
>>> based on e.g. entity names.
>>>
>>> How should the documentation be arranged? The documentation is arranged by
>>> fourccs currently; we'd probably need a separate section for vendor specific
>>> formats. I think the device name should be listed there as well.
>>
>> There already is a separate section for metadata formats:
>>
>> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/meta-formats.html
>>
>> But perhaps that page should be organized by device. And with some more
>> detailed information on how to find the video node (i.e. entity names).
>>
>>> I'd like to have perhaps Hans's comment on that as well.
>>>
>>> I don't really see a drawback in the current way of doing this either; we
>>> may get a few new fourcc codes occasionally of which I'm not really worried
>>> about. --- I'd rather ask why should there be an exception on how vendor
>>> specific formats are defined. And if we do make an exception, then how do
>>> you decide which one is and isn't vendor specific? There are raw bayer
>>> format variants that are just raw bayer data but the pixels are arranged
>>> differently (e.g. CIO2 driver).
>>>
>>
>> For these unique formats I am happy with the way it is today. The problem
>> is more with 'parameterized' formats. A simple example would be the 4:2:2
>> interleaved YUV formats where you have four different ways of ordering the
>> Y, U and V components. Right now we have four defines for that, but things
>> get out of hand quickly when you have multiple parameters like that.
>>
>> Laurent and myself discussed that with NVidia some time ago, without
>> reaching a clear conclusion. Mostly because we couldn't come up with an
>> API that is simple enough.
>
> Actually I back off a bit. Still, it looks like we have a metadata
> interface already, but it's limited to CAPTURE:
>
> https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/dev-meta.html#metadata
>
> Maybe we can also have V4L2_BUF_TYPE_META_OUTPUT and solve the problem
> of private FourCCs (and possible collisions with rest of the world) by
> restricting them to the V4L2_BUF_TYPE_META_* classes only?

Any comments on this idea?

Actually, there is one more thing, which would become possible with
switching to different queue types. If we have a device with queues
like this:
- video input,
- video output,
- parameters,
- statistics,
they could all be contained within one video node simply exposing 4
different queues. It would actually even allow an easy implementation
of mem2mem, given that for mem2mem devices opening a video node means
creating a mem2mem context (while multiple video nodes would require
some special synchronization to map contexts together, which doesn't
exist as of today).

Best regards,
Tomasz
