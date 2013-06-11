Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:55762 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3FKJNn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 05:13:43 -0400
Received: by mail-ve0-f176.google.com with SMTP id c13so5490533vea.21
        for <linux-media@vger.kernel.org>; Tue, 11 Jun 2013 02:13:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306101530.31252.hverkuil@xs4all.nl>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
	<1370870586-24141-6-git-send-email-arun.kk@samsung.com>
	<201306101530.31252.hverkuil@xs4all.nl>
Date: Tue, 11 Jun 2013 14:43:42 +0530
Message-ID: <CALt3h78QUPyEDMQ_y0HKifwBCsNfzCqi2eviOrWVhub2W8U0rA@mail.gmail.com>
Subject: Re: [PATCH 5/6] [media] V4L: Add VP8 encoder controls
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

Hi Hans,

Thank you for the review.

>> +
>> +    <section id="vpx-controls">
>> +      <title>VPX Control Reference</title>
>> +
>> +      <para>The VPX control class includes controls for encoding parameters
>> +      of VPx video codec.</para>
>
> Are these controls defined by the VPx standard, or are they specific to the
> Samsung hardware?

These controls are part of VP8 standard and even the reference VP8 encoder
supports these.

>
> I am not certain whether a separate class should be created for these. Adding
> it to the MPEG control class might be a better approach (yes, I know MPEG is
> a bit of a misnomer, but it already handles other compressions standards as
> well).
>

Ok. I added them as a separate control class as VP8 is not from MPEG.
I shall add it along with MPEG in the v2 version..


>> +           <row><entry></entry></row>
>> +           <row>
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD</constant>&nbsp;</entry>
>> +             <entry>integer</entry>
>> +           </row>
>> +           <row><entry spanname="descr">Sets the refresh period for golden frame.</entry>
>
> The period is in number of frames I assume? And is the golden frame taken at
> the start or at the end of the period?
>

Yes its in number of frames.
If we set refresh period as 5, then every 5th frame starting from 1st
frame is made as golden frame.
Will update to make it more clear.


>> +           <row><entry></entry></row>
>> +           <row id="v4l2-vpx-golden-frame-sel">
>> +             <entry spanname="id"><constant>V4L2_CID_VPX_GOLDEN_FRAME_SEL</constant>&nbsp;</entry>
>> +             <entry>enum&nbsp;v4l2_vp8_golden_frame_sel</entry>
>> +           </row>
>> +           <row><entry spanname="descr">Selects the golden frame for encoding.
>> +Possible values are:</entry>
>> +           </row>
>> +           <row>
>> +             <entrytbl spanname="descr" cols="2">
>> +               <tbody valign="top">
>> +                 <row>
>> +                   <entry><constant>V4L2_VPX_GOLDEN_FRAME_USE_PREV</constant>&nbsp;</entry>
>> +                   <entry>Use the previous second frame as a golden frame</entry>
>
> Second frame of what? It's not clear to me how I should interpret this.
>

This means the second last frame.
When user selects 2 reference frames for encoding, the last frame and
the golden frame is searched
for reference. With the V4L2_VPX_GOLDEN_FRAME_USE_PREV option, the
last to last frame is
selected as the golden frame. Will update the description for more clarity.

> +                 </row>
> +                 <row>
> +                   <entry><constant>V4L2_VPX_GOLDEN_FRAME_USE_REF_PERIOD</constant>&nbsp;</entry>
> +                   <entry>Use the previous specific frame indicated by V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD as a golden frame</entry>
> +                 </row>
> +                  </tbody>
> +             </entrytbl>
> +           </row>

>> @@ -456,6 +456,23 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>               "RGB full range (0-255)",
>>               NULL,
>>       };
>> +     static const char * const vpx_num_partitions[] = {
>> +             "1 partition",
>> +             "2 partitions",
>> +             "4 partitions",
>> +             "8 partitions",
>
> Please use a capital P for Partition.
>

Ok.

>> +             NULL,
>> +     };
>> +     static const char * const vpx_num_ref_frames[] = {
>> +             "1 reference frame",
>> +             "2 reference frame",
>
> frame -> Frames
>
> Capitalize these strings. Same for all the others.

Ok.

>
>> +             NULL,
>> +     };
>> +     static const char * const vpx_golden_frame_sel[] = {
>> +             "Use previous frame",
>> +             "Use frame indicated by GOLDEN_FRAME_REF_PERIOD",
>> +             NULL,
>> +     };
>>
>>
>>       switch (id) {
>> @@ -545,6 +562,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>       case V4L2_CID_DV_TX_RGB_RANGE:
>>       case V4L2_CID_DV_RX_RGB_RANGE:
>>               return dv_rgb_range;
>> +     case V4L2_CID_VPX_NUM_PARTITIONS:
>> +             return vpx_num_partitions;
>> +     case V4L2_CID_VPX_NUM_REF_FRAMES:
>> +             return vpx_num_ref_frames;
>> +     case V4L2_CID_VPX_GOLDEN_FRAME_SEL:
>> +             return vpx_golden_frame_sel;
>>
>>       default:
>>               return NULL;
>> @@ -806,6 +829,17 @@ const char *v4l2_ctrl_get_name(u32 id)
>>       case V4L2_CID_FM_RX_CLASS:              return "FM Radio Receiver Controls";
>>       case V4L2_CID_TUNE_DEEMPHASIS:          return "De-Emphasis";
>>       case V4L2_CID_RDS_RECEPTION:            return "RDS Reception";
>> +
>> +     /* VPX controls */
>> +     case V4L2_CID_VPX_CLASS:                return "VPX Encoder Controls";
>> +     case V4L2_CID_VPX_NUM_PARTITIONS:       return "VPX Number of partitions";
>> +     case V4L2_CID_VPX_IMD_DISABLE_4X4:      return "VPX Intra mode decision disable";
>> +     case V4L2_CID_VPX_NUM_REF_FRAMES:       return "VPX Number of reference pictures for P frames";
>
> This string is too long: only 31 characters (excluding the trailing \0) can
> be used.

Ok will correct it.


Thanks and regards
Arun
