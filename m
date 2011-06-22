Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1144 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1FVI0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 04:26:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 2/4 v9] v4l: add control definitions for codec devices.
Date: Wed, 22 Jun 2011 10:25:53 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com> <1308069416-24723-3-git-send-email-k.debski@samsung.com>
In-Reply-To: <1308069416-24723-3-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106221025.53838.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, June 14, 2011 18:36:54 Kamil Debski wrote:
> Add control definitions and documentation for controls
> specific to codec devices.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |  958 ++++++++++++++++++++++++++
>  include/linux/videodev2.h                    |  171 +++++
>  2 files changed, 1129 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 6880798..6b0d06a 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -325,6 +325,22 @@ minimum value disables backlight compensation.</entry>
>  <constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_CID_MIN_BUFFERS_FOR_CAPTURE</constant></entry>
> +	    <entry>integer</entry>
> +	    <entry>This is a read-only control that can be read by the application
> +and used as a hint to determine the number of CAPTURE buffers to pass to REQBUFS.
> +The value is the minimum number of CAPTURE buffers that is necessary for hardware
> +to work.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_CID_MIN_BUFFERRS_FOR_OUTPUT</constant></entry>

Typo: double 'R' in BUFFERRS :-)

> +	    <entry>integer</entry>
> +	    <entry>This is a read-only control that can be read by the application
> +and used as a hint to determine the number of OUTPUT buffers to pass to REQBUFS.
> +The value is the minimum number of OUTPUT buffers that is necessary for hardware
> +to work.</entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
>  	    <entry></entry>
>  	    <entry>ID of the first custom (driver specific) control.
> @@ -1409,6 +1425,948 @@ of the video. The supplied 32-bit integer is interpreted as follows (bit
>  		  </tbody>
>  		</entrytbl>
>  	      </row>
> +
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">If enabled the decoder expects a single slice in one OUTPUT buffer, otherwise
> +the decoder expects a single frame in one input buffer. Applicable to the decoder, all codecs.

'in one OUTPUT buffer' vs 'in one input buffer'. Perhaps rewriting it like this is better:

	      <row><entry spanname="descr">If enabled the decoder expects to receive a single slice per buffer, otherwise
the decoder expects a single frame in per buffer. Applicable to the decoder, all codecs.

BTW: 'all codecs'? Your decoder hardware can handle e.g. MPEG-2 sliced input?
I thought slices were specific to e.g. MPEG4/H264? Just checking...

> +</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Enable writing sample aspect ratio in the Video Usability Information.
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_h264_vui_sar_idc</entry>
> +	      </row>
> +	      <row><entry spanname="descr">VUI sample aspect ratio indicator for H.264 encoding. The value
> +is defined in the table E-1 in the standard. Applicable to the H264 encoder.</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED</constant>&nbsp;</entry>
> +			  <entry>Unspecified</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_1x1</constant>&nbsp;</entry>
> +			  <entry>1x1</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_12x11</constant>&nbsp;</entry>
> +			  <entry>12x11</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_10x11</constant>&nbsp;</entry>
> +			  <entry>10x11</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_16x11</constant>&nbsp;</entry>
> +			  <entry>16x11</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_40x33</constant>&nbsp;</entry>
> +			  <entry>40x33</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_24x11</constant>&nbsp;</entry>
> +			  <entry>24x11</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_20x11</constant>&nbsp;</entry>
> +			  <entry>20x11</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_32x11</constant>&nbsp;</entry>
> +			  <entry>32x11</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_80x33</constant>&nbsp;</entry>
> +			  <entry>80x33</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_18x11</constant>&nbsp;</entry>
> +			  <entry>18x11</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_15x11</constant>&nbsp;</entry>
> +			  <entry>15x11</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_64x33</constant>&nbsp;</entry>
> +			  <entry>64x33</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_160x99</constant>&nbsp;</entry>
> +			  <entry>160x99</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_4x3</constant>&nbsp;</entry>
> +			  <entry>4x3</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_3x2</constant>&nbsp;</entry>
> +			  <entry>3x2</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_2x1</constant>&nbsp;</entry>
> +			  <entry>2x1</entry>
> +			</row>
> +			<row>
> +			  <entry><constant>V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED</constant>&nbsp;</entry>
> +			  <entry>Extended SAR</entry>
> +			</row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Extended sample aspect ratio width for H.264 VUI encoding.
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Extended sample aspect ratio height for H.264 VUI encoding.
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LEVEL</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_h264_level</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The level information for the H264 video elementary stream.
> +Applicable to the H264 encoder.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_1_0</constant>&nbsp;</entry>
> +		      <entry>Level 1.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_1B</constant>&nbsp;</entry>
> +		      <entry>Level 1B</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_1_1</constant>&nbsp;</entry>
> +		      <entry>Level 1.1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_1_2</constant>&nbsp;</entry>
> +		      <entry>Level 1.2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_1_3</constant>&nbsp;</entry>
> +		      <entry>Level 1.3</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_2_0</constant>&nbsp;</entry>
> +		      <entry>Level 2.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_2_1</constant>&nbsp;</entry>
> +		      <entry>Level 2.1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_2_2</constant>&nbsp;</entry>
> +		      <entry>Level 2.2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_3_0</constant>&nbsp;</entry>
> +		      <entry>Level 3.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_3_1</constant>&nbsp;</entry>
> +		      <entry>Level 3.1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_3_2</constant>&nbsp;</entry>
> +		      <entry>Level 3.2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_4_0</constant>&nbsp;</entry>
> +		      <entry>Level 4.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_4_1</constant>&nbsp;</entry>
> +		      <entry>Level 4.1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_4_2</constant>&nbsp;</entry>
> +		      <entry>Level 4.2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_5_0</constant>&nbsp;</entry>
> +		      <entry>Level 5.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LEVEL_5_1</constant>&nbsp;</entry>
> +		      <entry>Level 5.1</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_video_mpeg4_level</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The level information for the MPEG4 elementary stream.
> +Applicable to the MPEG4 encoder.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_0</constant>&nbsp;</entry>
> +		      <entry>Level 0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_0B</constant>&nbsp;</entry>
> +		      <entry>Level 0b</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_1</constant>&nbsp;</entry>
> +		      <entry>Level 1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_2</constant>&nbsp;</entry>
> +		      <entry>Level 2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_3</constant>&nbsp;</entry>
> +		      <entry>Level 3</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_3B</constant>&nbsp;</entry>
> +		      <entry>Level 3b</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_4</constant>&nbsp;</entry>
> +		      <entry>Level 4</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_5</constant>&nbsp;</entry>
> +		      <entry>Level 5</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_PROFILE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_h264_profile</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The profile information for H264.
> +Applicable to the H264 encoder.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE</constant>&nbsp;</entry>
> +		      <entry>Baseline profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE</constant>&nbsp;</entry>
> +		      <entry>Constrained Baseline profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_MAIN</constant>&nbsp;</entry>
> +		      <entry>Main profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED</constant>&nbsp;</entry>
> +		      <entry>Extended profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_HIGH</constant>&nbsp;</entry>
> +		      <entry>High profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10</constant>&nbsp;</entry>
> +		      <entry>High 10 profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422</constant>&nbsp;</entry>
> +		      <entry>High 422 profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_PREDICTIVE</constant>&nbsp;</entry>
> +		      <entry>High 444 Predictive profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10_INTRA</constant>&nbsp;</entry>
> +		      <entry>High 10 Intra profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422_INTRA</constant>&nbsp;</entry>
> +		      <entry>High 422 Intra profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_INTRA</constant>&nbsp;</entry>
> +		      <entry>High 444 Intra profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_CAVLC_444_INTRA</constant>&nbsp;</entry>
> +		      <entry>CAVLC 444 Intra profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_BASELINE</constant>&nbsp;</entry>
> +		      <entry>Scalable Baseline profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH</constant>&nbsp;</entry>
> +		      <entry>Scalable High profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH_INTRA</constant>&nbsp;</entry>
> +		      <entry>Scalable High Intra profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH</constant>&nbsp;</entry>
> +		      <entry>Stereo High profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH</constant>&nbsp;</entry>
> +		      <entry>Multiview High profile</entry>
> +		    </row>
> +
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_mpeg4_profile</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The profile information for MPEG4.
> +Applicable to the MPEG4 encoder.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_PROFILE_SIMPLE</constant>&nbsp;</entry>
> +		      <entry>Simple profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_PROFILE_ADVANCED_SIMPLE</constant>&nbsp;</entry>
> +		      <entry>Advanced Simple profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_PROFILE_CORE</constant>&nbsp;</entry>
> +		      <entry>Core profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_PROFILE_SIMPLE_SCALABLE</constant>&nbsp;</entry>
> +		      <entry>Simple Scalable profile</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_PROFILE_ADVANCED_CODING_EFFICIENCY</constant>&nbsp;</entry>
> +		      <entry></entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MAX_REF_PIC</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The maximum number of reference pictures used for encoding.
> +Applicable to the encoder.
> +</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_multi_slice_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Determines how should the encoder handle division of frame into slices.

Should be: 'Determines how the decoder should handle...'

> +Applicable to the encoder.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE</constant>&nbsp;</entry>
> +		      <entry>Single slice per frame.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB</constant>&nbsp;</entry>
> +		      <entry>Multiple slices with set maximum number of macroblocks per slice.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES</constant>&nbsp;</entry>
> +		      <entry>Multiple slice with set maximum size in bytes per slice.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The maximum number of macroblocks in a slice. Used when
> +<constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE</constant> is set to <constant>V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_MB</constant>.
> +Applicable to the encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The maximum size of a slice in bytes. Used when
> +<constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE</constant> is set to <constant>V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES</constant>.
> +Applicable to the encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_h264_loop_filter_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Loop filter mode for H264 encoder.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED</constant>&nbsp;</entry>
> +		      <entry>Loop filter is enabled.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED</constant>&nbsp;</entry>
> +		      <entry>Loop filter is disabled.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY</constant>&nbsp;</entry>
> +		      <entry>Loop filter is disabled at the slice boundary.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Loop filter alpha coefficient, defined in the H264 standard.
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Loop filter beta coefficient, defined in the H264 standard.
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_h264_symbol_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Entropy coding mode for H264 - CABAC/CAVALC.
> +Applicable to the H264 encoder.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC</constant>&nbsp;</entry>
> +		      <entry>Use CAVLC entropy coding.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC</constant>&nbsp;</entry>
> +		      <entry>Use CABAC entropy coding.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Enable 8X8 transform for H264. Applicable to the H264 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Cyclic intra macroblock refresh. This is the number of continuous macroblocks
> +refreshed every frame. Each frame a succesive set of macroblocks is refreshed until the cycle completes and starts from the
> +top of the frame. Applicable to H264, H263 and MPEG4 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Frame level rate control enable.
> +If this control is disabled then the quantization parameter for each frame type is constant and set with appropriate controls
> +(e.g. <constant>V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP</constant>). 
> +If frame rate control is enabled then quantization parameter is adjusted to meet the chosen bitrate. Minimum and maximum value
> +for the quantization parameter can be set with appropriate controls (e.g. <constant>V4L2_CID_MPEG_VIDEO_H263_MIN_QP</constant>).
> +Applicable to encoders.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Macroblock level rate control enable.
> +Applicable to the MPEG4 and H264 encoders.</entry>

If I understand this right enabling this will 'activate' the V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_* controls.

So this makes me wonder whether this control shouldn't perhaps be MFC51 specific
as well. Alternatively, we can say something like: 'How macroblock rate control is
implemented will differ per device, so devices that implement this will have their
own set of controls.'

> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_QPEL</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quarter pixel motion estimation for MPEG4. Applicable to the MPEG4 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an I frame for H263. Valid range: from 1 to 31.</entry>

Is this range defined by the H263 standard? If not, then you shouldn't mention
the range as it is hardware dependent.

> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H263_MIN_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Minimum quantization parameter for H263. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H263_MAX_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Maximum quantization parameter for H263. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an P frame for H263. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an B frame for H263. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an I frame for H264. Valid range: from 0 to 51.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_MIN_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Minimum quantization parameter for H264. Valid range: from 0 to 51.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_MAX_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Maximum quantization parameter for H264. Valid range: from 0 to 51.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an P frame for H264. Valid range: from 0 to 51.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an B frame for H264. Valid range: from 0 to 51.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an I frame for MPEG4. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Minimum quantization parameter for MPEG4. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Maximum quantization parameter for MPEG4. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an P frame for MPEG4. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an B frame for MPEG4. Valid range: from 1 to 31.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VBV_SIZE</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The Video Buffer Verifier size in kilobytes, it used as a limitation of frame skip.

Typo: 'it used' -> 'it is used'

I think it would be good to either give some background information here, or refer
to the standard for that information.

> +Applicable to the MPEG1, MPEG2, MPEG4 encoders.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The Coded Picture Buffer size in kilobytes, it used as a limitation of frame skip.

Same typo.

> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_I_PERIOD</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Period between I-frames in the open GOP for H264. In case of an open GOP
> +this is the period between two I-frames. The period between IDR (Instantaneous Decoding Refresh) frames is taken from the GOP_SIZE control.
> +An IDR frame, which stands for Instantaneous Decoding Refresh is an I-frame after which no prior frames are
> +referenced. This means that a stream can be restarted from an IDR frame without the need to store or decode any
> +previous frames. Applicable to the H264 encoder.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_HEADER_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_header_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Determines whether the header is returned as the first buffer or is
> +it returned together with the first frame. Applicable to encoders.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE</constant>&nbsp;</entry>
> +		      <entry>The stream header is returned separately in the first buffer.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME</constant>&nbsp;</entry>
> +		      <entry>The stream header is returned together with the first encoded frame.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row><row><entry spanname="descr">Enabled the deblocking post processing filter for MPEG4 decoder.
> +Applicable to the MPEG4 decoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">vop_time_increment_resolution value for MPEG4. Applicable to the MPEG4 encoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">vop_time_increment value for MPEG4. Applicable to the MPEG4 encoder.</entry>

How should these two controls be used? Are you supposed to set them? Or do they
have suitable default values?

> +	      </row>
> +
> +	    </tbody>
> +	  </tgroup>
> +	</table>
> +      </section>
> +
> +      <section>
> +	<title>MFC 5.1 MPEG Controls</title>
> +
> +	<para>The following MPEG class controls deal with MPEG
> +decoding and encoding settings that are specific to the Multi Format Codec 5.1 device present
> +in the S5P family of SoCs by Samsung.
> +</para>
> +
> +	<table pgwide="1" frame="none" id="mfc51-control-id">
> +	  <title>MFC 5.1 Control IDs</title>
> +	  <tgroup cols="4">
> +	    <colspec colname="c1" colwidth="1*" />
> +	    <colspec colname="c2" colwidth="6*" />
> +	    <colspec colname="c3" colwidth="2*" />
> +	    <colspec colname="c4" colwidth="6*" />
> +	    <spanspec namest="c1" nameend="c2" spanname="id" />
> +	    <spanspec namest="c2" nameend="c4" spanname="descr" />
> +	    <thead>
> +	      <row>
> +		<entry spanname="id" align="left">ID</entry>
> +		<entry align="left">Type</entry>
> +	      </row><row><entry spanname="descr" align="left">Description</entry>
> +	      </row>
> +	    </thead>
> +	    <tbody valign="top">
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">If the display delay is enabled then the decoder has to return an

typo: 'return a'

> +CAPTURE buffer after processing a certain number of OUTPUT buffers. If this number is low, then it may result in
> +buffers not being dequeued in display order. In addition hardware may still use those buffers as reference, thus
> +application should not write to those buffers. This feature can be used for example for generating thumbnails of videos.
> +Applicable to the H264 decoder.
> +	      </entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Display delay value for H264 decoder.</entry>

What's the unit of this control? Frames? Slices? Buffers?

> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">The number of reference pictures used for encoding a P picture.
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_PADDING</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row><row><entry spanname="descr">Padding enable in the encoder - use a color instead of repeating border pixels.
> +Applicable to encoders.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Padding color in the encoder. Applicable to encoders. The supplied 32-bit integer is interpreted as follows (bit
> +0 = least significant bit):</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry>Bit 0:7</entry>
> +		      <entry>V chrominance information</entry>
> +		    </row>
> +		    <row>
> +		      <entry>Bit 8:15</entry>
> +		      <entry>U chrominance information</entry>
> +		    </row>
> +		    <row>
> +		      <entry>Bit 16:23</entry>
> +		      <entry>Y luminance information</entry>
> +		    </row>
> +		    <row>
> +		      <entry>Bit 24:31</entry>
> +		      <entry>Must be zero.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Reaction coefficient for MFC rate control. Applicable to encoders.
> +<para>Note 1: Valid only when the frame level RC is enabled.</para>
> +<para>Note 2: For tight CBR, this field must be small (ex. 2 ~ 10).
> +For VBR, this field must be large (ex. 100 ~ 1000).</para>
> +<para>Note 3: It is not recommended to use the greater number than FRAME_RATE * (10^9 / BIT_RATE).</para>
> +</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row><row><entry spanname="descr">Adaptive rate control for dark region.
> +Valid only when H.264 and macroblock level RC is enabled (<constant>V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE</constant>). 
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row><row><entry spanname="descr">Adaptive rate control for smooth region.
> +Valid only when H.264 and macroblock level RC is enabled (<constant>V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE</constant>). 
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row><row><entry spanname="descr">Adaptive rate control for static region.
> +Valid only when H.264 and macroblock level RC is enabled (<constant>V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE</constant>). 
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row><row><entry spanname="descr">Adaptive rate control for activity region.
> +Valid only when H.264 and macroblock level RC is enabled (<constant>V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE</constant>). 
> +Applicable to the H264 encoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_mfc51_frame_skip_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">
> +Indicates in what conditions should the encoder skip frames. If encoding a frame would cause the

Typo: 'Indicates in what conditions the encoder should skip frames.'

> encoded stream to be larger then
> +a chosen data limit then the frame will be skipped.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_DISABLED</constant>&nbsp;</entry>
> +		      <entry>Frame skip mode is disabled.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_LEVEL_LIMIT</constant>&nbsp;</entry>
> +		      <entry>Frame skip mode enabled and buffer limit is set by the chosen level.</entry>

With which control do I set that level?

> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_VBV_LIMIT</constant>&nbsp;</entry>
> +		      <entry>Frame skip mode enabled and buffer limit is set by the VBV buffer size control.</entry>

VBV or H264_CPB. Perhaps this should be renamed SKIP_MODE_BUF_LIMIT with references
to the VBV and H264_CPB controls.

> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Enable rate-control with fixed target bit.
> +If this setting is enabled, then the rate control logic of the encoder will calculate the average bitrate for a GOP and keep it below or equal the set bitrate target.
> +Otherwise the rate control logic calculates the overall average bitrate for the stream and keeps it below or equal to the set bitrate. In the first case the
> +average bitrate for the whole stream will be smaller then the set bitrate. This is caused because the average is calculated for smaller number of frames, on the
> +other hand enabling this setting will ensure that the stream will meet tight bandwidth contraints. Applicable to encoders.
> +</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_mfc51_force_frame_type</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Force a frame type for the next queued buffer. Applicable to encoders.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_DISABLED</constant>&nbsp;</entry>
> +		      <entry>Forcing a specific frame type disabled.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_I_FRAME</constant>&nbsp;</entry>
> +		      <entry>Force an I-frame.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_NOT_CODED</constant>&nbsp;</entry>
> +		      <entry>Force a non-coded frame.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
>  	    </tbody>
>  	  </tgroup>
>  	</table>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 17d6e27..e338bc4 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1160,6 +1160,10 @@ enum v4l2_colorfx {
>  /* last CID + 1 */
>  #define V4L2_CID_LASTP1                         (V4L2_CID_BASE+39)
>  
> +/* Minimum number of buffer neede by the device */
> +#define V4L2_CID_MIN_BUFFERS_FOR_CAPTURE	(V4L2_CID_BASE+40)
> +#define V4L2_CID_MIN_BUFFERS_FOR_OUTPUT		(V4L2_CID_BASE+41)
> +
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
>  #define V4L2_CID_MPEG_CLASS 			(V4L2_CTRL_CLASS_MPEG | 1)
> @@ -1331,6 +1335,146 @@ enum v4l2_mpeg_video_bitrate_mode {
>  #define V4L2_CID_MPEG_VIDEO_MUTE 		(V4L2_CID_MPEG_BASE+210)
>  #define V4L2_CID_MPEG_VIDEO_MUTE_YUV 		(V4L2_CID_MPEG_BASE+211)
>  
> +#define V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE	(V4L2_CID_MPEG_BASE+212)
> +#define V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE		(V4L2_CID_MPEG_BASE+213)
> +#define V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC		(V4L2_CID_MPEG_BASE+214)
> +enum v4l2_mpeg_video_h264_vui_sar_idc {
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_UNSPECIFIED	= 0,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_1x1		= 1,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_12x11		= 2,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_10x11		= 3,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_16x11		= 4,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_40x33		= 5,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_24x11		= 6,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_20x11		= 7,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_32x11		= 8,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_80x33		= 9,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_18x11		= 10,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_15x11		= 11,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_64x33		= 12,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_160x99		= 13,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_4x3		= 14,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_3x2		= 15,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_2x1		= 16,
> +	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED	= 17,
> +};
> +
> +#define V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH	(V4L2_CID_MPEG_BASE+215)
> +#define V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_HEIGHT	(V4L2_CID_MPEG_BASE+216)
> +#define V4L2_CID_MPEG_VIDEO_H264_LEVEL			(V4L2_CID_MPEG_BASE+217)
> +enum v4l2_mpeg_video_h264_level {
> +	V4L2_MPEG_VIDEO_H264_LEVEL_1_0	= 0,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_1B	= 1,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_1_1	= 2,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_1_2	= 3,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_1_3	= 4,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_2_0	= 5,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_2_1	= 6,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_2_2	= 7,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_3_0	= 8,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_3_1	= 9,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_3_2	= 10,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_4_0	= 11,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_4_1	= 12,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_4_2	= 13,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_5_0	= 14,
> +	V4L2_MPEG_VIDEO_H264_LEVEL_5_1	= 15,
> +};
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL		(V4L2_CID_MPEG_BASE+218)
> +enum v4l2_mpeg_video_mpeg4_level {
> +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_0	= 0,
> +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_0B	= 1,
> +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_1	= 2,
> +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_2	= 3,
> +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_3	= 4,
> +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_3B	= 5,
> +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_4	= 6,
> +	V4L2_MPEG_VIDEO_MPEG4_LEVEL_5	= 7,
> +};
> +#define V4L2_CID_MPEG_VIDEO_H264_PROFILE	(V4L2_CID_MPEG_BASE+219)
> +enum v4l2_mpeg_video_h264_profile {
> +	V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE			= 0,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE	= 1,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_MAIN			= 2,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED			= 3,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH			= 4,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10			= 5,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422			= 6,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_PREDICTIVE	= 7,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_10_INTRA		= 8,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_422_INTRA		= 9,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_HIGH_444_INTRA		= 10,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_CAVLC_444_INTRA		= 11,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_BASELINE		= 12,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH		= 13,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_SCALABLE_HIGH_INTRA	= 14,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_STEREO_HIGH		= 15,
> +	V4L2_MPEG_VIDEO_H264_PROFILE_MULTIVIEW_HIGH		= 16,
> +};
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE	(V4L2_CID_MPEG_BASE+220)
> +enum v4l2_mpeg_video_mpeg4_profile {
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE				= 0,
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE			= 1,
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_CORE				= 2,
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE_SCALABLE			= 3,
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_CODING_EFFICIENCY	= 4,
> +};
> +#define V4L2_CID_MPEG_VIDEO_MAX_REF_PIC		(V4L2_CID_MPEG_BASE+221)
> +#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE	(V4L2_CID_MPEG_BASE+222)
> +enum v4l2_mpeg_video_multi_slice_mode {
> +	V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE		= 0,
> +	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB		= 1,
> +	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES	= 2,
> +};
> +#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB		(V4L2_CID_MPEG_BASE+223)
> +#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES	(V4L2_CID_MPEG_BASE+224)
> +#define V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE	(V4L2_CID_MPEG_BASE+225)
> +enum v4l2_mpeg_video_h264_loop_filter_mode {
> +	V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED				= 0,
> +	V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED				= 1,
> +	V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY	= 2,
> +};
> +#define V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA	(V4L2_CID_MPEG_BASE+226)
> +#define V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA	(V4L2_CID_MPEG_BASE+227)
> +#define V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE		(V4L2_CID_MPEG_BASE+228)
> +enum v4l2_mpeg_video_h264_symbol_mode {
> +	V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CAVLC	= 0,
> +	V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC	= 1,
> +};
> +
> +#define V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM		(V4L2_CID_MPEG_BASE+229)
> +#define V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB	(V4L2_CID_MPEG_BASE+230)
> +#define V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE		(V4L2_CID_MPEG_BASE+231)
> +#define V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE		(V4L2_CID_MPEG_BASE+232)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL			(V4L2_CID_MPEG_BASE+233)
> +#define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+234)
> +#define V4L2_CID_MPEG_VIDEO_H263_MIN_QP			(V4L2_CID_MPEG_BASE+235)
> +#define V4L2_CID_MPEG_VIDEO_H263_MAX_QP			(V4L2_CID_MPEG_BASE+236)
> +#define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+237)
> +#define V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP		(V4L2_CID_MPEG_BASE+238)
> +#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP		(V4L2_CID_MPEG_BASE+239)
> +#define V4L2_CID_MPEG_VIDEO_H264_MIN_QP			(V4L2_CID_MPEG_BASE+240)
> +#define V4L2_CID_MPEG_VIDEO_H264_MAX_QP			(V4L2_CID_MPEG_BASE+241)
> +#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP		(V4L2_CID_MPEG_BASE+242)
> +#define V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP		(V4L2_CID_MPEG_BASE+243)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP		(V4L2_CID_MPEG_BASE+244)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP		(V4L2_CID_MPEG_BASE+245)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP		(V4L2_CID_MPEG_BASE+246)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP		(V4L2_CID_MPEG_BASE+247)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP		(V4L2_CID_MPEG_BASE+248)
> +#define V4L2_CID_MPEG_VIDEO_VBV_SIZE			(V4L2_CID_MPEG_BASE+249)
> +#define V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE		(V4L2_CID_MPEG_BASE+250)
> +#define V4L2_CID_MPEG_VIDEO_H264_I_PERIOD		(V4L2_CID_MPEG_BASE+251)
> +#define V4L2_CID_MPEG_VIDEO_HEADER_MODE			(V4L2_CID_MPEG_BASE+252)
> +enum v4l2_mpeg_video_header_mode {
> +	V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE			= 0,
> +	V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME	= 1,
> +
> +};
> +#define V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER	(V4L2_CID_MPEG_BASE+253)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_RES			(V4L2_CID_MPEG_BASE+254)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_VOP_TIME_INC			(V4L2_CID_MPEG_BASE+255)
> +
>  /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
>  #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
>  #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
> @@ -1372,6 +1516,33 @@ enum v4l2_mpeg_cx2341x_video_median_filter_type {
>  #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP 	(V4L2_CID_MPEG_CX2341X_BASE+10)
>  #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS 	(V4L2_CID_MPEG_CX2341X_BASE+11)
>  
> +/*  MPEG-class control IDs specific to the Samsung MFC 5.1 driver as defined by V4L2 */
> +#define V4L2_CID_MPEG_MFC51_BASE				(V4L2_CTRL_CLASS_MPEG | 0x1000)
> +
> +#define V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY		(V4L2_CID_MPEG_MFC51_BASE+0)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE	(V4L2_CID_MPEG_MFC51_BASE+1)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P		(V4L2_CID_MPEG_MFC51_BASE+2)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_PADDING				(V4L2_CID_MPEG_MFC51_BASE+3)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV				(V4L2_CID_MPEG_MFC51_BASE+4)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF			(V4L2_CID_MPEG_MFC51_BASE+5)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK			(V4L2_CID_MPEG_MFC51_BASE+6)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH		(V4L2_CID_MPEG_MFC51_BASE+7)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC		(V4L2_CID_MPEG_MFC51_BASE+8)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY		(V4L2_CID_MPEG_MFC51_BASE+9)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE			(V4L2_CID_MPEG_MFC51_BASE+10)
> +enum v4l2_mpeg_mfc51_video_frame_skip_mode {
> +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED		= 0,
> +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_LEVEL_LIMIT	= 1,
> +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_VBV_LIMIT		= 2,
> +};
> +#define V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT	(V4L2_CID_MPEG_MFC51_BASE+11)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE	(V4L2_CID_MPEG_MFC51_BASE+12)
> +enum v4l2_mpeg_mfc51_video_force_frame_type {
> +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED		= 0,
> +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME		= 1,
> +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_NOT_CODED	= 2,
> +};
> +
>  /*  Camera class control IDs */
>  #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
>  #define V4L2_CID_CAMERA_CLASS 		(V4L2_CTRL_CLASS_CAMERA | 1)
> 

Regards,

	Hans
