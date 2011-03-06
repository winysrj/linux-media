Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57612 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592Ab1CFRzD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Mar 2011 12:55:03 -0500
Subject: Re: [Query] What is the best way to handle V4L2_PIX_FMT_NV12
 buffers?
From: Andy Walls <awalls@md.metrocast.net>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <A24693684029E5489D1D202277BE89448861F7E6@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE89448861F7E6@dlee02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 12:55:24 -0500
Message-ID: <1299434124.2310.12.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-03-05 at 22:49 -0600, Aguirre, Sergio wrote:
> Hi,
> 
> I was curious in how to handle properly buffers of pixelformat V4L2_PIX_FMT_NV12.
> 
> I see that the standard convention for determining a bytesize of an image buffer is:
> 
> bytesperline * height
> 
> However, for NV12 case, the bytes per line is equal to the width, _but_ the actual buffer size is:
> 
> For the Y buffer: width * height
> For the UV buffer: width * (height / 2)
> Total size = width * (height + height / 2)
> 
> Which I think renders the bytesperline * height formula not valid for this case.
> 
> Any ideas how this should be properly handled?

For the HM12 macroblock format:

http://git.linuxtv.org/media_tree.git?a=blob;f=Documentation/video4linux/cx2341x/README.hm12;h=b36148ea07501bdac37ae74b31cc258150f75a81;hb=staging/for_v2.6.39

ivtv and cx18 do this in cx18-ioctl.c and ivtv-ioctl.c:

...
	if (id->type == xxxx_ENC_STREAM_TYPE_YUV) {
                pixfmt->pixelformat = V4L2_PIX_FMT_HM12;
                /* YUV size is (Y=(h*720) + UV=(h*(720/2))) */
                pixfmt->sizeimage = pixfmt->height * 720 * 3 / 2;
                pixfmt->bytesperline = 720;
	}
...

Note that the wdith is fixed at 720 because the CX2341x chips always
build HM12 planes assuming a width of 720, even though it isn't going to
actually fill in the off-sceen pixels for widths less than 720.


Note that "pixfmt->height * 3 / 2" is just "(height + height / 2)".

It's not a definitive answer; only an example of what two drivers do for
a very uncommon macroblock format.

Regards,
Andy

> NOTE: See here for more details: http://www.fourcc.org/yuv.php#NV12
> 
> Regards,
> Sergio--


