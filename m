Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZDNPNm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 11:13:42 -0400
Date: Tue, 14 Apr 2009 12:13:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,
 2.6.16-2.6.21: WARNINGS
Message-ID: <20090414121331.7bad313e@pedra.chehab.org>
In-Reply-To: <200904131820.n3DIKYCS006043@smtp-vbr6.xs4all.nl>
References: <200904131820.n3DIKYCS006043@smtp-vbr6.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 13 Apr 2009 20:20:34 +0200 (CEST)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:

> linux-2.6.30-rc1-armv5: ERRORS
> linux-2.6.30-rc1-armv5-ixp: ERRORS
> linux-2.6.30-rc1-armv5-omap2: ERRORS
> linux-2.6.30-rc1-i686: ERRORS
> linux-2.6.30-rc1-m32r: ERRORS
> linux-2.6.30-rc1-mips: ERRORS
> linux-2.6.30-rc1-powerpc64: ERRORS
> linux-2.6.30-rc1-x86_64: ERRORS

After some backporting work, it is now compiling for me with latest 2.6.30
upstream, at least with x86_64. 

One notice with 2.6.30 is that the syntax of one of upstream scripts has
changed. So, you may need to run something like "make allmodconfig && make
init" at kernel tree, in order to re-compile this script and put the 2.6.30
into a sane state for v4l-dvb compilation.

There are still a few merging stuff needed. This is the current diffs:

 arch/arm/mach-mx1/Makefile                |    2 -
 drivers/media/dvb/dvb-core/dvb_net.c      |   57 ++++++++++++++----------------
 drivers/media/dvb/firewire/firedtv-avc.c  |   10 +++--
 drivers/media/dvb/frontends/drx397xD.c    |    2 -
 drivers/media/video/au0828/au0828-video.c |    1 
 drivers/media/video/cx231xx/Kconfig       |   44 +++++++++++------------
 drivers/media/video/cx88/cx88-dsp.c       |    4 +-
 drivers/media/video/uvc/uvc_status.c      |   10 +++--
 include/linux/i2c-id.h                    |   39 --------------------
 sound/pci/bt87x.c                         |    6 +--
 10 files changed, 71 insertions(+), 104 deletions(-)

Except for dvb_net, most of the changes above seem trivial.

I hope to finish all backports later today. 

Of course, such backports could break compat (or runtime) with legacy kernels.
Nothing is perfect. If so, please report.

Cheers,
Mauro
