Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46698 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbeIJX3o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 19:29:44 -0400
Date: Mon, 10 Sep 2018 15:34:17 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/3] media: replace strncpy() by strscpy()
Message-ID: <20180910153417.07c6715f@coco.lan>
In-Reply-To: <CAGXu5jK9T86We8eNGLNa-9i9iPvFTdZ_4Y0zzuvWVkr6MgZTzA@mail.gmail.com>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
        <7da460f4d77659c3fc19743c287f0b24f6cd596a.1536581758.git.mchehab+samsung@kernel.org>
        <CAGXu5jK9T86We8eNGLNa-9i9iPvFTdZ_4Y0zzuvWVkr6MgZTzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 10 Sep 2018 09:18:05 -0700
Kees Cook <keescook@chromium.org> escreveu:

> On Mon, Sep 10, 2018 at 5:19 AM, Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> > The strncpy() function is being deprecated upstream. Replace
> > it by the safer strscpy().  
> 
> This one I'm quite concerned about. This could lead to kernel memory
> exposures if any of the callers depend on strncpy()'s trailing
> NUL-padding to clear a buffer of prior contents.
> 
> How did you validate that for these changes?

That's actually easy for those familiar with the V4L2 API. There are 
several fields at either uAPI or kAPI (or both) that have strings.

For example, a video input has a name.

So, for one familiar with the V4L2 API, it is clear that something
like:

+       strscpy(inp->name, zr->card.input[inp->index].name,
+               sizeof(inp->name));

Is just filling the uAPI with the name of Input, with is, typically,
something like:
	S-Video
	Television
	Radio
	Composite

A visual inspection of the patch shows that, on almost all cases, it is
either filling a device driver's name (used mainly for debug routines),
a video Input, a format description string, or the video caps fields
name and driver.

Thanks,
Mauro
