Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:56862 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab1FCPkB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 11:40:01 -0400
Message-ID: <4DE90048.2060407@infradead.org>
Date: Fri, 03 Jun 2011 12:39:52 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?=
	<u.kleine-koenig@pengutronix.de>
CC: Kyungmin Park <kmpark@infradead.org>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [media] V4L/videobuf2-memops: use pr_debug for debug
 messages
References: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de> <BANLkTimG=xP7qvpN7G8+Mmmy-JozEpyPNw@mail.gmail.com> <4DE6E8A7.2080305@infradead.org> <20110603073908.GC9907@pengutronix.de>
In-Reply-To: <20110603073908.GC9907@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-06-2011 04:39, Uwe Kleine-König escreveu:
> Hello Mauro,
> 
> On Wed, Jun 01, 2011 at 10:34:31PM -0300, Mauro Carvalho Chehab wrote:
>> Hi Kyungmin,
>>
>> Em 01-06-2011 21:50, Kyungmin Park escreveu:
>>> Acked-by: Kyungmin Park <kyunginn.,park@samsung.com>
>>
>> As this patch is really trivial and makes sense, I've just applied it earlier
>> today.
> You somehow screwed up my name in the Author field more than I'm used
> to:
> 
>  $ git cat-file commit 215c52702775556f4caf5872cc84fa8810e6fc7d | grep Uwe
>  author Uwe Kleine-KÃƒÆ’Ã‚Â¶nig <u.kleine-koenig@pengutronix.de> 1306959562 -0300
>  Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Strange enough my name in the commitlog looks fine.

You should thank Python for that. We use patchwork to retrieve patches. It is written
in Python. Python seems to have serious troubles handling anything that it is not pure
ASCII. In the past, a non-north-american name in Patchwork would be simply discarded,
as python used to abort patchwork. Lots of locale-fix patches later trying to address
this issue and now, it sometimes do the right thing.

> 
> If you care to fix it, you can easily do so using git filter-branch.
> E.g.:
> 
> 	$ git filter-branch --env-filter 'test "x$GIT_COMMIT" != "x215c52702775556f4caf5872cc84fa8810e6fc7d" || { GIT_AUTHOR_NAME="Uwe Kleine-König"; export GIT_AUTHOR_NAME; }' ^215c5270277^ HEAD
> 
> (Assuming an UTF-8 locale.)
> 
> This converts 215c527 to a commit c6cbbfc that has my name fixed and
> rebases all following commits on top of this. In your master branch this
> only affects "00c4526 (Merge /home/v4l/v4l/for_upstream)"

This breaks merge. 

$ git push
To /home/v4l/bare_trees/v4l-dvb.git/
 ! [rejected]        staging/for_v3.0 -> staging/for_v3.0 (non-fast-forward)


Fortunately, as the patches on this branch are meant to go to v3.1,
I just renamed the branch to staging/for_v3.1, keeping the wrong patch
at the old branch. This way, the need of rebasing was avoided.

> 
> Best regards and thanks
> Uwe
> 

