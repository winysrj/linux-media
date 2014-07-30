Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:4287
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753065AbaG3MRA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 08:17:00 -0400
Date: Wed, 30 Jul 2014 20:16:30 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	"Hans Verkuil" <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH v3 06/32] [media] coda: Add encoder/decoder support for
 CODA960
Message-ID: <20140730121628.GA22243@dragon>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
 <1405071403-1859-7-git-send-email-p.zabel@pengutronix.de>
 <20140721160128.27eb7428.m.chehab@samsung.com>
 <20140721191944.GK13730@pengutronix.de>
 <1406033433.4496.16.camel@paszta.hi.pengutronix.de>
 <20140729153050.GE6827@dragon>
 <CA+gwMccgFGxpDZFqZR=pEgnnc1z5rit4T+LsVKvp1KrWw7_aJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+gwMccgFGxpDZFqZR=pEgnnc1z5rit4T+LsVKvp1KrWw7_aJA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 29, 2014 at 07:06:25PM +0200, Philipp Zabel wrote:
> > I followed the step to generate the firmware v4l-coda960-imx6q, and
> > tested it on next-20140725 with patch 'ARM: dts: imx6qdl: Enable CODA960
> > VPU' applied on top of it.  But I got the error of 'Wrong firmwarel' as
> > below.
> >
> > [    2.582837] coda 2040000.vpu: requesting firmware 'v4l-coda960-imx6q.bin' for CODA960
> > [    2.593344] coda 2040000.vpu: Firmware code revision: 0
> > [    2.598649] coda 2040000.vpu: Wrong firmware. Hw: CODA960, Fw: (0x0000), Version: 0.0.0
> 
> I just tried with the same kernel, and the above download, converted
> with the program in the referenced mail, and I get this:
> 
>     coda 2040000.vpu: Firmware code revision: 36350
>     coda 2040000.vpu: Initialized CODA960.
>     coda 2040000.vpu: Unsupported firmware version: 2.1.9
>     coda 2040000.vpu: codec registered as /dev/video0

Okay, the reason I'm running into the issue is that I'm using the FSL
U-Boot which turns off VDDPU at initialization.

Shawn
