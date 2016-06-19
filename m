Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:32867 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbcFSKnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2016 06:43:31 -0400
Received: by mail-yw0-f193.google.com with SMTP id d137so7296618ywe.0
        for <linux-media@vger.kernel.org>; Sun, 19 Jun 2016 03:43:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160619084552.GY23520@phenom.ffwll.local>
References: <1466189823-21489-1-git-send-email-minipli@googlemail.com> <20160619084552.GY23520@phenom.ffwll.local>
From: Mathias Krause <minipli@googlemail.com>
Date: Sun, 19 Jun 2016 12:43:30 +0200
Message-ID: <CA+rthh_bR1zcxzQ5sX6Uf1sFd+DaNCfC-mZfEvm0hvxTyXhF=Q@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: propagate errors from dma_buf_describe() on
 debugfs read
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19 June 2016 at 10:45, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Fri, Jun 17, 2016 at 08:57:03PM +0200, Mathias Krause wrote:
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index 6355ab38d630..0f2a4592fdd2 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -881,10 +881,9 @@ static int dma_buf_describe(struct seq_file *s)
>>
>>  static int dma_buf_show(struct seq_file *s, void *unused)
>>  {
>> -     void (*func)(struct seq_file *) = s->private;
>> +     int (*func)(struct seq_file *) = s->private;
>>
>> -     func(s);
>> -     return 0;
>> +     return func(s);
>
> Probably even better to just nuke that indirection. Set this pointer to
> NULL and inline dma_buf_describe into dma_buf_show.

Even further, we can get rid of dma_buf_debugfs_create_file() too as
it's only used to create this indirection.
I'll send a v2 just doing that.

Thanks,
Mathias
