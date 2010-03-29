Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f222.google.com ([209.85.219.222]:39425 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0C2FUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 01:20:07 -0400
Received: by ewy22 with SMTP id 22so1704794ewy.37
        for <linux-media@vger.kernel.org>; Sun, 28 Mar 2010 22:20:06 -0700 (PDT)
Date: Mon, 29 Mar 2010 14:21:38 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: MPEG2 encoder uPD61151 next...
Message-ID: <20100329142138.7d8b4e91@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

I have more questions now.

Our card has DVB-T zl10353. Befor start encoder need set its out to Z-state. How to I can do it?
This is my last big problem.

Startup step by step:

Call zarlink to set Z-state of a bus.
Configure TS port of the saa7134 to PARALLEL_PS and config other regs
Configure DMA of a TS
Prepare settings for uPD61151 encoder
Enable MPEG out of the uPD61151 by GPIO pin of the saa7134
Start DMA and TS
Start encoder

Stop step by step:

Stop encoder
Stop DMA and TS
Disable  MPEG out by GPIO pin of the saa7134

Zarlink and encoder connected to same bus and has different TS config.
I need know who want use TS: zarlink or encoder. Now to I can do it?

> Um, what is the 'Z state' of a bus?  

Write special value to command register of the zl10353. The chip disconnect
internal bus from output bus. This bus used for send MPEG TS data from zl10353 to saa7134.
uPD61151 and zl10353 connected to the same bus. At one time only one chip can
send MPEG TS data to the saa7134. When DVB-T mode zl10353 send date, uPD61151 disconnected from a bus.
When MPEG2 encode mode, uPD61151 send date, zl10353 disconnected from a bus.

With my best regards, Dmitry.
