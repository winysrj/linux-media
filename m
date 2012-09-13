Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49109 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825Ab2IMVBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 17:01:13 -0400
Received: by eekc1 with SMTP id c1so2177715eek.19
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2012 14:01:11 -0700 (PDT)
Message-ID: <1347570063.2848.24.camel@Route3278>
Subject: Re: ITE9135 on AMD SB700 - ehci_hcd bug
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Marx <acc.for.news@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Thu, 13 Sep 2012 22:01:03 +0100
In-Reply-To: <ksm5i9-2t1.ln1@wuwek.kopernik.gliwice.pl>
References: <ksm5i9-2t1.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-09-12 at 08:32 +0200, Marx wrote:
> Hello
> I'm trying to use dual DVB-T tuner based on ITE9135 tuner. I use Debian 
> kernel 3.5-trunk-686-pae. My motherboard is AsRock E350M1 (no USB3 ports).
> Tuner is detected ok, see log at the end of post.
> 
> When I try to scan channels, bug happens:
> Sep 11 17:16:31 wuwek kernel: [  209.291329] ehci_hcd 0000:00:13.2: 
> force halt; handshake f821a024 00004000 00000000 -> -110
> Sep 11 17:16:31 wuwek kernel: [  209.291401] ehci_hcd 0000:00:13.2: HC 
> died; cleaning up
> Sep 11 17:16:31 wuwek kernel: [  209.291606] usb 2-3: USB disconnect, 
> device number 2
> Sep 11 17:16:41 wuwek kernel: [  219.312848] dvb-usb: error while 
> stopping stream.
> Sep 11 17:16:41 wuwek kernel: [  219.320585] dvb-usb: ITE 9135(9006) 
> Generic successfully deinitialized and disconnected.
> 
> After trying many ways I've read about problems with ehci on SB700 based 
> boards and switched off ehci via command
> sh -c 'echo -n "0000:00:13.2" > unbind'
> and now ehci bug doesn't happen. Of course I can see only one tuner and 
> in slower USB mode (see log at the end). But now I can scan succesfully 
> without any errors.
> 
> Of course it isn't acceptable fix for my problem. Drivers for ITE9135 
> seems ok, but there is a problem with ehci_hcd on my motherboard.
> I would like to know what can I do to fix my problem.
> 
Hi Marx

The only thing I can think of is the firmware for dual ite 9135(9006)
chip version 1 may be different.

Make sure you only scan on adapter 0 on ehci.

If you want to send me privately a copy of the IT9135BDA.sys file
from /WINDOWS/system32/drivers directory. I can extract and test that
firmware against the devices I have and eliminate the Linux driver.

Regards


Malcolm









