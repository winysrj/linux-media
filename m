Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52210 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbeEDRuc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 13:50:32 -0400
Date: Fri, 4 May 2018 14:50:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Brian Johnson <brijohn@gmail.com>,
        Christoph =?UTF-8?B?QsO2aG13YWxkZXI=?= <christoph@boehmwalder.at>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Daniele Nicolodi <daniele@grinta.net>,
        David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
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
Subject: Re: [v3] [media] Use common error handling code in 19 functions
Message-ID: <20180504144928.566ae507@vento.lan>
In-Reply-To: <9e766f52-b09e-c61e-8d9f-23542d83f6b1@users.sourceforge.net>
References: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
        <57ef3a56-2578-1d5f-1268-348b49b0c573@users.sourceforge.net>
        <9e766f52-b09e-c61e-8d9f-23542d83f6b1@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 4 May 2018 18:08:59 +0200
SF Markus Elfring <elfring@users.sourceforge.net> escreveu:

> > Adjust jump targets so that a bit of exception handling can be better
> > reused at the end of these functions.  
> 
> Why was this update suggestion rejected once more a moment ago?
> 
> https://patchwork.linuxtv.org/patch/47827/
> lkml.kernel.org/r/<57ef3a56-2578-1d5f-1268-348b49b0c573@users.sourceforge.net>
> https://lkml.org/lkml/2018/3/9/823

Taking just the first diff there as an example:


diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 61a750fae465..17d05b05fa9d 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -656,18 +656,18 @@  static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 	tsfeed->priv = filter;
 
 	ret = tsfeed->set(tsfeed, feed->pid, ts_type, ts_pes, timeout);
-	if (ret < 0) {
-		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
-		return ret;
-	}
+	if (ret < 0)
+		goto release_feed;
 
 	ret = tsfeed->start_filtering(tsfeed);
-	if (ret < 0) {
-		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
-		return ret;
-	}
+	if (ret < 0)
+		goto release_feed;
 
 	return 0;
+
+release_feed:
+	dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
+	return ret;
 }

There's *nothing* wrong with the above. It works fine, avoids goto
and probably even produce the same code, as gcc will likely optimize
it. It is also easier to review, as the error handling is closer
to the code. On the other hand, there's nothing wrong on taking
the approach you're proposing.

In the end, using goto or not on error handling like the above is 
a matter of personal taste - and taste changes with time and with
developer. I really don't have time to keep reviewing patches that
are just churning the code just due to someone's personal taste.

I'm pretty sure if I start accepting things like that, someone
else would be on some future doing patches just reverting it,
and I would be likely having to apply them too.

So, except if the patch is really fixing something - e.g. a broken
error handling code, I'll just ignore such patches and mark as
rejected without further notice/comments from now on.


Thanks,
Mauro
