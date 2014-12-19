Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60958 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaLSK2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 05:28:31 -0500
Message-ID: <1418984906.3165.53.camel@pengutronix.de>
Subject: Re: coda: Unable to use encoder video_bitrate
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Sureau
	<frederic.sureau@vodalys.com>, Fabio Estevam <festevam@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Date: Fri, 19 Dec 2014 11:28:26 +0100
In-Reply-To: <CAL8zT=jL3psKQ7+K4avQp=tr58m-KXvqGGhXzYrafEuRB5hkcw@mail.gmail.com>
References: <54930468.6010007@vodalys.com>
	 <1418921549.4212.57.camel@pengutronix.de>
	 <CAL8zT=jjm9BXuUbk5RS-LZpC1EyyTwdGQRy-fQEUMdDfj4Ej7g@mail.gmail.com>
	 <1418922570.4212.67.camel@pengutronix.de>
	 <CAL8zT=jL3psKQ7+K4avQp=tr58m-KXvqGGhXzYrafEuRB5hkcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

Am Donnerstag, den 18.12.2014, 18:10 +0100 schrieb Jean-Michel Hautbois:
> > Sorry, forgot to put all of you on Cc: for the "[media] coda: fix
> > encoder rate control parameter masks" patch. The coda driver is in
> > drivers/media/platform/coda, register definitions in coda_regs.h.
> > The CODA_RATECONTROL_BITRATE_MASK is 0x7f, but it should be 0x7fff.
> >
> 
> Well, I meant, the datasheet of the CODA960 because we don't know,
> just by reading the coda_regs.h which register is where and does what.

I wish. If you search for "cnm-codadx6-datasheet-v2.9.pdf" with a search
engine of your choice, on chipsnmedia.com you can get documentation for
the very oldest coda version supported by the driver. That's all I have
in addition to the old GPLed Freescale imx-vpu-lib for reference.

regards
Philipp

