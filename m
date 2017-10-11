Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:47605 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752350AbdJKNqF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 09:46:05 -0400
Received: by mail-oi0-f42.google.com with SMTP id h200so3132713oib.4
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 06:46:05 -0700 (PDT)
MIME-Version: 1.0
From: Alexandre Da Costa <alexandre.dacosta1@gmail.com>
Date: Wed, 11 Oct 2017 15:46:04 +0200
Message-ID: <CAFN7RgCdDoURyS-3NFd_FiZ1gWizD=_eJcG=syWT8_PHg837yA@mail.gmail.com>
Subject: add support of Geniatech X9320 DVB-S2 quad tuner
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

I recently got a Geniatech X9320 DVB-S2 PCIe card :
https://www.geniatech.com/product/x9320-quad-dvb-s2s-tv-tuner/

The card is not listed in the LinuxTV so it's most probably not
supported as of now. I quickly tried it on a 4.9 kernel and it seems
that no driver was loaded.

On the hardware side, the board is based on the following ICs :
- Renesas =C2=B5PD720201 USB 3.0 controller (4 ports)
- Cypress CY68013 USB bridge
- Montage M88DS3103as demodulator
- Unknown RF Tuner but most probably Montage M88TS2022. If required, I
can remove the RF shield and have a look at the chip.

The board is very similar to the Geniatech HD Star (hardware V3.0) :
https://www.linuxtv.org/wiki/index.php/Geniatech_HD_Star_DVB-S2_USB2.0

However, it reports a different idProduct. Instead of 0x3000
(idProduct of Geniatech HD Star), it returns the following list
(different idProduct for each DVB-S2 tuner) :
Bus 001 Device 005: ID 1f4d:3300 G-Tek Electronics Group
Bus 001 Device 004: ID 1f4d:3301 G-Tek Electronics Group
Bus 001 Device 003: ID 1f4d:3302 G-Tek Electronics Group
Bus 001 Device 002: ID 1f4d:3303 G-Tek Electronics Group

I assume that since the hardware is almost the same, the drivers used
for the HD Star should work with the X9320 card by adding the new
idProduct.

I've no experience in Linux driver development but I would give it a
try if someone can show me where to look at.

Regards,
Alex
