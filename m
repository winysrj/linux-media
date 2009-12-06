Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63916 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756123AbZLFDI5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Dec 2009 22:08:57 -0500
Subject: Heads up, I'm adding IR stuff to cx23885 and cx25840
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 05 Dec 2009 22:07:45 -0500
Message-Id: <1260068865.3105.50.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I noticed you've added some changes to th v4l-dvb tree for IR.

Just to let you know, I've added an NEC protocol implementation to
cx23885-input.c.   The two relevant changes are here:

	cx23885: Convert from struct card_ir to struct cx23885_ir_input for IR Rx
	http://linuxtv.org/hg/~awalls/cx23885-ir/rev/c51daeba32cb

	cx23885: Add NEC protocol decoding for IR Rx
	http://linuxtv.org/hg/~awalls/cx23885-ir/rev/6cba2fc1ea99

I haven't kept track with all your changes so far, but just wanted to
let you know these would be ready sometime before Christmas for
hopefully the HVR-1800 and TeVii S470.  Hopefully, the changes will also
be brought up to date with your changes by then too.

Regards,
Andy

