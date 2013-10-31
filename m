Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34725 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3JaVJO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 17:09:14 -0400
Date: Thu, 31 Oct 2013 15:09:12 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH -next] media/platform/marvell-ccic: fix cafe_ccic build
 error
Message-ID: <20131031150912.099a9d36@lwn.net>
In-Reply-To: <52729C60.6000408@infradead.org>
References: <20131031210027.cb3604b9589e0b7a1599dbd2@canb.auug.org.au>
	<52729C60.6000408@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 31 Oct 2013 11:07:28 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> The cafe_ccic driver (the mcam-core.c part of it) uses dma_sg
> interfaces so it needs to select VIDEOBUF2_DMA_SG to prevent
> build errors.

Geert sent a patch too a little while back.

BUT, this shouldn't be happening.  Could you send a .config file that
evokes this failure?  All of the s/g stuff is ifdeffed out if
VIDEOBUF2_DMA_SG isn't enabled...or it used to be...  I'd rather figure
out what's going on and not drag the s/g stuff into OLPC XO builds, where
memory is tight and there's no use for it.

(Sorry, I'm *way* behind on everything...)

Thanks,

jon
