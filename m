Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45187 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2CRHmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Mar 2012 03:42:43 -0400
Received: by qadc11 with SMTP id c11so335377qad.19
        for <linux-media@vger.kernel.org>; Sun, 18 Mar 2012 00:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPM=9txFA1M4CK2njLDJRwLn6ZaPQMUsiqMCybqLSwWmZ7Y=mw@mail.gmail.com>
References: <1331913881-13105-1-git-send-email-rob.clark@linaro.org> <CAPM=9txFA1M4CK2njLDJRwLn6ZaPQMUsiqMCybqLSwWmZ7Y=mw@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Sun, 18 Mar 2012 13:12:22 +0530
Message-ID: <CAO_48GH_zkgQQgvbiD8MQ5dHb3pD5mTSxtA_z4+KhGQJWQhC1g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add get_dma_buf()
To: Dave Airlie <airlied@gmail.com>
Cc: Rob Clark <rob.clark@linaro.org>, patches@linaro.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	daniel@ffwll.ch, airlied@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 March 2012 23:23, Dave Airlie <airlied@gmail.com> wrote:
> On Fri, Mar 16, 2012 at 4:04 PM, Rob Clark <rob.clark@linaro.org> wrote:
>> From: Rob Clark <rob@ti.com>
>>
>> Works in a similar way to get_file(), and is needed in cases such as
>> when the exporter needs to also keep a reference to the dmabuf (that
>> is later released with a dma_buf_put()), and possibly other similar
>> cases.
>>
>> Signed-off-by: Rob Clark <rob@ti.com>
>
> Reviewed-by: Dave Airlie <airlied@redhat.com>
>
Thanks; pulled into for-next.

BR,
~me.
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
