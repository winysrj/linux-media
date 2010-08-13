Return-path: <mchehab@pedra>
Received: from blu0-omc2-s19.blu0.hotmail.com ([65.55.111.94]:44721 "EHLO
	blu0-omc2-s19.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934340Ab0HMNvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 09:51:47 -0400
Message-ID: <BLU0-SMTP664E69E794AD6D8EAB4A1BD8980@phx.gbl>
From: Stefan <tuxoholic@hotmail.de>
Reply-To: tuxoholic@hotmail.de
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt
Date: Fri, 13 Aug 2010 15:51:41 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello Marko

I confirm this patch reduces the amount of interrupts to nearly one third:

[*] v4l mercurial wo patch: about 600 calls/sec over a 10 seconds interval
[*] v4l mercurial with patch: about 160 calls/sec over a 10 seconds interval

Measured using powertop -t 10
Tuning a Twinhan/Azurewave AD SP400 CI (VP-1041) with szap

The same ratio using vdr 1.7.15 + xineliboutput + vdr-sfxe:

[*] wo patch: about 1100 calls/sec over a 10 seconds interval
[*] with patch: about 320 calls/sec over a 10 seconds interval

Regards,
Stefan

>
> This patch obsoletes patch with broken spaces
> https://patchwork.kernel.org/patch/107036/
> 
> With VDR streaming HDTV into network, generating an interrupt once per 16kb,
> implemented in this patch, seems to support more robust throughput with 
> HDTV.
> Fix leaking almost 64kb data from the previous TS after changing the TS.
> One effect of the old version was, that the DMA transfer and driver's
> DMA buffer access might happen at the same time - a race condition.
> 
> Signed-off-by: Marko M. Ristola <marko.ristola@xxxxxxxxxxxx>
> 
> Regards,
> Marko Ristola
>
