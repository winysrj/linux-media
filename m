Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46042 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab1LFOf1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 09:35:27 -0500
Received: by eaak14 with SMTP id k14so5159678eaa.19
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2011 06:35:25 -0800 (PST)
Message-ID: <4EDE27A0.8060406@gmail.com>
Date: Tue, 06 Dec 2011 15:33:04 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/1] xc3028: force reload of DTV7 firmware in VHF band with
 Zarlink demodulator
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I have a Terratec Cinergy Hybrid T USB XS stick (USB 0ccd:0042).
This device is made of the following components:
- Empiatech em2880 USB bridge;
- Zarlink zl10353 demodulator;
- Xceive XC3028 tuner;

For this device, the ZARLINK456 define is set to true so it is using the
firmwares with type D2633 for the XC3028 tuner.

I found out that:
1) the DTV7 firmware works fine in VHF band (bw=7MHz);
2) the DTV8 firmware works fine in UHF band (bw=8MHz);
3) the DTV78 firmware works fine in UHF band (bw=8MHz) but it doesn not
work at all in VHF band (bw=7MHz);

In fact, when the DTV78 firmware is loaded and I try to tune a VHF
channel, the frequency lock is ciclically acquired for a second and
immediately lost.
So the proposed patch forces a reload of the DTV7 firmware every time a
7MHz channel is requested.
The only drawback is that channel change from VHF to UHF or viceversa is
slightly slower.
Devices using the D2620 firmwares are unaffected.

Best regards,
Gianluca Gennari
