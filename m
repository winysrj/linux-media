Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35416 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759771AbZKLBot (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 20:44:49 -0500
Date: Thu, 12 Nov 2009 02:44:52 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/4] DVB: firedtv: port to new firewire driver stack
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
Message-ID: <tkrat.f5c6b067dba96030@s5r6.in-berlin.de>
References: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
> [PATCH 1/4] firedtv: move remote control workqueue handling into rc source file
> [PATCH 2/4] firedtv: reform lock transaction backend call
> [PATCH 3/4] firedtv: add missing include, rename a constant
> [PATCH 4/4] firedtv: port to new firewire core
> 
>  drivers/media/dvb/firewire/Kconfig        |    7
>  drivers/media/dvb/firewire/Makefile       |    1
>  drivers/media/dvb/firewire/firedtv-1394.c |   37 +-
>  drivers/media/dvb/firewire/firedtv-avc.c  |   50 +-
>  drivers/media/dvb/firewire/firedtv-dvb.c  |   15
>  drivers/media/dvb/firewire/firedtv-fw.c   |  385 ++++++++++++++++++++++
>  drivers/media/dvb/firewire/firedtv-rc.c   |    2
>  drivers/media/dvb/firewire/firedtv.h      |   17
>  8 files changed, 471 insertions(+), 43 deletions(-)

These patches are now also available in the v2.6.31 based "firedtv"
branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv

This branch is also merged into linux1394-2.6.git for-next and thereby
linux-next.git.
-- 
Stefan Richter
-=====-==--= =-== -==--
http://arcgraph.de/sr/

