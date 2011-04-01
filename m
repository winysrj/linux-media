Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50648 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab1DAKBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2011 06:01:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC] New controls for codec devices
Date: Fri, 1 Apr 2011 12:00:50 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"jaeryul.oh@samsung.com" <jaeryul.oh@samsung.com>,
	"hansverk@cisco.com" <hansverk@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF3619110DAD1E@bssrvexch01>
In-Reply-To: <ADF13DA15EB3FE4FBA487CCC7BEFDF3619110DAD1E@bssrvexch01>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011200.51712.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kamil,

Thanks for the RC. Here are some comments (more might come later when I'll get 
a better understanding of some MPEG4 and H264 concepts :-)).

On Tuesday 29 March 2011 11:48:03 Kamil Debski wrote:
> Hi,
> 
> I would like to propose a new set of controls for codec devices. By codec
> devices I mean hardware that can encode raw video into compressed stream
> and can decode compressed streams.
> 
> This topic has been discussed during the v4l2 brainstorming session and
> this email contains the propositions that have been made.
> 
> The conclusion was that we should use the existing V4L2_CID_MPEG_CLASS for
> controls related do encoding and decoding data. I had to distinguish which
> controls should be common for all codecs and which should be specific to
> MFC 5.1 (I am working on the driver for this hardware). To do this I
> have analysed the options of ffmpeg and x264 software decoders. If the
> options was used only in MFC then it should be hardware specific. If it
> was also used in ffmpeg or x264 then it would qualify as a common control.
> I would welcome comments from other hw codec driver developers.
> 
> I have another question - regarding v4l2_buffer flags. What do you think
> about adding a new flag - V4L2_BUF_FLAG_SKIPPED? It would be used in
> encoding to indicate that the frame to be encoded should be skipped and
> write information that the decoder should display the previous frame
> again.
> 
> Please find the table with controls attached below:
> - the names have the "V4L2_CID_MPEG_" prefix truncated
> - letter in the second column means D for decoder, E for encoder and A for
>   both
> - last column is MFC if the control should be hw specific, common otherwise
> 
> *** Controls for decoding ***
>  1) DECODER_MPEG4_LOOP_FILTER           D   MPEG4           MFC
> Deblocking filter on the decoder output for MPEG4.
>  2) DECODER_SLICE_INTERFACE             D   all             common
> If set the decoder can accept separate picture slices on input, otherwise
> it requires a whole frame.

Isn't that a property instead of a settable control ? I'm not sure to 
understand why applications would need to tell the decoder what it can accept. 
Or is it supposed to be a read-only control ?

>  3) DECODER_H264_DISPLAY_DELAY          D   H264            MFC
> Programmable display delay for H264. MFC will return a decoded frame after
> the set number of frames (this may cause that frames are not returned in
> display order).
>  4) DECODER_H264_DISPLAY_DELAY_ENABLE   D   H264            MFC
> Enable display delay for H264.

Can't display delay enable/disable be controlled through the 
DECODER_H264_DISPLAY_DELAY control ? A zero value would mean no display delay.

What is the display delay used for ?

> *** Controls for both decoding and encoding ***
>  5) H264_AR_VUI_IDC                     A   H264            common
> VUI aspect ratio IDC for H.264 encoding.  The value is defined in VUI Table
> E-1 in the standard.
>  6) H264_EXT_SAR_WIDTH                  A   H264            common
> Extended sample aspect ratio width for H.264 VUI encoding.
>  7) H264_EXT_SAR_HEIGHT                 A   H264            common
> Extended sample aspect ratio height for H.264 VUI encoding

What are those 3 controls used for when decoding ?

>  8) MIN_REQ_BUFS_OUT                    A   all             common
> This is the minimum number of buffers required for the output queue. This
> option may be useful if the encoding settings require a minimum number of
> buffers required as reference and the application would like to have N more
> buffers. For example - the encoding options require 3 buffers and the
> application wants to have 2 more. One can read this value (3) and supply
> (3+2) to the reqbufs call.
>  9) MIN_REQ_BUFS_CAP                    A   all             common
> This is the minimum number of buffers required for the capture queue. This
> option may be useful if the decoder requires a minimum number of buffers
> required as reference and the application would like to have N more
> buffers. For example - the stream requires 3 buffers and the application
> wants to have 2 more. One can read this value (3) and supply (3+2) to the
> reqbufs call.

Are these 2 read-only controls ?

> *** Controls for encoding ***
> 10) GOP_SIZE                            E   all             common
> The size of group of pictures. For H264 this is the IDR period.
> 11) H264_LEVEL                          E   H264            common
> The level information for H264.
> 12) MPEG4_LEVEL                         E   MPEG4           common
> The level information for MPEG4.

Do those need to be separate controls ?

> 13) H264_PROFILE                        E   H264            common
> The profile information for H264.
> 14) MPEG4_PROFILE                       E   MPEG4           common
> The profile information for MPEG4.

Same question here.

> 15) B_FRAMES                            E   H264, MPEG4     common
> The number of B-frames to use between P frames.
> 16) MAX_REF_PIC                         E   H264            common
> The maximum number of reference pictures used for encoding.
> 17) NUM_REF_PIC_FOR_P                   E   H264            MFC
> The number of reference pictures used for encoding a P picture.
> 18) MULTI_SLICE_MODE                    E   H264, MPEG4     common
> Determines how multiple slices are handled.
> 19) MULTI_SLICE_MB                      E   H264, MPEG4     common
> The upper limit of macroblocks for a slice.

Maybe MULTI_SLICE_MAX_MB ?

> 20) MULTI_SLICE_BITS                    E   H264, MPEG4     common
> The upper limit of size for a slice.

MULTI_SLICE_MAX_BITS ?

> 21) H264_LOOP_FILTER_MODE               E   H264            common
> Loop filter mode for H264.

There's a DECODER_MPEG4_LOOP_FILTER control. Are they similar ?

> 22) H264_LOOP_FILTER_ALPHA              E   H264            common
> Loop filter alpha coefficient, defined in the standard.
> 23) H264_LOOP_FILTER_BETA               E   H264            common
> Loop filter alpha coefficient, defined in the standard.

s/alpha/beta/

> 24) H264_SYMBOL_MODE                    E   H264            common
> Symbol mode for H264 - CABAC/CAVALC.
> 25) INTERLACE                           E   H264, MPEG4     common
> Enable interlace mode.
> 26) H264_8X8_TRANSFORM                  E   H264            common
> Enable 8X8 transform for H264.
> 27) INTRA_REFRESH_MB                    E   all             common
> Period of random intra macroblock refresh.
> 28) PADDING_ENABLE                      E   all             MFC
> Padding enable - use a color instead of repeating border pixels.
> 29) PADDING_LUMA                        E   all             MFC
> 30) PADDING_CB                          E   all             MFC
> 31) PADDING_CR                          E   all             MFC

Do we need 3 controls for that, or can we use a single one (similarly to what 
we did with the color key control) ?

> 32) FRAME_RC_ENABLE                     E   all             common
> Frame level rate control enable.
> 33) MB_RC_ENABLE                        E   H264            common
> Macroblock level rate control enable.
> 34) FRAME_RATE                          E   all             common
> Frames per second in 1000x scale (e.g., 7500 stands for 7.5 frames/sec).

What is this used for ?

> 35) RC_BITRATE                          E   all             common
> Bitrate for rate control.
> 36) RC_REACTION_COEFF                   E   all             MFC
> Reaction coefficient for MFC rate control.
> 37) H264_ADAPTIVE_RC_DARK_DISABLE       E   H264            MFC
> Disable adaptive rate control for dark region.
> 38) H264_ADAPTIVE_RC_SMOOTH_DISABLE     E   H264            MFC
> Disable adaptive rate control for smooth region.
> 39) H264_ADAPTIVE_RC_STATIC_DISABLE     E   H264            MFC
> Disable adaptive rate control for static region.
> 40) H264_ADAPTIVE_RC_ACTIVITY_DISABLE   E   H264            MFC
> Disable adaptive rate control for region with activity.
> 41) MPEG4_QPEL_DISABLE                  E   MPEG4           common
> Disable quarter pixel motion estimation for MPEG4.

Should we remove the _DISABLE suffix and make the controls default to true ?

> 42) I_FRAME_QP                          E   all             common
> Quantization parameter for an I frame.
> 43) MIN_QP                              E   all             common
> Minimum quantization parameter.
> 44) MAX_QP                              E   all             common
> Maximum quantization parameter.
> 45) P_FRAME_QP                          E   all             common
> Quantization parameter for an P frame.
> 46) B_FRAME_QP                          E   H264, MPEG4     common
> Quantization parameter for an B frame.
> 47) VBV_BUF_SIZE                        E   H264, MPEG*     common
> VBV buffer size. I think it is valid for all MPEG versions.
> 48) FRAME_SKIP_MODE                     E   all             MFC
> Mode of skipping frames for VBV compliance.
> 49) RC_FIXED_TARGET_BIT                 E   all             MFC
> 50) MPEG4_VOP_TIME_RES                  E   MPEG4           MFC
> Used to compute vop_time_increment and modulo_time_base in MPEG4.
> 51) MPEG4_VOP_FRAME_DELTA               E   MPEG4           MFC
> Used to compute vop_time_increment and modulo_time_base in MPEG4.
> 52) H264_OPEN_GOP                       E   H264            common
> Enable open GOP in H264.
> 53) H264_I_PERIOD                       E   H264            common
> Period between I frames in open GOP for H264.
> 54) H264_AR_VUI_ENABLE                  E   H264            MFC
> Enable writing aspect ratio in VUI.
> 55) HEADER_MODE                         E   all             common
> Determines whether the header is returned as the first buffer or is
> it returned together with the first frame.
> 56) FORCE_FRAME_TYPE                    E   all             MFC
> Force frame type on the encoder - either I-frame or skipped.
> I hope that buffer flags could be used instead of this.
> 57) FRAME_TAG                           E   all             MFC
> Frame tag is assigned to an input buffer passed to hardware, and
> the same frame tag is then assigned to the buffer that contains the
> result of processing that frame.

-- 
Regards,

Laurent Pinchart
