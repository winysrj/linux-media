Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46653 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbeIJVM6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 17:12:58 -0400
Received: by mail-yw1-f66.google.com with SMTP id j131-v6so8038331ywc.13
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 09:18:08 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id 79-v6sm5787062ywp.71.2018.09.10.09.18.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Sep 2018 09:18:06 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id i144-v6so2298056ywc.3
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 09:18:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7da460f4d77659c3fc19743c287f0b24f6cd596a.1536581758.git.mchehab+samsung@kernel.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org> <7da460f4d77659c3fc19743c287f0b24f6cd596a.1536581758.git.mchehab+samsung@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Sep 2018 09:18:05 -0700
Message-ID: <CAGXu5jK9T86We8eNGLNa-9i9iPvFTdZ_4Y0zzuvWVkr6MgZTzA@mail.gmail.com>
Subject: Re: [PATCH 3/3] media: replace strncpy() by strscpy()
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 10, 2018 at 5:19 AM, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> The strncpy() function is being deprecated upstream. Replace
> it by the safer strscpy().

This one I'm quite concerned about. This could lead to kernel memory
exposures if any of the callers depend on strncpy()'s trailing
NUL-padding to clear a buffer of prior contents.

How did you validate that for these changes?

-Kees

-- 
Kees Cook
Pixel Security
