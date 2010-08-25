Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:58296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0HYU0z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 16:26:55 -0400
Message-ID: <4C757C9B.5090902@infradead.org>
Date: Wed, 25 Aug 2010 17:27:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [ANOUNCE] removal of backport for versions older than 2.6.26
References: <AANLkTimzPXc=xGXL8ZS1tOAfa1W=qD-DPZeqtxkmiC5s@mail.gmail.com>
In-Reply-To: <AANLkTimzPXc=xGXL8ZS1tOAfa1W=qD-DPZeqtxkmiC5s@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 25-08-2010 17:01, Douglas Schilling Landgraf escreveu:
> Hello folks,
> 
> I would like to share that I will just keep the maintain of
> compatibility of hg  from 2.6.26 until lastest upstream kernel.
> I am writing this because we have errors from IR to lowest kernels
> from a lot of time and just
> 1 person pinged me about it which also claims that he is moving to new
> versions. So, if you are looking for a backport until 2.6.26 I can
> help.
> Otherwise, I will work on keeping hg synced with git, backporting and
> continuing helping on drivers at upstream.
> 
> I have selected 2.6.26 because between all free distros available out
> there the lowest kernel used is 2.6.26.
> 
> Finally, the next cut for backport version can happen probably based
> on 2.6.32 since most of free distros will be using
> kernel >= 2.6.32.

Seems OK to me. I would just move to 2.6.32, since on all major distros, people
can get a compiled 2.6.32 kernel for testing.

> If someone, would like to maintain a backport tree to < 2.6.26 fell
> free to contact me/send patches or contact Mauro.

> This increased can keep occurring (not frequently) but of course
> according with kernel evolution.

Just to be clear to everybody: except if Douglas decide later otherwise, the backport
tree primary objective is to allow users with older kernels to test new
unstable/experimental features without needing to replace the entire kernel.

The drivers and patches generally go there before even reaching upstream, so
they may have bad side effects. So, use at your own risk. Also, even allowing
compilation against older vanilla kernels (that's basically what Douglas tries
to maintain along the time), no real tests are done when doing the backports.
So, a driver may work against the latest upstream kernel and may compile but
fail, against a legacy kernel.

So, there's no explicit or implicit type of support at all using the backport
tree.

Mauro.
