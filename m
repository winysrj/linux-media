Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37371 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754603Ab1HBRnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 13:43:11 -0400
Date: Tue, 2 Aug 2011 10:43:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	jaeryul.oh@samsung.com, mchehab@infradead.org
Subject: Re: [PATCH v2] v4l2: Fix documentation of the codec device controls
Message-Id: <20110802104309.00be2e23.rdunlap@xenotime.net>
In-Reply-To: <1312300429-26777-1-git-send-email-k.debski@samsung.com>
References: <1312300429-26777-1-git-send-email-k.debski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 02 Aug 2011 17:53:49 +0200 Kamil Debski wrote:

> Fixed missing ids of the codec controls description in the controls.xml file.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
> Hi,
> 
> This patch fixes the problem with codec controls documentation reported by Randy
> in the following email:
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/36288
> 
> The first version did not address all the errors detected - this one should
> make the docs build without errors.
> 
> Thank you again for reporting these errors.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


Thanks.  This patch does fix all of these errors:

Error: no ID for constraint linkend: v4l2-mpeg-video-header-mode.
Error: no ID for constraint linkend: v4l2-mpeg-video-multi-slice-mode.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-entropy-mode.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-level.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-loop-filter-mode.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-profile.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-vui-sar-idc.
Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-level.
Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-profile.
Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-frame-skip-mode.
Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-force-frame-type.
Error: no ID for constraint linkend: v4l2-mpeg-video-header-mode.
Error: no ID for constraint linkend: v4l2-mpeg-video-multi-slice-mode.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-entropy-mode.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-level.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-loop-filter-mode.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-profile.
Error: no ID for constraint linkend: v4l2-mpeg-video-h264-vui-sar-idc.
Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-level.
Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-profile.
Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-frame-skip-mode.
Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-force-frame-type.

leaving only these:
Error: no ID for constraint linkend: AUDIO_GET_PTS.
Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
Error: no ID for constraint linkend: CA_RESET.
Error: no ID for constraint linkend: CA_GET_CAP.
Error: no ID for constraint linkend: CA_GET_SLOT_INFO.
Error: no ID for constraint linkend: CA_GET_DESCR_INFO.
Error: no ID for constraint linkend: CA_GET_MSG.
Error: no ID for constraint linkend: CA_SEND_MSG.
Error: no ID for constraint linkend: CA_SET_DESCR.
Error: no ID for constraint linkend: CA_SET_PID.
Error: no ID for constraint linkend: DMX_GET_PES_PIDS.
Error: no ID for constraint linkend: DMX_GET_CAPS.
Error: no ID for constraint linkend: DMX_SET_SOURCE.
Error: no ID for constraint linkend: DMX_ADD_PID.
Error: no ID for constraint linkend: DMX_REMOVE_PID.
Error: no ID for constraint linkend: NET_ADD_IF.
Error: no ID for constraint linkend: NET_REMOVE_IF.
Error: no ID for constraint linkend: NET_GET_IF.
Error: no ID for constraint linkend: VIDEO_GET_SIZE.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
Error: no ID for constraint linkend: VIDEO_GET_PTS.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
Error: no ID for constraint linkend: VIDEO_COMMAND.
Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.


> Best wishes,
> Kamil Debski
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   38 +++++++++++++-------------
>  1 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 8516401..23fdf79 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -1455,7 +1455,7 @@ Applicable to the H264 encoder.</entry>
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-h264-vui-sar-idc">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC</constant>&nbsp;</entry>
>  		<entry>enum&nbsp;v4l2_mpeg_video_h264_vui_sar_idc</entry>
>  	      </row>
> @@ -1561,7 +1561,7 @@ Applicable to the H264 encoder.</entry>
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-h264-level">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LEVEL</constant>&nbsp;</entry>
>  		<entry>enum&nbsp;v4l2_mpeg_video_h264_level</entry>
>  	      </row>
> @@ -1641,7 +1641,7 @@ Possible values are:</entry>
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-mpeg4-level">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL</constant>&nbsp;</entry>
>  		<entry>enum&nbsp;v4l2_mpeg_video_mpeg4_level</entry>
>  	      </row>
> @@ -1689,9 +1689,9 @@ Possible values are:</entry>
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-h264-profile">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_PROFILE</constant>&nbsp;</entry>
> -		<entry>enum&nbsp;v4l2_mpeg_h264_profile</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_h264_profile</entry>
>  	      </row>
>  	      <row><entry spanname="descr">The profile information for H264.
>  Applicable to the H264 encoder.
> @@ -1774,9 +1774,9 @@ Possible values are:</entry>
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-mpeg4-profile">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE</constant>&nbsp;</entry>
> -		<entry>enum&nbsp;v4l2_mpeg_mpeg4_profile</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_mpeg4_profile</entry>
>  	      </row>
>  	      <row><entry spanname="descr">The profile information for MPEG4.
>  Applicable to the MPEG4 encoder.
> @@ -1820,9 +1820,9 @@ Applicable to the encoder.
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-multi-slice-mode">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE</constant>&nbsp;</entry>
> -		<entry>enum&nbsp;v4l2_mpeg_multi_slice_mode</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_multi_slice_mode</entry>
>  	      </row>
>  	      <row><entry spanname="descr">Determines how the encoder should handle division of frame into slices.
>  Applicable to the encoder.
> @@ -1868,9 +1868,9 @@ Applicable to the encoder.</entry>
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-h264-loop-filter-mode">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE</constant>&nbsp;</entry>
> -		<entry>enum&nbsp;v4l2_mpeg_h264_loop_filter_mode</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_h264_loop_filter_mode</entry>
>  	      </row>
>  	      <row><entry spanname="descr">Loop filter mode for H264 encoder.
>  Possible values are:</entry>
> @@ -1913,9 +1913,9 @@ Applicable to the H264 encoder.</entry>
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-h264-entropy-mode">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE</constant>&nbsp;</entry>
> -		<entry>enum&nbsp;v4l2_mpeg_h264_symbol_mode</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_h264_entropy_mode</entry>
>  	      </row>
>  	      <row><entry spanname="descr">Entropy coding mode for H264 - CABAC/CAVALC.
>  Applicable to the H264 encoder.
> @@ -2140,9 +2140,9 @@ previous frames. Applicable to the H264 encoder.</entry>
>  	      </row>
>  
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-video-header-mode">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_HEADER_MODE</constant>&nbsp;</entry>
> -		<entry>enum&nbsp;v4l2_mpeg_header_mode</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_header_mode</entry>
>  	      </row>
>  	      <row><entry spanname="descr">Determines whether the header is returned as the first buffer or is
>  it returned together with the first frame. Applicable to encoders.
> @@ -2320,9 +2320,9 @@ Valid only when H.264 and macroblock level RC is enabled (<constant>V4L2_CID_MPE
>  Applicable to the H264 encoder.</entry>
>  	      </row>
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-mfc51-video-frame-skip-mode">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE</constant>&nbsp;</entry>
> -		<entry>enum&nbsp;v4l2_mpeg_mfc51_frame_skip_mode</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_mfc51_video_frame_skip_mode</entry>
>  	      </row>
>  	      <row><entry spanname="descr">
>  Indicates in what conditions the encoder should skip frames. If encoding a frame would cause the encoded stream to be larger then
> @@ -2361,9 +2361,9 @@ the stream will meet tight bandwidth contraints. Applicable to encoders.
>  </entry>
>  	      </row>
>  	      <row><entry></entry></row>
> -	      <row>
> +	      <row id="v4l2-mpeg-mfc51-video-force-frame-type">
>  		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE</constant>&nbsp;</entry>
> -		<entry>enum&nbsp;v4l2_mpeg_mfc51_force_frame_type</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_mfc51_video_force_frame_type</entry>
>  	      </row>
>  	      <row><entry spanname="descr">Force a frame type for the next queued buffer. Applicable to encoders.
>  Possible values are:</entry>
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
