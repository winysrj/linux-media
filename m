Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZCTAHE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 20:07:04 -0400
Date: Thu, 19 Mar 2009 21:06:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: linux-next: Tree for March 19 (media/au8522)
Message-ID: <20090319210633.6911eba1@pedra.chehab.org>
In-Reply-To: <49C27CC2.6070803@oracle.com>
References: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
	<49C27CC2.6070803@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009 10:11:30 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090318:
> 
> 
> au8522_decoder.c:(.text+0x199898): undefined reference to `v4l2_ctrl_query_fill'
> au8522_decoder.c:(.text+0x1998b3): undefined reference to `v4l2_ctrl_query_fill'
> au8522_decoder.c:(.text+0x199944): undefined reference to `v4l2_device_unregister_subdev'
> au8522_decoder.c:(.text+0x19997c): undefined reference to `v4l2_chip_ident_i2c_client'
> au8522_decoder.c:(.text+0x199f1e): undefined reference to `v4l2_i2c_subdev_init'
> 
Thanks! This were due to the fact that au8522 is now dependent on V4L2, since
the same chip is used for both DVB frontand and Analog demodulation.

Devin,

IMO, you have a bad design here: You should try to have a core module with the
common parts, and separate modules for the analog and the DVB parts of the chip.

Anyway, for now, I just added the required dependencies at the Kconfig.

Cheers,
Mauro

PS.: I'll be updating the linux-next patches later, after adding some other
stuff. So, you'll probably see the fix for those reported issues merged only
tomorrow.
