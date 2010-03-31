Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56874 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab0CaIkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 04:40:39 -0400
Date: Wed, 31 Mar 2010 10:40:36 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antonio Ospite <ospite@studenti.unina.it>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: mx1-camera: compile fix
Message-ID: <20100331084036.GT2241@pengutronix.de>
References: <Pine.LNX.4.64.1003161129460.5123@axis700.grange> <1269726133-12377-1-git-send-email-u.kleine-koenig@pengutronix.de> <Pine.LNX.4.64.1003282211010.11679@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.1003282211010.11679@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 28, 2010 at 10:12:06PM +0200, Guennadi Liakhovetski wrote:
> On Sat, 27 Mar 2010, Uwe Kleine-K�nig wrote:
> 
> > This fixes a regression of
> > 
> > 	7d58289 (mx1: prefix SOC specific defines with MX1_ and deprecate old names)
> > 
> > Signed-off-by: Uwe Kleine-K�nig <u.kleine-koenig@pengutronix.de>
> 
> Sascha, I need your ack to pull this via my tree.

Here we go:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
