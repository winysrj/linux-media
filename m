Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:59753 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758395AbZIOTOh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 15:14:37 -0400
Message-ID: <4AAFE78B.6060606@gmail.com>
Date: Tue, 15 Sep 2009 21:14:19 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	jirislaby@gmail.com
Subject: Re: V4L2 drivers: potentially dangerous and inefficient msecs_to_jiffies()
 calculation
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
In-Reply-To: <20090914210741.GA16799@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andreas Mohr pisze:
> Hi all,
> 
> ./drivers/media/video/sn9c102/sn9c102_core.c
> ,
> ./drivers/media/video/et61x251/et61x251_core.c
> and
> ./drivers/media/video/zc0301/zc0301_core.c
> do
>                             cam->module_param.frame_timeout *
>                             1000 * msecs_to_jiffies(1) );
> multiple times each.
> What they should do instead is
> frame_timeout * msecs_to_jiffies(1000), I'd think.

Or better: frame_timeout * HZ

Marcin
