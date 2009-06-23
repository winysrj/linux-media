Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64504 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZFWVvd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 17:51:33 -0400
Subject: Re: PxDVR3200 H LinuxTV v4l-dvb patch : Pull GPIO-20 low for DVB-T
From: Andy Walls <awalls@radix.net>
To: Terry Wu <terrywu2009@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>, stoth@kernellabs.com
In-Reply-To: <6ab2c27e0906230610t588ffdf8p7640920b9dbe5a28@mail.gmail.com>
References: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
	 <6ab2c27e0906230610t588ffdf8p7640920b9dbe5a28@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 17:53:26 -0400
Message-Id: <1245794006.3185.16.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-06-23 at 21:10 +0800, Terry Wu wrote:


> 2. Also, I can not find GPIO functions in the cx25840-core.c
> 
> Something missing or unfinished ?

Missing: they are not implemented in the cx25840 driver.  I will at
least implement a change to the cx25840 module so the v4l bridge driver
(cx23885) can set the GPIOs.

Regards,
Andy


> Best Regards,
> Terry


