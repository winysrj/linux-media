Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38278 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbbK0WPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 17:15:45 -0500
Received: by wmec201 with SMTP id c201so72283635wme.1
        for <linux-media@vger.kernel.org>; Fri, 27 Nov 2015 14:15:43 -0800 (PST)
Received: from ?IPv6:2003:62:5f55:ba00:b5bb:17e1:e888:2713? (p200300625F55BA00B5BB17E1E8882713.dip0.t-ipconnect.de. [2003:62:5f55:ba00:b5bb:17e1:e888:2713])
        by smtp.googlemail.com with ESMTPSA id jz1sm34696907wjc.27.2015.11.27.14.15.43
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 27 Nov 2015 14:15:43 -0800 (PST)
To: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Can't access CIR wakeup registers of Nuvoton 6779D
Message-ID: <5658D601.2000907@gmail.com>
Date: Fri, 27 Nov 2015 23:15:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Zotac CI321 mini-PC which uses a Nuvoton 6779D (or compatible) Super-IO
for infrared remote control. The normal CIR part works flawlessly however I can't
access the wakeup registers.
Resource allocation works normal, /proc/ioports reports:

0220-022e : nuvoton-cir-wake
02e0-02ee : nuvoton-cir

Also configuring the logical device works normal as can be seen in the debug output.
However all reads to this ioport region fail.
I tried manually changing the ioport region but this didn't help either.

Meanwhile I'm wondering whether there might be stripped down versions of this chip
w/o the wake functionality as I'm running out of other ideas.
Appreciate any hint.

[ 7608.622878] nuvoton_cir: nuvoton-cir: Dump CIR logical device registers:
[ 7608.622949] nuvoton_cir:  * CR CIR ACTIVE :   0x1
[ 7608.623005] nuvoton_cir:  * CR CIR BASE ADDR: 0x2e0
[ 7608.623059] nuvoton_cir:  * CR CIR IRQ NUM:   0x3
[ 7608.623109] nuvoton_cir: nuvoton-cir: Dump CIR registers:
[ 7608.623166] nuvoton_cir:  * IRCON:     0x36
[ 7608.623210] nuvoton_cir:  * IRSTS:     0x0
[ 7608.623255] nuvoton_cir:  * IREN:      0x60
[ 7608.623299] nuvoton_cir:  * RXFCONT:   0x0
[ 7608.623344] nuvoton_cir:  * CP:        0x0
[ 7608.623388] nuvoton_cir:  * CC:        0x0
[ 7608.623432] nuvoton_cir:  * SLCH:      0x7
[ 7608.623478] nuvoton_cir:  * SLCL:      0xd0
[ 7608.623524] nuvoton_cir:  * FIFOCON:   0x23
[ 7608.623569] nuvoton_cir:  * IRFIFOSTS: 0x96
[ 7608.623614] nuvoton_cir:  * SRXFIFO:   0x84
[ 7608.623659] nuvoton_cir:  * TXFCONT:   0x0
[ 7608.623706] nuvoton_cir:  * STXFIFO:   0x0
[ 7608.623762] nuvoton_cir:  * FCCH:      0x0
[ 7608.623808] nuvoton_cir:  * FCCL:      0x0
[ 7608.623853] nuvoton_cir:  * IRFSM:     0x14
[ 7608.623904] nuvoton_cir: nuvoton-cir: Dump CIR WAKE logical device registers:
[ 7608.623979] nuvoton_cir:  * CR CIR WAKE ACTIVE :   0x1
[ 7608.624039] nuvoton_cir:  * CR CIR WAKE BASE ADDR: 0x220
[ 7608.624097] nuvoton_cir:  * CR CIR WAKE IRQ NUM:   0x3
[ 7608.624151] nuvoton_cir: nuvoton-cir: Dump CIR WAKE registers
[ 7608.624210] nuvoton_cir:  * IRCON:          0xff
[ 7608.624258] nuvoton_cir:  * IRSTS:          0xff
[ 7608.624308] nuvoton_cir:  * IREN:           0xff
[ 7608.624356] nuvoton_cir:  * FIFO CMP DEEP:  0xff
[ 7608.624404] nuvoton_cir:  * FIFO CMP TOL:   0xff
[ 7608.624453] nuvoton_cir:  * FIFO COUNT:     0xff
[ 7608.624502] nuvoton_cir:  * SLCH:           0xff
[ 7608.624550] nuvoton_cir:  * SLCL:           0xff
[ 7608.625897] nuvoton_cir:  * FIFOCON:        0xff
[ 7608.627204] nuvoton_cir:  * SRXFSTS:        0xff
[ 7608.628481] nuvoton_cir:  * SAMPLE RX FIFO: 0xff
[ 7608.629393] nuvoton_cir:  * WR FIFO DATA:   0xff
[ 7608.630157] nuvoton_cir:  * RD FIFO ONLY:   0xff
[ 7608.630906] nuvoton_cir:  * RD FIFO ONLY IDX: 0xff
[ 7608.631648] nuvoton_cir:  * FIFO IGNORE:    0xff
[ 7608.632380] nuvoton_cir:  * IRFSM:          0xff
[ 7608.633085] nuvoton_cir: nuvoton-cir: Dump CIR WAKE FIFO (len 255)
