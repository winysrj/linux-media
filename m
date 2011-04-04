Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56128 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab1DDOuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 10:50:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC] New controls for codec devices
Date: Mon, 4 Apr 2011 16:50:30 +0200
Cc: linux-media@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	jaeryul.oh@samsung.com, hansverk@cisco.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF3619110DAD1E@bssrvexch01> <201104011200.51712.laurent.pinchart@ideasonboard.com> <002101cbf082$daa237b0$8fe6a710$%debski@samsung.com>
In-Reply-To: <002101cbf082$daa237b0$8fe6a710$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104041650.30819.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kamil,

On Friday 01 April 2011 17:38:26 Kamil Debski wrote:
> > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > On Tuesday 29 March 2011 11:48:03 Kamil Debski wrote:

[snip]

> > >  2) DECODER_SLICE_INTERFACE             D   all             common
> > > 
> > > If set the decoder can accept separate picture slices on input,
> > > otherwise it requires a whole frame.
> > 
> > Isn't that a property instead of a settable control ? I'm not sure to
> > understand why applications would need to tell the decoder what it can
> > accept. Or is it supposed to be a read-only control ?
> 
> I think I have not described this control properly. It is used by the
> application to set what kind of buffer it will send to the driver.
> 
> A picture can consist of one or more slice. Our hardware can accept two
> kinds of input buffers and its behavior is determined by a register. So it
> is a read/write control.  In the first case, a single input buffer contains
> a whole picture (one or more slices). In the second case, a single input
> buffer contains a single slice.
> 
> A nice figure describing pictures and slices can be found here:
> http://goo.gl/info/bnFe2

OK I understand it better now.

Is this configurable at runtime for each buffer, or is it a decoder 
configuration that must be set before the start of the stream ?

> > >  3) DECODER_H264_DISPLAY_DELAY          D   H264            MFC
> > > 
> > > Programmable display delay for H264. MFC will return a decoded frame
> > > after the set number of frames (this may cause that frames are not
> > > returned in display order).
> > > 
> > >  4) DECODER_H264_DISPLAY_DELAY_ENABLE   D   H264            MFC
> > > 
> > > Enable display delay for H264.
> > 
> > Can't display delay enable/disable be controlled through the
> > DECODER_H264_DISPLAY_DELAY control ? A zero value would mean no display
> > delay.
> 
> Firstly I have had the same idea as you have proposed. But in this case
> zero value is meaningful. If display delay is disabled then it is up to
> the decoder to determine how many OUTPUT buffers will it process before a
> buffer on the CAPTURE is dequeued. This is influenced by the number of B
> frames and how many reference frames are used by P and B frames. This
> ensures that after the CAPTURE buffer is dequeued it won't be used by the
> hardware.
> 
> If the display delay is enabled then the decoder has to return an CAPTURE
> buffer after processing a certain number of OUTPUT buffers. If this number
> is low, then it may result in buffers not being dequeued in display order.
> 
> Even worse, I have just discovered that the buffer can still be used by the
> hardware as a reference after it has been dequeued in case of low display
> delay. So I think that this feature is very specific to our hardware (thus
> I think it should be hw specific control) and application has to be aware
> of this.

If I understand this correctly, drivers need to reference CAPTURE buffers 
(containing decoded images) for some time to decode P and B frames. The 
default behaviour is to return a buffer to userspace only when the buffer 
isn't needed by the driver anymore. This behaviour can be overridden using the 
display delay control to return CAPTURE buffers sooner, making it possible to 
display frames without an additional delay.

If applications need to write to the buffers, they can't use that feature. 
Otherwise, why shouldn't drivers always return frames to userspace ASAP ? We 
would then need a single control to tell the driver whether the application 
wants to write to the buffers (in which case they won't be dequeued until the 
driver doesn't need them anymore), or only wants to read from them (in which 
case the driver will dequeued them ASAP).

> > What is the display delay used for ?
> 
> As described above - it is used to force hardware to return an CAPTURE
> buffer after a set number or OUTPUT buffers was processed.
> 
> > > *** Controls for both decoding and encoding ***
> > > 
> > >  5) H264_AR_VUI_IDC                     A   H264            common
> > > 
> > > VUI aspect ratio IDC for H.264 encoding.  The value is defined in VUI
> > 
> > Table
> > 
> > > E-1 in the standard.
> > > 
> > >  6) H264_EXT_SAR_WIDTH                  A   H264            common
> > > 
> > > Extended sample aspect ratio width for H.264 VUI encoding.
> > > 
> > >  7) H264_EXT_SAR_HEIGHT                 A   H264            common
> > > 
> > > Extended sample aspect ratio height for H.264 VUI encoding
> > 
> > What are those 3 controls used for when decoding ?
> 
> While encoding it is used to set the aspect ratio indicator in the VUI.
> During decoding it is used to read such information.
> 
> Maybe a better name would be H264_VUI_(AR_IDC, EXT_SAR_WIDTH,
> EXT_SAR_HEIGHT).

So they're used to read/write information about the encoded stream.

I wonder whether we should create an ioctl to get/set an MPEG information 
block.

> > >  8) MIN_REQ_BUFS_OUT                    A   all             common
> > > 
> > > This is the minimum number of buffers required for the output queue.
> > > This option may be useful if the encoding settings require a minimum
> > > number of buffers required as reference and the application would like
> > > to have N more buffers. For example - the encoding options require 3
> > > buffers and the application wants to have 2 more. One can read this
> > > value (3) and supply (3+2) to the reqbufs call.
> > > 
> > >  9) MIN_REQ_BUFS_CAP                    A   all             common
> > > 
> > > This is the minimum number of buffers required for the capture queue.
> > > This option may be useful if the decoder requires a minimum number of
> > > buffers required as reference and the application would like to have N
> > > more buffers. For example - the stream requires 3 buffers and the
> > > application wants to have 2 more. One can read this value (3) and
> > > supply (3+2) to the reqbufs call.
> > 
> > Are these 2 read-only controls ?
> 
> Yes they are read only.

This feature is useful for non-codec devices as well, should it be a standard 
control usable by other drivers ?

> > > *** Controls for encoding ***
> > > 10) GOP_SIZE                            E   all             common
> > > The size of group of pictures. For H264 this is the IDR period.
> > > 11) H264_LEVEL                          E   H264            common
> > > The level information for H264.
> > > 12) MPEG4_LEVEL                         E   MPEG4           common
> > > The level information for MPEG4.
> > 
> > Do those need to be separate controls ?
> 
> I've been thinking hard about this for some time. My first thought was to
> have a single control. On second thought I have decided to have them
> separate.
> 
> Level names are pretty similar though there are important differences.
> In case of H264 the level is a number consisting of two digits (such as 1.1
> or 4.0) and level "1b". In case of MPEG4 we have a single digit 0, 1, 2,
> 3, 4, 5 and 0b and 3b levels.

You could have a single menu control with different options depending on the 
stream type.

> > > 13) H264_PROFILE                        E   H264            common
> > > The profile information for H264.
> > > 14) MPEG4_PROFILE                       E   MPEG4           common
> > > The profile information for MPEG4.
> 
> In case of profiles the naming differs quite a lot. For H264 we have a lot
> of profiles to choose from
> (http://en.wikipedia.org/wiki/H.264/MPEG-4_AVC#Profiles). For MPEG4 we
> have: Simple, Advanced Simple, Core, Simple Scalable and Advanced Coding
> Efficiency.

[snip]

> > > 21) H264_LOOP_FILTER_MODE               E   H264            common
> > > Loop filter mode for H264.
> > 
> > There's a DECODER_MPEG4_LOOP_FILTER control. Are they similar ?
> 
> The difference is that H264_LOOP_FILTER is a control for encoding. It is
> used during encoding. The encoder set this and a decoder has to obey the
> setting used to encode that stream. In case of MPEG4 the filter is used
> for post processing.

Do those loop filters have a similar purpose, or are they completely different 
concepts with a similar name ?

[snip]

> > > 24) H264_SYMBOL_MODE                    E   H264            common
> > > Symbol mode for H264 - CABAC/CAVALC.
> > > 25) INTERLACE                           E   H264, MPEG4     common
> > > Enable interlace mode.
> > > 26) H264_8X8_TRANSFORM                  E   H264            common
> > > Enable 8X8 transform for H264.
> > > 27) INTRA_REFRESH_MB                    E   all             common
> > > Period of random intra macroblock refresh.
> > > 28) PADDING_ENABLE                      E   all             MFC
> > > Padding enable - use a color instead of repeating border pixels.
> > > 29) PADDING_LUMA                        E   all             MFC
> > > 30) PADDING_CB                          E   all             MFC
> > > 31) PADDING_CR                          E   all             MFC
> > 
> > Do we need 3 controls for that, or can we use a single one (similarly to
> > what
> > we did with the color key control) ?
> 
> You mean like the chromakey field here:
> http://v4l2spec.bytesex.org/spec-single/v4l2.html#V4L2-WINDOW ?
> 
> For V4L2_PIX_FMT_BGR24 it seems quite reasonable. What about
> V4L2_PIX_FMT_NV12MT? There are two planes which makes it less obvious.
> Something like 0xYYCbCr?

It's less obvious, but it can be defined. Or we could define a COLOR control 
type :-) It would essentially be an integer with a defined way to encode 
colors.

[snip]

> > > 34) FRAME_RATE                          E   all             common
> > > Frames per second in 1000x scale (e.g., 7500 stands for 7.5
> > > frames/sec).
> > 
> > What is this used for ?
> 
> This is used for encoding rate control. If you want to control the bit rate
> per second then you need to know how many frames are there per second.

OK. Does the encoder simply divide the requested bitrate by the frame rate to 
get a bit per frame value, and program the hardware with that, or is it more 
complex ? If it does, we could have a per-frame bitrate instead of a per-
second bitrate, but that might be confusing.

-- 
Regards,

Laurent Pinchart
