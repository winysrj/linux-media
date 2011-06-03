Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:40850 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1FCT4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 15:56:22 -0400
Message-ID: <4DE93C5C.5050301@infradead.org>
Date: Fri, 03 Jun 2011 16:56:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?=
	<u.kleine-koenig@pengutronix.de>
CC: Kyungmin Park <kmpark@infradead.org>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [PATCH] [media] V4L/videobuf2-memops: use pr_debug for debug
 messages
References: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de> <BANLkTimG=xP7qvpN7G8+Mmmy-JozEpyPNw@mail.gmail.com> <4DE6E8A7.2080305@infradead.org> <20110603073908.GC9907@pengutronix.de> <4DE90048.2060407@infradead.org> <20110603195022.GF9907@pengutronix.de>
In-Reply-To: <20110603195022.GF9907@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-06-2011 16:50, Uwe Kleine-König escreveu:
>
>> Fortunately, as the patches on this branch are meant to go to v3.1,
>> I just renamed the branch to staging/for_v3.1, keeping the wrong patch
>> at the old branch. This way, the need of rebasing was avoided.
> I don't get what you mean here. Which merge is broken? Just in case you
> didn't know, git push -f should be able to overwrite the remote branch,
> with all the downside that brings that with it.

A git push -f will cause troubles on all clones of the media tree.

Cheers,
Mauro
