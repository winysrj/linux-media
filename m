Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51119 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZF1SUu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 14:20:50 -0400
Subject: Re: [PATCH] MAINTAINERS: Remove ivtv-user lists, add CX18 url
From: Andy Walls <awalls@radix.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <1246212979.13673.15.camel@Joe-Laptop.home>
References: <cover.1246173664.git.joe@perches.com>
	 <7eeefbbba34fc477540566c6b1888cb7c871f4cd.1246173681.git.joe@perches.com>
	 <1246209460.1550.12.camel@palomino.walls.org>
	 <1246209679.13673.6.camel@Joe-Laptop.home>
	 <1246212608.1550.45.camel@palomino.walls.org>
	 <1246212979.13673.15.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 14:22:33 -0400
Message-Id: <1246213353.1550.49.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-06-28 at 11:16 -0700, Joe Perches wrote:
> On Sun, 2009-06-28 at 14:10 -0400, Andy Walls wrote:
> > On Sun, 2009-06-28 at 10:21 -0700, Joe Perches wrote:
> > > On Sun, 2009-06-28 at 13:17 -0400, Andy Walls wrote:
> > > > This is on topic for the ivtv-devel list, but must we spam the
> > > > ivtv-users list with this sort of trivia? 
> > > > Perhaps your Maintainers file scraper script could be tweaked a little?
> > > Perhaps the ivtv-users list entries should be removed from MAINTAINERS
> > OK by me for 'CX18 VIDEO4LINUX DRIVER'.
> > Also, a second website entry should be to be added for 'CX18 VIDEO4LINUX
> > DRIVER'
> > W:	http://www.ivtvdriver.org/index.php/Cx18
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fa2a16d..311fc61 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1678,10 +1678,10 @@ M:	hverkuil@xs4all.nl
>  P:	Andy Walls
>  M:	awalls@radix.net
>  L:	ivtv-devel@ivtvdriver.org
> -L:	ivtv-users@ivtvdriver.org
>  L:	linux-media@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>  W:	http://linuxtv.org
> +W:	http://www.ivtvdriver.org/index.php/Cx18
>  S:	Maintained
>  F:	Documentation/video4linux/cx18.txt
>  F:	drivers/media/video/cx18/
> @@ -3231,7 +3231,6 @@ IVTV VIDEO4LINUX DRIVER
>  P:	Hans Verkuil
>  M:	hverkuil@xs4all.nl
>  L:	ivtv-devel@ivtvdriver.org
> -L:	ivtv-users@ivtvdriver.org
>  L:	linux-media@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>  W:	http://www.ivtvdriver.org


Acked-by: Andy Walls <awalls@radix.net>

Regards,
Andy

