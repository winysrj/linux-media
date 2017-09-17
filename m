Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:40806 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbdIQGNO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 02:13:14 -0400
Received: from pide.tip.net.au (pide.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 3xvz9W3YZVzFsBt
        for <linux-media@vger.kernel.org>; Sun, 17 Sep 2017 16:04:15 +1000 (AEST)
Received: from e4.eyal.emu.id.au (124-171-157-232.dyn.iinet.net.au [124.171.157.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pide.tip.net.au (Postfix) with ESMTPSA id 3xvz9V3myxz9BWV
        for <linux-media@vger.kernel.org>; Sun, 17 Sep 2017 16:04:13 +1000 (AEST)
Subject: Re: dvb_usb_rtl2832u vs dvb_usb_rtl28xxu
To: linux-media@vger.kernel.org
References: <70db3561-4d75-d79a-1d83-cc44eeb74426@eyal.emu.id.au>
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Message-ID: <7ba6e4ae-23f0-1ff8-3115-da152d52cced@eyal.emu.id.au>
Date: Sun, 17 Sep 2017 16:04:08 +1000
MIME-Version: 1.0
In-Reply-To: <70db3561-4d75-d79a-1d83-cc44eeb74426@eyal.emu.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/09/17 09:29, Eyal Lebedinsky wrote:
> I was running f19 and had dvb_usb_rtl2832u built from git handling my "Leadtek Winfast DTV2000 DS PLUS TV" tuners.
>      https://www.linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV2000DS_PLUS
>      I am using jaredquinn's driver
> 
> Yesterday I upgraded to f22 and the tuners stopped working. I discovered that dvb_usb_rtl2832u failed
> to build (my rc.local had rules for this). A small fix sorted this out but the tuners still did not
> work.
> 
> I then noticed a new module is activated, dvb_usb_rtl28xxu. I blacklisted it and now the tuners work.
> 
> My question: is dvb_usb_rtl28xxu supposed to handle this card?

   I now tried it and while it does not log issues at boot, and it does create the expected frontend devices,
   it fails to tune to any channel (using mythtv). I will try again after I upgrade to f26.

> Or should I continue to build the out of kernel module?
> Or, is there another module to handle this card now?
> 
> TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
