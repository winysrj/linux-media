Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37098 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab1G2L5f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 07:57:35 -0400
Date: Fri, 29 Jul 2011 13:57:32 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Jan Pohanka <xhpohanka@gmail.com>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: mx2_camera driver on mx27ipcam: dma_alloc_coherent size  failed
Message-ID: <20110729115732.GA16561@pengutronix.de>
References: <op.vzdduqnuyxxkfz@localhost.localdomain>
 <20110729075143.GX16561@pengutronix.de>
 <op.vzdhx5ucyxxkfz@localhost.localdomain>
 <20110729092311.GY16561@pengutronix.de>
 <op.vzdldvr1yxxkfz@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vzdldvr1yxxkfz@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jan,

On Fri, Jul 29, 2011 at 12:14:09PM +0200, Jan Pohanka wrote:
> which repository should I search
> 90026c8c823bff54172eab33a5e7fcecfd3df635 in? I have not found it in
> git.pengutronix.de/git/imx/linux-2.6.git nor in vanilla sources.
Seems my copy'n'paste foo isn't optimal.  Commit
dca7c0b4293a06d1ed9387e729a4882896abccc2 is the relevant, it's in
vanilla.

http://git.kernel.org/linus/dca7c0b4293a06d1ed9387e729a4882896abccc2

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
