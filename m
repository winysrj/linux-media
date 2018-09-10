Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeIKBKD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 21:10:03 -0400
Date: Mon, 10 Sep 2018 17:14:15 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/3] media: replace strcpy() by strscpy()
Message-ID: <20180910171415.7eac2732@coco.lan>
In-Reply-To: <20180910164847.3f015458@coco.lan>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
        <ac8f27b58748f6d474ffd141f29536638f793953.1536581758.git.mchehab+samsung@kernel.org>
        <CAGXu5jKAN6JihMhxz_tMZ6q_Feik3j5RD5QwhuRFmAyiNQJXpA@mail.gmail.com>
        <20180910164847.3f015458@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Sep 2018 16:48:47 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

> Em Mon, 10 Sep 2018 09:16:35 -0700
> Kees Cook <keescook@chromium.org> escreveu:
> 
> > On Mon, Sep 10, 2018 at 5:19 AM, Mauro Carvalho Chehab
> > <mchehab+samsung@kernel.org> wrote:  
> > > The strcpy() function is being deprecated upstream. Replace
> > > it by the safer strscpy().    
> > 
> > Did you verify that all the destination buffers here are arrays and
> > not pointers? For example:
> > 
> > struct thing {
> >   char buffer[64];
> >   char *ptr;
> > }
> > 
> > strscpy(instance->buffer, source, sizeof(instance->buffer));
> > 
> > is correct.
> > 
> > But:
> > 
> > strscpy(instance->ptr, source, sizeof(instance->ptr));
> > 
> > will not be and will truncate strings to sizeof(char *).
> > 
> > If you _did_ verify this, I'd love to know more about your tooling. :)  
> 
> I ended by implementing a simple tooling to test... it found just
> one place where it was wrong. I'll send the correct patch.

Btw, at the only case it was trying to fill a pointer was for
some sysfs fill. AFAIKT, the buffer size there is PAGE_SIZE,
so, I guess the enclosed patch would be the right way to use
strscpy().

Yet, IMHO, a better fix would be if the parameters for
DEVICE_ATTR store field would have a count.

Thanks,
Mauro

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 1041c056854d..989d2554ec72 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -772,9 +772,9 @@ static ssize_t show_associate_remote(struct device *d,
 
 	mutex_lock(&ictx->lock);
 	if (ictx->rf_isassociating)
-		strcpy(buf, "associating\n");
+		strscpy(buf, "associating\n", PAGE_SIZE);
 	else
-		strcpy(buf, "closed\n");
+		strscpy(buf, "closed\n", PAGE_SIZE);
 
 	dev_info(d, "Visit http://www.lirc.org/html/imon-24g.html for instructions on how to associate your iMON 2.4G DT/LT remote\n");
 	mutex_unlock(&ictx->lock);
