Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42276 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1K1MvJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 07:51:09 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVD006CUFP79E@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Nov 2011 12:51:07 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVD00MXGFP6W2@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Nov 2011 12:51:07 +0000 (GMT)
Date: Mon, 28 Nov 2011 13:51:06 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC] JPEG encoders control class
In-reply-to: <201111281320.30522.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Message-id: <4ED383BA.5050302@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4EBECD11.8090709@gmail.com> <201111281320.30522.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/28/2011 01:20 PM, Hans Verkuil wrote:
> On Saturday 12 November 2011 20:46:25 Sylwester Nawrocki wrote:
>> Hi all,
>>
>> This RFC is discussing the current support of JPEG encoders in V4L2 and
>> a proposal of new JPEG control class.
...
>>
>> et61x251, sn9c102, s2255drv.c
>> -----------------------------
> 
> Note that et61x251 and sn9c102 are going to be deprecated and removed at some
> time in the future (gspca will support these devices).

Ok, thanks for the update.

...
>> The following is an initial draft of the new control class
>>
>> o V4L2_CTRL_CLASS_JPEG
>>
>> As not everything might be covered by the controls (the application data
>> and comment segments, quantization and Huffman tables, etc.) the control
>> class should probably just complement VIDIOC_[G/S]_JPEGCOMP ioctls, rather
>> than entirely replacing them.
>>
>>
>> Proposed controls
>> =================
>>
>> 1. Chroma sub-sampling
>> ---------------------
>>
>> The subsampling factors describe how each component of an input image is
>> sampled, in respect to maximum sample rate in each spatial dimension.
>> More general description can be found in [2], clause A.1.1., "Dimensions
>> and sampling factors".
>>
>> The chroma subsampling would describe how Cb, Cr components should be
>> downsampled after coverting an input image from RGB to Y'CbCr color space.
>>
>> o V4L2_CID_JPEG_CHROMA_SUBSAMPLING
>>
>>   - V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY - only luminance component is
>> present, - V4L2_JPEG_CHROMA_SUBSAMPLING_410  - subsample Cr, Cb signals
>> horizontally by 4 and vertically by 2
>>   - V4L2_JPEG_CHROMA_SUBSAMPLING_411  - horizontally subsample Cr, Cb
>> signals by a factor of 4
>>   - V4L2_JPEG_CHROMA_SUBSAMPLING_420  - subsample Cr, Cb signals
>> horizontally and vertically by 2
>>   - V4L2_JPEG_CHROMA_SUBSAMPLING_422  - horizontally subsample Cr, Cb
>> signals by a factor of 2,
>>   - V4L2_JPEG_CHROMA_SUBSAMPLING_444  - no chroma subsampling, each pixel
>> has Y, Cr and Cb values.
>>
>> Using no subsampling produces sharper colours, even with higher compression
>> (in order to achieve similar file size) [7], thus it seems important to
>> provide the user with a method of precise subsampling control.
>>
>>
>> 2. Restart interval (DRI)
>> -----------------------
>>
>> o V4L2_CID_JPEG_RESTART_INTERVAL
>>
>> The restart interval (DRI marker) determines the interval of inserting RSTm
>> markers. The purpose of RSTm markers is to additionally reinitialize
>> decoder process' predictor with initial default value. For lossy
>> compression processes the restart interval is expressed in MCU (Minimm
>> Coded Unit).
>> If restart interval value is 0 DRI and RSTm (m = 0..7) markers will not be
>> inserted. Consequently this control would make current V4L2_JPEG_MARKER_DRI
>> markers flag redundant. This control would be useful for S5P JPEG IP block
>> [6].
>>
>>
>> 3. Image quality
>> ----------------
>>
>> o V4L2_CID_JPEG_QUALITY
>>
>> Image quality is not defined in the standard but it is used as an
>> intermediate parameter by many encoders to control set of encoding
>> parameters, which then allow to obtain certain image quality and
>> corresponding file size. IMHO it makes sense to add the quality control to
>> the JPEG class as it's widely used, not only for webcams.
>>
>> As far as the value range is concerned, probably it's better to leave this
>> driver specific. The applications would then be more aware of what is
>> supported by a device (min, max, step) and they could translate driver
>> specific range into standardised values (0..100) if needed. Still the
>> drivers could do the translation themselves if required. The specification
>> would only say the 0..100 range is recommended.
> 
> It should also say that higher numbers must represent better quality.

ok, certainly it's a good idea to state it explicitly. I seem to have
forgotten to write it down.

> 
>>
>> 4. JPEG markers presence
>> ------------------------
>>
>> Markers serve as identifiers of various structural parts of compressed data
>> formats. All markers are assigned two-byte codes: an 0xFF byte followed by
>> a byte which is not equal to 0 or 0xFF. [2] Excluding the reserved ones
>> there is 39 valid codes.
>>
>> I'm not really sure how the markers inhibit feature is useful, but since
>> some drivers use it let's assume it is needed. Likely a 32-bit bitmask
>> control could be used for activating/deactivating markers, as it doesn't
>> make sense for some of markers to be freely discarded from the compressed
>> data.
>>
>> o V4L2_CID_JPEG_ACTIVE_MARKERS
>>
>> Following markers might be covered by this control, listed in Table E.1,
>> [2]: APP0..15, COM, DHT, DQT, DAC and additionally DNL.
>> There is still room for 10 additional markers which might be added if
>> required.
> 
> Are there limitation on the contents of the COM field? I.e., can it contain
> '\0' values? If not, then it can perhaps be represented by a string control.

There is no limitation, valid values for each comment byte are 0..255, and
the standard (B.2.4.5, p.43, [2]) says "the interpretation is left to the
application".

Thus unfortunately the string control cannot be used here.

> 
>>
>> The above list of controls is most likely not exhaustive, it's just an
>> attempt to cover features available in the mainline drivers and the S5P
>> SoC JPEG codec IP block [6].
>>
>> In order to support reconfiguration of quantization and Huffman tables the
>> VIDIOC_[G/S]_JPEGCOMP probably need to be re-designed, but it's out of
>> scope of this RFC.
> 
> Overall I'm pleased to see this RFC. The JPEGCOMP ioctls are poorly designed
> and having a well-designed replacement is long overdue.

Thanks, at least the first step is already done:)

> 
> Regards,
> 
> 	Hans
> 
>>
>>
>> References
>> ==========
>>
>> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg01783.html
>>
>> [2] http://www.w3.org/Graphics/JPEG/itu-t81.pdf
>>
>> [3] http://www.w3.org/Graphics/JPEG/jfif3.pdf
>>
>> [4] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-jpegcomp.html
>>
>> [5] http://www.mail-archive.com/linux-media@vger.kernel.org/msg01784.html
>>
>> [6] http://patchwork.linuxtv.org/patch/8197
>>
>> [7] http://www.ampsoft.net/webdesign-l/jpeg-compression.html

--

Thanks,
Sylwester
