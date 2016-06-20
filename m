Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36572 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbcFTQdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 12:33:13 -0400
Received: by mail-yw0-f195.google.com with SMTP id f75so2962175ywb.3
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 09:32:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160620133157.GK23520@phenom.ffwll.local>
References: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
 <1466339491-12639-4-git-send-email-minipli@googlemail.com> <20160620133157.GK23520@phenom.ffwll.local>
From: Mathias Krause <minipli@googlemail.com>
Date: Mon, 20 Jun 2016 18:32:54 +0200
Message-ID: <CA+rthh-yj=aLgH7R-KC01tb-8yqaRC8f9pD8VTA=62yYxCBT-w@mail.gmail.com>
Subject: Re: [PATCH 3/3] dma-buf: remove dma_buf_debugfs_create_file()
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 June 2016 at 15:31, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Sun, Jun 19, 2016 at 02:31:31PM +0200, Mathias Krause wrote:
>> [...]
>> With no users left, we can remove dma_buf_debugfs_create_file().
>>
>> While at it, simplify the error handling in dma_buf_init_debugfs()
>> slightly.
>>
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>
> ah, here's the 2nd part, feel free to ignore my earlier comments. On the
> series:

Yeah, I've split the original patch into three to separate bug fixes
(patch 1+2) from enhancements (this patch) -- just in case anybody
wants to backport the fixes.

Also, this way this patch can easily be left out without missing the
fixes, in case new debugfs files below dma_buf/ are expected in the
near future. Those might want to make use of
dma_buf_debugfs_create_file(). But, as there haven't been any since
its introduction in commit
b89e35636bc7 ("dma-buf: Add debugfs support") in 2013, I guess, we can
just remove that function. ;)
>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Thanks,
Mathias
