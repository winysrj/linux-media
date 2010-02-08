Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3116 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab0BHH5h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 02:57:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: [SAA7134, REQUEST] slow register writing
Date: Mon, 8 Feb 2010 08:59:23 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <20100208162014.1c12ec9a@glory.loctelecom.ru>
In-Reply-To: <20100208162014.1c12ec9a@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002080859.23332.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 February 2010 08:20:14 Dmitri Belimov wrote:
> Hi All.
> 
> I wrote SPI bitbang master over GPIO of saa7134. Speed of writing is much slow then in a Windows systems.
> I make some tests:
> 
> Windows, SPI bitbang 97002 bytes x 2 time of writing is around 1.2 seconds
> Linux, SPI bitbang with call saa7134_set_gpio time of writing is 18 seconds
> Linux, SPI bitbang without call saa7134_set_gpio time of writing is 0.25seconds.
> 
> The overhead of SPI subsystem is 0.25 seconds. Writing speed to registers of the saa7134
> tooooo slooooow.
> 
> What you think about it?

Internally the spi subsystem uses delays based on some nsecs parameter. I see some
interesting code in spi_bitbang.h under #ifdef EXPAND_BITBANG_TXRX. My guess is
that you use the default timings from the spi subsystem that are too high for this
card.

Try to discover what timings are currently in use and see if they match the
hardware spec. If not, then you should figure out how to optimize that.

Regards,

	Hans

> 
> With my best regards, Dmitry.
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
