Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34666 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaK0SKm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 13:10:42 -0500
Received: by mail-la0-f52.google.com with SMTP id q1so4473688lam.25
        for <linux-media@vger.kernel.org>; Thu, 27 Nov 2014 10:10:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL8zT=gnkaD=9XbyBDcDh7D=w+rDSQPsi3dKfQ17ezvz6NZMCg@mail.gmail.com>
References: <CAL8zT=i+UZP7gpukW-cRe2M=xWW5Av9Mzd-FnnZAP5d+5J7Mzg@mail.gmail.com>
	<1417020934.3177.15.camel@pengutronix.de>
	<CAL8zT=hY8XeAb4j7-eBt3VJX-3Kzg6-BOajvSpxvgc+o3ZRuYQ@mail.gmail.com>
	<CAL8zT=gnkaD=9XbyBDcDh7D=w+rDSQPsi3dKfQ17ezvz6NZMCg@mail.gmail.com>
Date: Thu, 27 Nov 2014 16:10:40 -0200
Message-ID: <CAOMZO5BsikrKPCjV129FWWW2DVe-ziLz_kMGSh6aM2JC=wnkhA@mail.gmail.com>
Subject: Re: i.MX6 CODA960 encoder
From: Fabio Estevam <festevam@gmail.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Schwebel <r.schwebel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 27, 2014 at 3:54 PM, Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com> wrote:

> I don't have the same behaviour, but I may have missed a patch.
> I have taken linux-next and rebased my work on it. I have some issues,
> but nothing to be worried about, no link with coda.
> I get the following :
> $> v4l2-ctl -d0 --set-fmt-video-out=width=1280,height=720,pixelfor
> $> v4l2-ctl -d0 --stream-mmap --stream-out-mmap --stream-to x.raw
> [  173.705701] coda 2040000.vpu: CODA PIC_RUN timeout

I have this same error with linux-next when I try to decode a file.

Philipp,

Do you know if linux-next contains all required coda patches?

Could this be caused by the fact that we are using an unsupported VPU
firmware version?

Thanks
