Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32181 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3AKKjy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 05:39:54 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Message-id: <50EFEBF7.4080801@samsung.com>
Date: Fri, 11 Jan 2013 11:39:51 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: =?UTF-8?B?U2ViYXN0aWFuIERyw7ZnZQ==?= <slomo@circular-chaos.org>
Cc: sylvester.nawrocki@gmail.com, LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: FIMC/CAMIF V4L2 driver
References: <1356685333.4296.92.camel@thor.lan>
In-reply-to: <1356685333.4296.92.camel@thor.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Cc: <linux-media@vger.kernel.org>

On 12/28/2012 10:02 AM, Sebastian Dröge wrote:
> Hi Sylwester,
> 
> Kamil Debski told me that you should be able to help me with any issues
> about the FIMC/CAMIF V4L2 driver. I'm currently using it on Exynos 4
> hardware and wrote a GStreamer plugin using it (and the MFC driver).
> 
> So far everything works great but I found a bug in the driver. When
> configuring the CAPTURE side to use the pixel format
> V4L2_PIX_FMT_YUV420M the strides that are reported are wrong.
> 
> I get them by setting a v4l2_format with VIDIOC_S_FMT and having the
> fmt.pix_mp.plane_fmt[X].bytesperline set to zero. The value set there
> after the ioctl is correct for the luma plane but has the same value for
> the chroma planes while it should be the half.
> By using a stride that is half the value I can get valid and usable
> output.
> 
> For V4L2_PIX_FMT_NV12MT and V4L2_PIX_FMT_NV12M these stride values are
> correct, so maybe a check for V4L2_PIX_FMT_YUV420M is missing somewhere
> to divide by two for the chroma planes.

Thank you for the bug report. And sorry for the delay..

The driver sets same bytesperline value for each plane, since I found
definition of this parameter very vague for planar formats, especially
the macro-block ones, e.g. [1]. So it's really a feature, not a bug ;)

Nevertheless, what the documentation [2] says is:

"\bytesperline\    Distance in bytes between the leftmost pixels in two
adjacent lines."
...

"When the image format is planar the bytesperline value applies to the
largest plane and is divided by the same factor as the width field for
any smaller planes. For example the Cb and Cr planes of a YUV 4:2:0 image
have half as many padding bytes following each line as the Y plane. To
avoid ambiguities drivers must return a bytesperline value rounded up to
a multiple of the scale factor."

Then, for V4L2_PIX_FMT_NV12M format bytesperline for both planes should be
same, since according to the format definition chroma and luma plane width
are same.

For V4L2_PIX_FMT_YUV420M the Cr and Cb plane is half the width and half
the height of the image (Y plane). I agree the bytesperline of the chroma
should be half of that of luma plane.

Please let me know if this patch helps:
http://patchwork.linuxtv.org/patch/16205

If it's OK then I'll submit it for v3.9 kernel.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/re31.html
[2] http://linuxtv.org/downloads/v4l-dvb-apis/pixfmt.html#v4l2-pix-format

--

Regards,
Sylwester
