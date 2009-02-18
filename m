Return-path: <linux-media-owner@vger.kernel.org>
Received: from 217-112-173-73.cust.avonet.cz ([217.112.173.73]:33519 "EHLO
	podzimek.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbZBRWKw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 17:10:52 -0500
Message-ID: <499C863B.5000507@podzimek.org>
Date: Wed, 18 Feb 2009 23:05:47 +0100
From: Andrej Podzimek <andrej@podzimek.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3 works, but keys get stuck
References: <49738339.9030203@podzimek.org> <4973900C.6090406@iki.fi>
In-Reply-To: <4973900C.6090406@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> After reloading the module, the remote control (almost) worked. Unfortunately, keys got stuck somehow, just as if I were holding a key on the keyboard. Another key press changed the event being repeated, but there seemed to be *no* key release events at all.
>>
>> Pressing the channel up/down keys seemed to stop that key event flood, but both of my keyboards (one on the laptop and an external one) stopped working. Again, this may have been due to the absence of a key release event. (This time the key events were not that obvious, since channel up/down does not produce an alphanumeric key code.)
>>
>> I use kernel 2.6.27.10, revision af9015-57423d241699 and (presumably) MSI Digivox Mini II V3.
>>
>> Either I misunderstood / misconfigured something, or this could be a bug. I'm not familiar with this source code and don't have time to explore it in detail. However, feel free to ask for debugging output and other data you may need.
> 
> This seems to be hw bug. For more information:
> 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-November/030292.html

Hello,

Those quirks worked perfectly fine before I switched to kernel 2.6.28. (I use 2.6.28.6 at the moment.) Now I have the same problem again. Is there a new workaround? Tried the driver included in the kernel and the mercurial tree. Keys remain „down“ in both cases.

Regards,

Andrej Podzimek
