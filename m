Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36203 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0IUIpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Sep 2010 04:45:54 -0400
Received: by yxp4 with SMTP id 4so1557087yxp.19
        for <linux-media@vger.kernel.org>; Tue, 21 Sep 2010 01:45:54 -0700 (PDT)
MIME-Version: 1.0
From: Dejan Rodiger <dejan.rodiger@gmail.com>
Date: Tue, 21 Sep 2010 10:45:34 +0200
Message-ID: <AANLkTimv3PH6pTOgk3KxGw4TiZUOcwr5S4rio96t9-Jw@mail.gmail.com>
Subject: Asus MyCinema P7131 Dual support
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I am using Ubuntu linux 10.10 with the latest kernel 2.6.35-22-generic
on x86_64. I have installed nonfree firmware which should support this
card, but to be sure, can somebody confirm that my TV card is
supported in Analog or DVB mode?

sudo lspci -vnn
01:06.0 Multimedia controller [0480]: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
        Subsystem: ASUSTeK Computer Inc. My Cinema-P7131 Hybrid [1043:4876]
        Flags: bus master, medium devsel, latency 32, IRQ 18
        Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: saa7134
        Kernel modules: saa7134

It says Hybrid, but I put the following in the /etc/modprobe.d/saa7134.conf
options saa7134 card=78 tuner=54


Thanks
--
Dejan Rodiger
S: callto://drodiger
