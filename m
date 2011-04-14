Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62318 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1DNQ20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2011 12:28:26 -0400
Received: by gyd10 with SMTP id 10so522221gyd.19
        for <linux-media@vger.kernel.org>; Thu, 14 Apr 2011 09:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTin7iY81OSJfq=0m0TxZSE8CsNxxxA@mail.gmail.com>
References: <BANLkTin7iY81OSJfq=0m0TxZSE8CsNxxxA@mail.gmail.com>
Date: Thu, 14 Apr 2011 18:28:25 +0200
Message-ID: <BANLkTimQNN2hJ-JVbK5smO0Wd5YYHuEBoQ@mail.gmail.com>
Subject: Re: KNC ONE DVB-C [1894:0022] can't find any channels, PAT/SDT/NIT
 filter timeout
From: Frantisek Augusztin <faugusztin@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Apr 14, 2011 at 2:38 AM, Frantisek Augusztin
<faugusztin@gmail.com> wrote:
> Tested using Arch Linux 2.6.37-ARCH and current 2.6.39-rc3 kernels,
> same result.
>
> Signal level according to the set top box is ~57%, signal quality is
> 97-99%, and as i mentoined, set top box works without problems, and
> it works using this DVB-C card and same cable when using with Windows
> (but true, on different PC).

Small follow-up - moved the card to other PC (P67 board), installed a
completely different distribution (MythDora), result is exactly the
same - filter timeouts. Rebooting on same PC to Windows, leaving the
card and cable connection as is, i have no problems searching for
channels and watching them using the official Windows driver and
application (GlobeTV Digital).

I'm seriously out of ideas, the dmesg messages look right, even if i
can't find the device listed by exactly the same name on the wiki
(KNC1 DVB-C MK3), but i guess this is the TDA10023 revision mentioned
on wiki page :

Linux video capture interface: v2.00
saa7146: register extension 'budget_av'.
budget_av 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
saa7146: found saa7146 @ mem f8036000 (revision 1, irq 16) (0x1894,0x0022).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (KNC1 DVB-C MK3)
adapter failed MAC signature check
encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-0: MAC addr = 00:09:d6:6d:a5:f4
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
budget-av: ci interface initialised.
budget-av: cam inserted A
dvb_ca adapter 0: DVB CAM detected and initialised successfully
-- 
Frantisek Augusztin
