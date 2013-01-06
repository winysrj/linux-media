Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab3AFLdW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 06:33:22 -0500
Date: Sun, 6 Jan 2013 09:32:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [GIT PULL FOR 3.9] Exynos SoC media drivers updates
Message-ID: <20130106093246.36f959da@redhat.com>
In-Reply-To: <50E75A10.8090906@gmail.com>
References: <50E726F4.7060704@samsung.com>
	<50E75A10.8090906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Jan 2013 23:39:12 +0100
Sylwester Nawrocki <sylvester.nawrocki@gmail.com> escreveu:


> > Tomasz Stanislawski (1):
> >        s5p-tv: mixer: fix handling of VIDIOC_S_FMT

I'll drop this one for now. Devin raised a point: such changes would break
existing applications.

So, we'll need to revisit this topic before changing the drivers.

Btw, I failed to find the corresponding patch at patchwork:
	http://patchwork.linuxtv.org/project/linux-media/list/?state=*&q=VIDIOC_S_FMT

So, its status update may be wrong after flushing your pwclient commands.

Regards,
Mauro
