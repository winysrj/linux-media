Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:42596 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750913AbdIWMsg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 08:48:36 -0400
Received: from pide.tip.net.au (pide.tip.net.au [IPv6:2401:fc00:0:107::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 3xzqsH4BQ0zFt2W
        for <linux-media@vger.kernel.org>; Sat, 23 Sep 2017 22:48:35 +1000 (AEST)
Received: from e4.eyal.emu.id.au (203-214-8-205.dyn.iinet.net.au [203.214.8.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pide.tip.net.au (Postfix) with ESMTPSA id 3xzqsH3kzJz9BLy
        for <linux-media@vger.kernel.org>; Sat, 23 Sep 2017 22:48:35 +1000 (AEST)
Subject: f26: dvb_usb_rtl28xxu not tuning "Leadtek Winfast DTV2000 DS PLUS TV"
To: list linux-media <linux-media@vger.kernel.org>
References: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Message-ID: <3f0c2037-4a84-68a9-228f-015034e27900@eyal.emu.id.au>
Date: Sat, 23 Sep 2017 22:48:34 +1000
MIME-Version: 1.0
In-Reply-To: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18/09/17 14:26, Eyal Lebedinsky wrote:
> I have just upgraded to f24. I am now using the standard dvb_usb_rtl28xxu fe

I have upgraded to f26 and this driver still fails to tune the "Leadtek Winfast DTV2000 DS PLUS TV".

> which logs messages suggesting all is well (I get the /dev/dvb/adapter? etc.)
> but I get no channels tuned when I run mythfrontend or scandvb.
> 
> Is anyone using this combination?
> Is this the correct way to use this tuner?

Is this the wrong list? If so then please suggest a more suitable one.

> BTW:
> 
> Until f22 I was using the out of kernel driver from
>      https://github.com/jaredquinn/DVB-Realtek-RTL2832U.git
> but I now get a compile error.
> 
> TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
