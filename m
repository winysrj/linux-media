Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33459 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeIKBew (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 21:34:52 -0400
Received: by mail-yb1-f193.google.com with SMTP id m123-v6so8505792ybm.0
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 13:39:02 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id d6-v6sm5640946ywa.85.2018.09.10.13.38.59
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Sep 2018 13:38:59 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id d34-v6so8504824yba.3
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 13:38:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180910153417.07c6715f@coco.lan>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
 <7da460f4d77659c3fc19743c287f0b24f6cd596a.1536581758.git.mchehab+samsung@kernel.org>
 <CAGXu5jK9T86We8eNGLNa-9i9iPvFTdZ_4Y0zzuvWVkr6MgZTzA@mail.gmail.com> <20180910153417.07c6715f@coco.lan>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Sep 2018 13:38:58 -0700
Message-ID: <CAGXu5jKHQ8dJ_guvBphUoyjmZ_0QiUxKxT1SfknXPqB+-YmFSA@mail.gmail.com>
Subject: Re: [PATCH 3/3] media: replace strncpy() by strscpy()
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 10, 2018 at 11:34 AM, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> Em Mon, 10 Sep 2018 09:18:05 -0700
> Kees Cook <keescook@chromium.org> escreveu:
>
>> On Mon, Sep 10, 2018 at 5:19 AM, Mauro Carvalho Chehab
>> <mchehab+samsung@kernel.org> wrote:
>> > The strncpy() function is being deprecated upstream. Replace
>> > it by the safer strscpy().
>>
>> This one I'm quite concerned about. This could lead to kernel memory
>> exposures if any of the callers depend on strncpy()'s trailing
>> NUL-padding to clear a buffer of prior contents.
>>
>> How did you validate that for these changes?
>
> That's actually easy for those familiar with the V4L2 API. There are
> several fields at either uAPI or kAPI (or both) that have strings.
>
> For example, a video input has a name.
>
> So, for one familiar with the V4L2 API, it is clear that something
> like:
>
> +       strscpy(inp->name, zr->card.input[inp->index].name,
> +               sizeof(inp->name));
>
> Is just filling the uAPI with the name of Input, with is, typically,
> something like:
>         S-Video
>         Television
>         Radio
>         Composite
>
> A visual inspection of the patch shows that, on almost all cases, it is
> either filling a device driver's name (used mainly for debug routines),
> a video Input, a format description string, or the video caps fields
> name and driver.

It looks like the ioctl path also pre-clears the output buffer before
handing it over to the per-driver routines, so I think this looks
okay. It's a large patch, but if you're comfortable with it, go for
it. :)

-Kees

-- 
Kees Cook
Pixel Security
