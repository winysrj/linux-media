Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56939 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1AZQvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 11:51:43 -0500
Date: Wed, 26 Jan 2011 08:51:32 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Mark Lord <kernel@teksavvy.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126165132.GC29163@core.coreip.homeip.net>
References: <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D4004F9.6090200@redhat.com>
 <4D401CC5.4020000@redhat.com>
 <4D402D35.4090206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D402D35.4090206@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 26, 2011 at 12:18:29PM -0200, Mauro Carvalho Chehab wrote:
> diff --git a/input.c b/input.c
> index d57a31e..a9bd5e8 100644
> --- a/input.c
> +++ b/input.c
> @@ -101,8 +101,8 @@ int device_open(int nr, int verbose)
>  		close(fd);
>  		return -1;
>  	}
> -	if (EV_VERSION != version) {
> -		fprintf(stderr, "protocol version mismatch (expected %d, got %d)\n",
> +	if (EV_VERSION > version) {
> +		fprintf(stderr, "protocol version mismatch (expected >= %d, got %d)\n",
>  			EV_VERSION, version);

Please do not do this. It causes check to "float" depending on the
version of kernel headers it was compiled against.

The check should be against concrete version (0x10000 in this case).

Thanks.

-- 
Dmitry
