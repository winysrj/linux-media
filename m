Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37890 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752892AbdJQKXg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 06:23:36 -0400
Date: Tue, 17 Oct 2017 13:23:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: =?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@endlessm.com>
Cc: alan@linux.intel.com, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: Kabylake atomisp driver?
Message-ID: <20171017102334.nif6koaba53u7k6z@valkosipuli.retiisi.org.uk>
References: <CAOcMMiftY+VXTCWZRR8FKbUNr4uDGkZ+X0OZfzJQMQDa8WC8uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOcMMiftY+VXTCWZRR8FKbUNr4uDGkZ+X0OZfzJQMQDa8WC8uw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joãn,

On Mon, Jul 24, 2017 at 12:00:12PM -0700, João Paulo Rechi Vita wrote:
> At Endless we are trying to support an Asus T304UA convertible
> tablet/laptop, which has the following controller:
> 
> 00:14.3 Multimedia controller [0480]: Intel Corporation Device
> [8086:9d32] (rev 01)
> Subsystem: ASUSTeK Computer Inc. Device [1043:1d2d]
> Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Interrupt: pin A routed to IRQ 255
> Region 0: Memory at ef510000 (64-bit, non-prefetchable) [disabled] [size=64K]
> Capabilities: [90] MSI: Enable- Count=1/1 Maskable- 64bit+
> Address: 0000000000000000  Data: 0000
> Capabilities: [d0] Power Management version 3
> Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> 
> I believe this is similar to the controllers driver by the atomisp2
> driver, which recently made into staging -- but this is a Kabylake
> processor, not a Baytrail / Cherrytrail.
> 
> Do you guys know anything about this controller? Has any linux driver
> for it been seen out there in the wild (like in an Android code dump)?

This is the CIO2 CSI-2 receiver.

A driver for it has been posted to the list, the latest version is in a set
called "[PATCH v5 0/3] [media] add IPU3 CIO2 CSI2 driver".

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
