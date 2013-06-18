Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56013 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3FRJtw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 05:49:52 -0400
Message-ID: <1371548849.4276.6.camel@weser.hi.pengutronix.de>
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
 framework
From: Lucas Stach <l.stach@pengutronix.de>
To: Inki Dae <inki.dae@samsung.com>
Cc: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date: Tue, 18 Jun 2013 11:47:29 +0200
In-Reply-To: <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com>
	 <1371467722-665-1-git-send-email-inki.dae@samsung.com>
	 <51BEF458.4090606@canonical.com>
	 <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com>
	 <20130617133109.GG2718@n2100.arm.linux.org.uk>
	 <CAAQKjZO_t_kZkU46bUPTpoJs_oE1KkEqS2OTrTYjjJYZzBf+XA@mail.gmail.com>
	 <20130617154237.GJ2718@n2100.arm.linux.org.uk>
	 <CAAQKjZOokFKN85pygVnm7ShSa+O0ZzwxvQ0rFssgNLp+RO5pGg@mail.gmail.com>
	 <20130617182127.GM2718@n2100.arm.linux.org.uk>
	 <007301ce6be4$8d5c6040$a81520c0$%dae@samsung.com>
	 <20130618084308.GU2718@n2100.arm.linux.org.uk>
	 <008a01ce6c02$e00a9f50$a01fddf0$%dae@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 18.06.2013, 18:04 +0900 schrieb Inki Dae:
[...]
> 
> > a display device driver.  It shouldn't be used within a single driver
> > as a means of passing buffers between userspace and kernel space.
> 
> What I try to do is not really such ugly thing. What I try to do is to
> notify that, when CPU tries to access a buffer , to kernel side through
> dmabuf interface. So it's not really to send the buffer to kernel.
> 
> Thanks,
> Inki Dae
> 
The most basic question about why you are trying to implement this sort
of thing in the dma_buf framework still stands.

Once you imported a dma_buf into your DRM driver it's a GEM object and
you can and should use the native DRM ioctls to prepare/end a CPU access
to this BO. Then internally to your driver you can use the dma_buf
reservation/fence stuff to provide the necessary cross-device sync.

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

