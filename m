Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZCDSV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 13:21:26 -0500
Date: Wed, 4 Mar 2009 10:35:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org
Subject: Re: Cleanup of dvb frontend driver header files
Message-ID: <20090304103555.327d2de5@caramujo.chehab.org>
In-Reply-To: <200903041136.27283.zzam@gentoo.org>
References: <200903041136.27283.zzam@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 4 Mar 2009 11:36:26 +0100
Matthias Schwarzott <zzam@gentoo.org> wrote:

> Hi there!
> 
> While having a look at lnbp21.h I have seen it includes <linux/dvb/frontend.h> 
> without needing it. (There are only pointers referring to struct 
> dvb_frontend).
> 
> So I had a look at the whole directory.
> # cd linux/drivers/media/dvb/frontends
> # grep -l linux/dvb/frontend.h *.h|wc -l
> 47
> 
> So 47 header files include this header and seem not to need it.
> At least removing this line still allows me to compile the full set of v4l-dvb 
> drivers.
> # sed -e '/linux\/dvb\/frontend/s-^-// -' -i *.h
> 
> Some of these files use more headers the same way like dvb_frontend.h, 
> firmware.h or i2c.h
> 
> Is this kind of cleanup appreciated, or should the includes be kept even if 
> they are not really needed for pointers to structs like dvb_frontend.

This kind of cleanup is appreciated, since it reduces the compilation time of
the kernel. Some care should be taken, however, since a few headers are
required on other architectures, or may be needed, depending on the enabled
CONFIG options.

Cheers,
Mauro
