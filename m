Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43147 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbeIJVIU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 17:08:20 -0400
Received: by mail-yw1-f66.google.com with SMTP id l189-v6so8043199ywb.10
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 09:13:31 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id n6-v6sm5892019ywe.89.2018.09.10.09.13.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Sep 2018 09:13:30 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id l16-v6so8145825ybk.11
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 09:13:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8984cbc7c4af93f8449c5af1cd9b26b620d4fb9f.1536581757.git.mchehab+samsung@kernel.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org> <8984cbc7c4af93f8449c5af1cd9b26b620d4fb9f.1536581757.git.mchehab+samsung@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Sep 2018 09:13:28 -0700
Message-ID: <CAGXu5jJ=454dZ_L4E-hGqu_095nYk5JoXq=_V2WYgAjZxMY=RA@mail.gmail.com>
Subject: Re: [PATCH 1/3] media: use strscpy() instead of strlcpy()
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 10, 2018 at 5:19 AM, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> The implementation of strscpy() is more robust and safer.
>
> That's now the recommended way to copy NUL terminated strings.

This looks fine since I don't see anything using the strlcpy() return
value (the return value meaning between strlcpy() and strscpy()
differs).

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
