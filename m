Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56049 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1KZU7U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 15:59:20 -0500
Received: by bke11 with SMTP id 11so6124482bke.19
        for <linux-media@vger.kernel.org>; Sat, 26 Nov 2011 12:59:18 -0800 (PST)
Message-ID: <4ED15324.9040805@gmail.com>
Date: Sat, 26 Nov 2011 21:59:16 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: [RFC] JPEG encoders control class
References: <4EBECD11.8090709@gmail.com> <20111126184323.GD29805@valkosipuli.localdomain>
In-Reply-To: <20111126184323.GD29805@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 11/26/2011 07:43 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> Thanks for the RFC. I originally missed it; thanks for pointing to it!

Thanks for your comments!

> 
> On Sat, Nov 12, 2011 at 08:46:25PM +0100, Sylwester Nawrocki wrote:
>> Hi all,
>>
>> This RFC is discussing the current support of JPEG encoders in V4L2 and
>> a proposal of new JPEG control class.
>>
...
>>
>> The following is an initial draft of the new control class
>>
>> o V4L2_CTRL_CLASS_JPEG
>>
>> As not everything might be covered by the controls (the application data and comment
>> segments, quantization and Huffman tables, etc.) the control class should probably
>> just complement VIDIOC_[G/S]_JPEGCOMP ioctls, rather than entirely replacing them.
> 
> I wonder if there would be enough benefits in having blob controls. The
> challenge is how to describe the format of the data in a standard and
> flexible way and also what those bits actually signify. We will have lots of
> table format data when the image processing functionality (much of which is
> hardware-dependent) in ISPs get better supported.

If the table data is parametrized and the parameters are not inside the table
then it's indeed not an easy task to provide a generic meta-data format.
 
In case of JPEG the format of tables/markers/segments is well defined and 
AFAICT single binary blob ID and its length might be all what's needed
for the applications and drivers to interpret the data.

> 
> FYI: you have over 80 characters per line. It's hard to read without
> rewrapping.

Ups, sorry. I have just turned off word wrapping in Thunderbird completely 
as it was extremely annoying and I've lost a bit the 80-character sense :/  
Thank you for the notice.

> 
>> Proposed controls
>> =================
>>
>> 1. Chroma sub-sampling
>> ---------------------
>>
>> The subsampling factors describe how each component of an input image is sampled,
>> in respect to maximum sample rate in each spatial dimension.
>> More general description can be found in [2], clause A.1.1., "Dimensions and
>> sampling factors".
>>
>> The chroma subsampling would describe how Cb, Cr components should be downsampled
>> after converting an input image from RGB to Y'CbCr color space.
>>
>> o V4L2_CID_JPEG_CHROMA_SUBSAMPLING
>>
>>    - V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY - only luminance component is present,
>>    - V4L2_JPEG_CHROMA_SUBSAMPLING_410  - subsample Cr, Cb signals horizontally by
>>                                          4 and vertically by 2
>>    - V4L2_JPEG_CHROMA_SUBSAMPLING_411  - horizontally subsample Cr, Cb signals by
>>                                          a factor of 4
>>    - V4L2_JPEG_CHROMA_SUBSAMPLING_420  - subsample Cr, Cb signals horizontally and
>>                                          vertically by 2
>>    - V4L2_JPEG_CHROMA_SUBSAMPLING_422  - horizontally subsample Cr, Cb signals by
>>                                          a factor of 2,
>>    - V4L2_JPEG_CHROMA_SUBSAMPLING_444  - no chroma subsampling, each pixel has Y,
>>                                          Cr and Cb values.
>>
>> Using no subsampling produces sharper colours, even with higher compression
>> (in order to achieve similar file size) [7], thus it seems important to provide
>> the user with a method of precise subsampling control.
>>
>>
>> 2. Restart interval (DRI)
>> -----------------------
>>
>> o V4L2_CID_JPEG_RESTART_INTERVAL
>>
>> The restart interval (DRI marker) determines the interval of inserting RSTm
>> markers. The purpose of RSTm markers is to additionally reinitialize decoder
>> process' predictor with initial default value. For lossy compression processes
>> the restart interval is expressed in MCU (Minimm Coded Unit).
>> If restart interval value is 0 DRI and RSTm (m = 0..7) markers will not be
>> inserted. Consequently this control would make current V4L2_JPEG_MARKER_DRI
>> markers flag redundant. This control would be useful for S5P JPEG IP block [6].
>>
>>
>> 3. Image quality
>> ----------------
>>
>> o V4L2_CID_JPEG_QUALITY	
>>
>> Image quality is not defined in the standard but it is used as an intermediate
>> parameter by many encoders to control set of encoding parameters, which then
>> allow to obtain certain image quality and corresponding file size.
>> IMHO it makes sense to add the quality control to the JPEG class as it's widely
>> used, not only for webcams.
>>
>> As far as the value range is concerned, probably it's better to leave this driver
>> specific. The applications would then be more aware of what is supported by
>> a device (min, max, step) and they could translate driver specific range into
>> standardised values (0..100) if needed. Still the drivers could do the translation
>> themselves if required. The specification would only say the 0..100 range is
>> recommended.
> 
> I think it's best to leave this hardware specific. Granularity might matter
> sometimes in the user space. As the step is enforced (which is correct), it
> may be impossible to support the span 0--100 with desired granularity.

Agreed. So we leave it hardware specific, deferring the translation to 0..100
range to the applications.

> 
>> 4. JPEG markers presence
>> ------------------------
>>
>> Markers serve as identifiers of various structural parts of compressed data
>> formats. All markers are assigned two-byte codes: an 0xFF byte followed by
>> a byte which is not equal to 0 or 0xFF. [2] Excluding the reserved ones there
>> is 39 valid codes.
>>
>> I'm not really sure how the markers inhibit feature is useful, but since some
>> drivers use it let's assume it is needed. Likely a 32-bit bitmask control could
>> be used for activating/deactivating markers, as it doesn't make sense for some
>> of markers to be freely discarded from the compressed data.
>>
>> o V4L2_CID_JPEG_ACTIVE_MARKERS
>>
>> Following markers might be covered by this control, listed in Table E.1, [2]:
>> APP0..15, COM, DHT, DQT, DAC and additionally DNL.
>> There is still room for 10 additional markers which might be added if required.
>>
>>
>> The above list of controls is most likely not exhaustive, it's just an attempt
>> to cover features available in the mainline drivers and the S5P SoC JPEG codec
>> IP block [6].
>>
>> In order to support reconfiguration of quantization and Huffman tables the
>> VIDIOC_[G/S]_JPEGCOMP probably need to be re-designed, but it's out of scope
>> of this RFC.
> 
> Is this something that a regular user might typically want to do?

I don't think so. It would be rather an interface for libraries, since this is 
more or less hardware specific data.

> 
> Also, if you keep adding more functionality to a single structure like that
> it forces user to get all the other parameters (s)he doesn't want to change
> before issuing the set operation. I don't particularly like that idea.

Agreed. I thought about making the ioctl more v4l2 control like, i.e. make
it handle one data segment at time, with an ID field at the data structure 
indicating what standard data segment type is handled. Something like this 
could be possibly covered by a binary blob controls, if such have existed.

--
Thanks,
Sylwester
