Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53687 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbbAUXEa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2015 18:04:30 -0500
Date: Wed, 21 Jan 2015 21:04:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT FIXES FOR v3.19] Fixes for 3.19
Message-ID: <20150121210425.70983828@recife.lan>
In-Reply-To: <54B902C7.1040507@xs4all.nl>
References: <54B902C7.1040507@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Jan 2015 13:23:35 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The following changes since commit 99f3cd52aee21091ce62442285a68873e3be833f:
> 
>   [media] vb2-vmalloc: Protect DMA-specific code by #ifdef CONFIG_HAS_DMA (2014-12-23 16:28:09 -0200)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git for-v3.19a
> 
> for you to fetch changes up to f490fe1a4b4cd0a6454db02e8459d30a2ff02c49:
> 
>   Fix Mygica T230 support (2015-01-16 13:07:28 +0100)
> 
> ----------------------------------------------------------------
> Jim Davis (1):
>       media: tlg2300: disable building the driver

This one is superseded by:
	https://patchwork.linuxtv.org/patch/27671/

Instead of marking as Broken, the right fix is to preserve the media
USB dependency, so I'm replacing this patch by 27671.

> 
> Jonathan McDowell (1):
>       Fix Mygica T230 support
> 
> Matthias Schwarzott (1):
>       cx23885: Split Hauppauge WinTV Starburst from HVR4400 card entry

The other two patches are ok.
> 
>  drivers/media/pci/cx23885/cx23885-cards.c | 23 +++++++++++++++++------
>  drivers/media/pci/cx23885/cx23885-dvb.c   | 11 +++++++++++
>  drivers/media/pci/cx23885/cx23885.h       |  1 +
>  drivers/media/usb/dvb-usb/cxusb.c         |  2 +-
>  drivers/staging/media/tlg2300/Kconfig     |  1 +
>  5 files changed, 31 insertions(+), 7 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
