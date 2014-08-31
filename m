Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:32838 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHaPFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 11:05:33 -0400
Received: by mail-lb0-f172.google.com with SMTP id 10so4753426lbg.17
        for <linux-media@vger.kernel.org>; Sun, 31 Aug 2014 08:05:31 -0700 (PDT)
Message-ID: <54033A14.10309@googlemail.com>
Date: Sun, 31 Aug 2014 17:07:00 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: oravecz@nytud.mta.hu
CC: linux-media@vger.kernel.org
Subject: Re: HVR 900 (USB ID 2040:6500) no analogue sound reloaded
References: <201408221903.s7MJ3IT28956@ny01.nytud.hu>
In-Reply-To: <201408221903.s7MJ3IT28956@ny01.nytud.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 22.08.2014 um 21:03 schrieb Oravecz Csaba:
> I reported this issue earlier but for some reason it went pretty much
> unnoticed. The essence is that with the newest em28xx drivers now present in
> 3.14 kernels (i'm on stock fedora 3.14.15-100.fc19.i686.PAE) I can't get
> analogue sound from this card.
>
> I see that the code snippet that produced this output in the pre 3.14 versions
>
> em2882/3 #0: Config register raw data: 0x50
> em2882/3 #0: AC97 vendor ID = 0xffffffff
> em2882/3 #0: AC97 features = 0x6a90
> em2882/3 #0: Empia 202 AC97 audio processor detected
>
> is still there in em28xx-core.c, however, there is nothing like that in
> current kernel logs so it seems that this part of the code is just skipped,
> which I tend to think is not the intended behaviour. I have not gone any
> further to investigate the issue, rather I've simply copied the 'old' em28xx
> directory over the current one in the latest source and compiled the drivers
> in this way and so got back the old em28xx version, which is working well in
> the current kernel as well.
>
> I don't consider this an optimal solution so 
> I would very much appreciate any help in this issue.
>
> best,
> o.cs.

Thank you for reporting this issue.
I suspect reverting commit b99f0aadd3 "[media] em28xx: check if a device
has audio earlier" will resolve it.
Can you check that ?

Regards,
Frank
