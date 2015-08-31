Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33073 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbHaUAT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 16:00:19 -0400
Received: by laboe4 with SMTP id oe4so52475188lab.0
        for <linux-media@vger.kernel.org>; Mon, 31 Aug 2015 13:00:17 -0700 (PDT)
Received: from faustian.sytes.net (178-36-220-161.adsl.inetia.pl. [178.36.220.161])
        by smtp.googlemail.com with ESMTPSA id lu1sm4211380lac.37.2015.08.31.13.00.16
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:00:16 -0700 (PDT)
Message-ID: <55E4B250.3090109@gmail.com>
Date: Mon, 31 Aug 2015 22:00:16 +0200
From: =?UTF-8?B?UGF3ZcWCIEtpZcWCa293c2tp?= <kielkowski.pawel@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: tvtime cannot set PAL-DK for cx88 device
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Last week I made a big jump from Fedora 16 to Fedora 22 and tvtime is no
longer able to set the PAL-DK norm. What I am getting is: "videoinput:
Driver refuses to set norm: Device or resource busy". There is no such
message when running tvtime on Fedora 16.
I presume that following change introduced this check.
http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=078859a3230c123ed9cb798fb1cd7f89b4fde102

Fedora 16 kernel: 3.6.11-4.fc16.i686.PAE
Fedora 22 kernel: 4.1.6-200.fc22.x86_64
tvtime 1.0.7 from git on both systems
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

Best regards
PK
