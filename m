Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab0D1MOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 08:14:52 -0400
Message-ID: <4BD826B2.8000707@infradead.org>
Date: Wed, 28 Apr 2010 09:14:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Bee Hock Goh <beehock@gmail.com>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	linux-media@vger.kernel.org
Subject: Re: tm6000
References: <20100423104804.784fb730@glory.loctelecom.ru>	<4BD1B985.8060703@arcor.de>	<20100426102514.2c13761e@glory.loctelecom.ru>	<k2m6e8e83e21004260558sb3695c27o5d061b7bc69198c1@mail.gmail.com>	<20100427151545.217a5c90@glory.loctelecom.ru>	<t2v6e8e83e21004262307wfc0b746x22779c4a2ad431ee@mail.gmail.com> <20100428154903.374449eb@glory.loctelecom.ru>
In-Reply-To: <20100428154903.374449eb@glory.loctelecom.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitri Belimov wrote:
> Hi
> 
> Anyone can watch TV with tm6000 module??
> 
> I try mplayer. My PC crashed inside copy_streams function after some time.
> 
> With my best regards, Dmitry.

It is still causing panic on my tests. Probably, the routine is still writing
something out of the buffer area.

-- 

Cheers,
Mauro
