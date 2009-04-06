Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:6324 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbZDFJEm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 05:04:42 -0400
Date: Mon, 6 Apr 2009 11:04:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Mike Isely <isely@pobox.com>,
	isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
  model
Message-ID: <20090406110430.400d4608@hyperion.delvare>
In-Reply-To: <1238960152.3337.84.camel@morgan.walls.org>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
	<20090405160519.629ee7d0@hyperion.delvare>
	<1238960152.3337.84.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sun, 05 Apr 2009 15:35:52 -0400, Andy Walls wrote:
> --- v4l-dvb.orig/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-04-04 10:53:08.000000000 +0200
> +++ v4l-dvb/linux/drivers/media/video/ivtv/ivtv-i2c.c	2009-04-04 10:58:36.000000000 +0200
> [snip]
> -
> +		const unsigned short addr_list[] = {
> +			0x1a, 0x18, 0x64, 0x30,
> +			I2C_CLIENT_END
> +		};
> [snip]
> 
> 
> I just noticed you're missing address 0x71 for ivtv.  At least some
> PVR-150 boards have a Zilog chip at that address.

Thanks for reporting. The list above is taken directly from the
original ir-kbd-i2c driver (minus address 0x4b which Hans Verkuil told
me was useless for the ivtv and cx18 adapters). I'm all for adding
support for more boards, however I'd rather do this _after_ the i2c
model conversion is done, so that we have a proper changelog entry
saying that we added support for the PVR-150, and that it gets proper
testing. Hiding support addition in a larger patch would probably do
as much harm as good.

-- 
Jean Delvare
