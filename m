Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41424 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbeIJVL2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 17:11:28 -0400
Received: by mail-yw1-f66.google.com with SMTP id q129-v6so8048318ywg.8
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 09:16:39 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id v18-v6sm5890806ywv.9.2018.09.10.09.16.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Sep 2018 09:16:38 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id n21-v6so8057818ywh.5
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 09:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ac8f27b58748f6d474ffd141f29536638f793953.1536581758.git.mchehab+samsung@kernel.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org> <ac8f27b58748f6d474ffd141f29536638f793953.1536581758.git.mchehab+samsung@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Sep 2018 09:16:35 -0700
Message-ID: <CAGXu5jKAN6JihMhxz_tMZ6q_Feik3j5RD5QwhuRFmAyiNQJXpA@mail.gmail.com>
Subject: Re: [PATCH 2/3] media: replace strcpy() by strscpy()
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 10, 2018 at 5:19 AM, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> The strcpy() function is being deprecated upstream. Replace
> it by the safer strscpy().

Did you verify that all the destination buffers here are arrays and
not pointers? For example:

struct thing {
  char buffer[64];
  char *ptr;
}

strscpy(instance->buffer, source, sizeof(instance->buffer));

is correct.

But:

strscpy(instance->ptr, source, sizeof(instance->ptr));

will not be and will truncate strings to sizeof(char *).

If you _did_ verify this, I'd love to know more about your tooling. :)

-Kees

-- 
Kees Cook
Pixel Security
