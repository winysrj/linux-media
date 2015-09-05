Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:36279 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbbIEL2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Sep 2015 07:28:16 -0400
Received: by lanb10 with SMTP id b10so27187056lan.3
        for <linux-media@vger.kernel.org>; Sat, 05 Sep 2015 04:28:15 -0700 (PDT)
Received: from faustian.sytes.net (77-254-35-59.adsl.inetia.pl. [77.254.35.59])
        by smtp.googlemail.com with ESMTPSA id au10sm1296192lbc.1.2015.09.05.04.28.13
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 05 Sep 2015 04:28:13 -0700 (PDT)
Message-ID: <55EAD1CC.1090303@gmail.com>
Date: Sat, 05 Sep 2015 13:28:12 +0200
From: =?UTF-8?B?UGF3ZcWCIEtpZcWCa293c2tp?= <kielkowski.pawel@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: noise after modprobe cx8800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have also another issue after switching from Fedora 16 to Fedora 22.
Every time the cx8800 module is loaded I hear annoying high-pitched
noise until I open tvtime. After closing tvtime there is no sound
anymore. Similar case was already reported here:
http://video4linux-list.redhat.narkive.com/I1MD0PsM/cx88-white-noise-with-audio-cable-no-sound-with-cx88-alsa
But it is very old case (even pre-F16) and seems that it did not get any
attention.

I have the TV card connected to soundcard’s Line In as I couldn’t get
the cx88-alsa to work. Is that so, if I do not see the corresponding
"…[Audio Port]…" in lspci, that my card does not support the DMA sound
and cx88-alsa won’t work? At boot cx88-alsa is not loaded at all and if
I load it by myself there is no log output apart from "cx2388x alsa
driver version 0.0.9 loaded". No new audio device is created or anything
like that.

Fedora 16 kernel: 3.6.11-4.fc16.i686.PAE
Fedora 22 kernel: 4.1.6-200.fc22.x86_64
TV card: 01:09.0 Multimedia video controller [0400]: Conexant Systems,
Inc. CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
        Subsystem: LeadTek Research Inc. Winfast TV 2000XP Expert
[107d:6611]
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx8800
        Kernel modules: cx8800

Line In is not muted in Fedora 16. I use following options:
"options cx88xx card=5 tuner=38 i2c_scan=1"

Best regards
PK
