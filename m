Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56342 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbcATHa7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2016 02:30:59 -0500
Subject: Re: V4L2 Colorspace for RGB formats
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
References: <1453226443.5933.7.camel@collabora.com> <569EAF04.802@xs4all.nl>
 <1453244418.5933.55.camel@collabora.com>
Cc: Dimitrios Katsaros <patcherwork@gmail.com>,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569F37AD.9090709@xs4all.nl>
Date: Wed, 20 Jan 2016 08:30:53 +0100
MIME-Version: 1.0
In-Reply-To: <1453244418.5933.55.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2016 12:00 AM, Nicolas Dufresne wrote:
> Le mardi 19 janvier 2016 à 22:47 +0100, Hans Verkuil a écrit :
>> On 01/19/2016 07:00 PM, Nicolas Dufresne wrote:
>>> Hi Hans,
>>>
>>> we are having issues in GStreamer with the colorspace in V4L2. The
>>> API
>>> does not provide any encoding for RGB formats.
>>
>> Which API? GStreamer or V4L2?
>>
>>> The encoding matrix for
>>> those is usually the identity matrix, anything else makes very
>>> little
>>> sense to me.
>>
>> While normally RGB formats use the sRGB colorspace, this is by no
>> means
>> always the case. HDMI for example also supports AdobeRGB and BT2020
>> RGB.
>>
>>> For example, vivid will declare a stream with RGB based
>>> pixel format as having the default for sRGB colorspace, which lead
>>> to
>>> non-identity syCC encoding.
>>
>> I don't follow. sYCC is for YCbCr formats. RGB formats do not contain
>> any
>> information about YCbCr (i.e. the ycbcr_enc field should be ignored).
>>
>> If gstreamer wants to convert RGB formats to YCbCr formats, then it
>> can
>> choose whatever RGB->YCbCr conversion it wants.
>>
>> The colorspace (i.e. the chromaticities), xfer_func and quantization
>> fields
>> as reported by V4L2 are all still valid for RGB pixelformats.
>>
>> You need those as well: take an HDMI receiver that converts Y'CbCr to
>> R'G'B'
>> (let's be precise here and use the quote). If the input is HDTV using
>> Rec.709, then the colorspace is set to V4L2_COLORSPACE_REC709 and the
>> other
>> fields are all 0 (DEFAULT). These map to XFER_FUNC_709 for the
>> transfer
>> function, QUANTIZATION_FULL_RANGE for the quantization and ycbcr_enc
>> is
>> ignored since there is nothing to do here (the Y'CbCr to R'G'B'
>> conversion
>> is already done in hardware using the Rec. 709 Y'CbCr encoding).
>>
>> If you would just ignore all fields and use COLORSPACE_SRGB, then you
>> would be using the wrong transfer function (XFER_FUNC_SRGB instead of
>> XFER_FUNC_709).
>>
>>> Shall we simply ignore the encoding set by drivers when the pixel
>>> format is RGB based ? To me it makes very little sense, but the
>>> code in
>>> GStreamer is very generic and this wrong information lead to errors
>>> when the data is converted to YUV and back to RGB.
>>
>> It seems to me that for RGB formats GStreamer should just set cinfo-
>>> matrix
>> (which I assume is the Y'CbCr to R'G'B' matrix) to the unity matrix
>> and
>> everything else follows the normal rules.
> 
> So you are saying that from V4L2 we may receive weird R'G'B data, like
> one using limited range ?

Yes. That isn't V4L2 specific, it has to do with the HDMI standard.
Actually, the example you gave (limited range RGB) is relatively common
due to the way the HDMI standard is written. It expects that RGB video
using CE timings (e.g. 720p, 1080p) is limited range unless explicitly
signaled that it is full range. It is the cause of massive confusion
and the situation is so bad that we had to add controls to override
the HDMI signaling (http://hverkuil.home.xs4all.nl/spec/media.html#dv-controls,
RX/TX_RGB_RANGE).

> I believe what is hard to understand from
> V4L2 documentation is what transformation is left to be applied before
> this R'G'B frame can be used with other normalized frame (for mixing,
> or display, or anything). Where did the conversion stopped, basically
> what our converter still need to do to get things right.

The colorspace/ycbcr_enc/xfer_func/quantization tell you what you
received. So any mismatches with what you want you will need to
correct in your converter.

This might help:

http://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=qdisp

I'm working on a new utility (in utils/qdisp) that will capture from
a v4l device and output it on the display, doing any necessary conversions
in openGL. It's basically a simplified qv4l2. It's already working, but my
main focus at the moment is to clean up the OpenGL code.

Anyway, it is a good illustration how to handle all the different
colorspace variations. BTW, vivid can generate all combinations of
colorspace/ycbcr_enc/xfer_func/quantization, so that's what I used
to verify all the conversions are correct.

The setV4LFormat() function is used to map DEFAULT values to the
actual values to simplify further processing.

After that it is just a lot of switches to generate the appropriate openGL
code.

Regards,

	Hans

> 
> Nicolas
> 
> p.s. meanwhile we just removed the colorimetry information from non
> Y'CbCr pixel formats, as this brings back the behaviour prior to this.
> 

