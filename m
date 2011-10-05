Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsmtpvtin3.tin.it ([212.216.176.241]:52377 "EHLO
	vsmtpvtin3.tin.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934188Ab1JEK10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 06:27:26 -0400
Received: from [192.168.1.3] (95.247.48.127) by vsmtpvtin3.tin.it (8.5.132) (authenticated as loycfd)
        id 4D95A775037BD5AB for linux-media@vger.kernel.org; Wed, 5 Oct 2011 12:27:23 +0200
Message-ID: <4E8C3109.7020709@tin.it>
Date: Wed, 05 Oct 2011 12:27:21 +0200
From: LD <loycfd@tin.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: RE.request information
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the reply.

As suggested in the possible numbers of cards, I found the number (card 
= 174) which allows the card to scan for TV frequencies.
Unfortunately the scan does not finish successfully, because it also 
needs the identification of the tuner. Have suggestions for the number 
of tuners.
Waiting for your suggestion for the number of tuners to try, I would 
like to write for confirmation of ASUSTeK (Device [1043:8188]) have an 
address where I can write.

Thank you for the answer

LD

Il 03/10/2011 20:50, Charlie X. Liu ha scritto:
> Checking in the CARDLIST.saa7134 (
> http://www.mjmwired.net/kernel/Documentation/video4linux/CARDLIST.saa7134 
> ),
> sounds, it (Device [1043:8188]) is not in the CARDLIST yet. Then, you may
> check with ASUSTeK and see which one in the CARDLIST is closer to it. 
> Like:
>
> 78  ->  ASUSTeK P7131 Dual                       [1043:4862]
> 112 ->  ASUSTeK P7131 Hybrid                     [1043:4876]
> 146 ->  ASUSTeK P7131 Analog
> ..
> ..
> 174 ->  Asus Europa Hybrid OEM                   [1043:4847]
>
>
> -----Original Message-----
> From: linux-media-owner@vger.kernel.org
> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of LD
> Sent: Sunday, October 02, 2011 7:47 AM
> To: linux-media@vger.kernel.org
> Subject: request information
>
> I would like to know which firmware and drivers are helpful to install
> and set this type of card:
>
> Multimedia controller [0480]: Philips Semiconductors
> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d0)
> Subsystem: ASUSTeK Computer Inc. Device [1043:8188]
> Control: I/O- Mem + BusMaster +
> SpecCycle-MemWINV-VGASnoop-ParErr-Stepping-SERR-FastB2B-DisINTx-
> Status: Cap + 66MHz-UDF-FastB2B + ParErr-DEVSEL = medium>
> TAbort-<TAbort-<MAbort->  SERR-<PERR-intX-
> Latency: 64 (21000ns min, 8000ns max)
> Interrupt: pin A routed to IRQ 23
> Region 0: Memory at dbedb800 (32-bit, non-prefetchable) [size = 2K]
> Capabilities:<access denied>
> Kernel driver in use: saa7134
> Kernel modules: saa7134
>
> Thank you for the answer
>
> LD
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
