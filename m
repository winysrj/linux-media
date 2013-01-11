Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60474 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3AKL0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 06:26:30 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Message-id: <50EFF6E3.4090302@samsung.com>
Date: Fri, 11 Jan 2013 12:26:27 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: =?UTF-8?B?U2ViYXN0aWFuIERyw7ZnZQ==?=
	<sebastian.droege@collabora.co.uk>
Cc: sylvester.nawrocki@gmail.com, LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: FIMC/CAMIF V4L2 driver
References: <1356685333.4296.92.camel@thor.lan> <50EFEBF7.4080801@samsung.com>
 <1357902525.6914.139.camel@thor.lan>
In-reply-to: <1357902525.6914.139.camel@thor.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/11/2013 12:08 PM, Sebastian Dröge wrote:
> I can't test the patch right now but it should do almost the right
> thing. IMHO for the chroma planes the bytesperline should be (width
> +1)/2, otherwise you'll miss one chroma value per line for odd widths.

Odd widths are not allowed, the driver will adjust width to be multiple
of 16 pixels. However, you can adjust the usable area more precisely with
VIDIOC_S_CROP or VIDIOC_S_SELECTION ioctl. I still need to do some work to
define properly the selection ioctl on mem-to-mem devices in the V4L2
documentation.

> However I also noticed another bug. Currently S_FMT happily allows
> V4L2_PIX_FMT_BGR32, V4L2_PIX_FMT_BGR24, V4L2_PIX_FMT_RGB24 and probably
> others. But the output will be distorted and useless.
> (V4L2_PIX_FMT_RGB32 works perfectly fine)

This shouldn't really happen. Are you checking pixelformat after VIDIOC_S_FMT
call ? Isn't it adjusted to some valid and supported by the driver format ?

--

Regards,
Sylwester

