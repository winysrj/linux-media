Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:54073 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbeEEHzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 03:55:33 -0400
Subject: Re: [v3] [media] Use common error handling code in 19 functions
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Brian Johnson <brijohn@gmail.com>,
        =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph@boehmwalder.at>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Daniele Nicolodi <daniele@grinta.net>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Devendra Sharma <devendra.sharma9091@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Inki Dae <inki.dae@samsung.com>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Max Kellermann <max.kellermann@gmail.com>,
        Mike Isely <isely@pobox.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Sean Young <sean@mess.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Shyam Saini <mayhs11saini@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
 <57ef3a56-2578-1d5f-1268-348b49b0c573@users.sourceforge.net>
 <9e766f52-b09e-c61e-8d9f-23542d83f6b1@users.sourceforge.net>
 <20180504144928.566ae507@vento.lan>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <980b7bd9-b922-55f7-c2d7-2d20552ade4c@users.sourceforge.net>
Date: Sat, 5 May 2018 09:53:00 +0200
MIME-Version: 1.0
In-Reply-To: <20180504144928.566ae507@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> @@ -656,18 +656,18 @@  static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
>  	tsfeed->priv = filter;
>  
>  	ret = tsfeed->set(tsfeed, feed->pid, ts_type, ts_pes, timeout);
> -	if (ret < 0) {
> -		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto release_feed;
>  
>  	ret = tsfeed->start_filtering(tsfeed);
> -	if (ret < 0) {
> -		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto release_feed;
>  
>  	return 0;
> +
> +release_feed:
> +	dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
> +	return ret;
>  }
> 
> There's *nothing* wrong with the above. It works fine,

I can agree to this view in principle according to the required control flow.


> avoids goto

How does this wording fit to information from the section
“7) Centralized exiting of functions” in the document “coding-style.rst”?


> and probably even produce the same code, as gcc will likely optimize it.

Would you like to clarify the current situation around supported
software optimisations any more?


> It is also easier to review, as the error handling is closer
> to the code.

Do we stumble on different coding style preferences once more?


> On the other hand, there's nothing wrong on taking the approach
> you're proposing.

Thanks for another bit of positive feedback.


> In the end, using goto or not on error handling like the above is 
> a matter of personal taste - and taste changes with time

Do Linux guidelines need any adjustments?


> and with developer. I really don't have time to keep reviewing patches
> that are just churning the code just due to someone's personal taste.

I tried to apply another general source code transformation pattern.


> I'm pretty sure if I start accepting things like that,
> someone else would be on some future doing patches just reverting it,
> and I would be likely having to apply them too.

Why?

I hope also that the source code can be kept consistent to some degree.


> So, except if the patch is really fixing something - e.g. a broken
> error handling code, I'll just ignore such patches and mark as
> rejected without further notice/comments from now on.

I would find such a communication style questionable.
Do you distinguish between bug fixes and possible corrections for
other error categories (or software weaknesses)?

Regards,
Markus
