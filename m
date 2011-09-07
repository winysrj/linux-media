Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52784 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1IGR0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 13:26:21 -0400
Received: from octopus.hi.pengutronix.de ([2001:6f8:1178:2:215:17ff:fe12:23b0])
	by metis.ext.pengutronix.de with esmtp (Exim 4.72)
	(envelope-from <rsc@pengutronix.de>)
	id 1R1LtE-0001dh-Ss
	for linux-media@vger.kernel.org; Wed, 07 Sep 2011 19:26:20 +0200
Date: Wed, 7 Sep 2011 09:17:58 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <sha@pengutronix.de>
Subject: Re: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
Message-ID: <20110907071758.GG25231@pengutronix.de>
References: <CACKLOr3GB-WO2p3+pQPdyXsipvTGFuj-wATgv=FSxtge=_Pq2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CACKLOr3GB-WO2p3+pQPdyXsipvTGFuj-wATgv=FSxtge=_Pq2g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Sep 06, 2011 at 05:07:54PM +0200, javier Martin wrote:
> we are planning to add support to H.264/MPEG4 encoder inside the
> i.MX27 to v4l2. It is mainly a hardware module that has the following
> features:

We have driver prototypes for the MX27 VPU (which is basically the same
as on MX51/MX53, just an earlier version). Sascha Hauer can probably
elaborate about the details, but he is on holiday for this and next week
and will comment then.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
