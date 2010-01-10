Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45893 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0AJNaE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 08:30:04 -0500
Subject: Re: [PATCH 1/1] MAINTAINERS: ivtv-devel is moderated
From: Andy Walls <awalls@radix.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: mchehab@infradead.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	linux-media@vger.kernel.org
In-Reply-To: <1263114197-8476-1-git-send-email-jslaby@suse.cz>
References: <1263114197-8476-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain
Date: Sun, 10 Jan 2010 08:29:09 -0500
Message-Id: <1263130149.4061.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-01-10 at 10:03 +0100, Jiri Slaby wrote:
> Mark ivtv-devel@ivtvdriver.org as 'moderated for non-subscribers'.

Yes, that is true.

I don't know why it matters after years of not being marked as such,
especially since the moderator will push through on-topic posts.

I don't know the implications that such an annotation will have on
scripts that try to parse MAINTAINERS for e-mail addresses.

But anyway:

Acked-by: Andy Walls <awalls@radix.net>

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-media@vger.kernel.org
> ---
>  MAINTAINERS |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d4baf3d..6f088ac 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1649,7 +1649,7 @@ F:	sound/pci/cs5535audio/
>  CX18 VIDEO4LINUX DRIVER
>  M:	Hans Verkuil <hverkuil@xs4all.nl>
>  M:	Andy Walls <awalls@radix.net>
> -L:	ivtv-devel@ivtvdriver.org
> +L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
>  L:	linux-media@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>  W:	http://linuxtv.org
> @@ -3037,7 +3037,7 @@ F:	drivers/isdn/hardware/eicon/
>  
>  IVTV VIDEO4LINUX DRIVER
>  M:	Hans Verkuil <hverkuil@xs4all.nl>
> -L:	ivtv-devel@ivtvdriver.org
> +L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
>  L:	linux-media@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>  W:	http://www.ivtvdriver.org

