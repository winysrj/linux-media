Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:33026 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbZDFDsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 23:48:08 -0400
Date: Sun, 5 Apr 2009 20:48:04 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Mike Isely <isely@pobox.com>, Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
In-Reply-To: <1238962792.3337.122.camel@morgan.walls.org>
Message-ID: <Pine.LNX.4.58.0904052041190.5134@shell2.speakeasy.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <20090404142837.3e12824c@hyperion.delvare>  <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
  <20090405010539.187e6268@hyperion.delvare>  <Pine.LNX.4.64.0904041807300.32720@cnc.isely.net>
  <20090405161803.70810455@hyperion.delvare>  <Pine.LNX.4.64.0904051315490.32738@cnc.isely.net>
 <1238962792.3337.122.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009, Andy Walls wrote:
>
> Here is where LIRC may be its own worst enemy.  LIRC has filled some
> shortcomings in the kernel for support of IR device functions for so
> long (LWN says LIRC is 10 years old), that large numbers of users have
> come to depend on its operation, while at the same time apparently
> removing impetus for doing much to update the in kernel IR device
> support.

More than that.  In 1997 I bought a serial port remote off ebay and tried
to get it to work with linux.  I found an abandoned project from the
Metzler brothers called LIRC, though it didn't work.  I wrote a new
protocol for the serial port driver, which was the only one at the time,
rewrote the remote pulse decoding code and came up a new socket based the
client/server protocol and wrote the x-event client.  At that point remotes
were defined in header files so make was still needed to add a new one.
