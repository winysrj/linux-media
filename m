Return-path: <linux-media-owner@vger.kernel.org>
Received: from as-10.de ([212.112.241.2]:34775 "EHLO mail.as-10.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757430AbZFQQcM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 12:32:12 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id 50CE233A829
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 18:21:59 +0200 (CEST)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fo9etoXG64We for <linux-media@vger.kernel.org>;
	Wed, 17 Jun 2009 18:21:59 +0200 (CEST)
Received: from halim.local (pD9E3FFF3.dip.t-dialin.net [217.227.255.243])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id 1F50233A7E1
	for <linux-media@vger.kernel.org>; Wed, 17 Jun 2009 18:21:59 +0200 (CEST)
Date: Wed, 17 Jun 2009 18:24:00 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-media@vger.kernel.org
Subject: bttv problem loading takes about several minutes
Message-ID: <20090617162400.GA11690@halim.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
In the past I could use this card by typing
modprobe bttv card=34 tuner=24 gbuffers=16
Giving this command with current drivers has some problems:
1. it takes several minutes to load bttv module.
2. capturing doesn't work any more (dropped frames etc).
Tested with current v4l-dvb from hg, ubuntu 9.04, 
debian lenny.

I have a bt878  based card from leadtek.

Here is my output after loading the driver:
[ 3013.735459] bttv: driver version 0.9.17 loaded
[ 3013.735470] bttv: using 32 buffers with 16k (4 pages) each for capture
[ 3013.735542] bttv: Bt8xx card found (0).
[ 3013.735562] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19, latency: 32, mmio
: 0xf7800000
[ 3013.737762] bttv0: using: Leadtek WinFast 2000/ WinFast 2000 XP [card=34,insm
od option]
[ 3013.737825] bttv0: gpio: en=00000000, out=00000000 in=003ff502 [init]
[ 3148.136017] bttv0: tuner type=24
[ 3148.136029] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[ 3154.536019] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[ 3160.936018] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[ 3167.351398] bttv0: registered device video0
[ 3167.351434] bttv0: registered device vbi0
[ 3167.351463] bttv0: registered device radio0
[ 3167.351485] bttv0: PLL: 28636363 => 35468950 . ok
[ 3167.364182] input: bttv IR (card=34) as /class/input/input6

Please help!
Regards
Halim


-- 
Halim Sahin
E-Mail:				
halim.sahin (at) t-online.de
