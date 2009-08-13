Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59878 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZHMSRO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 14:17:14 -0400
Date: Thu, 13 Aug 2009 15:17:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: mo.ucina@gmail.com, linux-media@vger.kernel.org,
	"Jan D. Louw" <jd.louw@mweb.co.za>
Subject: Re: [linux-dvb] Support for Compro VideoMate S350
Message-ID: <20090813151713.2b94f373@caramujo.chehab.org>
In-Reply-To: <200906231804.28893.liplianin@me.by>
References: <81c0b0550905250703o786a2a65ib757287da841dc11@mail.gmail.com>
	<200906201633.58431.liplianin@me.by>
	<4A40C81E.7070304@gmail.com>
	<200906231804.28893.liplianin@me.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 23 Jun 2009 18:04:28 +0300
"Igor M. Liplianin" <liplianin@me.by> escreveu:

> On 23 June 2009 15:18:38 O&M Ugarcina wrote:
> > Thanks for that Igor,
> >
> > I have just pulled the latest hg and tried to apply patches . Patches
> > 12094 and 12095 went in with no problem . However patch 12096 failed
> > with this output :
> >
> > [root@localhost v4l-dvb]# patch -p1 < 12096.patch
> > patching file linux/drivers/media/common/ir-keymaps.c
> > Hunk #1 FAILED at 2800.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > linux/drivers/media/common/ir-keymaps.c.rej
> > patching file linux/drivers/media/video/saa7134/Kconfig
> > patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> > patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> > patching file linux/drivers/media/video/saa7134/saa7134-input.c
> > patching file linux/drivers/media/video/saa7134/saa7134.h
> > patching file linux/include/media/ir-common.h
> > Hunk #1 FAILED at 162.
> > 1 out of 1 hunk FAILED -- saving rejects to file
> > linux/include/media/ir-common.h.rej
> > [root@localhost v4l-dvb]#
> >
> 
> I recreate last patch just now.

Igor,

As this patch seems to depend on a new demod not yet merged, I'll assume that
this patch is an RFC. Please send me a pull request when you have it ready for
upstream.




Cheers,
Mauro
