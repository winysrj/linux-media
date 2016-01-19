Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:60596 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932787AbcASVry (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 16:47:54 -0500
Subject: Re: V4L2 Colorspace for RGB formats
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
References: <1453226443.5933.7.camel@collabora.com>
Cc: Dimitrios Katsaros <patcherwork@gmail.com>,
	linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569EAF04.802@xs4all.nl>
Date: Tue, 19 Jan 2016 22:47:48 +0100
MIME-Version: 1.0
In-Reply-To: <1453226443.5933.7.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2016 07:00 PM, Nicolas Dufresne wrote:
> Hi Hans,
> 
> we are having issues in GStreamer with the colorspace in V4L2. The API
> does not provide any encoding for RGB formats.

Which API? GStreamer or V4L2?

> The encoding matrix for
> those is usually the identity matrix, anything else makes very little
> sense to me.

While normally RGB formats use the sRGB colorspace, this is by no means
always the case. HDMI for example also supports AdobeRGB and BT2020 RGB.

> For example, vivid will declare a stream with RGB based
> pixel format as having the default for sRGB colorspace, which lead to
> non-identity syCC encoding.

I don't follow. sYCC is for YCbCr formats. RGB formats do not contain any
information about YCbCr (i.e. the ycbcr_enc field should be ignored).

If gstreamer wants to convert RGB formats to YCbCr formats, then it can
choose whatever RGB->YCbCr conversion it wants.

The colorspace (i.e. the chromaticities), xfer_func and quantization fields
as reported by V4L2 are all still valid for RGB pixelformats.

You need those as well: take an HDMI receiver that converts Y'CbCr to R'G'B'
(let's be precise here and use the quote). If the input is HDTV using
Rec.709, then the colorspace is set to V4L2_COLORSPACE_REC709 and the other
fields are all 0 (DEFAULT). These map to XFER_FUNC_709 for the transfer
function, QUANTIZATION_FULL_RANGE for the quantization and ycbcr_enc is
ignored since there is nothing to do here (the Y'CbCr to R'G'B' conversion
is already done in hardware using the Rec. 709 Y'CbCr encoding).

If you would just ignore all fields and use COLORSPACE_SRGB, then you
would be using the wrong transfer function (XFER_FUNC_SRGB instead of
XFER_FUNC_709).

> Shall we simply ignore the encoding set by drivers when the pixel
> format is RGB based ? To me it makes very little sense, but the code in
> GStreamer is very generic and this wrong information lead to errors
> when the data is converted to YUV and back to RGB.

It seems to me that for RGB formats GStreamer should just set cinfo->matrix
(which I assume is the Y'CbCr to R'G'B' matrix) to the unity matrix and
everything else follows the normal rules.

Regards,

	Hans

> https://bugzilla.gnome.org/show_bug.cgi?id=759624
> 
> cheers,
> Nicolas
> 

