Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41810 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaG1J2z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 05:28:55 -0400
Message-ID: <1406539725.25461.21.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 2/3] [media] coda: fix coda_g_selection
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.co.uk>,
	Philipp Zabel <philipp.zabel@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Sascha Hauer <kernel@pengutronix.de>
Date: Mon, 28 Jul 2014 11:28:45 +0200
In-Reply-To: <53D57BC3.9060205@xs4all.nl>
References: <69ab-53d52e80-1-565f8200@126846484>
		 <53D54338.9090707@xs4all.nl> <1406496776.2628.1.camel@mpb-nicolas>
	 <53D57BC3.9060205@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 28.07.2014, 00:22 +0200 schrieb Hans Verkuil:
> On 07/27/2014 11:32 PM, Nicolas Dufresne wrote:
> > Le dimanche 27 juillet 2014 à 20:21 +0200, Hans Verkuil a écrit :
> >> If cropcap returns -EINVAL then that means that the current input or
> >> output does
> >> not support cropping (for input) or composing (for output). In that case the
> >> pixel aspect ratio is undefined and you have no way to get hold of that information,
> >> which is a bug in the V4L2 API.
> >>
> >> In the case of an m2m device you can safely assume that whatever the pixel aspect
> >> is of the image you give to the m2m device, it will still be the same pixel
> >> aspect when you get it back. In fact, I would say that if an m2m device returns
> >> cropcap information, then the pixel aspect ratio information is most likely not
> >> applicable to the device and will typically be 1:1.
> >>
> >> Pixel aspect ratio is only relevant if the video comes in or goes out to a physical
> >> interface (sensor, video receiver/transmitter).
> > 
> > So far "not applicable" has been interpreted as not implemented /
> > ENOTTY. Can't CODA just do that and we can close this subject ?
> 
> Yes, that might be the best solution. Just call v4l2_disable_ioctl for CROPCAP and
> G/S_CROP, since none of them apply to the coda driver.

Sounds like a plan, I'll do that.

thanks
Philipp

