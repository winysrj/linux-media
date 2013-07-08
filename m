Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:37864 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3GHJT6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jul 2013 05:19:58 -0400
Received: by mail-vc0-f182.google.com with SMTP id id13so3087440vcb.41
        for <linux-media@vger.kernel.org>; Mon, 08 Jul 2013 02:19:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306281625.46438.hverkuil@xs4all.nl>
References: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
	<1372157835-27663-8-git-send-email-arun.kk@samsung.com>
	<201306281625.46438.hverkuil@xs4all.nl>
Date: Mon, 8 Jul 2013 14:49:57 +0530
Message-ID: <CALt3h799eMq4RmoygxuoHFmCmVmN3Rk8oaVmMQ9AZMvonUYGkA@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] [media] V4L: Add VP8 encoder controls
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Fri, Jun 28, 2013 at 7:55 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Arun,
>
> As promised, here is my review.
>

Thank you :). Sorry for the delay in response.

> I have been thinking a bit more about whether or not a VPX control class
> should be added, and in my opinion it shouldn't. These controls should be
> part of the MPEG control class, as the VPX encoder shares a lot of general
> encoding parameters, just like h264 and mpeg4.
>
> It is unfortunate that all the defines contain the MPEG name, and I take
> the blame for that since I came up with these defines originally.
>
> That said, there are some things that can be done to make it less confusing:
>
> - Clearly state in v4l2-controls.h and v4l2-ctrls.c that the MPEG controls
>   are really Codec Controls, so not MPEG specific, and that the 'MPEG' part of
>   the define is historical.

Ok will do that.

>
> - Currently the V4L2_CID_MPEG_CLASS name in v4l2-ctrls.c is "MPEG Encoder Controls".
>   This should be changed to "Codec Controls", since the controls in this class are
>   neither MPEG specific, nor are they encoder specific as there are also controls
>   related to the decoder.
>
> - Update the DocBook section for the MPEG controls accordingly: change 'MPEG' in
>   the text to 'Codec' and add a note explaining why all the defines are prefixed
>   with V4L2_CID_MPEG/V4L2_MPEG instead of _CODEC.
>

Ok will do these changes.

> I did toy with the idea of adding aliases in v4l2-controls.h replacing MPEG with
> CODEC, but that really is too messy. I think if you can take care of the three
> points mentioned above we should be OK.
>
> This also means that in this patch the V4L2_CID_VPX_ prefix changes to
> V4L2_CID_MPEG_VIDEO_VPX_ as that is consistent with the current naming convention
> in v4l2-controls.h: V4L2_CID_MPEG_VIDEO_H264_ASO, V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL.
>

Ok.

> Enums use V4L2_MPEG_VIDEO_VPX_ prefix.
>
> Yes, I know, this will make the names quite a bit longer, but it is important for
> consistency. Codecs are likely to have lots of controls since there are lots of
> knobs you can tweak. So using a systematic naming scheme will prevent it from
> descending into chaos...
>
> On Tue June 25 2013 12:57:14 Arun Kumar K wrote:
>> This patch adds new V4L controls for VP8 encoding.
>>
>> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> ---
>>  Documentation/DocBook/media/v4l/controls.xml |  150 ++++++++++++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ctrls.c         |   33 ++++++
>>  include/uapi/linux/v4l2-controls.h           |   29 ++++-
>>  3 files changed, 210 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index 8d7a779..736c991 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -3009,6 +3009,156 @@ in by the application. 0 = do not insert, 1 = insert packets.</entry>
>>         </tgroup>
>>       </table>
>>        </section>
>> +
>> +    <section>
>> +      <title>VPX Control Reference</title>
>> +
>> +      <para>The VPX controls include controls for encoding parameters
>> +      of VPx video codec.</para>
>> +
>> +      <table pgwide="1" frame="none" id="vpx-control-id">
>> +      <title>VPX Control IDs</title>
>> +
>> +      <tgroup cols="4">
>> +        <colspec colname="c1" colwidth="1*" />
>> +        <colspec colname="c2" colwidth="6*" />
>> +        <colspec colname="c3" colwidth="2*" />
>> +        <colspec colname="c4" colwidth="6*" />
>> +        <spanspec namest="c1" nameend="c2" spanname="id" />
>> +        <spanspec namest="c2" nameend="c4" spanname="descr" />
>> +        <thead>
>> +          <row>
>> +            <entry spanname="id" align="left">ID</entry>
>> +            <entry align="left">Type</entry>
>> +          </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
>> +          </row>
>> +        </thead>
>> +        <tbody valign="top">
>> +          <row><entry></entry></row>
>> +
>> +           <row><entry></entry></row>
>> +           <row id="v4l2-vpx-num-partitions">
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_NUM_PARTITIONS</constant></entry>
>> +             <entry>enum v4l2_vp8_num_partitions</entry>
>> +           </row>
>> +           <row><entry spanname="descr">The number of token partitions to use in VP8 encoder.
>> +Possible values are:</entry>
>> +           </row>
>> +           <row>
>> +             <entrytbl spanname="descr" cols="2">
>> +               <tbody valign="top">
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_1_PARTITION</constant></entry>
>> +                   <entry>1 coefficient partition</entry>
>> +                 </row>
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_2_PARTITIONS</constant></entry>
>> +                   <entry>2 partitions</entry>
>
> Add 'coefficient' for the other cases as well in the description. At least, I think
> this should be '2 coefficient partitions'.
>

Ok.

>> +                 </row>
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_4_PARTITIONS</constant></entry>
>> +                   <entry>4 partitions</entry>
>> +                 </row>
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_8_PARTITIONS</constant></entry>
>> +                   <entry>8 partitions</entry>
>> +                 </row>
>> +                  </tbody>
>> +             </entrytbl>
>> +           </row>
>> +
>> +           <row><entry></entry></row>
>> +           <row>
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_IMD_DISABLE_4X4</constant></entry>
>> +             <entry>boolean</entry>
>> +           </row>
>> +           <row><entry spanname="descr">Setting this prevents intra 4x4 mode in the intra mode decision.</entry>
>> +           </row>
>> +
>> +           <row><entry></entry></row>
>> +           <row id="v4l2-vpx-num-ref-frames">
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_NUM_REF_FRAMES</constant></entry>
>> +             <entry>enum v4l2_vp8_num_ref_frames</entry>
>> +           </row>
>> +           <row><entry spanname="descr">The number of reference pictures for encoding P frames.
>> +Possible values are:</entry>
>> +           </row>
>> +           <row>
>> +             <entrytbl spanname="descr" cols="2">
>> +               <tbody valign="top">
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_1_REF_FRAME</constant></entry>
>> +                   <entry>Last encoded frame will be searched</entry>
>> +                 </row>
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_2_REF_FRAME</constant></entry>
>> +                   <entry>Two frames would be searched among last encoded frame, golden frame
>
> s/would/will/
> s/among/among the/
> s/golden/the golden/
>
>> +and altref frame. Encoder implementation can decide which two are chosen.</entry>
>
> s/altref/the altref/
> s/Encoder/The encoder/
> s/can/will/
>
> Perhaps instead of writing 'altref' it should be 'alternate reference'? (At least, I assume
> that's what altref is short for).
>

Yes altref is the shortform for alternate reference. But the name altref is used
everywhere in the VP8 standard.

>> +                 </row>
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_3_REF_FRAME</constant></entry>
>> +                   <entry>The last encoded frame, golden frame and altref frame will be searched.</entry>
>
> s/golden/the golden/
> s/altref/the altref/
>
>> +                 </row>
>> +                  </tbody>
>> +             </entrytbl>
>> +           </row>
>> +
>> +           <row><entry></entry></row>
>> +           <row>
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_FILTER_LEVEL</constant></entry>
>> +             <entry>integer</entry>
>> +           </row>
>> +           <row><entry spanname="descr">Indicates the loop filter level. The adjustment of loop
>
> s/of loop/of the loop/
>
>> +filter level is done via a delta value against a baseline loop filter value.</entry>
>
> Is that baseline loop filter value implementation specific, or is it defined by the standard?
>

It is defined by the standard.

>> +           </row>
>> +
>> +           <row><entry></entry></row>
>> +           <row>
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_FILTER_SHARPNESS</constant></entry>
>> +             <entry>integer</entry>
>> +           </row>
>> +           <row><entry spanname="descr">This parameter affects the loop filter. Anything above
>> +zero weakens the deblocking effect on loop filter.</entry>
>
> s/loop/the loop/
>
>> +           </row>
>> +
>> +           <row><entry></entry></row>
>> +           <row>
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD</constant></entry>
>> +             <entry>integer</entry>
>> +           </row>
>> +           <row><entry spanname="descr">Sets the refresh period for golden frame. Period is defined
>
> s/golden/the golden/
> s/Period/The period/
>
>> +in number of frames. For a value of 'n', every nth frame will be taken as golden frame.</entry>
>
> So for a period of, say, 4, what does that mean in practice? For example, I start encoding and
> give you the first 8 frames: 0, 1, 2, 3, 4, 5, 6 and 7.
>
> Will frames 0 and 4 be marked as golden frames, or 3 and 7? Your documentation suggests the
> latter, but I'm not really sure that is what you meant.
>

Yes it was bit ambiguous. For the set of 8 frames you mentioned, 0 and
4 are golden frames.
Will make it more clear.


>> +           </row>
>> +
>> +           <row><entry></entry></row>
>> +           <row id="v4l2-vpx-golden-frame-sel">
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_GOLDEN_FRAME_SEL</constant></entry>
>> +             <entry>enum v4l2_vp8_golden_frame_sel</entry>
>> +           </row>
>> +           <row><entry spanname="descr">Selects the golden frame for encoding.
>> +Possible values are:</entry>
>> +           </row>
>> +           <row>
>> +             <entrytbl spanname="descr" cols="2">
>> +               <tbody valign="top">
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_GOLDEN_FRAME_USE_PREV</constant></entry>
>> +                   <entry>Use the last to last or (n-2)th frame as a golden frame. Current frame index being 'n'.</entry>
>
> "last to last" doesn't parse. Just use:
>
> "Use the (n-2)th frame as a golden frame, the current frame index being 'n'."
>
> That's unambiguous.

Ok.

Thanks and Regards
Arun
