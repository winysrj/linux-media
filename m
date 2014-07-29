Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49995 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaG2I1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 04:27:48 -0400
Message-ID: <1406622460.4001.5.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 00/11] CODA encoder/decoder device split
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Date: Tue, 29 Jul 2014 10:27:40 +0200
In-Reply-To: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
References: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 18.07.2014, 12:22 +0200 schrieb Philipp Zabel:
> Hi,
> 
> the following patches add a few fixes and cleanups and split the
> coda video4linux2 device into encoder and decoder.
> Following the principle of least surprise, this way the format
> enumeration on the output and capture sides is fixed and does
> not change depending on whether the given instance is currently
> configured as encoder or decoder.
>
> Changes since v1:
>  - Fixed "[media] coda: delay coda_fill_bitstream()", taking into account
>    "[media] v4l: vb2: Fix stream start and buffer completion race".
>  - Added Hans' acks.

is there still a chance to still get this series merged for v3.17?
Most of it got acked by Hans right away, and I have received no other
feedback.
The split into separate encoder and decoder devices (patch 08/11) is
necessary for this driver to work with the GStreamer v4l2videodec
element.

regards
Philipp

