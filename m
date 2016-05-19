Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58555 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679AbcESN0A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 09:26:00 -0400
Message-ID: <1463664351.2988.47.camel@pengutronix.de>
Subject: Re: gstreamer: v4l2videodec plugin
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>, ayaka <ayaka@soulik.info>
Date: Thu, 19 May 2016 15:25:51 +0200
In-Reply-To: <5737151F.2090201@linaro.org>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
	 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
	 <1460476636.2842.10.camel@collabora.com> <5735941E.6020703@mm-sol.com>
	 <1463223553.4185.3.camel@collabora.com> <5737151F.2090201@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 14.05.2016, 15:07 +0300 schrieb Stanimir Varbanov:
[...]
> > While I got you. I would be very interested to know who QCOM driver
> > interpreted the width and height expose on capture side of the decoder.
> > I'm adding Philippe Zabel in CC here (he's maintaining the
> > CODA/Freescale decoder). In Samsung MFC driver, the width and height
> > expose by the driver is the display size. Though, recently, Philippe is
> > reporting that his driver is exposing the coded size. Fixing one in
> > GStreamer will break the other, so I was wondering what other drivers
> > are doing.
> 
> In qcom driver s_fmt on capture queue will return bigger or the same as
> coded resolution depending on the width/height. This is related to hw
> alignment restrictions i.e 1280x720 on output queue will become 1280x736
> on capture queue. The the userspace can/must call g_crop to receive the
> active resolution for displaying.

Since in that case the input video is nominally 1280x720, and we are not
cropping away anything from that, this shouldn't use G_CROP (which maps
to G_SELECTION with V4L2_SEL_TGT_CROP_ACTIVE), but G_SELECTION with
V4L2_SEL_TGT_COMPOSE_DEFAULT on the capture queue.

For mem2mem devices, cropping should happen at the output queue, and
composing at the capture queue. For devices that don't scale, such as
decoders, the output crop rectangle should have the same size as the
capture compose rectangle.

Is there any reason not to update the MFC driver to use G_SELECTION? The
g_crop implementation could be kept for backwards compatibility.

regards
Philipp

