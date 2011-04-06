Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:59709 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1DFGFl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 02:05:41 -0400
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LJ700E86VLEGX80@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 15:05:39 +0900 (KST)
Received: from jtppark ([12.23.103.64])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LJ7004T8VLE7P@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 15:05:39 +0900 (KST)
Date: Wed, 06 Apr 2011 15:05:30 +0900
From: Jeongtae Park <jtp.park@samsung.com>
Subject: RE: [RFC] New controls for codec devices
In-reply-to: <201104041650.30819.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Kamil Debski' <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	jaeryul.oh@samsung.com, hansverk@cisco.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>,
	jemings@samsung.com, june.bae@samsung.com,
	janghyuck.kim@samsung.com
Reply-to: jtp.park@samsung.com
Message-id: <007e01cbf420$a6cee9a0$f46cbce0$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF3619110DAD1E@bssrvexch01>
 <201104011200.51712.laurent.pinchart@ideasonboard.com>
 <002101cbf082$daa237b0$8fe6a710$%debski@samsung.com>
 <201104041650.30819.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

AAZABlAHYAaQBjAGUAcw
	Ax-cr-puzzleid: {D5185033-3373-475A-A768-FCD559F05F0C}

Hi Laurent,
and Hi Kamil.

I think there are some point that I can reply.

First, How about think adding the prefix of common(decoding & encoding) and
encoding controls? Now, only controls for decoding have DECODER_* prefix.
([COMMON], DECODER, ENCODER)

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Monday, April 04, 2011 11:51 PM
> To: Kamil Debski
> Cc: linux-media@vger.kernel.org; 'Kyungmin Park'; jaeryul.oh@samsung.com;
> hansverk@cisco.com; Marek Szyprowski
> Subject: Re: [RFC] New controls for codec devices
> 
> Hi Kamil,
> 
> On Friday 01 April 2011 17:38:26 Kamil Debski wrote:
> > > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > > On Tuesday 29 March 2011 11:48:03 Kamil Debski wrote:
> 
> [snip]
> 
> > > >  2) DECODER_SLICE_INTERFACE             D   all             common
> > > >
> > > > If set the decoder can accept separate picture slices on input,
> > > > otherwise it requires a whole frame.
> > >
> > > Isn't that a property instead of a settable control ? I'm not sure to
> > > understand why applications would need to tell the decoder what it can
> > > accept. Or is it supposed to be a read-only control ?
> >
> > I think I have not described this control properly. It is used by the
> > application to set what kind of buffer it will send to the driver.
> >
> > A picture can consist of one or more slice. Our hardware can accept two
> > kinds of input buffers and its behavior is determined by a register. So it
> > is a read/write control.  In the first case, a single input buffer contains
> > a whole picture (one or more slices). In the second case, a single input
> > buffer contains a single slice.
> >
> > A nice figure describing pictures and slices can be found here:
> > http://goo.gl/info/bnFe2
> 
> OK I understand it better now.
> 
> Is this configurable at runtime for each buffer, or is it a decoder
> configuration that must be set before the start of the stream ?
> 

Actually, MFC allows to change slice interface at runtime not during slice decoding
(after multi-sliced frame decoding when slice interface is enabled).
But we not recommends this method and there may be no use-case like that.


> > > >  3) DECODER_H264_DISPLAY_DELAY          D   H264            MFC
> > > >
> > > > Programmable display delay for H264. MFC will return a decoded frame
> > > > after the set number of frames (this may cause that frames are not
> > > > returned in display order).
> > > >
> > > >  4) DECODER_H264_DISPLAY_DELAY_ENABLE   D   H264            MFC
> > > >
> > > > Enable display delay for H264.
> > >
> > > Can't display delay enable/disable be controlled through the
> > > DECODER_H264_DISPLAY_DELAY control ? A zero value would mean no display
> > > delay.
> >
> > Firstly I have had the same idea as you have proposed. But in this case
> > zero value is meaningful. If display delay is disabled then it is up to
> > the decoder to determine how many OUTPUT buffers will it process before a
> > buffer on the CAPTURE is dequeued. This is influenced by the number of B
> > frames and how many reference frames are used by P and B frames. This
> > ensures that after the CAPTURE buffer is dequeued it won't be used by the
> > hardware.
> >
> > If the display delay is enabled then the decoder has to return an CAPTURE
> > buffer after processing a certain number of OUTPUT buffers. If this number
> > is low, then it may result in buffers not being dequeued in display order.
> >
> > Even worse, I have just discovered that the buffer can still be used by the
> > hardware as a reference after it has been dequeued in case of low display
> > delay. So I think that this feature is very specific to our hardware (thus
> > I think it should be hw specific control) and application has to be aware
> > of this.
> 
> If I understand this correctly, drivers need to reference CAPTURE buffers
> (containing decoded images) for some time to decode P and B frames. The
> default behaviour is to return a buffer to userspace only when the buffer
> isn't needed by the driver anymore. This behaviour can be overridden using
> the
> display delay control to return CAPTURE buffers sooner, making it possible to
> display frames without an additional delay.
> 
> If applications need to write to the buffers, they can't use that feature.
> Otherwise, why shouldn't drivers always return frames to userspace ASAP ? We
> would then need a single control to tell the driver whether the application
> wants to write to the buffers (in which case they won't be dequeued until the
> driver doesn't need them anymore), or only wants to read from them (in which
> case the driver will dequeued them ASAP).
> 
> > > What is the display delay used for ?
> >
> > As described above - it is used to force hardware to return an CAPTURE
> > buffer after a set number or OUTPUT buffers was processed.
> >

It may be very useful to make thumbnail image of movie. User set display delay to 0,
trigger decoding, MFC produces displayable image on capture immediately.
Otherwise, MFC needs more output buffer(source stream) for thumbnail image.

One more use-case is 1-frame stream(stream has only 1 key frame) decoding.
If user cannot control display delay, user must input duplicated
source stream(output queue) for destination(capture queue) output frame data.

MFC 5.1 supports only display delay for H264 because H264 stream can has long display
delay especially due to codec feature. But next version of MFC or other codec devices
can support this feature every codec standard, then we can make this control as common.

Can we distinguish enable/disable by one control? 
-1 means disable display delay as a default.

> > > > *** Controls for both decoding and encoding ***
> > > >
> > > >  5) H264_AR_VUI_IDC                     A   H264            common
> > > >
> > > > VUI aspect ratio IDC for H.264 encoding.  The value is defined in VUI
> > >
> > > Table
> > >
> > > > E-1 in the standard.
> > > >
> > > >  6) H264_EXT_SAR_WIDTH                  A   H264            common
> > > >
> > > > Extended sample aspect ratio width for H.264 VUI encoding.
> > > >
> > > >  7) H264_EXT_SAR_HEIGHT                 A   H264            common
> > > >
> > > > Extended sample aspect ratio height for H.264 VUI encoding
> > >
> > > What are those 3 controls used for when decoding ?
> >
> > While encoding it is used to set the aspect ratio indicator in the VUI.
> > During decoding it is used to read such information.
> >
> > Maybe a better name would be H264_VUI_(AR_IDC, EXT_SAR_WIDTH,
> > EXT_SAR_HEIGHT).
> 
> So they're used to read/write information about the encoded stream.
> 
> I wonder whether we should create an ioctl to get/set an MPEG information
> block.
> 

It seems better H264_VUI_* naming.
These controls can be used to write VUI information in encoding only.
MPEG4 has AR(aspect ratio) in VOL, but it's different slightly.
(MFC 5.1 supports only H264 AR)
I'm not sure which is better separation or integration of control for AR.

> > > >  8) MIN_REQ_BUFS_OUT                    A   all             common
> > > >
> > > > This is the minimum number of buffers required for the output queue.
> > > > This option may be useful if the encoding settings require a minimum
> > > > number of buffers required as reference and the application would like
> > > > to have N more buffers. For example - the encoding options require 3
> > > > buffers and the application wants to have 2 more. One can read this
> > > > value (3) and supply (3+2) to the reqbufs call.
> > > >
> > > >  9) MIN_REQ_BUFS_CAP                    A   all             common
> > > >
> > > > This is the minimum number of buffers required for the capture queue.
> > > > This option may be useful if the decoder requires a minimum number of
> > > > buffers required as reference and the application would like to have N
> > > > more buffers. For example - the stream requires 3 buffers and the
> > > > application wants to have 2 more. One can read this value (3) and
> > > > supply (3+2) to the reqbufs call.
> > >
> > > Are these 2 read-only controls ?
> >
> > Yes they are read only.
> 
> This feature is useful for non-codec devices as well, should it be a standard
> control usable by other drivers ?
> 

I agree, but I'm not sure which non-CODEC device requires this feature.

> > > > *** Controls for encoding ***
> > > > 10) GOP_SIZE                            E   all             common
> > > > The size of group of pictures. For H264 this is the IDR period.
> > > > 11) H264_LEVEL                          E   H264            common
> > > > The level information for H264.
> > > > 12) MPEG4_LEVEL                         E   MPEG4           common
> > > > The level information for MPEG4.
> > >
> > > Do those need to be separate controls ?
> >
> > I've been thinking hard about this for some time. My first thought was to
> > have a single control. On second thought I have decided to have them
> > separate.
> >
> > Level names are pretty similar though there are important differences.
> > In case of H264 the level is a number consisting of two digits (such as 1.1
> > or 4.0) and level "1b". In case of MPEG4 we have a single digit 0, 1, 2,
> > 3, 4, 5 and 0b and 3b levels.
> 
> You could have a single menu control with different options depending on the
> stream type.
> 
> > > > 13) H264_PROFILE                        E   H264            common
> > > > The profile information for H264.
> > > > 14) MPEG4_PROFILE                       E   MPEG4           common
> > > > The profile information for MPEG4.
> >
> > In case of profiles the naming differs quite a lot. For H264 we have a lot
> > of profiles to choose from
> > (http://en.wikipedia.org/wiki/H.264/MPEG-4_AVC#Profiles). For MPEG4 we
> > have: Simple, Advanced Simple, Core, Simple Scalable and Advanced Coding
> > Efficiency.
> 
> [snip]

I think it seems better that level & profile control are not separated if possible.

> 
> > > > 21) H264_LOOP_FILTER_MODE               E   H264            common
> > > > Loop filter mode for H264.
> > >
> > > There's a DECODER_MPEG4_LOOP_FILTER control. Are they similar ?
> >
> > The difference is that H264_LOOP_FILTER is a control for encoding. It is
> > used during encoding. The encoder set this and a decoder has to obey the
> > setting used to encode that stream. In case of MPEG4 the filter is used
> > for post processing.
> 
> Do those loop filters have a similar purpose, or are they completely
> different
> concepts with a similar name ?
> 
> [snip]
> 

As Kamil's reply, MFC 5.1 provides loop filter for MPEG4 decoding as post filter.

> > > > 24) H264_SYMBOL_MODE                    E   H264            common
> > > > Symbol mode for H264 - CABAC/CAVALC.
> > > > 25) INTERLACE                           E   H264, MPEG4     common
> > > > Enable interlace mode.
> > > > 26) H264_8X8_TRANSFORM                  E   H264            common
> > > > Enable 8X8 transform for H264.
> > > > 27) INTRA_REFRESH_MB                    E   all             common
> > > > Period of random intra macroblock refresh.
> > > > 28) PADDING_ENABLE                      E   all             MFC
> > > > Padding enable - use a color instead of repeating border pixels.
> > > > 29) PADDING_LUMA                        E   all             MFC
> > > > 30) PADDING_CB                          E   all             MFC
> > > > 31) PADDING_CR                          E   all             MFC
> > >
> > > Do we need 3 controls for that, or can we use a single one (similarly to
> > > what
> > > we did with the color key control) ?
> >
> > You mean like the chromakey field here:
> > http://v4l2spec.bytesex.org/spec-single/v4l2.html#V4L2-WINDOW ?
> >
> > For V4L2_PIX_FMT_BGR24 it seems quite reasonable. What about
> > V4L2_PIX_FMT_NV12MT? There are two planes which makes it less obvious.
> > Something like 0xYYCbCr?
> 
> It's less obvious, but it can be defined. Or we could define a COLOR control
> type :-) It would essentially be an integer with a defined way to encode
> colors.
> 
> [snip]
> 

snip...

> > > > 34) FRAME_RATE                          E   all             common
> > > > Frames per second in 1000x scale (e.g., 7500 stands for 7.5
> > > > frames/sec).
> > >
> > > What is this used for ?
> >
> > This is used for encoding rate control. If you want to control the bit rate
> > per second then you need to know how many frames are there per second.
> 
> OK. Does the encoder simply divide the requested bitrate by the frame rate to
> get a bit per frame value, and program the hardware with that, or is it more
> complex ? If it does, we could have a per-frame bitrate instead of a per-
> second bitrate, but that might be confusing.
> 

How about make this control like MPEG4 and integrate one control? (resolution/delta)
Fixed-scale(x1000) method seems like too tightly coupled with MFC.

-----------------------------------------------------------------
50) MPEG4_VOP_TIME_RES                  E   MPEG4           MFC
Used to compute vop_time_increment and modulo_time_base in MPEG4.
51) MPEG4_VOP_FRAME_DELTA               E   MPEG4           MFC
Used to compute vop_time_increment and modulo_time_base in MPEG4.
-----------------------------------------------------------------
->
-----------------------------------------------------------------
50) FRAME_TIME_RES                  	E   all		common
Used to compute vop_time_increment and modulo_time_base in MPEG4
or used to compute frame-rate other standards
51) FRAME_TIME_DELTA               	E   all		common
Used to compute vop_time_increment and modulo_time_base in MPEG4
or used to compute frame-rate other standards
-----------------------------------------------------------------
H264, H263, MPEG4: use as frame-rate (res/delta)
MPEG4: can use as vop_time_* also.

To Laurent,
I have no idea about RC algorithm, but the bit-rate has more
complex relationship with frame-rate.


Best Regards,

Jeong Tae Park
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

