Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39199 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab1AaShm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Jan 2011 13:37:42 -0500
Received: by bwz15 with SMTP id 15so5529506bwz.19
        for <linux-media@vger.kernel.org>; Mon, 31 Jan 2011 10:37:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikaHBXmf_EE7UwJNDwESYcdM8x=6eRukuNEPZ2c@mail.gmail.com>
References: <AANLkTikaHBXmf_EE7UwJNDwESYcdM8x=6eRukuNEPZ2c@mail.gmail.com>
Date: Mon, 31 Jan 2011 19:37:40 +0100
Message-ID: <AANLkTikaNR28srMnQ0Ga1v6XzUai-Qz3Q1+fRdBi=nw-@mail.gmail.com>
Subject: Re: Asus U3100 Mini Plus
From: Michal Bojda <rexearth.mbojda@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Here are some specifications.

Chip : AF9035A
Demodulator : AF9035B
Tuner : FCI2580

lsusb :

Bus 002 Device 005: ID 045e:074f Microsoft Corp.
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 016: ID 0b05:1779 ASUSTek Computer, Inc.
Bus 001 Device 004: ID 04f2:b033 Chicony Electronics Co., Ltd
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

dmesg :

[141187.393085] usb 1-1: new high speed USB device using ehci_hcd and address 16
[141187.531276] usb 1-1: configuration #1 chosen from 1 choice
[141187.538888] af9035: tuner ID:50 not supported, please report!
[141187.543044] input: Afa Technologies Inc. AF9035A USB Device as
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1:1.1/input/input25
[141187.543160] generic-usb 0003:0B05:1779.000F: input,hidraw1: USB
HID v1.01 Keyboard [Afa Technologies Inc. AF9035A USB Device] on
usb-0000:00:04.1-1/input1


It looks that it is something with USBHID, but i didnt found any
/etc/modprobe.d/usbhid.conf to change. Kernel version I got is
2.6.32-28-generic-pae, Ubuntu 10.4.

[141187.538888] af9035: tuner ID:50 not supported, please report!
-----   I tried to make some changes, so this line is maybe my work.

I will be glad for any help. Thanks.

M. Bojda

2011/1/30 Michal Bojda <rexearth.mbojda@gmail.com>:
> Hello there,
>
> DVB-T card passed trough my hands. Asus U3100 Mini Plus. I was looking
> trough the internet, to make it working, but still dont have succes.
> Any1 met with this card and make it works ?
>
> Thanks, best regards M. Bojda
>
> --
> Those who watches their backs, meet death from the front.
>



-- 
Those who watches their backs, meet death from the front.
