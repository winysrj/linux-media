Return-path: <linux-media-owner@vger.kernel.org>
Received: from contrabass.post.ru ([85.21.78.5]:45442 "EHLO
	contrabass.corbina.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab1JXLAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 07:00:38 -0400
Received: from corbina.ru (violin.corbina.net [195.14.50.30])
	by contrabass.corbina.net (Postfix) with ESMTP id 96B52CA900
	for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 14:53:11 +0400 (MSD)
Received: from [95.31.6.113] (account sergmiron@post.ru HELO StorageServer.darkhome.local)
  by fe1-mc.corbina.ru (CommuniGate Pro SMTP 5.4.0)
  with ESMTPSA id 43028316 for linux-media@vger.kernel.org; Mon, 24 Oct 2011 14:53:11 +0400
Received: from [86.110.8.131] (helo=timelinex.darkhome.local)
	by StorageServer.darkhome.local with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <subscribe@darkmike.ru>)
	id 1RII9Q-0005RV-Ee
	for linux-media@vger.kernel.org; Mon, 24 Oct 2011 14:53:05 +0400
Message-ID: <4EA54389.9040505@darkmike.ru>
Date: Mon, 24 Oct 2011 14:52:57 +0400
From: Mike Mironov <subscribe@darkmike.ru>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Problem with TeVii S-470
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I have this card http://www.linuxtv.org/wiki/index.php/TeVii_S470

I try to use it under Debian Squeeze, but I can't get channel data from it.

I try to use drivers from 2.6.38, 2.6.39 kernels, s2-liplianin drivers 
with 2.6.32 kernel, last linux-media drivers with 2.6.32

With all drivers I can scan channels, but then a I'll try to lock 
channel I get some error in syslog (module cx23885 loaded with debug=1)

cx23885[0]/0: [f373ec80/27] cx23885_buf_queue - append to active
cx23885[0]/0: [f373ebc0/28] wakeup reg=477 buf=477
cx23885[0]/0: queue is not empty - append to active

and finally a lot of

cx23885[0]/0: [f42c4240/6] timeout - dma=0x03c5c000
cx23885[0]/0: [f42c4180/7] timeout - dma=0x3322b000
cx23885[0]/0: [f4374440/8] timeout - dma=0x33048000
cx23885[0]/0: [f4374140/9] timeout - dma=0x03d68000

In other machine this work under Windows. Under Linux I have same effects.

It's problem in drivers or in card? That addition information need to 
resolve this problem?
