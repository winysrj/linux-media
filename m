Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34409 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaGARw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jul 2014 13:52:57 -0400
Message-ID: <1404237167.19382.77.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 06/30] [media] coda: Add encoder/decoder support for
 CODA960
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Date: Tue, 01 Jul 2014 19:52:47 +0200
In-Reply-To: <1403625214.10756.10.camel@mpb-nicolas>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
	 <1402675736-15379-7-git-send-email-p.zabel@pengutronix.de>
	 <1403625214.10756.10.camel@mpb-nicolas>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

Am Dienstag, den 24.06.2014, 11:53 -0400 schrieb Nicolas Dufresne:
> Le vendredi 13 juin 2014 à 18:08 +0200, Philipp Zabel a écrit :
> > This patch adds support for the CODA960 VPU in Freescale i.MX6 SoCs.
> 
> I might be confused, but is this driver sharing the same device node for
> the encoder and the decoder ? If so why ? I know the spec might not be
> preventing it, but I don't know how in userspace I'm supposed to figure
> the type of m2m node this is ? Other drivers have decided to split
> encoding, decoding and transformation into their own node, which made it
> easier to use generically.

you are right. I'm planning to split this into at least encoder and
decoder device, and probably even later add the JPEG codec as separate
devices because of different hardware constraints.
I just didn't manage to find enough time for this yet.

regards
Philipp

