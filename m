Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53850 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1PYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 10:24:22 -0500
Message-ID: <1417188223.3721.2.camel@pengutronix.de>
Subject: Re: i.MX6 CODA960 encoder
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Schwebel <r.schwebel@pengutronix.de>
Date: Fri, 28 Nov 2014 16:23:43 +0100
In-Reply-To: <CAOMZO5BsikrKPCjV129FWWW2DVe-ziLz_kMGSh6aM2JC=wnkhA@mail.gmail.com>
References: <CAL8zT=i+UZP7gpukW-cRe2M=xWW5Av9Mzd-FnnZAP5d+5J7Mzg@mail.gmail.com>
	 <1417020934.3177.15.camel@pengutronix.de>
	 <CAL8zT=hY8XeAb4j7-eBt3VJX-3Kzg6-BOajvSpxvgc+o3ZRuYQ@mail.gmail.com>
	 <CAL8zT=gnkaD=9XbyBDcDh7D=w+rDSQPsi3dKfQ17ezvz6NZMCg@mail.gmail.com>
	 <CAOMZO5BsikrKPCjV129FWWW2DVe-ziLz_kMGSh6aM2JC=wnkhA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 27.11.2014, 16:10 -0200 schrieb Fabio Estevam:
> On Thu, Nov 27, 2014 at 3:54 PM, Jean-Michel Hautbois
> <jean-michel.hautbois@vodalys.com> wrote:
> 
> > I don't have the same behaviour, but I may have missed a patch.
> > I have taken linux-next and rebased my work on it. I have some issues,
> > but nothing to be worried about, no link with coda.
> > I get the following :
> > $> v4l2-ctl -d0 --set-fmt-video-out=width=1280,height=720,pixelfor
> > $> v4l2-ctl -d0 --stream-mmap --stream-out-mmap --stream-to x.raw
> > [  173.705701] coda 2040000.vpu: CODA PIC_RUN timeout
> 
> I have this same error with linux-next when I try to decode a file.
> 
> Philipp,
> 
> Do you know if linux-next contains all required coda patches?
> 
> Could this be caused by the fact that we are using an unsupported VPU
> firmware version?

I missed that the commit a04a0b6fed4f ("ARM: dts: imx6qdl: Enable
CODA960 VPU") lost the switching of the interrupts between
http://www.spinics.net/lists/arm-kernel/msg338645.html
and
http://www.spinics.net/lists/arm-kernel/msg376571.html .

Of course the JPEG interrupt will never fire when encoding H.264, which
causes the timeout. Patch in another mail.

regards
Philipp

