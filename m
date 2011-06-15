Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3400 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1FOGkJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 02:40:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 1/4 v9] v4l: add fourcc definitions for compressed formats.
Date: Wed, 15 Jun 2011 08:39:59 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com> <1308069416-24723-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1308069416-24723-2-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106150839.59635.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 14, 2011 18:36:53 Kamil Debski wrote:
> Add fourcc definitions and documentation for the following
> compressed formats: H264, H264 without start codes,
> MPEG1/2/4 ES, DIVX versions 3.11, 4, 5.0-5.0.2, 5.03 and up,
> XVID, VC1 Annex G and Annex L compliant.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |    7 ++-
>  Documentation/DocBook/media/v4l/pixfmt.xml   |   67 +++++++++++++++++++++++++-
>  include/linux/videodev2.h                    |   21 +++++++--
>  3 files changed, 88 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index a920ee8..6880798 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -670,7 +670,8 @@ caption of a Tab page in a GUI, for example.</entry>
>  	      </row><row><entry spanname="descr">The MPEG-1, -2 or -4
>  output stream type. One cannot assume anything here. Each hardware
>  MPEG encoder tends to support different subsets of the available MPEG
> -stream types. The currently defined stream types are:</entry>
> +stream types. This control is specific to multiplexed MPEG streams.
> +The currently defined stream types are:</entry>
>  	      </row>
>  	      <row>
>  		<entrytbl spanname="descr" cols="2">
> @@ -800,6 +801,7 @@ frequency. Possible values are:</entry>
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_ENCODING</constant>&nbsp;</entry>
>  		<entry>enum&nbsp;v4l2_mpeg_audio_encoding</entry>
>  	      </row><row><entry spanname="descr">MPEG Audio encoding.
> +This control is specific to multiplexed MPEG streams.
>  Possible values are:</entry>
>  	      </row>
>  	      <row>
> @@ -1250,7 +1252,8 @@ and reproducible audio bitstream. 0 = unmuted, 1 = muted.</entry>
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_ENCODING</constant>&nbsp;</entry>
>  		<entry>enum&nbsp;v4l2_mpeg_video_encoding</entry>
>  	      </row><row><entry spanname="descr">MPEG Video encoding
> -method. Possible values are:</entry>
> +method. This control is specific to multiplexed MPEG streams.
> +Possible values are:</entry>
>  	      </row>
>  	      <row>
>  		<entrytbl spanname="descr" cols="2">
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 88e5c21..7f0f447 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -741,10 +741,75 @@ information.</para>
>  	  <row id="V4L2-PIX-FMT-MPEG">
>  	    <entry><constant>V4L2_PIX_FMT_MPEG</constant></entry>
>  	    <entry>'MPEG'</entry>
> -	    <entry>MPEG stream. The actual format is determined by
> +	    <entry>MPEG multiplexed stream. The actual format is determined by
>  extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
>  <xref linkend="mpeg-control-id" />.</entry>
>  	  </row>
> +	  <row id="V4L2-PIX-FMT-H264">
> +		<entry><constant>V4L2_PIX_FMT_H264</constant></entry>
> +		<entry>'H264'</entry>
> +		<entry>H264 video elementary stream with start codes.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-H264-NO-SC">
> +		<entry><constant>V4L2_PIX_FMT_H264_NO_SC</constant></entry>
> +		<entry>'AVC1'</entry>
> +		<entry>H264 video elementary stream without start codes.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-H263">
> +		<entry><constant>V4L2_PIX_FMT_H263</constant></entry>
> +		<entry>'H263'</entry>
> +		<entry>H263 video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-MPEG1">
> +		<entry><constant>V4L2_PIX_FMT_MPEG1</constant></entry>
> +		<entry>'MPG1'</entry>
> +		<entry>MPEG1 video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-MPEG2">
> +		<entry><constant>V4L2_PIX_FMT_MPEG2</constant></entry>
> +		<entry>'MPG2'</entry>
> +		<entry>MPEG2 video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-MPEG4">
> +		<entry><constant>V4L2_PIX_FMT_MPEG4</constant></entry>
> +		<entry>'MPG4'</entry>
> +		<entry>MPEG4 video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-DIVX3">
> +		<entry><constant>V4L2_PIX_FMT_DIVX3</constant></entry>
> +		<entry>'DIV3'</entry>
> +		<entry>Divx 3.11 video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-DIVX4">
> +		<entry><constant>V4L2_PIX_FMT_DIVX4</constant></entry>
> +		<entry>'DIV4'</entry>
> +		<entry>Divx 4 video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-DIVX500">
> +		<entry><constant>V4L2_PIX_FMT_DIVX500</constant></entry>
> +		<entry>'DX50'</entry>
> +		<entry>Divx 5.0-5.0.2 video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-DIVX5">
> +		<entry><constant>V4L2_PIX_FMT_DIVX5</constant></entry>
> +		<entry>'DIV5'</entry>
> +		<entry>Divx 5.0.3+ video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-XVID">
> +		<entry><constant>V4L2_PIX_FMT_XVID</constant></entry>
> +		<entry>'XVID'</entry>
> +		<entry>Xvid video elementary stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-VC1-ANNEX-G">
> +		<entry><constant>V4L2_PIX_FMT_VC1_ANNEX_G</constant></entry>
> +		<entry>'VC1G'</entry>
> +		<entry>VC1, SMPTE 421M Annex G compliant stream.</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-VC1-ANNEX-L">
> +		<entry><constant>V4L2_PIX_FMT_VC1_ANNEX_L</constant></entry>
> +		<entry>'VC1L'</entry>
> +		<entry>VC1, SMPTE 421M Annex L compliant stream.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 8a4c309..65bcb61 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -376,7 +376,20 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-JPEG   */
>  #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
>  #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
> -#define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4    */
> +#define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 Multiplexed */
> +#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
> +#define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
> +#define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
> +#define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
> +#define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
> +#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 ES     */
> +#define V4L2_PIX_FMT_DIVX3    v4l2_fourcc('D', 'I', 'V', '3') /* DivX 3.11     */
> +#define V4L2_PIX_FMT_DIVX4    v4l2_fourcc('D', 'I', 'V', '4') /* DivX 4.12     */
> +#define V4L2_PIX_FMT_DIVX500  v4l2_fourcc('D', 'X', '5', '0') /* DivX 5.00 - 5.02  */
> +#define V4L2_PIX_FMT_DIVX5    v4l2_fourcc('D', 'I', 'V', '5') /* DivX 5.03 - x  */

Wasn't DIVX removed due to licensing issues?

> +#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
> +#define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
> +#define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */

Just to verify: are all these formats actually used in the driver?

>  
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
> @@ -1151,7 +1164,7 @@ enum v4l2_colorfx {
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
>  #define V4L2_CID_MPEG_CLASS 			(V4L2_CTRL_CLASS_MPEG | 1)
>  
> -/*  MPEG streams */
> +/*  MPEG streams, specific to multiplexed streams */
>  #define V4L2_CID_MPEG_STREAM_TYPE 		(V4L2_CID_MPEG_BASE+0)
>  enum v4l2_mpeg_stream_type {
>  	V4L2_MPEG_STREAM_TYPE_MPEG2_PS   = 0, /* MPEG-2 program stream */
> @@ -1173,7 +1186,7 @@ enum v4l2_mpeg_stream_vbi_fmt {
>  	V4L2_MPEG_STREAM_VBI_FMT_IVTV = 1,  /* VBI in private packets, IVTV format */
>  };
>  
> -/*  MPEG audio */
> +/*  MPEG audio controls specific to multiplexed streams  */
>  #define V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ 	(V4L2_CID_MPEG_BASE+100)
>  enum v4l2_mpeg_audio_sampling_freq {
>  	V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100 = 0,
> @@ -1289,7 +1302,7 @@ enum v4l2_mpeg_audio_ac3_bitrate {
>  	V4L2_MPEG_AUDIO_AC3_BITRATE_640K = 18,
>  };
>  
> -/*  MPEG video */
> +/*  MPEG video controls specific to multiplexed streams */

The 'multiplexed' part of this comment is only true for VIDEO_ENCODING. The
other controls are valid for elementary streams as well.

>  #define V4L2_CID_MPEG_VIDEO_ENCODING 		(V4L2_CID_MPEG_BASE+200)
>  enum v4l2_mpeg_video_encoding {
>  	V4L2_MPEG_VIDEO_ENCODING_MPEG_1     = 0,
> 

Regards,

	Hans
