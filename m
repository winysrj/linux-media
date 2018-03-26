Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:40516 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbeCZKrz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 06:47:55 -0400
Received: by mail-wm0-f41.google.com with SMTP id x4so2222297wmh.5
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2018 03:47:54 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH] dma-buf: use parameter structure for dma_buf_attach
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        sumit.semwal@linaro.org
References: <20180325113451.2425-1-christian.koenig@amd.com>
 <20180326083638.GS14155@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <84c1bd05-7ba2-c35d-a8cb-23adbbc5bfec@gmail.com>
Date: Mon, 26 Mar 2018 12:47:53 +0200
MIME-Version: 1.0
In-Reply-To: <20180326083638.GS14155@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 26.03.2018 um 10:36 schrieb Daniel Vetter:
> On Sun, Mar 25, 2018 at 01:34:51PM +0200, Christian König wrote:
[SNIP]
>> -	attach->dev = dev;
>> +	attach->dev = info->dev;
>>   	attach->dmabuf = dmabuf;
>> +	attach->priv = info->priv;
> The ->priv field is for the exporter, not the importer. See e.g.
> drm_gem_map_attach. You can't let the importer set this now too, so needs
> to be removed from the info struct.

Crap, in this case I need to add an importer_priv field because we now 
need to map from the attachment to it's importer object as well.

Thanks for noticing this.

Regards,
Christian.
