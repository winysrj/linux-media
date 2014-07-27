Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2077 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaG0SWU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 14:22:20 -0400
Message-ID: <53D54338.9090707@xs4all.nl>
Date: Sun, 27 Jul 2014 20:21:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.co.uk>,
	Philipp Zabel <philipp.zabel@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 2/3] [media] coda: fix coda_g_selection
References: <69ab-53d52e80-1-565f8200@126846484>
In-Reply-To: <69ab-53d52e80-1-565f8200@126846484>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/27/2014 06:53 PM, Nicolas Dufresne wrote:
>  
> Le Samedi 26 Juillet 2014 12:37 EDT, Philipp Zabel <philipp.zabel@gmail.com> a écrit: 
> 
>> I have tried the GStreamer v4l2videodec element with the coda driver and
>> noticed that GStreamer calls VIDIOC_CROPCAP to obtain the pixel aspect
>> ratio. This always fails with -EINVAL because of this issue. Currently GStreamer
>> throws a warning if the return value is an error other than -ENOTTY.
> 
> But for now, this seems like a fair thing to do. We currently assume that if your
> driver is not implementing CROPCAP, then pixel aspect ratio at output will be
> unchanged at capture. If there is an error though, it's not good sign, and we report
> it. If that is wrong, let us know why and how to detect your driver error isn't a an error.

If cropcap returns -EINVAL then that means that the current input or output does
not support cropping (for input) or composing (for output). In that case the
pixel aspect ratio is undefined and you have no way to get hold of that information,
which is a bug in the V4L2 API.

In the case of an m2m device you can safely assume that whatever the pixel aspect
is of the image you give to the m2m device, it will still be the same pixel
aspect when you get it back. In fact, I would say that if an m2m device returns
cropcap information, then the pixel aspect ratio information is most likely not
applicable to the device and will typically be 1:1.

Pixel aspect ratio is only relevant if the video comes in or goes out to a physical
interface (sensor, video receiver/transmitter).

Regards,

	Hans
