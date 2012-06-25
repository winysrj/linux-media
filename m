Return-path: <linux-media-owner@vger.kernel.org>
Received: from aotearoadigitalarts.org.nz ([72.14.179.101]:36919 "EHLO
	linode.halo.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2FYBoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 21:44:37 -0400
Received: from 203-97-236-46.cable.telstraclear.net ([203.97.236.46] helo=[192.168.1.42])
	by linode.halo.gen.nz with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <douglas@paradise.net.nz>)
	id 1Siy1I-0004KJ-OE
	for linux-media@vger.kernel.org; Mon, 25 Jun 2012 13:23:12 +1200
Message-ID: <4FE7C27B.8060207@paradise.net.nz>
Date: Mon, 25 Jun 2012 13:44:27 +1200
From: Douglas Bagnall <douglas@paradise.net.nz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Avoid sysfs oops when an rc_dev's raw device is absent
References: <4FE7AA34.8090304@paradise.net.nz>
In-Reply-To: <4FE7AA34.8090304@paradise.net.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,

I probably should have sent that in reply to 
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/49740
which is the problem it fixes.

Some things which might be of interest:

1. I innocently followed the instructions on
   http://www.linuxtv.org/wiki/index.php/Maintaining_Git_trees (i.e.,
   use v4l-dvb tree on top of linus tree) and spent a while looking at
   IR/ir-sysfs.c instead of rc/rc-main.c. How stable it seemed! no
   patches in years! So I added a warning at the top of the wiki page,
   though a fix from someone who knows would be preferable.

2. From the above, I ended up reading a lot of ancient history and saw
   that this was inadvertently sort of fixed for a few weeks in 2010
   between a08c7c68f702e2a2797a4035b and d8b4b5822f51e2142b731b42.

3. I wrote:

> This patch avoids the NULL dereference, and ignores the issue of how
> this state of affairs came about in the first place.

Would, in rc_unregister_device(), putting device_del(&dev->dev) before
ir_raw_event_unregister(dev) help? I've only been a kernel hacker for
two hours so I am honestly clueless, but it seems like that might
avert the race by hiding the structure from sysfs before it is pulled
apart.

regards,

Douglas
