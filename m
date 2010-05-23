Return-path: <linux-media-owner@vger.kernel.org>
Received: from fe02x03-cgp.akado.ru ([77.232.31.165]:64367 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752228Ab0EWHfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 03:35:37 -0400
Date: Sun, 23 May 2010 10:33:44 +0400
From: Boris Popov <popov@stdin.info>
To: linux-media@vger.kernel.org
Subject: Pinnacle capture card
Message-ID: <20100523063344.GA4704@phenom.router.popov.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I have a capture card.
It has input RCA and S-Video, output - RCA and S-Video.
Also it has FireWire.
Card looks like the picture [1].

Card has an inscription: "Pinnacle Systems Bendino V1.0A".

It has chips:
	- saa7113h  [2]
	- adv7179   [3]
	- mb87j3560 [4]


It is my lspci output:


phenom:/home/boris-testing# lspci -s 03:06
03:06.0 Multimedia controller: Pinnacle Systems Inc. AV/DV Studio Capture Card
03:06.1 FireWire (IEEE 1394): Pinnacle Systems Inc. Device 0015

phenom:/home/boris-testing# lspci -s 03:06 -vvn
03:06.0 0480: 11bd:bede
        Subsystem: 11bd:0002
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 4000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at feb00000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

03:06.1 0c00: 11bd:0015 (prog-if 10 [OHCI])
        Subsystem: 11bd:0002
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at feb01000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-



What should I do?

Thanks.

[1] http://c1.neweggimages.com/NeweggImage/productimage/15-144-033-02.jpg
[2] http://www.ixbt.com/divideo/movie-box-board/saa7113h.jpg
[3] http://www.ixbt.com/divideo/movie-box-board/adv7179.jpg 
[4] http://www.ixbt.com/divideo/movie-box-board/mb87j3560.jpg
