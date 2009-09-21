Return-path: <linux-media-owner@vger.kernel.org>
Received: from m3.goneo.de ([82.100.220.82]:58605 "EHLO m3.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZIUKww (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 06:52:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by scan.goneo.de (Postfix) with ESMTP id 174594A0984
	for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 12:52:56 +0200 (CEST)
Received: from m3.goneo.de ([127.0.0.1])
	by localhost (m3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 2CXKCZdJeiK6 for <linux-media@vger.kernel.org>;
	Mon, 21 Sep 2009 12:52:55 +0200 (CEST)
Received: from sleipnir.naglfar (localhost [127.0.0.1])
	by m3-smtp.goneo.de (Postfix) with ESMTPA id A58864A097F
	for <linux-media@vger.kernel.org>; Mon, 21 Sep 2009 12:52:55 +0200 (CEST)
From: Roman <lists@hasnoname.de>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: MSI Digivox mini III Remote Control
Date: Mon, 21 Sep 2009 12:53:49 +0200
References: <200909202026.27086.lists@hasnoname.de> <20090921081933.GA29884@moon>
In-Reply-To: <20090921081933.GA29884@moon>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909211253.49766.lists@hasnoname.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

thx for the tip, i jusst tested it on Windows 7 and i was amazed....
Not only the remote worked perfectly out of the box, also the software used 
(some media-center from ArcSoft), worked flawless. (I last used a Hauppauge 
TV-Card about 2 years ago on windows).
One thing to note is the channel switching was a LOT faster (max. 1sec.) than 
on linux (sometimes > 5sec.).

Anyway, the remote works on windows, no i am trying to compile the mentioned 
repository, but it seems to fail compiling.
I already sent a mail to the msi-support...

#------
make[2]: Entering directory `/home/strowi/src/zen-sources'
  CC [M]  /home/strowi/src/af9015-digivox3_remote/v4l/au0828-cards.o
In file included from /home/strowi/src/af9015-digivox3_remote/v4l/dmxdev.h:33,
                 from /home/strowi/src/af9015-digivox3_remote/v4l/au0828.h:29,
                 
from /home/strowi/src/af9015-digivox3_remote/v4l/au0828-cards.c:22:
/home/strowi/src/af9015-digivox3_remote/v4l/compat.h:385: error: redefinition 
of 'usb_endpoint_type'
include/linux/usb/ch9.h:377: error: previous definition of 'usb_endpoint_type' 
was here
make[3]: *** [/home/strowi/src/af9015-digivox3_remote/v4l/au0828-cards.o] 
Error 1
#------

Am Monday 21 September 2009 10:19:33 schrieb Aleksandr V. Piskunov:
> Well, it seems there is a patch for Digivox mini III remote control at
> http://linuxtv.org/hg/~anttip/af9015-digivox3_remote/, perhaps Antti
> can tell you more about it.
>
> I got this tuner, and no, IR receiver doesn't work for me, it doesn't
> even work in WinXP with bundled drivers and software, tested with
> USB snoop, no reaction to keypresses. Maybe a hardware defect at
> receiver part, maybe something is missing in a firmware, no idea.
>
> So check it on some Windows system first, then try patch..
>

greetings,
Roman
-- 
Iron Law of Distribution:
	Them that has, gets.
