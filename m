Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46152 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab0EYOYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 10:24:21 -0400
Received: by gyg13 with SMTP id 13so2001553gyg.19
        for <linux-media@vger.kernel.org>; Tue, 25 May 2010 07:24:20 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 May 2010 17:24:19 +0300
Message-ID: <AANLkTikeN4JrQXd-5SkiyhfyAqNQgaI10ofT_V9XURrk@mail.gmail.com>
Subject: Problem with decrypting dvb-s channels
From: OJ <olejl77@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Technotrend S-1500 DVB card:
04:01.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
       Subsystem: Technotrend Systemtechnik GmbH Device 1017
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
       Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 64 (3750ns min, 9500ns max)
       Interrupt: pin A routed to IRQ 17
       Region 0: Memory at febffc00 (32-bit, non-prefetchable) [size=512]
       Kernel driver in use: budget_ci dvb
       Kernel modules: budget-ci

$ dmesg | grep dvb
[   17.596948] saa7146: register extension 'budget_ci dvb'.
[   17.673434] budget_ci dvb 0000:04:01.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[   17.742536] input: Budget-CI dvb ir receiver saa7146 (0) as
/devices/pci0000:00/0000:00:1e.0/0000:04:01.0/input/input7
[   17.851584] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[   26.880221] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[  769.995583] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[ 2017.120157] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[ 2034.781417] dvb_ca adapter 0: DVB CAM detected and initialised successfully
[265057.101369] dvb_ca adapter 0: DVB CAM detected and initialised successfully


I have tried several players. MythTV, MPlayer, Kaffeine. All of them
shows unencrypted channels OK, but will not play any of the encrypted
channels.

This was working fine a couple of months back with the same HW. My
MythTV frontend was broken so I did not use the system. When I tried
again now it is not working as described above. I have tested the
Smart Card in my Humax receiver, and it is working ok there.

I have tried to boot an older kernel, and the same problem exists.
What could be my problem? Is there anything I can do to debug the
problem?
