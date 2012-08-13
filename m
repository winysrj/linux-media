Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:33611 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2HMSFq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 14:05:46 -0400
Message-ID: <502941F6.3080809@iki.fi>
Date: Mon, 13 Aug 2012 21:05:42 +0300
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
CC: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 0/2] Add Nokia N900 (RX51) IR diode support
References: <1344593797-15819-1-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1344593797-15819-1-git-send-email-timo.t.kokkonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/10/12 13:16, Timo Kokkonen wrote:
> These patches add the support for sending IR remote controller codes
> on the Nokia N900 phone. The code is taken from the public N900 kernel
> release and modified to work with today's kernel.
> 
> The code has been tested with a real Nokia N900 device and confirmed
> to work. I can identify only one known issue; The IR pulses being sent
> become *veeery* long if the device chooses to go into any sleep modes
> during transmitting the IR pulses. The driver makes an attempt to set
> up PM latency constraints, but apparently those don't apply as there
> is currently only no-op PM layer available. Therefore, I guess this
> driver doesn't actually work properly unless there is some background
> load that prevents the device from enterint sleep modes or the sleep
> modes are disabled altogether. However, once a proper PM layer
> implementation becomes available, I expect this problem to resolve
> itself. The same code used to work with the actual N900 kernel that
> has those implemented.
> 
> Any comments regarding the patches are welcome.
> 
> I guess media list won't take in omap patches and omap list doesn't
> take media patches. So I wrote the patches so that they can be applied
> independently. If you want me to remove the #ifdef hacks from the
> board file (that is needed to break the build dependency between the
> patches), then the ir-rx51.c patch needs to be applied before the
> board file patch. But I though it would be more flexible this way. I'm
> open to suggestions on how you are willing to accept the patches.
> 
> ---
> 
> Changes since v1:
> 
> - Move ir-rx51.h into include/media directory
> 

Any comments on these? Anything still missing before you can consider
accepting these? Thanks!

-Timo

> 
> Timo Kokkonen (2):
>   media: rc: Introduce RX51 IR transmitter driver
>   ARM: mach-omap2: board-rx51-peripherals: Add lirc-rx51 data
> 
>  arch/arm/mach-omap2/board-rx51-peripherals.c |   30 ++
>  drivers/media/rc/Kconfig                     |   10 +
>  drivers/media/rc/Makefile                    |    1 +
>  drivers/media/rc/ir-rx51.c                   |  496 ++++++++++++++++++++++++++
>  include/media/ir-rx51.h                      |   10 +
>  5 files changed, 547 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/rc/ir-rx51.c
>  create mode 100644 include/media/ir-rx51.h
> 

