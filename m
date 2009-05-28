Return-path: <linux-media-owner@vger.kernel.org>
Received: from corsa.pop-pr.rnp.br ([200.238.128.2]:51408 "EHLO
	corsa.pop-pr.rnp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763958AbZE1VXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 17:23:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by corsa.pop-pr.rnp.br (Postfix) with ESMTP id AA71C5BD21
	for <linux-media@vger.kernel.org>; Thu, 28 May 2009 18:14:38 -0300 (BRT)
Received: from corsa.pop-pr.rnp.br ([127.0.0.1])
 by localhost (corsa.pop-pr.rnp.br [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 20965-02 for <linux-media@vger.kernel.org>;
 Thu, 28 May 2009 18:14:33 -0300 (BRT)
Received: from viper.localnet (viper.pop-pr.rnp.br [200.238.128.25])
	by corsa.pop-pr.rnp.br (Postfix) with ESMTP id DEF7442203
	for <linux-media@vger.kernel.org>; Thu, 28 May 2009 18:14:33 -0300 (BRT)
From: Christian Lyra <lyra@pop-pr.rnp.br>
To: linux-media@vger.kernel.org
Subject: C-1501 and 309/321Mhz transponders
Date: Thu, 28 May 2009 18:14:54 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905281814.54896.lyra@pop-pr.rnp.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I guess I´m about to have every TDA10023 based card, just to find that 
none of them works right with my provider... 

I tried with a C-1501 hoping that the new patch (from the thread 
"Locking issues on 388Mhz") could also solve my problem. Well... it 
didnt. Using the scan utility to scan for channels on 309 and 321 Mhz 
frequencies returns nothing. Other frequencies (like 129, 135, 585) 
works right. I also found this on dmesg:

[   75.377597] saa7146 (0) saa7146_i2c_writeout [irq]: timed out
waiting for end of xfer

May someone help me with this? I can provide ssh access to the machine, 
and/or donate a card to the developer (you can choose: C-1501, knc-1 or 
cablestar HD2). Until now, the only card that worked was a twinhan CAB-
CI.

-- 
Christian Lyra
POP-PR - RNP

