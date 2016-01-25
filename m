Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47050 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933261AbcAYUB2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 15:01:28 -0500
Date: Mon, 25 Jan 2016 18:01:21 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
Subject: Re: [PATCH] tvp5150: Fix breakage for serial usage
Message-ID: <20160125180121.5bc5bf75@recife.lan>
In-Reply-To: <2963199.ud5niVsfSC@avalon>
References: <54ffe2ae9209b607f54142809902764e2eaaf1d2.1453740290.git.mchehab@osg.samsung.com>
	<1496492.fG104z7bmU@avalon>
	<20160125170721.01dcf4dc@recife.lan>
	<2963199.ud5niVsfSC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Jan 2016 21:32:21 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,

> Let's see, I can't test em28xx, could you try remove the CONF_SHARED_PIN 
> change and replacing the write in s_stream with a read-modify-write that 
> disables the output (bits 3, 2 and 0) ? If that works I'll test it with the 
> omap3 isp when I'll be back home.

Didn't work. I'll  do more tests later (or tomorrow).

Regards,
Mauro
