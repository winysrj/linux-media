Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60608 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab1AAAqD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 19:46:03 -0500
Subject: Adaptec AVC-2410 remote codes
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 18:48:17 -0500
Message-ID: <1293839297.2410.36.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Mauro,

Here is the lirc config file for the Adaptec AVC-2410:

http://lirc.git.sourceforge.net/git/gitweb.cgi?p=lirc/lirc;a=blob;f=remotes/adaptec/lircd.conf.AVC-2410;h=3f6c5f08c8fef187d6015f4c1abe930464aa0d78;hb=HEAD

The 16 bit button codes are obviously in a command:command' data payload
like standard NEC.  For example:
	Mute                     0x00000000000013EC

The 16 bit prefix data is 0x82F1, which doesn't remind me of anything in
particular.

Regards,
Andy

