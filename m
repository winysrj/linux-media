Return-path: <mchehab@pedra>
Received: from mga02.intel.com ([134.134.136.20]:58452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933934Ab1CXTvl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 15:51:41 -0400
Message-ID: <4D8BA0CD.3090105@intel.com>
Date: Thu, 24 Mar 2011 12:51:41 -0700
From: Auke Kok <auke-jan.h.kok@intel.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] use pci_dev->revision
References: <1300718156-25395-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1300718156-25395-1-git-send-email-bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/21/11 07:35, Bjørn Mork wrote:
> pci_setup_device() has saved the PCI revision in the pci_dev
> struct since Linux 2.6.23.  Use it.
>
> Cc: Auke Kok<auke-jan.h.kok@intel.com>
> Signed-off-by: Bjørn Mork<bjorn@mork.no>
> ---
> I assume some of these drivers could have the revision
> removed from their driver specific structures as well, but
> I haven't done that to avoid unnecessary ABI changes.
>
>   drivers/media/common/saa7146_core.c        |    7 +------
>   drivers/media/dvb/b2c2/flexcop-pci.c       |    4 +---
>   drivers/media/dvb/bt8xx/bt878.c            |    2 +-
>   drivers/media/dvb/mantis/mantis_pci.c      |    5 ++---
>   drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
>   drivers/media/video/cx18/cx18-driver.c     |    2 +-
>   drivers/media/video/cx23885/cx23885-core.c |    2 +-
>   drivers/media/video/cx88/cx88-mpeg.c       |    2 +-
>   drivers/media/video/cx88/cx88-video.c      |    2 +-
>   drivers/media/video/ivtv/ivtv-driver.c     |    4 +---
>   drivers/media/video/saa7134/saa7134-core.c |    2 +-
>   drivers/media/video/saa7164/saa7164-core.c |    2 +-
>   drivers/media/video/zoran/zoran_card.c     |    2 +-
>   13 files changed, 14 insertions(+), 24 deletions(-)

looks great, thanks for picking up this (overdue) cleanup :)

Auke
