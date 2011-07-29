Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab1G2ULz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 16:11:55 -0400
Message-ID: <4E331406.2010408@redhat.com>
Date: Fri, 29 Jul 2011 17:11:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alina Friedrichsen <x-alina@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for v3.0] media updates for v3.1
References: <4E32EE71.4030908@redhat.com> <20110729200151.213060@gmx.net>
In-Reply-To: <20110729200151.213060@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-07-2011 17:01, Alina Friedrichsen escreveu:
> Hi Mauro,
> 
> please include your patch "cx23885-dvb: Fix demod IF".
> It works fine!

Yes, I saw your email. Thanks for testing!

I'll submit it on the next patch series. Before sending upstream,
we first merge on our tree, and then send to linux-next tree.
The patches I've sent today are the ones I've prepared 2 days ago
for merge.

Also, as this patch fixes a bug that exists on the previous versions,
it should also be c/c to stable@kernel.org, in order to get it 
backported to 3.0 and a few other stable versions.

Thanks!
Mauro.
