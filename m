Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp057.webpack.hosteurope.de ([80.237.132.64]:41380 "EHLO
        wp057.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725895AbeKOG4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 01:56:32 -0500
Subject: Re: TechnoTrend CT2-4500 remote not working
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
References: <236ee34e-3052-f511-36c4-5dd48c6b433b@mknetz.de>
 <20181111214536.q2mplhfb5luzl5mg@gofer.mess.org>
From: "martin.konopka@mknetz.de" <martin.konopka@mknetz.de>
Message-ID: <64464af6-a85e-b03a-27e6-42cea34424d8@mknetz.de>
Date: Wed, 14 Nov 2018 21:51:38 +0100
MIME-Version: 1.0
In-Reply-To: <20181111214536.q2mplhfb5luzl5mg@gofer.mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> 
> It would be interesting to see what the device is sending. Please can you turn
> on dynamic debug for ir-kbd-i2c.c:
> 
> echo "file ir-kbd-i2.c +p" > /sys/kernel/debug/dynamic_debug/control
> 
> Try the remote again and report what in the kernel messages.
> 
>   
> Sean
> 

I turned on dynamic debug and got the following messages in the kernel log:

[  837.160992] rc rc0: get_key_fusionhdtv: ff ff ff ff
[  837.263927] rc rc0: ir_key_poll
[  837.264528] rc rc0: get_key_fusionhdtv: ff ff ff ff
[  837.367840] rc rc0: ir_key_poll
[  837.368441] rc rc0: get_key_fusionhdtv: ff ff ff ff

Pressing a key on the remote did not change the pattern. I rechecked the 
connection of the IR receiver to the card but it was firmly plugged in.

Martin
