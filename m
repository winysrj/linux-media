Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40948 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZLaSKL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 13:10:11 -0500
Subject: Re: [PATCH] MAINTAINERS: Andy Walls is the new ivtv maintainer
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <200912311455.44818.hverkuil@xs4all.nl>
References: <200912311455.44818.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Thu, 31 Dec 2009 13:09:28 -0500
Message-Id: <1262282968.3055.42.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-31 at 14:55 +0100, Hans Verkuil wrote:
> Hi Mauro,
> 
> Attached is a diff for the 2.6.33-rc2 MAINTAINERS file that removes me as
> cx18 maintainer and makes Andy the new ivtv maintainer. After 4 1/2 years
> I've decided to hand over the ivtv driver to Andy. Andy was already doing
> more work on ivtv than I did, so this just makes official what was happening
> in practice.
> 
> My SoB:
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Andy, can you add your own SoB as well?

Sure.

Signed-off-by: Andy Walls <awalls@radix.net>

Regards,
Andy

> Regards,
> 
> 	Hans
> 
> --- MAINTAINERS.org	2009-12-31 13:25:48.000000000 +0100
> +++ MAINTAINERS	2009-12-31 13:26:50.000000000 +0100
> @@ -1638,7 +1638,6 @@
>  F:	sound/pci/cs5535audio/
>  
>  CX18 VIDEO4LINUX DRIVER
> -M:	Hans Verkuil <hverkuil@xs4all.nl>
>  M:	Andy Walls <awalls@radix.net>
>  L:	ivtv-devel@ivtvdriver.org
>  L:	linux-media@vger.kernel.org
> @@ -3021,7 +3020,7 @@
>  F:	drivers/isdn/hardware/eicon/
>  
>  IVTV VIDEO4LINUX DRIVER
> -M:	Hans Verkuil <hverkuil@xs4all.nl>
> +M:	Andy Walls <awalls@radix.net>
>  L:	ivtv-devel@ivtvdriver.org
>  L:	linux-media@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> 

