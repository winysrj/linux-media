Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60541 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaFXPNT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 11:13:19 -0400
Message-ID: <1403622788.2910.35.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 08/30] [media] coda: add support for frame size
 enumeration
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Date: Tue, 24 Jun 2014 17:13:08 +0200
In-Reply-To: <539EA5EF.1000407@xs4all.nl>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
	 <1402675736-15379-9-git-send-email-p.zabel@pengutronix.de>
	 <539EA5EF.1000407@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 16.06.2014, 10:08 +0200 schrieb Hans Verkuil:
> On 06/13/2014 06:08 PM, Philipp Zabel wrote:
> > This patch adds support for the VIDIOC_ENUM_FRAMESIZES ioctl.
> > When decoding H.264, the output frame size is rounded up to the
> > next multiple of the macroblock size (16 pixels).
> 
> Why do you need this? Implementing VIDIOC_ENUM_FRAMESIZES for a m2m device
> seems odd.

As soon as the OUTPUT side starts streaming, the possible buffer
dimensions on the CAPTURE side are fixed, but not necessarily the same
as on the OUTPUT side. Since GStreamer checks ENUM_FRAMESIZES before
trying to find the possible min/max dimensions via TRY_FMT, I just
implemented that.
Right now I could (and probably should) also implement this using just
TRY_FMT, but the JPEG decoder will also support decoding to half, 1/4
and 1/8 size, and I'd like to report that to userspace.

I'll postpone this patch for now.

regards
Philipp

