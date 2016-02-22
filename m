Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:43069 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbcBVVWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 16:22:19 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: pxa_camera: fix the buffer free path
References: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
	<87io5wwahg.fsf@belgarion.home>
	<Pine.LNX.4.64.1510272306300.21185@axis700.grange>
	<87twpcj6vj.fsf@belgarion.home>
	<Pine.LNX.4.64.1510291656580.694@axis700.grange>
	<87d1s72bls.fsf@belgarion.home>
	<Pine.LNX.4.64.1602211400050.5959@axis700.grange>
	<874md2xgg9.fsf@belgarion.home>
	<Pine.LNX.4.64.1602211749460.5959@axis700.grange>
Date: Mon, 22 Feb 2016 22:22:14 +0100
In-Reply-To: <Pine.LNX.4.64.1602211749460.5959@axis700.grange> (Guennadi
	Liakhovetski's message of "Sun, 21 Feb 2016 17:50:15 +0100 (CET)")
Message-ID: <87fuwkwid5.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Sun, 21 Feb 2016, Robert Jarzmik wrote:
> Please, have a look at 
> http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/log/?h=for-4.6-2
> If all is good there, no need for a v6

Thanks for fixing the *_dma_irq() mess, and sorry for that.

And I just tested your branch, and it's working perfectly fine.

Cheers.

-- 
Robert
