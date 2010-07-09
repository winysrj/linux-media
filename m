Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout11.t-online.de ([194.25.134.85]:52542 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0GIWIy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 18:08:54 -0400
From: "Andreas Witte" <andreaz@t-online.de>
To: <linux-media@vger.kernel.org>
Subject: Strange Problem with Antti's af9015 driver on gentoo 2.6.30-r5
Date: Sat, 10 Jul 2010 00:07:29 +0200
Message-ID: <008801cb1fb3$1f9b7580$5ed26080$@de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello TV-Friends,

today i checked out Antti's last af9015 (af9013) driver and encountered a
strange problem
on my gentoo 2.6.30-r5 box. If i install this driver, udev (149) start to
behave strange and 
take a long time to finish. When it comes to set to utf8 the whole box hang
without any
chance to do anything. I need to erase all the modules in the
/lib/modules/./media -tree 
(chroot from a boot-cd) to make it boot again. With the driver from around
May all seems 
to work (except that weird bug with not getting a lock anymore sometimes on
my digivox-stick).

I wonder what changed in the meantime and what i missed on my gentoo-box to
make
it work..? Am i need a more recent kernel? More recent udev-version?

Any help would be nice, cause i would love to test the last change of that
driver and all
your wonderful work.

Thanks in advance,
Andreas


