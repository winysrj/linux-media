Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51052 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbeIKAob (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 20:44:31 -0400
Date: Mon, 10 Sep 2018 16:48:47 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/3] media: replace strcpy() by strscpy()
Message-ID: <20180910164847.3f015458@coco.lan>
In-Reply-To: <CAGXu5jKAN6JihMhxz_tMZ6q_Feik3j5RD5QwhuRFmAyiNQJXpA@mail.gmail.com>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
        <ac8f27b58748f6d474ffd141f29536638f793953.1536581758.git.mchehab+samsung@kernel.org>
        <CAGXu5jKAN6JihMhxz_tMZ6q_Feik3j5RD5QwhuRFmAyiNQJXpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Sep 2018 09:16:35 -0700
Kees Cook <keescook@chromium.org> escreveu:

> On Mon, Sep 10, 2018 at 5:19 AM, Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> > The strcpy() function is being deprecated upstream. Replace
> > it by the safer strscpy().  
> 
> Did you verify that all the destination buffers here are arrays and
> not pointers? For example:
> 
> struct thing {
>   char buffer[64];
>   char *ptr;
> }
> 
> strscpy(instance->buffer, source, sizeof(instance->buffer));
> 
> is correct.
> 
> But:
> 
> strscpy(instance->ptr, source, sizeof(instance->ptr));
> 
> will not be and will truncate strings to sizeof(char *).
> 
> If you _did_ verify this, I'd love to know more about your tooling. :)

I ended by implementing a simple tooling to test... it found just
one place where it was wrong. I'll send the correct patch.

The tooling is actually a hack... see enclosed.

Basically, it defines a __strscpy() that will try to create a negative
array if the size is equal to a pointer size.

Then, I replaced all occurrences of strscpy with __strcpy() with:
	$ for i in $(git grep -l strscpy drivers/media drivers/staging/media); do sed s,strscpy,__strscpy,g -i $i; done

and compiled on 32 bits (that's my usual build). As all strings at
the media API are bigger than 4 bytes, it will only complain if it
tries to do a sizeof(*).


Thanks,
Mauro

TEST hack

diff --git a/include/linux/string.h b/include/linux/string.h
index 4a5a0eb7df51..06a87e328293 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -66,6 +66,15 @@ extern char * strrchr(const char *,int);
 #endif
 extern char * __must_check skip_spaces(const char *);
 
+
+#define __strscpy(origin, dest, size) \
+({ \
+	char zzz[1 - 2*(size == sizeof(char *))]; \
+	zzz[0] = 1; \
+	if (zzz[0] >2) zzz[0]++; \
+	strscpy(origin, dest, size); \
+})
+
 extern char *strim(char *);
 
 static inline __must_check char *strstrip(char *str)
