Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDD4C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 10:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68DB420866
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 10:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaX1hXxc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392110AbfAPKkw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 05:40:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32959 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392105AbfAPKkw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 05:40:52 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so6379807wrr.0;
        Wed, 16 Jan 2019 02:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=9Np+v0nwdYyba8op+9dujYv6+2JU/p/NoCLmU7xwACU=;
        b=XaX1hXxc+maMj3l+h2ty5I0KaMI9rquMFWs/93PjAVF4RLzUGx0zOfw7tHz7xa+SQ7
         bTX0VrZsaLWOR8C0EGhwA+HcPvBGgutFzJgaSB9N6VQQ/wGRjUhpzD6C7o7OtN8hG9pb
         fKbyGGB3RDevAnDw77qP+TI9snucjziGuOyrdDSEY35LgGMKnHZy9z9jFXvstS511K/O
         yw/A0zZxI8xEhBmqQ3H2+L951Gmq/OifHNvYaFkbwwgiKFo1AOgAfWEeMrWJbSO77lth
         67X0ZqxnVRV55qnZtZiRBXnSuSt9w5hcqXVs5399Q6nR674ZGNZD6sfCdv4nXJ1/b24O
         XZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=9Np+v0nwdYyba8op+9dujYv6+2JU/p/NoCLmU7xwACU=;
        b=b2aBNQRBrJCV2BFKTS1M4aZgOhu/L4L4dHytVi9rjMiSmdx56xSOeWzb/qKZJ7SJJk
         sYY/AGRo+UWDCEoDxDZBO7f0Cw8JXpsm4Zid8wB2KPCvLu2g6YTfcT261/lpiQY8A15J
         Y7PvxEVyGzSIJmxWPiD+m+Z+MabNoJQl664HQTi0OKpnLHp9jCKr8PJY8URClR+MZKOt
         tmqsRH0bKT7eb4LWOYC121I9vNFkBMvVCesuvDtL4dUWOcl3+Y94Fxow4k6Wtt7vyWLQ
         zem11qFZoGSTTqeQtJXebPR0/D6YxGAfbMaOZphGAD6wJs5wquUFHFcar9o8YcFeIKmm
         hbfw==
X-Gm-Message-State: AJcUukeBhvdpO5Gvs2cXcNdwgw8mRWFiFpJOzJalDuCp0lH9Dm8BUEE2
        BfclVpRBArfYBB7z1rOUECA=
X-Google-Smtp-Source: ALg8bN5oKn+dTawjD32jcZGI925zb+XJ/F8Dg9jWF7WjviUE3CNsAtGMC5ZfNMU996bPePP+9WBXng==
X-Received: by 2002:adf:b190:: with SMTP id q16mr6955550wra.95.1547635250036;
        Wed, 16 Jan 2019 02:40:50 -0800 (PST)
Received: from ?IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7? ([2a02:908:1252:fb60:be8a:bd56:1f94:86e7])
        by smtp.gmail.com with ESMTPSA id y1sm40558941wme.1.2019.01.16.02.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 02:40:49 -0800 (PST)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH] lib/scatterlist: Provide a DMA page iterator
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Thomas Hellstrom <thellstrom@vmware.com>
Cc:     "syeh@vmware.com" <syeh@vmware.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "jian.xu.zheng@intel.com" <jian.xu.zheng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "bingbu.cao@intel.com" <bingbu.cao@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "hch@lst.de" <hch@lst.de>,
        "tian.shu.qiu@intel.com" <tian.shu.qiu@intel.com>,
        "yong.zhi@intel.com" <yong.zhi@intel.com>
References: <20190104223531.GA1705@ziepe.ca> <20190110234218.GM6890@ziepe.ca>
 <20190114094856.GB29604@lst.de>
 <1fb20ab4b171b281e9994b6c55734c120958530b.camel@vmware.com>
 <20190115212501.GE22045@ziepe.ca>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <744b82a0-bc81-06ee-307b-52ffda705e2c@gmail.com>
Date:   Wed, 16 Jan 2019 11:40:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190115212501.GE22045@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am 15.01.19 um 22:25 schrieb Jason Gunthorpe:
> On Tue, Jan 15, 2019 at 02:17:26PM +0000, Thomas Hellstrom wrote:
>> Hi, Christoph,
>>
>> On Mon, 2019-01-14 at 10:48 +0100, Christoph Hellwig wrote:
>>> On Thu, Jan 10, 2019 at 04:42:18PM -0700, Jason Gunthorpe wrote:
>>>>> Changes since the RFC:
>>>>> - Rework vmwgfx too [CH]
>>>>> - Use a distinct type for the DMA page iterator [CH]
>>>>> - Do not have a #ifdef [CH]
>>>> ChristophH: Will you ack?
>>> This looks generally fine.
>>>
>>>> Are you still OK with the vmwgfx reworking, or should we go back to
>>>> the original version that didn't have the type safety so this
>>>> driver
>>>> can be left broken?
>>> I think the map method in vmgfx that just does virt_to_phys is
>>> pretty broken.  Thomas, can you check if you see any performance
>>> difference with just doing the proper dma mapping, as that gets the
>>> driver out of interface abuse land?
>> The performance difference is not really the main problem here. The
>> problem is that even though we utilize the streaming DMA interface, we
>> use it only since we have to for DMA-Remapping and assume that the
>> memory is coherent. To be able to be as compliant as possible and ditch
>> the virt-to-phys mode, we *need* a DMA interface flag that tells us
>> when the dma_sync_for_xxx are no-ops. If they aren't we'll refuse to
>> load for now. I'm not sure, but I think also nouveau and radeon suffer
>> from the same issue.
> RDMA needs something similar as well, in this case drivers take a
> struct page * from get_user_pages() and need to have the DMA map fail
> if the platform can't DMA map in a way that does not require any
> additional DMA API calls to ensure coherence. (think Userspace RDMA
> MR's)
>
> Today we just do the normal DMA map and when it randomly doesn't work
> and corrupts data tell those people their platforms don't support RDMA
> - it would be nice to have a safer API base solution..

Oh, yes really good point. We have to support get_user_pages (or HMM) in 
a similar manner on GPUs as well.

Regards,
Christian.

>
> Jason
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

