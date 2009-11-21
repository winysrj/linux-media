Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53284 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZKUA2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 19:28:14 -0500
Date: Sat, 21 Nov 2009 01:26:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/6] DVB: firedtv: simplifications and a portability fix
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
Message-ID: <tkrat.b94d6be3d9a0bad9@s5r6.in-berlin.de>
References: <tkrat.7dc1f889fd1b69ad@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18 Nov, Stefan Richter wrote:
> The following three patches are applicable after "firedtv: port to new
> firewire core" from 2009-11-08:
...
> The rest of this patch set additionally requires the latest firedtv as
> of 2.6.32-rc7:
...

I updated the "firedtv" branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git firedtv

now (based on v2.6.31 but having a merge from v2.6.32-rc8 in it due to
above mentioned requirement).

Mauro, please harvest the posted 4 + 6 patches from the mailing list, or
pull or cherry-pick them from linux1394-2.6.git firedtv.  Thanks.

Stefan Richter (11):
      firedtv: move remote control workqueue handling into rc source file
      firedtv: reform lock transaction backend call
      firedtv: add missing include, rename a constant
      firedtv: port to new firewire core
      firedtv: shrink buffer pointer table
      firedtv: packet requeuing is likely to succeed
      firedtv: remove an unnecessary function argument
      Merge tag 'v2.6.32-rc8' into firedtv
      firedtv: do not DMA-map stack addresses
      firedtv: remove check for interrupting signal
      firedtv: reduce memset()s

 drivers/media/dvb/firewire/Kconfig        |    7 +-
 drivers/media/dvb/firewire/Makefile       |    1 +
 drivers/media/dvb/firewire/firedtv-1394.c |   42 +-
 drivers/media/dvb/firewire/firedtv-avc.c  |  566 +++++++++++----------
 drivers/media/dvb/firewire/firedtv-dvb.c  |   16 +-
 drivers/media/dvb/firewire/firedtv-fw.c   |  376 ++++++++++++++
 drivers/media/dvb/firewire/firedtv-rc.c   |    2 +
 drivers/media/dvb/firewire/firedtv.h      |   23 +-
 8 files changed, 746 insertions(+), 287 deletions(-)
-- 
Stefan Richter
-=====-==--= =-== =-=-=
http://arcgraph.de/sr/

