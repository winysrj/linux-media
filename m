Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4362 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3GHMwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jul 2013 08:52:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arun Kumar K <arun.kk@samsung.com>
Subject: Re: [PATCH v4 7/8] [media] V4L: Add VP8 encoder controls
Date: Mon, 8 Jul 2013 14:51:54 +0200
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	jtp.park@samsung.com, s.nawrocki@samsung.com,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
References: <1373286637-30154-1-git-send-email-arun.kk@samsung.com> <1373286637-30154-8-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1373286637-30154-8-git-send-email-arun.kk@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201307081451.54485.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

A few small comments below. After fixing that you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

for this patch.

On Mon July 8 2013 14:30:35 Arun Kumar K wrote:
> This patch adds new V4L controls for VP8 encoding.
> 
> Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |  168 +++++++++++++++++++++++++-
>  drivers/media/v4l2-core/v4l2-ctrls.c         |   39 +++++-
>  include/uapi/linux/v4l2-controls.h           |   33 ++++-
>  3 files changed, 230 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 8d7a779..4bcedbf 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -722,17 +722,22 @@ for more details.</para>
>      </section>
>  
>      <section id="mpeg-controls">
> -      <title>MPEG Control Reference</title>
> +      <title>Codec Control Reference</title>
>  
> -      <para>Below all controls within the MPEG control class are
> +      <para>Below all controls within the Codec control class are
>  described. First the generic controls, then controls specific for
>  certain hardware.</para>
>  
> +      <para>Note: These controls are applicable all codecs and

s/all/to all/

> +not just MPEG. The defines are prefixed with V4L2_CID_MPEG/V4L2_MPEG
> +as the controls were originally made for MPEG class and later

s/class/codecs/

> +extended to cover all encoding formats.</para>
> +
>        <section>
> -	<title>Generic MPEG Controls</title>
> +	<title>Generic Codec Controls</title>
>  
>  	<table pgwide="1" frame="none" id="mpeg-control-id">
> -	  <title>MPEG Control IDs</title>
> +	  <title>Codec Control IDs</title>
>  	  <tgroup cols="4">
>  	    <colspec colname="c1" colwidth="1*" />
>  	    <colspec colname="c2" colwidth="6*" />
> @@ -752,7 +757,7 @@ certain hardware.</para>
>  	      <row>
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_CLASS</constant>&nbsp;</entry>
>  		<entry>class</entry>
> -	      </row><row><entry spanname="descr">The MPEG class
> +	      </row><row><entry spanname="descr">The Codec class
>  descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
>  description of this control class. This description can be used as the
>  caption of a Tab page in a GUI, for example.</entry>
> @@ -3009,6 +3014,159 @@ in by the application. 0 = do not insert, 1 = insert packets.</entry>
>  	  </tgroup>
>  	</table>
>        </section>
> +
> +    <section>
> +      <title>VPX Control Reference</title>
> +
> +      <para>The VPX controls include controls for encoding parameters
> +      of VPx video codec.</para>
> +
> +      <table pgwide="1" frame="none" id="vpx-control-id">
> +      <title>VPX Control IDs</title>
> +
> +      <tgroup cols="4">
> +        <colspec colname="c1" colwidth="1*" />
> +        <colspec colname="c2" colwidth="6*" />
> +        <colspec colname="c3" colwidth="2*" />
> +        <colspec colname="c4" colwidth="6*" />
> +        <spanspec namest="c1" nameend="c2" spanname="id" />
> +        <spanspec namest="c2" nameend="c4" spanname="descr" />
> +        <thead>
> +          <row>
> +            <entry spanname="id" align="left">ID</entry>
> +            <entry align="left">Type</entry>
> +          </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
> +          </row>
> +        </thead>
> +        <tbody valign="top">
> +          <row><entry></entry></row>
> +
> +	      <row><entry></entry></row>
> +	      <row id="v4l2-vpx-num-partitions">
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS</constant></entry>
> +		<entry>enum v4l2_vp8_num_partitions</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The number of token partitions to use in VP8 encoder.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_1_PARTITION</constant></entry>
> +		      <entry>1 coefficient partition</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_2_PARTITIONS</constant></entry>
> +		      <entry>2 coefficient partitions</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_4_PARTITIONS</constant></entry>
> +		      <entry>4 coefficient partitions</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_8_PARTITIONS</constant></entry>
> +		      <entry>8 coefficient partitions</entry>
> +	            </row>
> +                  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4</constant></entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Setting this prevents intra 4x4 mode in the intra mode decision.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row id="v4l2-vpx-num-ref-frames">
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES</constant></entry>
> +		<entry>enum v4l2_vp8_num_ref_frames</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The number of reference pictures for encoding P frames.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_1_REF_FRAME</constant></entry>
> +		      <entry>Last encoded frame will be searched</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_2_REF_FRAME</constant></entry>
> +		      <entry>Two frames will be searched among the last encoded frame, the golden frame
> +and the alternate reference (altref) frame. The encoder implementation will decide which two are chosen.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_3_REF_FRAME</constant></entry>
> +		      <entry>The last encoded frame, the golden frame and the altref frame will be searched.</entry>
> +		    </row>
> +                  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_FILTER_LEVEL</constant></entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Indicates the loop filter level. The adjustment of the loop
> +filter level is done via a delta value against a baseline loop filter value.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_FILTER_SHARPNESS</constant></entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">This parameter affects the loop filter. Anything above
> +zero weakens the deblocking effect on the loop filter.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD</constant></entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Sets the refresh period for the golden frame. The period is defined
> +in number of frames. For a value of 'n', every nth frame starting from the first key frame will be taken as a golden frame.
> +For eg. for encoding sequence of 0, 1, 2, 3, 4, 5, 6, 7 where the golden frame refresh period is set as 4, the frames
> +0, 4, 8 etc will be taken as the golden frames as frame 0 is always a key frame.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row id="v4l2-vpx-golden-frame-sel">
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL</constant></entry>
> +		<entry>enum v4l2_vp8_golden_frame_sel</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Selects the golden frame for encoding.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV</constant></entry>
> +		      <entry>Use the (n-2)th frame as a golden frame, current frame index being 'n'.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_REF_PERIOD</constant></entry>
> +		      <entry>Use the previous specific frame indicated by
> +V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD as a golden frame.</entry>
> +		    </row>
> +                  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +          <row><entry></entry></row>
> +        </tbody>
> +      </tgroup>
> +      </table>
> +
> +      </section>
>      </section>
>  
>      <section id="camera-controls">
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index e03a2e8..c6dc1fd 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -424,6 +424,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		NULL,
>  	};
>  
> +	static const char * const vpx_golden_frame_sel[] = {
> +		"Use Previous Frame",
> +		"Use Previous Specific Frame",
> +		NULL,
> +	};
> +
>  	static const char * const flash_led_mode[] = {
>  		"Off",
>  		"Flash",
> @@ -538,6 +544,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return mpeg_mpeg4_level;
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>  		return mpeg4_profile;
> +	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
> +		return vpx_golden_frame_sel;
>  	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>  		return jpeg_chroma_subsampling;
>  	case V4L2_CID_DV_TX_MODE:
> @@ -552,13 +560,26 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_get_menu);
>  
> +#define __v4l2_qmenu_int_len(arr, len) ({ *(len) = ARRAY_SIZE(arr); arr; })
>  /*
>   * Returns NULL or an s64 type array containing the menu for given
>   * control ID. The total number of the menu items is returned in @len.
>   */
>  const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
>  {
> +	static const s64 const qmenu_int_vpx_num_partitions[] = {
> +		1, 2, 4, 8,
> +	};
> +
> +	static const s64 const qmenu_int_vpx_num_ref_frames[] = {
> +		1, 2, 3,
> +	};
> +
>  	switch (id) {
> +	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:
> +		return __v4l2_qmenu_int_len(qmenu_int_vpx_num_partitions, len);
> +	case V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES:
> +		return __v4l2_qmenu_int_len(qmenu_int_vpx_num_ref_frames, len);
>  	default:
>  		*len = 0;
>  		return NULL;
> @@ -614,9 +635,11 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_ALPHA_COMPONENT:		return "Alpha Component";
>  	case V4L2_CID_COLORFX_CBCR:		return "Color Effects, CbCr";
>  
> -	/* MPEG controls */
> +	/* Codec controls */
> +	/* The MPEG controls are applicable to all codec controls
> +	 * and the 'MPEG' part of the define is historical */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> -	case V4L2_CID_MPEG_CLASS:		return "MPEG Encoder Controls";
> +	case V4L2_CID_MPEG_CLASS:		return "Codec Controls";
>  	case V4L2_CID_MPEG_STREAM_TYPE:		return "Stream Type";
>  	case V4L2_CID_MPEG_STREAM_PID_PMT:	return "Stream PMT Program ID";
>  	case V4L2_CID_MPEG_STREAM_PID_AUDIO:	return "Stream Audio Program ID";
> @@ -714,6 +737,15 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return "Initial Delay for VBV Control";
>  	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
>  
> +	/* VPX controls */
> +	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
> +	case V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4:		return "VPX Intra Mode Decision Disable";
> +	case V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES:		return "VPX No. of Refs for P Frame";
> +	case V4L2_CID_MPEG_VIDEO_VPX_FILTER_LEVEL:		return "VPX Loop Filter Level Range";
> +	case V4L2_CID_MPEG_VIDEO_VPX_FILTER_SHARPNESS:		return "VPX Deblocking Effect Control";
> +	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD:	return "VPX Golden Frame Refresh Period";
> +	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:		return "VPX Golden Frame Indicator";
> +
>  	/* CAMERA controls */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
>  	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> @@ -928,6 +960,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_DV_RX_RGB_RANGE:
>  	case V4L2_CID_TEST_PATTERN:
>  	case V4L2_CID_TUNE_DEEMPHASIS:
> +	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
>  	case V4L2_CID_LINK_FREQ:
> @@ -939,6 +972,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  		break;
>  	case V4L2_CID_ISO_SENSITIVITY:
>  	case V4L2_CID_AUTO_EXPOSURE_BIAS:
> +	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:
> +	case V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES:
>  		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
>  		break;
>  	case V4L2_CID_USER_CLASS:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 69bd5bb..273a362 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -165,7 +165,9 @@ enum v4l2_colorfx {
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
>  #define V4L2_CID_MPEG_CLASS 			(V4L2_CTRL_CLASS_MPEG | 1)
>  
> -/*  MPEG streams, specific to multiplexed streams */
> +/*  MPEG streams, specific to multiplexed streams
> + *  The MPEG controls are applicable to all codec controls
> + *  and the 'MPEG' part of the define is historical */

I would move these last two lines to above the V4L2_CID_MPEG_BASE define.
That is a more suitable place for it.

>  #define V4L2_CID_MPEG_STREAM_TYPE 		(V4L2_CID_MPEG_BASE+0)
>  enum v4l2_mpeg_stream_type {
>  	V4L2_MPEG_STREAM_TYPE_MPEG2_PS   = 0, /* MPEG-2 program stream */
> @@ -522,6 +524,33 @@ enum v4l2_mpeg_video_mpeg4_profile {
>  };
>  #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
>  
> +/*  Control IDs for VP8 streams
> + *  Though VP8 is not part of MPEG, adding it here as MPEG class is

"Although VP8 is not part of MPEG we add these controls to the MPEG class as that class is"

> + *  already handling other video compression standards
> + */
> +#define V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS		(V4L2_CID_MPEG_BASE+500)
> +enum v4l2_vp8_num_partitions {
> +	V4L2_CID_MPEG_VIDEO_VPX_1_PARTITION	= 0,
> +	V4L2_CID_MPEG_VIDEO_VPX_2_PARTITIONS	= 1,
> +	V4L2_CID_MPEG_VIDEO_VPX_4_PARTITIONS	= 2,
> +	V4L2_CID_MPEG_VIDEO_VPX_8_PARTITIONS	= 3,
> +};
> +#define V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4		(V4L2_CID_MPEG_BASE+501)
> +#define V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES		(V4L2_CID_MPEG_BASE+502)
> +enum v4l2_vp8_num_ref_frames {
> +	V4L2_CID_MPEG_VIDEO_VPX_1_REF_FRAME	= 0,
> +	V4L2_CID_MPEG_VIDEO_VPX_2_REF_FRAME	= 1,
> +	V4L2_CID_MPEG_VIDEO_VPX_3_REF_FRAME	= 2,
> +};
> +#define V4L2_CID_MPEG_VIDEO_VPX_FILTER_LEVEL		(V4L2_CID_MPEG_BASE+503)
> +#define V4L2_CID_MPEG_VIDEO_VPX_FILTER_SHARPNESS	(V4L2_CID_MPEG_BASE+504)
> +#define V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD	(V4L2_CID_MPEG_BASE+505)
> +#define V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL	(V4L2_CID_MPEG_BASE+506)
> +enum v4l2_vp8_golden_frame_sel {
> +	V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV		= 0,
> +	V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_REF_PERIOD	= 1,
> +};
> +
>  /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
>  #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
>  #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
> @@ -590,7 +619,6 @@ enum v4l2_mpeg_mfc51_video_force_frame_type {
>  #define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC		(V4L2_CID_MPEG_MFC51_BASE+53)
>  #define V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P		(V4L2_CID_MPEG_MFC51_BASE+54)
>  
> -

Don't remove this line

>  /*  Camera class control IDs */
>  
>  #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
> @@ -818,7 +846,6 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
>  #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
>  
> -

Ditto. I always keep two empty lines between control classes as it makes it
easier to detect when the definitions for a new control class begin in the
header.

>  /*  DV-class control IDs defined by V4L2 */
>  #define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
>  #define V4L2_CID_DV_CLASS			(V4L2_CTRL_CLASS_DV | 1)
> 

Regards,

	Hans
