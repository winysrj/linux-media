Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback.mail.elte.hu ([157.181.151.13]:49191 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0FAGrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jun 2010 02:47:42 -0400
Date: Tue, 1 Jun 2010 08:04:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH -mmotm] media: ak881x needs slab.h
Message-ID: <20100601060433.GA24396@elte.hu>
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
 <20100520140823.a9b81de9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520140823.a9b81de9.randy.dunlap@oracle.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add slab.h to fix ak881x build:
> 
> drivers/media/video/ak881x.c:265:error: implicit declaration of function 'kzalloc'
> drivers/media/video/ak881x.c:265:warning: assignment makes pointer from integer without a cast
> drivers/media/video/ak881x.c:283:error: implicit declaration of function 'kfree'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> ---
>  drivers/media/video/ak881x.c |    1 +

This build bug is now triggering in .35-rc1 as well.

	Ingo
