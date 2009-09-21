Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbZIUX6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 19:58:30 -0400
Date: Mon, 21 Sep 2009 20:57:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] media: video: Fix build in
 saa7164
Message-ID: <20090921205754.26c59c46@pedra.chehab.org>
In-Reply-To: <20090921182345.GA25100@elte.hu>
References: <20090919014930.7dd90f77@pedra.chehab.org>
	<20090921182345.GA25100@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Sep 2009 20:23:45 +0200
Ingo Molnar <mingo@elte.hu> escreveu:

> 
> * Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > This series also contains several new drivers:
> > 
> >    - new driver for NXP saa7164;
> 
> -tip testing found that an allyesconfig build buglet found its way into 
> this driver - find the fix below.
> 

> diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
> index f0dbead..60f3214 100644
> --- a/drivers/media/video/saa7164/saa7164-core.c
> +++ b/drivers/media/video/saa7164/saa7164-core.c
> @@ -45,8 +45,8 @@ MODULE_LICENSE("GPL");
>   32 bus
>   */
>  
> -unsigned int debug;
> -module_param(debug, int, 0644);
> +unsigned int saa_debug;
> +module_param(saa_debug, int, 0644);

Hmm... it is better to use module_param_named(debug, saa_debug, int, 0644), to
keep presenting the parameter as just "debug" to userspace.

> This is because recent saa7164 changes introduced a global symbol
> named 'debug'. The x86 platform code already defines a 'debug'
> symbol. (which is named in a too generic way as well - but it
> can be used nicely to weed out too generic symbols in drivers ;-

Agreed.

Btw, I suggest to do a similar patch also for x86, to avoid such future conflicts.

-- 

Cheers,
Mauro
