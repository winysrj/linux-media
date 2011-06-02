Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:9349 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab1FBHo1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 03:44:27 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LM5003Q6K5KKOJ0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Jun 2011 16:44:25 +0900 (KST)
Received: from jtppark ([12.23.121.105])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LM500JU0K61KT@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Jun 2011 16:44:25 +0900 (KST)
Date: Thu, 02 Jun 2011 16:44:24 +0900
From: Jeongtae Park <jtp.park@samsung.com>
Subject: RE: [RFC/PATCH v2] v4l: add control definitions for codec devices.
In-reply-to: <1306832883-12352-1-git-send-email-k.debski@samsung.com>
To: 'Kamil Debski' <k.debski@samsung.com>, linux-media@vger.kernel.org
Cc: jaeryul.oh@samsung.com, june.bae@samsung.com,
	janghyuck.kim@samsung.com, kyungmin.park@samsung.com,
	younglak1004.kim@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Reply-to: jtp.park@samsung.com
Message-id: <001e01cc20f8$e4a441d0$adecc570$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1306832883-12352-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Thank you for your nice work. Here are my some comments. 

> -----Original Message-----
> From: Kamil Debski [mailto:k.debski@samsung.com]
> Sent: Tuesday, May 31, 2011 6:08 PM
> Cc: m.szyprowski@samsung.com; kyungmin.park@samsung.com; k.debski@samsung.com; jaeryul.oh@samsung.com;
> hverkuil@xs4all.nl; laurent.pinchart@ideasonboard.com; jtp.park@samsung.com
> Subject: [RFC/PATCH v2] v4l: add control definitions for codec devices.
> 
> Hi,
> 
> This is a second version of the patch that adds controls for the codec family of
> devices. I have implemented the suggestions I got from Hans Verkuil on the #v4l
> channel.
> 
> Change log:
> - rename V4L2_CID_MIN_REQ_BUFS_(CAP/OUT) to V4L2_CID_MIN_BUFFERS_FOR_(CAPTURE/OUTPUT)
> - use existing controls for GOP size, number of frames and GOP closure
> - remove frame rate controls (in favour of the S_PARM call)
> - split level into separate controls for MPEG4 and H264
> 
> I would welcome further comments.
> 
> Best regards,
> Kamil Debski
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/v4l/controls.xml |  733 ++++++++++++++++++++++++++++++++
>  include/linux/videodev2.h              |  147 +++++++
>  2 files changed, 880 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
> index 6880798..7c2df42 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -325,6 +325,22 @@ minimum value disables backlight compensation.</entry>
>  <constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_CID_MIN_BUFFERS_FOR_CAPTURE</constant></entry>
> +	    <entry>integer</entry>
> +	    <entry>This is a read only control that can read by the application
> +and used as a hint to determine the number of CAPTURE buffer to pass to REQBUFS.
> +The value is the minimum number of CAPTURE buffer that it necessary for hardware
> +to work.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_CID_MIN_BUFFERSS_FOR_OUTPUT</constant></entry>
> +	    <entry>integer</entry>
> +	    <entry>This is a read only control that can read by the application
> +and used as a hint to determine the number of OUTPUT buffer to pass to REQBUFS.
> +The value is the minimum number of OUTPUT buffer that it necessary for hardware
> +to work.</entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
>  	    <entry></entry>
>  	    <entry>ID of the first custom (driver specific) control.
> @@ -1409,6 +1425,723 @@ of the video. The supplied 32-bit integer is interpreted as follows (bit
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
> +	      <row><entry spanname="descr">If enabled the decoder expects a single slice in one buffer, otherwise
> +the decoder expects a single frame in one input buffer.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_AR_ENABLE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Enable writing aspect ratio in the Video Usability Information.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_AR_IDC</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">VUI aspect ratio IDC for H.264 encoding. The value is defined in VUI Table
> +E-1 in the standard.
> +	      </entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_EXT_SAR_WIDTH</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Extended sample aspect ratio width for H.264 VUI encoding.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_EXT_SAR_HEIGHT</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Extended sample aspect ratio height for H.264 VUI encoding.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_LEVEL</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_level</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The level information for stream.
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
> +		      <entry>Level 1.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_1_1</constant>&nbsp;</entry>
> +		      <entry>Level 1.1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_1_2</constant>&nbsp;</entry>
> +		      <entry>Level 1.2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_1_3</constant>&nbsp;</entry>
> +		      <entry>Level 1.3</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_2</constant>&nbsp;</entry>
> +		      <entry>Level 2.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_2_1</constant>&nbsp;</entry>
> +		      <entry>Level 2.1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_2_2</constant>&nbsp;</entry>
> +		      <entry>Level 2.2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_3</constant>&nbsp;</entry>
> +		      <entry>Level 3.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_3B</constant>&nbsp;</entry>
> +		      <entry>Level 3b</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_3_1</constant>&nbsp;</entry>
> +		      <entry>Level 3.1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_3_2</constant>&nbsp;</entry>
> +		      <entry>Level 3.2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_4</constant>&nbsp;</entry>
> +		      <entry>Level 4.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_4_1</constant>&nbsp;</entry>
> +		      <entry>Level 4.1</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_4_2</constant>&nbsp;</entry>
> +		      <entry>Level 4.2</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_5</constant>&nbsp;</entry>
> +		      <entry>Level 5.0</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_LEVEL_5_1</constant>&nbsp;</entry>
> +		      <entry>Level 5.1</entry>
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
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The maximum number of reference pictures used for encoding.</entry>
> +	      </row>

Is it boolean type?

> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_multi_slice_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Determines how multiple slices are handled.
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
> +		      <entry><constant>V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BITS</constant>&nbsp;</entry>
> +		      <entry>Multiple slice with set maximum size in bits per slice.</entry>
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
> +	      <row><entry spanname="descr">The upper limit of macroblocks of a slice.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">The upper limit of size in bits of a slice.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_h264_loop_filter_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Loop filter mode for H264.
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
> +
> <entry><constant>V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY</constant>&nbsp;</entry>
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
> +	      <row><entry spanname="descr">Loop filter alpha coefficient, defined in the standard.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Loop filter alpha coefficient, defined in the standard.</entry>
> +	      </row>

alpha -> beta.

> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_SYMBOL_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_h264_symbol_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Symbol mode for H264 - CABAC/CAVALC.
> +Possible values are:</entry>
> +	      </row>
> +	      <row>
> +		<entrytbl spanname="descr" cols="2">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_SYMBOL_MODE_CAVLC</constant>&nbsp;</entry>
> +		      <entry>Use CAVLC entropy coding.</entry>
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_VIDEO_H264_SYMBOL_MODE_CABAC</constant>&nbsp;</entry>
> +		      <entry>Use CABAC entropy coding.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_INTERLACE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Enable interlace mode.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Enable 8X8 transform for H264.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_MB</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Period of random intra macroblock refresh.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Padding enable - use a color instead of repeating border pixels.</entry>
> +	      </row>

The description may be wrong.

> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_MB_RC_ENABLE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Macroblock level rate control enable for H264.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RATE_NOMINATOR</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Frames per second - nominator.</entry>
> +	      </row>

Removed as you mentioned.

> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RATE_DENOMINATOR</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Frames per second - denominator</entry>
> +	      </row>
> +

Removed as you mentioned.

> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_RC_BITRATE</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Bitrate per second for rate control.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_QPEL</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quarter pixel motion estimation for MPEG4.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_I_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an I frame.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MIN_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Minimum quantization parameter.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MAX_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Maximum quantization parameter.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_P_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an P frame.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_B_FRAME_QP</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an B frame.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VBV_BUF_SIZE</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Quantization parameter for an P frame.</entry>
> +	      </row>

The description may be wrong, How about this?
'The VBV buffer size in kilo bytes, it used as a limitation of frame skip'

> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_OPEN_GOP</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Enable open GOP in H264.</entry>
> +	      </row>

I cannot find V4L2_CID_MPEG_VIDEO_H264_OPEN_GOP definition at videodev2.h,
we will use V4L2_CID_MPEG_VIDEO_GOP_CLOSURE instead, right?

> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_I_PERIOD</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Period between I frames in open GOP for H264.</entry>
> +	      </row>
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_HEADER_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_header_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Determines whether the header is returned as the first buffer or is
> +it returned together with the first frame.
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
> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Frame level rate control enable.</entry>
> +	      </row>

I saw the same CID above, previous definition have to remove.

> +
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_MB_RC_ENABLE</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Macroblock level rate control enable.</entry>
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
> +decoding and encoding settings that are specific to the MFC 5.1 device present
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
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER</constant>&nbsp;</entry>
> +		<entry>boolean</entry>
> +	      </row><row><entry spanname="descr">Enabled the deblocking post processing filter for MPEG4
> decoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">If the display delay is enabled then the decoder has to return an
> +CAPTURE buffer after processing a certain number of OUTPUT buffers. If this number is low, then it may result in
> +buffers not being dequeued in display order. In addition hardware may still use those buffers as reference, thus
> +application should not write to those buffers. This feature can be used for example for generating thumbnails of
> videos.
> +	      </entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Display delay value for H264 decoder.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_NUM_REF_PIC_FOR_P</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">The number of reference pictures used for encoding a P
> picture.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V;4L2_CID_MPEG_MFC51_VIDEO_PADDING</constant>&nbsp;</entry>

There is a miss typing(;).

> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Padding enable - use a color instead of repeating border
> pixels.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Padding color. The supplied 32-bit integer is interpreted as follows
> (bit
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
> +	      </row><row><entry spanname="descr">Reaction coefficient for MFC rate control.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Adaptive rate control for dark region.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Adaptive rate control for smooth region.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Adaptive rate control for static region.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Adaptive rate control for activity region.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_mfc51_frame_skip_mode</entry>
> +	      </row>
> +	      <row><entry spanname="descr">
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
> +		    </row>
> +		    <row>
> +		      <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_VBV_LIMIT</constant>&nbsp;</entry>
> +		      <entry>Frame skip mode enabled and buffer limit is set by the VBV buffer size control.</entry>
> +		    </row>
> +		  </tbody>
> +		</entrytbl>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr"></entry>

How about below description?
' Enable rate-control with fixed target bit. If enabled encoder targets bitrate in GOP, else try to meet average bitrate.'

> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_MPEG4_VOP_TIME_RES</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Used to compute vop_time_increment and modulo_time_base in
> MPEG4.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_MPEG4_VOP_FRAME_DELTA</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Used to compute vop_time_increment and modulo_time_base in
> MPEG4.</entry>
> +	      </row>
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE</constant>&nbsp;</entry>
> +		<entry>enum&nbsp;v4l2_mpeg_mfc51_force_frame_type</entry>
> +	      </row>
> +	      <row><entry spanname="descr">Force a frame type for the next queued buffer.
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
> +	      <row><entry></entry></row>
> +	      <row>
> +		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FRAME_TAG</constant>&nbsp;</entry>
> +		<entry>integer</entry>
> +	      </row><row><entry spanname="descr">Frame tag is assigned to an input buffer passed to hardware, and
> +the same frame tag is then assigned to the buffer that contains the
> +result of processing that frame.
> +	      </entry>
> +	      </row>
>  	    </tbody>
>  	  </tgroup>
>  	</table>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 6168da0..5ec2aba 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1157,6 +1157,10 @@ enum v4l2_colorfx {
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
> @@ -1328,6 +1332,118 @@ enum v4l2_mpeg_video_bitrate_mode {
>  #define V4L2_CID_MPEG_VIDEO_MUTE 		(V4L2_CID_MPEG_BASE+210)
>  #define V4L2_CID_MPEG_VIDEO_MUTE_YUV 		(V4L2_CID_MPEG_BASE+211)
> 
> +#define V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE	(V4L2_CID_MPEG_BASE+212)
> +#define V4L2_CID_MPEG_VIDEO_H264_VUI_AR_ENABLE		(V4L2_CID_MPEG_BASE+213)
> +#define V4L2_CID_MPEG_VIDEO_H264_VUI_AR_IDC		(V4L2_CID_MPEG_BASE+214)
> +#define V4L2_CID_MPEG_VIDEO_H264_EXT_SAR_WIDTH		(V4L2_CID_MPEG_BASE+215)
> +#define V4L2_CID_MPEG_VIDEO_H264_EXT_SAR_HEIGHT		(V4L2_CID_MPEG_BASE+216)
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
> +};

How about include SVC, MVC extension profiles?

> +#define V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE	(V4L2_CID_MPEG_BASE+220)
> +enum v4l2_mpeg_video_mpeg4_profile {
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE				= 0,
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE			= 1,
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_CORE				= 2,
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE_SCALABLE			= 3,
> +	V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_CODING_EFFICIENCY	= 4,
> +};
> +#define V4L2_CID_MPEG_VIDEO_MAX_REF_PIC		(V4L2_CID_MPEG_BASE+223)
> +#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE	(V4L2_CID_MPEG_BASE+224)
> +enum v4l2_mpeg_video_multi_slice_mode {
> +	V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE		= 0,
> +	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB		= 1,
> +	V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BITS	= 2,
> +};
> +#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB		(V4L2_CID_MPEG_BASE+225)
> +#define V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BITS	(V4L2_CID_MPEG_BASE+226)
> +#define V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE	(V4L2_CID_MPEG_BASE+227)
> +enum v4l2_mpeg_video_h264_loop_filter_mode {
> +	V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED				= 0,
> +	V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED				= 1,
> +	V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY	= 2,
> +};
> +#define V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA	(V4L2_CID_MPEG_BASE+228)
> +#define V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_BETA	(V4L2_CID_MPEG_BASE+229)
> +#define V4L2_CID_MPEG_VIDEO_H264_SYMBOL_MODE		(V4L2_CID_MPEG_BASE+230)
> +enum v4l2_mpeg_video_h264_symbol_mode {
> +	V4L2_MPEG_VIDEO_H264_SYMBOL_MODE_CAVLC	= 0,
> +	V4L2_MPEG_VIDEO_H264_SYMBOL_MODE_CABAC	= 1,
> +};
> +
> +#define V4L2_CID_MPEG_VIDEO_INTERLACE		(V4L2_CID_MPEG_BASE+231)

MFC encoder supports only H.264 the interlace encoding, and
how about use v4l2_field in struct v4l2_pix_format_mplane with VIDIOC_*_FMT ioctl?

> +#define V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM	(V4L2_CID_MPEG_BASE+232)
> +#define V4L2_CID_MPEG_VIDEO_INTRA_REFRESH_MB	(V4L2_CID_MPEG_BASE+233)
> +#define V4L2_CID_MPEG_VIDEO_FRAME_RC_ENABLE	(V4L2_CID_MPEG_BASE+234)
> +#define V4L2_CID_MPEG_VIDEO_H264_MB_RC_ENABLE	(V4L2_CID_MPEG_BASE+235)
> +#define V4L2_CID_MPEG_VIDEO_RC_BITRATE		(V4L2_CID_MPEG_BASE+236)

How about use V4L2_CID_MPEG_VIDEO_BITRATE?

> +#define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+237)
> +#define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP	(V4L2_CID_MPEG_BASE+238)
> +#define V4L2_CID_MPEG_VIDEO_H263_MIN_QP		(V4L2_CID_MPEG_BASE+239)
> +#define V4L2_CID_MPEG_VIDEO_H263_MAX_QP		(V4L2_CID_MPEG_BASE+240)
> +#define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP	(V4L2_CID_MPEG_BASE+241)
> +#define V4L2_CID_MPEG_VIDEO_H263_B_FRAME_QP	(V4L2_CID_MPEG_BASE+242)
> +#define V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP	(V4L2_CID_MPEG_BASE+243)
> +#define V4L2_CID_MPEG_VIDEO_H264_MIN_QP		(V4L2_CID_MPEG_BASE+244)
> +#define V4L2_CID_MPEG_VIDEO_H264_MAX_QP		(V4L2_CID_MPEG_BASE+245)
> +#define V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP	(V4L2_CID_MPEG_BASE+246)
> +#define V4L2_CID_MPEG_VIDEO_H264_B_FRAME_QP	(V4L2_CID_MPEG_BASE+247)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+248)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_MIN_QP	(V4L2_CID_MPEG_BASE+249)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_MAX_QP	(V4L2_CID_MPEG_BASE+250)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+251)
> +#define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+252)

There are only V4L2_CID_MPEG_VIDEO_[I,P,B]_FRAME_QP descriptions in controls.xml.

> +#define V4L2_CID_MPEG_VIDEO_VBV_BUF_SIZE	(V4L2_CID_MPEG_BASE+253)
> +#define V4L2_CID_MPEG_VIDEO_H264_I_PERIOD	(V4L2_CID_MPEG_BASE+255)
> +#define V4L2_CID_MPEG_VIDEO_HEADER_MODE		(V4L2_CID_MPEG_BASE+256)
> +enum v4l2_mpeg_video_header_mode {
> +	V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE			= 0,
> +	V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME	= 1,
> +
> +};
> +
>  /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
>  #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
>  #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
> @@ -1369,6 +1485,37 @@ enum v4l2_mpeg_cx2341x_video_median_filter_type {
>  #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP 	(V4L2_CID_MPEG_CX2341X_BASE+10)
>  #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS 	(V4L2_CID_MPEG_CX2341X_BASE+11)
> 
> +/*  MPEG-class control IDs specific to the Samsung MFC 5.1 driver as defined by V4L2 */
> +#define V4L2_CID_MPEG_MFC51_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x1000)
> +
> +#define V4L2_CID_MPEG_MFC51_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER		(V4L2_CID_MPEG_MFC51_BASE+0)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY		(V4L2_CID_MPEG_MFC51_BASE+1)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE	(V4L2_CID_MPEG_MFC51_BASE+2)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_NUM_REF_PIC_FOR_P			(V4L2_CID_MPEG_MFC51_BASE+3)

Support in H.264 only.

> +#define V4L2_CID_MPEG_MFC51_VIDEO_PADDING				(V4L2_CID_MPEG_MFC51_BASE+4)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_PADDING_YUV				(V4L2_CID_MPEG_MFC51_BASE+5)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_RC_REACTION_COEFF			(V4L2_CID_MPEG_MFC51_BASE+8)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_DARK			(V4L2_CID_MPEG_MFC51_BASE+9)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_SMOOTH		(V4L2_CID_MPEG_MFC51_BASE+10)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC		(V4L2_CID_MPEG_MFC51_BASE+11)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_ACTIVITY		(V4L2_CID_MPEG_MFC51_BASE+12)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE			(V4L2_CID_MPEG_MFC51_BASE+13)
> +enum v4l2_mpeg_mfc51_video_frame_skip_mode {
> +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_DISABLED		= 0,
> +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_LEVEL_LIMIT	= 1,
> +	V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_VBV_LIMIT		= 2,
> +};
> +#define V4L2_CID_MPEG_MFC51_VIDEO_RC_FIXED_TARGET_BIT	(V4L2_CID_MPEG_MFC51_BASE+14)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_MPEG4_VOP_TIME_RES	(V4L2_CID_MPEG_MFC51_BASE+15)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_MPEG4_VOP_FRAME_DELTA	(V4L2_CID_MPEG_MFC51_BASE+16)
> +#define V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE	(V4L2_CID_MPEG_MFC51_BASE+17)
> +enum v4l2_mpeg_mfc51_video_force_frame_type {
> +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_DISABLED		= 0,
> +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_I_FRAME		= 1,
> +	V4L2_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE_NOT_CODED	= 2,
> +};
> +#define V4L2_CID_MPEG_MFC51_VIDEO_FRAME_TAG	(V4L2_CID_MPEG_MFC51_BASE+18)
> +

I remember that you try to add extra frame type(SKIPPED or NOT_CODED) to V4L2_BUF_FLAG_*.
How is it going?

>  /*  Camera class control IDs */
>  #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
>  #define V4L2_CID_CAMERA_CLASS 		(V4L2_CTRL_CLASS_CAMERA | 1)



> --
> 1.6.3.3

Thanks
Best Regards,

/jtpark

