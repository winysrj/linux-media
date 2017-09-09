Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:34649 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750967AbdIIXh5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 19:37:57 -0400
Received: from pide.tip.net.au (pide.tip.net.au [IPv6:2401:fc00:0:107::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 3xqVlp50SpzFslF
        for <linux-media@vger.kernel.org>; Sun, 10 Sep 2017 09:29:58 +1000 (AEST)
Received: from e4.eyal.emu.id.au (124-171-101-107.dyn.iinet.net.au [124.171.101.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pide.tip.net.au (Postfix) with ESMTPSA id 3xqVlp4MBDz9BWV
        for <linux-media@vger.kernel.org>; Sun, 10 Sep 2017 09:29:58 +1000 (AEST)
To: linux-media@vger.kernel.org
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: dvb_usb_rtl2832u vs dvb_usb_rtl28xxu
Message-ID: <70db3561-4d75-d79a-1d83-cc44eeb74426@eyal.emu.id.au>
Date: Sun, 10 Sep 2017 09:29:57 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was running f19 and had dvb_usb_rtl2832u built from git handling my "Leadtek Winfast DTV2000 DS PLUS TV" tuners.
	https://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV2000DS_PLUS
	I am using jaredquinn's driver

Yesterday I upgraded to f22 and the tuners stopped working. I discovered that dvb_usb_rtl2832u failed
to build (my rc.local had rules for this). A small fix sorted this out but the tuners still did not
work.

I then noticed a new module is activated, dvb_usb_rtl28xxu. I blacklisted it and now the tuners work.

My question: is dvb_usb_rtl28xxu supposed to handle this card?
Or should I continue to build the out of kernel module?
Or, is there another module to handle this card now?

TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
