Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36879 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755329AbdGXTAN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 15:00:13 -0400
Received: by mail-pg0-f52.google.com with SMTP id y129so60753034pgy.4
        for <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 12:00:13 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Date: Mon, 24 Jul 2017 12:00:12 -0700
Message-ID: <CAOcMMiftY+VXTCWZRR8FKbUNr4uDGkZ+X0OZfzJQMQDa8WC8uw@mail.gmail.com>
Subject: Kabylake atomisp driver?
To: alan@linux.intel.com, Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

At Endless we are trying to support an Asus T304UA convertible
tablet/laptop, which has the following controller:

00:14.3 Multimedia controller [0480]: Intel Corporation Device
[8086:9d32] (rev 01)
Subsystem: ASUSTeK Computer Inc. Device [1043:1d2d]
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin A routed to IRQ 255
Region 0: Memory at ef510000 (64-bit, non-prefetchable) [disabled] [size=3D=
64K]
Capabilities: [90] MSI: Enable- Count=3D1/1 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [d0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3cold-=
)
Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D0 PME-

I believe this is similar to the controllers driver by the atomisp2
driver, which recently made into staging -- but this is a Kabylake
processor, not a Baytrail / Cherrytrail.

Do you guys know anything about this controller? Has any linux driver
for it been seen out there in the wild (like in an Android code dump)?

Thanks and best regards,

...........................................................................=
...........
Jo=C3=A3o Paulo Rechi Vita  |  +1.415.851.5778  |  Endless
