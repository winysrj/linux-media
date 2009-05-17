Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39989 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbZEQCMh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 May 2009 22:12:37 -0400
Subject: cx18: Testers needed: VBI for non-NTSC-M input signals
From: Andy Walls <awalls@radix.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	ivtv-devel@ivtvdriver.org
Cc: hverkuil@xs4all.nl, ivtv-users@ivtvdriver.org
Content-Type: text/plain
Date: Sat, 16 May 2009 22:06:04 -0400
Message-Id: <1242525964.16178.15.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks to a loaner PVR-350 from Hans, I've been able to implement VBI
support in the cx18 driver for non-NTSC video standards. 

If you've got a 625 line PAL, SECAM, etc, video source and can test VBI
functions on a CX23418 based card, I'd like to hear how it works.  The
patches for testing are here:

http://linuxtv.org/hg/~awalls/cx18-av-core
http://linuxtv.org/hg/~awalls/cx18-av-core/archive/tip.tar.bz2

I've only been able to test with PAL with VPS in field 1 line 16 and WSS
in field 1 line 23.  I wasn't able to figure out how to get Teletext B
out of the PVR-350, so I'd certainly like to hear if Teletext is
working.

Note: to implement Raw VBI for 625 line/50 Hz systems to extract line 23
(WSS), I had to blank one extra line in each field.  This means that
625/50 systems will be missing 1 line from the top of each field (e.g.
line 24 won't show).  I thought that was better than having the fields
move up or down around if the user turned VBI on or off.

Regards,
Andy

