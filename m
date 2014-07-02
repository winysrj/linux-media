Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50952 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaGBNnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 09:43:55 -0400
Message-ID: <1404308630.4109.6.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 23/29] [media] coda: use prescan_failed variable to
 stop stream after a timeout
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Fabio Estevam' <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Date: Wed, 02 Jul 2014 15:43:50 +0200
In-Reply-To: <0b3901cf95f5$493770d0$dba65270$%debski@samsung.com>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
	 <1403621771-11636-24-git-send-email-p.zabel@pengutronix.de>
	 <0b3901cf95f5$493770d0$dba65270$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 02.07.2014, 14:58 +0200 schrieb Kamil Debski:
> Hi,
> 
> > From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> > Sent: Tuesday, June 24, 2014 4:56 PM
> > To: linux-media@vger.kernel.org
> > Cc: Mauro Carvalho Chehab; Kamil Debski; Fabio Estevam;
> > kernel@pengutronix.de; Philipp Zabel
> > Subject: [PATCH v2 23/29] [media] coda: use prescan_failed variable to
> > stop stream after a timeout
> > 
> > This variable should be renamed to hold instead (temporarily stopping
> > streaming until new data is fed into the bitstream buffer).
> 
> Could you explain this commit message to me? If the name should be changed
> then why isn't it done in this patch or any subsequent patches?

Hrng, this was an improperly marked note to self. I'll add a patch to
rename this in the next round.

thanks
Philipp

