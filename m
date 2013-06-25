Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:45753 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3FYEge (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 00:36:34 -0400
Received: by mail-ve0-f172.google.com with SMTP id jz10so9718091veb.3
        for <linux-media@vger.kernel.org>; Mon, 24 Jun 2013 21:36:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51C76037.8050106@gmail.com>
References: <1371560183-23244-1-git-send-email-arun.kk@samsung.com>
	<1371560183-23244-8-git-send-email-arun.kk@samsung.com>
	<51C76037.8050106@gmail.com>
Date: Tue, 25 Jun 2013 10:06:33 +0530
Message-ID: <CALt3h7_Pf=DR9EkbVq=6mT14Nk357uRRNDKguEUco2PEte+CYQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] [media] V4L: Add VP8 encoder controls
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the review.

On Mon, Jun 24, 2013 at 2:23 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Arun,
>
>
> On 06/18/2013 02:56 PM, Arun Kumar K wrote:
>>
>> This patch adds new V4L controls for VP8 encoding.
>>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> Signed-off-by: Kiran AVND<avnd.kiran@samsung.com>
>
>
> I think your signed-off-by should be last one, since you're submitting
> the patch.
>
>
>> ---
>>   Documentation/DocBook/media/v4l/controls.xml |  151
>> ++++++++++++++++++++++++++
>>   drivers/media/v4l2-core/v4l2-ctrls.c         |   36 ++++++
>>   include/uapi/linux/v4l2-controls.h           |   28 ++++-
>>   3 files changed, 213 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>> b/Documentation/DocBook/media/v4l/controls.xml
>> index 8d7a779..cd87000 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -3009,6 +3009,156 @@ in by the application. 0 = do not insert, 1 =
>> insert packets.</entry>
>>         </tgroup>
>>         </table>
>>         </section>
>> +
>> +<section>
>> +<title>VPX Control Reference</title>
>> +
>> +<para>The VPX controls include controls for encoding parameters
>> +      of VPx video codec.</para>
>> +
>> +<table pgwide="1" frame="none" id="vpx-control-id">
>> +<title>VPX Control IDs</title>
>> +
>> +<tgroup cols="4">
>> +<colspec colname="c1" colwidth="1*" />
>> +<colspec colname="c2" colwidth="6*" />
>> +<colspec colname="c3" colwidth="2*" />
>> +<colspec colname="c4" colwidth="6*" />
>> +<spanspec namest="c1" nameend="c2" spanname="id" />
>> +<spanspec namest="c2" nameend="c4" spanname="descr" />
>> +<thead>
>> +<row>
>> +<entry spanname="id" align="left">ID</entry>
>> +<entry align="left">Type</entry>
>> +</row><row rowsep="1"><entry spanname="descr"
>> align="left">Description</entry>
>> +</row>
>> +</thead>
>> +<tbody valign="top">
>> +<row><entry></entry></row>
>> +
>> +       <row><entry></entry></row>
>> +       <row id="v4l2-vpx-num-partitions">
>> +               <entry
>> spanname="id"><constant>V4L2_CID_VPX_NUM_PARTITIONS</constant>&nbsp;</entry>
>
>
> What is this '&nbsp;' at the end of an entry needed for ? I can see lots
> of similar ones elsewhere in this patch.
>
>
>> +               <entry>enum&nbsp;v4l2_vp8_num_partitions</entry>
>> +       </row>
>> +       <row><entry spanname="descr">The number of token partitions to use
>> in VP8 encoder.
>> +Possible values are:</entry>
>> +       </row>
>> +       <row>
>> +               <entrytbl spanname="descr" cols="2">
>> +               <tbody valign="top">
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_1_PARTITION</constant>&nbsp;</entry>
>> +               <entry>1 coefficient partition</entry>
>> +               </row>
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_2_PARTITIONS</constant>&nbsp;</entry>
>> +               <entry>2 partitions</entry>
>> +               </row>
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_4_PARTITIONS</constant>&nbsp;</entry>
>> +               <entry>4 partitions</entry>
>> +               </row>
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_8_PARTITIONS</constant>&nbsp;</entry>
>> +               <entry>8 partitions</entry>
>> +       </row>
>> +</tbody>
>> +               </entrytbl>
>> +       </row>
>> +
>> +       <row><entry></entry></row>
>> +       <row>
>> +               <entry
>> spanname="id"><constant>V4L2_CID_VPX_IMD_DISABLE_4X4</constant>&nbsp;</entry>
>> +               <entry>boolean</entry>
>> +       </row>
>> +       <row><entry spanname="descr">Setting this prevents intra 4x4 mode
>> in the intra mode decision.</entry>
>> +       </row>
>> +
>> +       <row><entry></entry></row>
>> +       <row id="v4l2-vpx-num-ref-frames">
>> +               <entry
>> spanname="id"><constant>V4L2_CID_VPX_NUM_REF_FRAMES</constant>&nbsp;</entry>
>> +               <entry>enum&nbsp;v4l2_vp8_num_ref_frames</entry>
>> +       </row>
>> +       <row><entry spanname="descr">The number of reference pictures for
>> encoding P frames.
>> +Possible values are:</entry>
>> +       </row>
>> +       <row>
>> +               <entrytbl spanname="descr" cols="2">
>> +               <tbody valign="top">
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_1_REF_FRAME</constant>&nbsp;</entry>
>> +               <entry>Last encoded frame will be searched</entry>
>> +               </row>
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_2_REF_FRAME</constant>&nbsp;</entry>
>> +               <entry>Two frames would be searched among last encoded
>> frame, golden frame
>> +and altref frame. Encoder implementation can decide which two are
>> chosen.</entry>
>> +               </row>
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_3_REF_FRAME</constant>&nbsp;</entry>
>> +               <entry>The last encoded frame, golden frame and altref
>> frame will be searched.</entry>
>> +               </row>
>> +</tbody>
>> +               </entrytbl>
>> +       </row>
>> +
>> +       <row><entry></entry></row>
>> +       <row>
>> +               <entry
>> spanname="id"><constant>V4L2_CID_VPX_FILTER_LEVEL</constant>&nbsp;</entry>
>> +               <entry>integer</entry>
>> +       </row>
>> +       <row><entry spanname="descr">Indicates the loop filter level. The
>> adjustment of loop
>> +filter level is done via a delta value against a baseline loop filter
>> value.</entry>
>> +       </row>
>> +
>> +       <row><entry></entry></row>
>> +       <row>
>> +               <entry
>> spanname="id"><constant>V4L2_CID_VPX_FILTER_SHARPNESS</constant>&nbsp;</entry>
>> +               <entry>integer</entry>
>> +       </row>
>> +       <row><entry spanname="descr">This parameter affects the loop
>> filter. Anything above
>> +zero weakens the deblocking effect on loop filter.</entry>
>> +       </row>
>> +
>> +       <row><entry></entry></row>
>> +       <row>
>> +               <entry
>> spanname="id"><constant>V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD</constant>&nbsp;</entry>
>> +               <entry>integer</entry>
>> +       </row>
>> +       <row><entry spanname="descr">Sets the refresh period for golden
>> frame. Period is defined
>> +in number of frames. For a value of 'n', every nth frame will be taken as
>> golden frame.</entry>
>> +       </row>
>> +
>> +       <row><entry></entry></row>
>> +       <row id="v4l2-vpx-golden-frame-sel">
>> +               <entry
>> spanname="id"><constant>V4L2_CID_VPX_GOLDEN_FRAME_SEL</constant>&nbsp;</entry>
>> +               <entry>enum&nbsp;v4l2_vp8_golden_frame_sel</entry>
>> +       </row>
>> +       <row><entry spanname="descr">Selects the golden frame for
>> encoding.
>> +Possible values are:</entry>
>> +       </row>
>> +       <row>
>> +               <entrytbl spanname="descr" cols="2">
>> +               <tbody valign="top">
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_GOLDEN_FRAME_USE_PREV</constant>&nbsp;</entry>
>> +               <entry>Use the previous second frame (last to last frame)
>> as a golden frame</entry>
>
>
> I can't understand what this means exactly. But this could be just my bad
> English skills... ;)
>

I thought mentioning last to last made it more clear :)
Its the (n-2)th frame where current frame index is 'n'.
Will update it to make it more clear.

>
>> +               </row>
>> +               <row>
>> +
>> <entry><constant>V4L2_VPX_GOLDEN_FRAME_USE_REF_PERIOD</constant>&nbsp;</entry>
>> +               <entry>Use the previous specific frame indicated by
>> V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD as a golden frame</entry>
>> +               </row>
>> +</tbody>
>> +               </entrytbl>
>> +       </row>
>> +
>> +<row><entry></entry></row>
>> +</tbody>
>> +</tgroup>
>> +</table>
>> +
>> +</section>
>>       </section>
>>
>>       <section id="camera-controls">
>> @@ -4772,4 +4922,5 @@ defines possible values for de-emphasis. Here they
>> are:</entry>
>>         </table>
>>
>>         </section>
>> +
>
>
> Unnecessary change ?
>

Yes. Will remove.

>
>>   </section>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
>> b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 3cb1cff..2a4413b 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -424,6 +424,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>                 NULL,
>>         };
>>
>> +       static const char * const vpx_golden_frame_sel[] = {
>> +               "Use Previous Frame",
>> +               "Use Frame Indicated By GOLDEN_FRAME_REF_PERIOD",
>
>
> That name is too long, look at VIDIOC_QUERYMENU ioctl specification [1] what
> a capacity of the menu item name storage is.
>
> [1] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-queryctrl.html
>

Ok.

>
>> +               NULL,
>> +       };
>> +
>>         static const char * const flash_led_mode[] = {
>>                 "Off",
>>                 "Flash",
>> @@ -538,6 +544,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>>                 return mpeg_mpeg4_level;
>>         case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>>                 return mpeg4_profile;
>> +       case V4L2_CID_VPX_GOLDEN_FRAME_SEL:
>> +               return vpx_golden_frame_sel;
>>         case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>>                 return jpeg_chroma_subsampling;
>>         case V4L2_CID_DV_TX_MODE:
>> @@ -558,7 +566,23 @@ EXPORT_SYMBOL(v4l2_ctrl_get_menu);
>>    */
>>   const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
>>   {
>> +#define V4L2_INT_MENU_RETURN(qmenu) \
>> +       do { *len = ARRAY_SIZE(qmenu); return qmenu; } while (0)
>
>
> How about using something along the lines of:
>
> #define __v4l2_qmenu_int_len(arr, len) ({ *(len) = ARRAY_SIZE(arr); arr; })
>
> ? And also moving it out of the function, above ?
>

Ok will make this change.

> The main problem with your macro is that contains a return statement. But
> also relies on a specific variable name.
>
> In Documentation/CodingStyle we read:
>
> " ...
> Things to avoid when using macros:
>
> 1) macros that affect control flow:
>
> #define FOO(x)                                  \
>         do {                                    \
>                 if (blah(x) < 0)                \
>                         return -EBUGGERED;      \
>         } while(0)
>
> is a _very_ bad idea.  It looks like a function call but exits the "calling"
> function; don't break the internal parsers of those who will read the code.
>
> 2) macros that depend on having a local variable with a magic name:
>
> #define FOO(val) bar(index, val)
>
> might look like a good thing, but it's confusing as hell when one reads the
> code and it's prone to breakage from seemingly innocent changes.
> ...
>
> "
>
>> +       static const s64 const qmenu_int_vpx_num_partitions[] = {
>> +               1, 2, 4, 8,
>> +       };
>> +
>> +       static const s64 const qmenu_int_vpx_num_ref_frames[] = {
>> +               1, 2, 3,
>> +       };
>> +
>>         switch (id) {
>> +       case V4L2_CID_VPX_NUM_PARTITIONS:
>> +               V4L2_INT_MENU_RETURN(qmenu_int_vpx_num_partitions);
>
>
> Then this would became:
>
>         return __v4l2_qmenu_int_len(qmenu_int_vpx_num_partitions, &len);
>
>
>> +       case V4L2_CID_VPX_NUM_REF_FRAMES:
>> +               V4L2_INT_MENU_RETURN(qmenu_int_vpx_num_ref_frames);
>
>
> Ditto.
>
>
>>         default:
>>                 *len = 0;
>>                 return NULL;
>> @@ -714,6 +738,15 @@ const char *v4l2_ctrl_get_name(u32 id)
>>         case V4L2_CID_MPEG_VIDEO_VBV_DELAY:                     return
>> "Initial Delay for VBV Control";
>>         case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:             return
>> "Repeat Sequence Header";
>>
>> +       /* VPX controls */
>> +       case V4L2_CID_VPX_NUM_PARTITIONS:                       return
>> "VPX Number of partitions";
>> +       case V4L2_CID_VPX_IMD_DISABLE_4X4:                      return
>> "VPX Intra mode decision disable";
>> +       case V4L2_CID_VPX_NUM_REF_FRAMES:                       return
>> "VPX No. of refs for P frame";
>> +       case V4L2_CID_VPX_FILTER_LEVEL:                         return
>> "VPX Loop filter level range";
>> +       case V4L2_CID_VPX_FILTER_SHARPNESS:                     return
>> "VPX Deblocking effect control";
>> +       case V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD:              return
>> "VPX Golden frame refresh period";
>> +       case V4L2_CID_VPX_GOLDEN_FRAME_SEL:                     return
>> "VPX Golden frame indicator";
>> +
>>         /* CAMERA controls */
>>         /* Keep the order of the 'case's the same as in videodev2.h! */
>>         case V4L2_CID_CAMERA_CLASS:             return "Camera Controls";
>> @@ -929,6 +962,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
>> v4l2_ctrl_type *type,
>>         case V4L2_CID_DV_RX_RGB_RANGE:
>>         case V4L2_CID_TEST_PATTERN:
>>         case V4L2_CID_TUNE_DEEMPHASIS:
>> +       case V4L2_CID_VPX_GOLDEN_FRAME_SEL:
>>                 *type = V4L2_CTRL_TYPE_MENU;
>>                 break;
>>         case V4L2_CID_LINK_FREQ:
>> @@ -940,6 +974,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
>> v4l2_ctrl_type *type,
>>                 break;
>>         case V4L2_CID_ISO_SENSITIVITY:
>>         case V4L2_CID_AUTO_EXPOSURE_BIAS:
>> +       case V4L2_CID_VPX_NUM_PARTITIONS:
>> +       case V4L2_CID_VPX_NUM_REF_FRAMES:
>>                 *type = V4L2_CTRL_TYPE_INTEGER_MENU;
>>                 break;
>>         case V4L2_CID_USER_CLASS:
>> diff --git a/include/uapi/linux/v4l2-controls.h
>> b/include/uapi/linux/v4l2-controls.h
>> index 69bd5bb..a1f6036 100644
>> --- a/include/uapi/linux/v4l2-controls.h
>> +++ b/include/uapi/linux/v4l2-controls.h
>> @@ -522,6 +522,32 @@ enum v4l2_mpeg_video_mpeg4_profile {
>>   };
>>   #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL
>> (V4L2_CID_MPEG_BASE+407)
>>
>> +/*  Control IDs for VP8 streams
>> + *  Though VP8 is not part of MPEG, adding it here as MPEG class is
>> + *  already handling other video compression standards */
>
>
> Please use proper comment style, i.e.
>

Ok will change.

Regards
Arun
