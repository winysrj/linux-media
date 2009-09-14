Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50268 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZINVes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 17:34:48 -0400
Message-ID: <4AAEB6F0.4080706@gmail.com>
Date: Mon, 14 Sep 2009 23:34:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: V4L2 drivers: potentially dangerous and inefficient	msecs_to_jiffies()
 calculation
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
In-Reply-To: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2009 11:07 PM, Andreas Mohr wrote:
> ./drivers/media/video/zc0301/zc0301_core.c
> do
>                             cam->module_param.frame_timeout *
>                             1000 * msecs_to_jiffies(1) );
> multiple times each.
> What they should do instead is
> frame_timeout * msecs_to_jiffies(1000), I'd think.

In fact, msecs_to_jiffies(frame_timeout * 1000) makes much more sense.

> msecs_to_jiffies(1) is quite a bit too boldly assuming
> that all of the msecs_to_jiffies(x) implementation branches
> always round up.

They do, don't they?
