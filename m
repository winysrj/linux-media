Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46293 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1FCHjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 03:39:18 -0400
Date: Fri, 3 Jun 2011 09:39:08 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [media] V4L/videobuf2-memops: use pr_debug for debug
 messages
Message-ID: <20110603073908.GC9907@pengutronix.de>
References: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <BANLkTimG=xP7qvpN7G8+Mmmy-JozEpyPNw@mail.gmail.com>
 <4DE6E8A7.2080305@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DE6E8A7.2080305@infradead.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Mauro,

On Wed, Jun 01, 2011 at 10:34:31PM -0300, Mauro Carvalho Chehab wrote:
> Hi Kyungmin,
> 
> Em 01-06-2011 21:50, Kyungmin Park escreveu:
> > Acked-by: Kyungmin Park <kyunginn.,park@samsung.com>
> 
> As this patch is really trivial and makes sense, I've just applied it earlier
> today.
You somehow screwed up my name in the Author field more than I'm used
to:

 $ git cat-file commit 215c52702775556f4caf5872cc84fa8810e6fc7d | grep Uwe
 author Uwe Kleine-KÃƒÆ’Ã‚Â¶nig <u.kleine-koenig@pengutronix.de> 1306959562 -0300
 Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Strange enough my name in the commitlog looks fine.

If you care to fix it, you can easily do so using git filter-branch.
E.g.:

	$ git filter-branch --env-filter 'test "x$GIT_COMMIT" != "x215c52702775556f4caf5872cc84fa8810e6fc7d" || { GIT_AUTHOR_NAME="Uwe Kleine-König"; export GIT_AUTHOR_NAME; }' ^215c5270277^ HEAD

(Assuming an UTF-8 locale.)

This converts 215c527 to a commit c6cbbfc that has my name fixed and
rebases all following commits on top of this. In your master branch this
only affects "00c4526 (Merge /home/v4l/v4l/for_upstream)"

Best regards and thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
