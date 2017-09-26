Return-path: <linux-media-owner@vger.kernel.org>
Received: from pide.tip.net.au ([203.10.76.2]:49454 "EHLO pide.tip.net.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934836AbdIZMNM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 08:13:12 -0400
Received: from pide.tip.net.au (pide.tip.net.au [IPv6:2401:fc00:0:107::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 3y1fx26GKnzFsy2
        for <linux-media@vger.kernel.org>; Tue, 26 Sep 2017 22:13:10 +1000 (AEST)
Received: from e4.eyal.emu.id.au (124-171-194-215.dyn.iinet.net.au [124.171.194.215])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pide.tip.net.au (Postfix) with ESMTPSA id 3y1fx25lkmz95QN
        for <linux-media@vger.kernel.org>; Tue, 26 Sep 2017 22:13:10 +1000 (AEST)
Subject: Re: [progress]: dvb_usb_rtl28xxu not tuning "Leadtek Winfast DTV2000
 DS PLUS TV"
To: list linux-media <linux-media@vger.kernel.org>
References: <00ad85dd-2fe3-5f15-6c0c-47fcf580f541@eyal.emu.id.au>
 <678bf4fa-5849-1fb2-adf1-a07458767d9e@eyal.emu.id.au>
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Message-ID: <1fb0dcc0-9202-75a7-c5e3-a744c8242a78@eyal.emu.id.au>
Date: Tue, 26 Sep 2017 22:13:09 +1000
MIME-Version: 1.0
In-Reply-To: <678bf4fa-5849-1fb2-adf1-a07458767d9e@eyal.emu.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-AU
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/09/17 14:32, Eyal Lebedinsky wrote:
> On 18/09/17 14:26, Eyal Lebedinsky wrote:
>> I have just upgraded to f24. I am now using the standard dvb_usb_rtl28xxu fe
>> which logs messages suggesting all is well (I get the /dev/dvb/adapter? etc.)
>> but I get no channels tuned when I run mythfrontend or scandvb.
>>
>> Is anyone using this combination?
>> Is this the correct way to use this tuner?
>>
>> BTW:
>>
>> Until f22 I was using the out of kernel driver from
>>      https://github.com/jaredquinn/DVB-Realtek-RTL2832U.git
>> but I now get a compile error.
>>
>> TIA
> 
> This is an FYI in case anyone else stumbles on this thread.
> 
> While the problem persists, I managed to find a way around it for now.
> 
> I changed the antenna input.
> 
> Originally I used a powered splitter to feed all the tuners, and it worked
> well with the out-of-kernel driver. This driver does not build or work with
> a more modern kernel so I shifted to using dvb_usb_rtl28xxu which fails to
> tune.
> 
> The new wiring splits (passive) the antenna in two, feeds one side directly
> to the two "Leadtek Winfast DTV2000 DS PLUS TV" cards (through another passive
> 2-way) and the other side goes to the old powered splitter that feeds a few
> USB tuners.
> 
> Now all tuners are happy. It seems that the "Leadtek Winfast DTV2000 DS PLUS TV"
> cannot handle the amplified input while the USB tuners require it.
> 
> I hope that there is a way to set a profile in dvb_usb_rtl28xxu to attenuate
> the input to an acceptable level thus unravelling the antenna cables rat-nest.

Looking further, I think that it is the fc0013 tuner that should manage the lna
but does not. Compare it to the module in here
	https://github.com/jaredquinn/DVB-Realtek-RTL2832U/blob/master/src/tuner_fc0013.c
which I was using successfully (unfortunately this repo does not build or work
with current linux kernels).

Is this possible? If so, can it be fixed?

cheers

> cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
