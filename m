Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48704 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbbBPUBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 15:01:10 -0500
Message-ID: <54E24C83.7090309@iki.fi>
Date: Mon, 16 Feb 2015 22:01:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Philip Downer <pdowner@prospero-tech.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/1]  [media] pci: Add support for DVB PCIe cards
 from Prospero Technologies Ltd.
References: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
In-Reply-To: <1424116126-14052-1-git-send-email-pdowner@prospero-tech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 02/16/2015 09:48 PM, Philip Downer wrote:
> The Vortex PCIe card by Prospero Technologies Ltd is a modular DVB card
> with a hardware demux, the card can support up to 8 modules which are
> fixed to the board at assembly time. Currently we only offer one
> configuration, 8 x Dibcom 7090p DVB-t tuners, but we will soon be releasing
> other configurations. There is also a connector for an infra-red receiver
> dongle on the board which supports RAW IR.
>
> The driver has been in testing on our systems (ARM Cortex-A9, Marvell Sheva,
> x86, x86-64) for longer than 6 months, so I'm confident that it works.
> However as this is the first Linux driver I've written, I'm sure there are
> some things that I've got wrong. One thing in particular which has been
> raised by one of our early testers is that we currently register all of
> our frontends as being attached to one adapter. This means the device is
> enumerated in /dev like this:
>
> /dev/dvb/adapter0/frontend0
> /dev/dvb/adapter0/dvr0
> /dev/dvb/adapter0/demux0
>
> /dev/dvb/adapter0/frontend1
> /dev/dvb/adapter0/dvr1
> /dev/dvb/adapter0/demux1
>
> /dev/dvb/adapter0/frontend2
> /dev/dvb/adapter0/dvr2
> /dev/dvb/adapter0/demux2
>
> etc.
>
> Whilst I think this is ok according to the spec, our tester has complained
> that it's incompatible with their software which expects to find just one
> frontend per adapter. So I'm wondering if someone could confirm if what
> I've done with regards to this is correct.

As I understand all those tuners are independent (could be used same 
time) you should register those as a 8 adapters, each having single 
frontend, dvr and demux.

regards
Antti

> I've tested this patch by applying it to current media-master and it applies
> cleanly and builds without issue for me.
>
> More information on the card can be found at:
> http://prospero-tech.com/vortex-1-dvb-t-pcie-card/
>
> Regards,
>
> Philip Downer
>
> Philip Downer (1):
>    [media] pci: Add support for DVB PCIe cards from Prospero Technologies
>      Ltd.
>
>   drivers/media/pci/Kconfig                     |    1 +
>   drivers/media/pci/Makefile                    |    2 +
>   drivers/media/pci/prospero/Kconfig            |    7 +
>   drivers/media/pci/prospero/Makefile           |    7 +
>   drivers/media/pci/prospero/prospero_common.h  |  264 ++++
>   drivers/media/pci/prospero/prospero_fe.h      |    5 +
>   drivers/media/pci/prospero/prospero_fe_main.c |  466 ++++++
>   drivers/media/pci/prospero/prospero_i2c.c     |  449 ++++++
>   drivers/media/pci/prospero/prospero_i2c.h     |    3 +
>   drivers/media/pci/prospero/prospero_ir.c      |  150 ++
>   drivers/media/pci/prospero/prospero_ir.h      |    4 +
>   drivers/media/pci/prospero/prospero_main.c    | 2086 +++++++++++++++++++++++++
>   12 files changed, 3444 insertions(+)
>   create mode 100644 drivers/media/pci/prospero/Kconfig
>   create mode 100644 drivers/media/pci/prospero/Makefile
>   create mode 100644 drivers/media/pci/prospero/prospero_common.h
>   create mode 100644 drivers/media/pci/prospero/prospero_fe.h
>   create mode 100644 drivers/media/pci/prospero/prospero_fe_main.c
>   create mode 100644 drivers/media/pci/prospero/prospero_i2c.c
>   create mode 100644 drivers/media/pci/prospero/prospero_i2c.h
>   create mode 100644 drivers/media/pci/prospero/prospero_ir.c
>   create mode 100644 drivers/media/pci/prospero/prospero_ir.h
>   create mode 100644 drivers/media/pci/prospero/prospero_main.c
>

-- 
http://palosaari.fi/
