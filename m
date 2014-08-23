Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep17.mx.upcmail.net ([62.179.121.37]:63232 "EHLO
	fep17.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaHWLuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 07:50:25 -0400
Message-ID: <1408794617.7936.2.camel@bjoern-W35xSTQ-370ST>
Subject: Re: [PATCH 0/5] Digital Devices PCIe bridge update to 0.9.15a
From: Bjoern <lkml@call-home.ch>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Sat, 23 Aug 2014 13:50:17 +0200
In-Reply-To: <1406951335-24026-1-git-send-email-crope@iki.fi>
References: <1406951335-24026-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

It's been 3 weeks since these patches were submitted - have they been
merged yet? If not - what's the problem? Who has to check this?

I'm not the only one longing for driver updated support of ddbridge "by
default", and it would really be nice if there was some "progress" here.
Antti did a lot of work here for all us ddbridge users.

Regards,
Bjoern

On Sa, 2014-08-02 at 06:48 +0300, Antti Palosaari wrote:
> After cold power-on, my device wasn't able to find DuoFlex C/C2/T/T2
> Expansion card, which I added yesterday. I looked old and new drivers
> and tried many things, but no success. Old kernel driver was ages,
> many years, behind manufacturer current Linux driver and there has
> been a tons of changes. So I ended up upgrading Linux kernel driver
> to 0.9.15a (it was 0.5).
> 
> Now it is very near Digital Devices official driver, only modulator
> and network streaming stuff is removed and CI is abusing SEC like
> earlier also.
> 
> Few device models are not supported due to missing kernel driver or
> missing device profile. Those devices are based of following DTV
> frontend chipsets:
> MaxLinear MxL5xx
> STMicroelectronics STV0910
> STMicroelectronics STV0367
> 
> 
> Tree for testing is here:
> http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=digitaldevices
> 
> regards
> Antti
> 
> 
> Antti Palosaari (5):
>   cxd2843: do not call get_if_frequency() when it is NULL
>   ddbridge: disable driver building
>   ddbridge: remove driver temporarily
>   ddbridge: add needed files from manufacturer driver 0.9.15a
>   ddbridge: clean up driver for release
> 
>  drivers/media/dvb-frontends/cxd2843.c      |    3 +-
>  drivers/media/pci/ddbridge/Makefile        |    2 -
>  drivers/media/pci/ddbridge/ddbridge-core.c | 3175 +++++++++++++++++++---------
>  drivers/media/pci/ddbridge/ddbridge-i2c.c  |  232 ++
>  drivers/media/pci/ddbridge/ddbridge-regs.h |  347 ++-
>  drivers/media/pci/ddbridge/ddbridge.c      |  456 ++++
>  drivers/media/pci/ddbridge/ddbridge.h      |  407 +++-
>  7 files changed, 3518 insertions(+), 1104 deletions(-)
>  create mode 100644 drivers/media/pci/ddbridge/ddbridge-i2c.c
>  create mode 100644 drivers/media/pci/ddbridge/ddbridge.c
> 


