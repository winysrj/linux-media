Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0959BC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9CA52086D
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:25:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7QHJ5M8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbfAOOZA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:25:00 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56145 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbfAOOZA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:25:00 -0500
Received: by mail-wm1-f65.google.com with SMTP id y139so3438292wmc.5;
        Tue, 15 Jan 2019 06:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=9nRDzFSapnRlPx9vKPqKnJm9H9JN9M+LXx5Bq0Oi5mw=;
        b=b7QHJ5M8joEwFDoYEweN4y2EA0WwzBVMf77tVHvPPOW48hnB10iO8zebDiGxysNmev
         e60GtnLt7sRMs7siFQiXkk9HProEIpHvRFWd7kIRKQF3MiJIHXPsq7mJFBSeHuXL1Zf2
         YvlTlRVw5CDJ6A5dM94kkxR9l9kUOIW9b7phvIjOdfZ/gCKSuV0zq3q8NIoLWqnUKMZP
         U3PU+4rehpQJmv5s+wgtne2DD4u92UE4VE9beXWly1ux0JCc97uyf8ZPS0zQX/QaGXVR
         QZZNmqBU/MIO/o03IDACm7fc5GpSxjY0kj1hz34UGJtYZoeuBOlGg5LOOw04kPZvegxo
         Kxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=9nRDzFSapnRlPx9vKPqKnJm9H9JN9M+LXx5Bq0Oi5mw=;
        b=Ga9C6YB/vY4PIYXjjd6w6zupyHhLYhRrYaCvsSeq0LMfFb8HOrC2Rzv1WQNk/PQhLe
         BDdDfbF66xNM4+TpDoOVmoRz+VNWBumbU9LmDsqq7XGM2VfugwXajfpuBJmVYos57RuK
         WlxMBRuPF5woGLdM7ozybE1hcp85PF34R09VJmztHPoF+MioXhmElxthU6Xn290V1v/l
         UXJZwrIzRJsZsZ9+HRzGXeugz9kxFBBcBfoCEBKORJNFJUJWdEnqKL0vN19Tr3m9tUNW
         DtOXW62T3XOsXbT2w5ZsN5pMQcCYRtwPObvZXbEfuioiF57iyjU3T86gogNBErFjSUvV
         nq3g==
X-Gm-Message-State: AJcUukdBLrZaFe+CG0y48A5/TFe0CJyzADXO4CGx3LIo5YJCAZHxFwvJ
        kE+/WhRWlSsbmplmg4zsMx/HNqrC
X-Google-Smtp-Source: ALg8bN70JELqFEDHY6HO+QxUUzA1eWTIBUdWWTjWle0acAUKCoU5zRlzUH+/FJxUTseId58ceLJd7Q==
X-Received: by 2002:a1c:2408:: with SMTP id k8mr3468340wmk.110.1547562297666;
        Tue, 15 Jan 2019 06:24:57 -0800 (PST)
Received: from ?IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7? ([2a02:908:1252:fb60:be8a:bd56:1f94:86e7])
        by smtp.gmail.com with ESMTPSA id j124sm22300980wmb.48.2019.01.15.06.24.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 06:24:57 -0800 (PST)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
To:     Thomas Hellstrom <thellstrom@vmware.com>,
        "hch@lst.de" <hch@lst.de>, "jgg@ziepe.ca" <jgg@ziepe.ca>
Cc:     "syeh@vmware.com" <syeh@vmware.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <2b440a3b-ed2f-8fd6-a21e-97ca0b2f5db9@gmail.com>
Date:   Tue, 15 Jan 2019 15:24:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am 15.01.19 um 15:17 schrieb Thomas Hellstrom:
> Hi, Christoph,
>
> On Mon, 2019-01-14 at 10:48 +0100, Christoph Hellwig wrote:
>> On Thu, Jan 10, 2019 at 04:42:18PM -0700, Jason Gunthorpe wrote:
>>>> Changes since the RFC:
>>>> - Rework vmwgfx too [CH]
>>>> - Use a distinct type for the DMA page iterator [CH]
>>>> - Do not have a #ifdef [CH]
>>> ChristophH: Will you ack?
>> This looks generally fine.
>>
>>> Are you still OK with the vmwgfx reworking, or should we go back to
>>> the original version that didn't have the type safety so this
>>> driver
>>> can be left broken?
>> I think the map method in vmgfx that just does virt_to_phys is
>> pretty broken.  Thomas, can you check if you see any performance
>> difference with just doing the proper dma mapping, as that gets the
>> driver out of interface abuse land?
> The performance difference is not really the main problem here. The
> problem is that even though we utilize the streaming DMA interface, we
> use it only since we have to for DMA-Remapping and assume that the
> memory is coherent. To be able to be as compliant as possible and ditch
> the virt-to-phys mode, we *need* a DMA interface flag that tells us
> when the dma_sync_for_xxx are no-ops. If they aren't we'll refuse to
> load for now. I'm not sure, but I think also nouveau and radeon suffer
> from the same issue.

Yeah, indeed. Bounce buffers are an absolute no-go for GPUs.

If the DMA API finds that a piece of memory is not directly accessible 
by the GPU we need to return an error and not try to use bounce buffers 
behind the surface.

That is something which always annoyed me with the DMA API, which is 
otherwise rather cleanly defined.

Christian.

>
>> While we're at it I think we need to merge my series in this area
>> for 5.0, because without that the driver is already broken.  Where
>> should we merge it?
> I can merge it through vmwgfx/drm-fixes. There is an outstanding issue
> with patch 3. Do you want me to fix that up?
>
> Thanks,
> Thomas
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

