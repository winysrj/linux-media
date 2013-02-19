Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45287 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923Ab3BSSrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 13:47:52 -0500
Date: Tue, 19 Feb 2013 19:47:49 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: =?iso-8859-15?Q?Ga=EBtan?= Carlier <gcembed@gmail.com>
Cc: linux-media@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Rob Herring <rob.herring@calxeda.com>
Subject: Re: coda: support of decoding
Message-ID: <20130219184749.GD30071@pengutronix.de>
References: <5122D999.3070405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5122D999.3070405@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 19, 2013 at 02:47:05AM +0100, Gaëtan Carlier wrote:
> I see in code source of coda driver that decoding is not supported.
>
> ctx->inst_type = CODA_INST_DECODER;
> v4l2_err(v4l2_dev, "decoding not supported.\n");
> return -EINVAL;
>
> Is there any technical reason or the code has not been written ?

We have a lot of encoder + decoder patches for Coda in the queue, but
unfortunately not all of that is ready-for-primetime yet.

Which processor are you interested in? MX27 or MX5/MX6?

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
