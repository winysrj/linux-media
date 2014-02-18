Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33060 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbaBRPC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 10:02:27 -0500
Message-ID: <1392735739.3606.48.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 0/3] uvcvideo VIDIOC_CREATE_BUFS support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Date: Tue, 18 Feb 2014 16:02:19 +0100
In-Reply-To: <1392733669-5281-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392733669-5281-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Dienstag, den 18.02.2014, 15:27 +0100 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Here's a patch set that enables VIDIOC_CREATE_BUFS support in the uvcvideo
> driver. It's based on the patch you've submitted (3/3), with two additional
> cleanup patches to simplify the queue_setup implementation and supporting
> allocation of buffers larger than the current frame size.
> 
> As you've submitted patch 3/3 I assume you have a use case, could you then
> please test the patch set to make sure 1/3 and 2/3 don't break anything ?

Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

Using a Logitech C920 UVC camera connected to i.MX6 SabreLite running
GStreamer 1.2.3:

gst-launch-1.0 v4l2src device=/dev/video8 \
	! image/jpeg,width=1280,height=720
	! queue max-size-buffers=5 min-threshold-buffers=5 \
	! rtpjpegpay ! udpsink host=... port=...

regards
Philipp

