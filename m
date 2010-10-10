Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38670 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab0JJAIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 20:08:52 -0400
Received: by wyb28 with SMTP id 28so2083340wyb.19
        for <linux-media@vger.kernel.org>; Sat, 09 Oct 2010 17:08:51 -0700 (PDT)
Subject: rtl2831-r2 still not working for Compro VideoMate U80
From: Ugnius Soraka <spam.ugnius40@gmail.com>
Reply-To: spam.ugnius40@gmail.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 01:07:26 +0100
Message-ID: <1286669246.3990.44.camel@linux-efue.site>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'd like to get in touch with driver developers, is there any way I
could help make RTL2831U driver work with Compro VideoMate U80. I would
like to actively participate. My programming skills are well below
required to write kernel modules, so I know I would be no use there. But
anything else, testing with VideoMate U80, sending debug logs, I think I
could do that.

I've tried http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2 driver, it
looked promising. U80 device was recognised as VideoMate U90, /dev/dvb
entries were created. But when scanning it says there's no signal. Debug
gives TPS_NON_LOCK, Signal NOT Present, rtd2830_soft_reset, etc. (I
could post message log, if it's any use to somebody).
U80 has a led which (on windows) shows if TV stick is tuned in and
working, when scanning on linux it's always on.

I've also tried to compile http://linuxtv.org/hg/~anttip/rtl2831u/ but
for now it's based on old dvb tree and seems to be incompatible with new
kernels (mine 2.6.34.7-0.3).

Is anttip driver supposed to be included in kernel, but it looks like
development is going slow.

Thank you,
Ugnius




