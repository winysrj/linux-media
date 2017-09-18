Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:33048 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbdIREdU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 00:33:20 -0400
Received: from pide.tip.net.au (pide.tip.net.au [IPv6:2401:fc00:0:107::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 3xwXy1069vzFskm
        for <linux-media@vger.kernel.org>; Mon, 18 Sep 2017 14:26:17 +1000 (AEST)
Received: from e4.eyal.emu.id.au (124-171-98-224.dyn.iinet.net.au [124.171.98.224])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pide.tip.net.au (Postfix) with ESMTPSA id 3xwXy06q8bz9B59
        for <linux-media@vger.kernel.org>; Mon, 18 Sep 2017 14:26:16 +1000 (AEST)
To: list linux-media <linux-media@vger.kernel.org>
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Urgent: dvb_usb_rtl28xxu not tuning "Leadtek Winfast DTV2000 DS PLUS
 TV"
Message-ID: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
Date: Mon, 18 Sep 2017 14:26:12 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have just upgraded to f24. I am now using the standard dvb_usb_rtl28xxu fe
which logs messages suggesting all is well (I get the /dev/dvb/adapter? etc.)
but I get no channels tuned when I run mythfrontend or scandvb.

Is anyone using this combination?
Is this the correct way to use this tuner?

BTW:

Until f22 I was using the out of kernel driver from
	https://github.com/jaredquinn/DVB-Realtek-RTL2832U.git
but I now get a compile error.

TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
