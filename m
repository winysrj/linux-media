Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41940 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1DRIp0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 04:45:26 -0400
Date: Mon, 18 Apr 2011 10:45:20 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] V4L: mx3_camera: select VIDEOBUF2_DMA_CONTIG instead of
 VIDEOBUF_DMA_CONTIG
Message-ID: <20110418084520.GB31131@pengutronix.de>
References: <1302166243-650-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110418080637.GA31131@pengutronix.de>
 <Pine.LNX.4.64.1104181013250.27247@axis700.grange>
 <20110418082049.GJ3811@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110418082049.GJ3811@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Robert,

On Mon, Apr 18, 2011 at 10:20:49AM +0200, Robert Schwebel wrote:
> On Mon, Apr 18, 2011 at 10:14:56AM +0200, Guennadi Liakhovetski wrote:
> > It's been pushed upstream almost 2 weeks ago:
> >
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/31352
> 
> As our autobuilder does still trigger, I assume that the configs have to
> be refreshed and it may be an issue on our side. Can you take care of
> that?
The problem is not our config, but that the change didn't hit next
(next-20110418) yet.

git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6 (master)
(which I guess is the tree targeted by Guennadi's pull request)
is currently at

	78fca1b9 (Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6)

which doesn't contain Guennadi's pull request. Also the other branches
in Mauro's repo don't contain it, in fact the repository is fully merged
into Linus tree.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
