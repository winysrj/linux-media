Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61877 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbZJCPqP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 11:46:15 -0400
Subject: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV M116
 for newer kernels
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>,
	"Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Content-Type: text/plain
Date: Sat, 03 Oct 2009 11:44:20 -0400
Message-Id: <1254584660.3169.25.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aleksandr and Jean,

Zdrastvoitye & Bonjour,

To support the AVerMedia M166's IR microcontroller in ivtv and
ir-kbd-i2c with the new i2c binding model, I have added 3 changesets in

	http://linuxtv.org/hg/~awalls/ivtv

01/03: ivtv: Defer legacy I2C IR probing until after setup of known I2C devices
http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=3d243437f046

02/03: ivtv: Add explicit IR controller initialization for the AVerTV M116
http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=0127ed2ea55b

03/03: ir-kbd-i2c: Add support for the AVerTV M116 with the new binding model
http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=c10e0d5d895c


 ir-kbd-i2c.c       |    1 
 ivtv/ivtv-cards.c  |    3 -
 ivtv/ivtv-cards.h  |   35 +++++++-------
 ivtv/ivtv-driver.c |    3 +
 ivtv/ivtv-i2c.c    |  128 ++++++++++++++++++++++++++++++++++++++---------------
 ivtv/ivtv-i2c.h    |    1 
 6 files changed, 118 insertions(+), 53 deletions(-)

I cannot really test them as I still am using an older kernel.  Could
you please review, and test them if possible?

Change 01/03 actually fixes a problem I inadvertantly let slip by for
ivtv in newer kernels, because I missed it in my initial review.  In
ivtv, we should really only do IR chip probing after all other known I2C
devices on a card are registered.

Regards,
Andy

