Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64204 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab1LSUpj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 15:45:39 -0500
Received: by lagp5 with SMTP id p5so2308596lag.19
        for <linux-media@vger.kernel.org>; Mon, 19 Dec 2011 12:45:37 -0800 (PST)
MIME-Version: 1.0
Reply-To: tomas.skocdopole@ippolna.cz
Date: Mon, 19 Dec 2011 21:45:37 +0100
Message-ID: <CALobSDoades+k8G2aGOHBxQuoXH6_9sHQmbO3LrLbp8wA41p7g@mail.gmail.com>
Subject: Airstar 2 PCI CX24123: wrong demod revision: 87
From: =?UTF-8?B?VG9tw6HFoSBTa2/EjWRvcG9sZQ==?=
	<tomas.skocdopole@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've bought a DVB-T card Airstar 2 PCI. I've found an error from about
CX24123 from dmesg output:
[    3.242141] CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
[    3.242176] CX24123: wrong demod revision: 87


Full output is here:
[    3.225961] b2c2-flexcop: found 'Zarlink MT352 DVB-T' .
[    3.225965] DVB: registering adapter 0 frontend 0 (Zarlink MT352 DVB-T)...
[    3.226030] b2c2-flexcop: initialization of 'Air2PC/AirStar 2
DVB-T' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
[    3.228095] flexcop-pci: will use the HW PID filter.
[    3.228097] flexcop-pci: card revision 2
[    3.228107] b2c2_flexcop_pci 0000:05:02.0: PCI INT A -> GSI 18
(level, low) -> IRQ 18
[    3.240137] DVB: registering new adapter (FlexCop Digital TV device)
[    3.241710] b2c2-flexcop: MAC address = 00:d0:d7:0d:d5:0a
[    3.242141] CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
[    3.242176] CX24123: wrong demod revision: 87

I am using latest kernel from Archlinux repository
Linux dvb 3.1.5-1-ARCH #1 SMP PREEMPT Sat Dec 10 14:43:09 CET 2011
x86_64 Intel(R) Core(TM)2 Duo CPU E7200 @ 2.53GHz GenuineIntel
GNU/Linux

Can anyone help me please?

Thanks
Regards Tomas
