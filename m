Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:44785 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751870AbeFFMrC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 08:47:02 -0400
Subject: Re: [PATCH v2 9/9] xen/gntdev: Expose gntdev's dma-buf API for
 in-kernel use
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        dongwon.kim@intel.com, matthew.d.roper@intel.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com, daniel.vetter@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180601114132.22596-1-andr2000@gmail.com>
 <20180601114132.22596-10-andr2000@gmail.com>
 <86f5b340-856c-204f-4ba7-dd51f1e92639@oracle.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <984bcf75-9bea-aceb-3d3a-62e3c65709c7@gmail.com>
Date: Wed, 6 Jun 2018 15:46:58 +0300
MIME-Version: 1.0
In-Reply-To: <86f5b340-856c-204f-4ba7-dd51f1e92639@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/05/2018 01:36 AM, Boris Ostrovsky wrote:
> On 06/01/2018 07:41 AM, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Allow creating grant device context for use by kernel modules which
>> require functionality, provided by gntdev. Export symbols for dma-buf
>> API provided by the module.
> Can you give an example of who'd be using these interfaces?
There is no use-case at the moment I can think of, but hyper dma-buf 
[1], [2]
I let Intel folks (CCed) to defend this patch as it was done primarily 
for them
and I don't use it in any of my use-cases. So, from this POV it can be 
dropped,
at least from this series.
>
> -boris
>
[1] https://patchwork.freedesktop.org/series/38207/
[2] https://patchwork.freedesktop.org/patch/204447/
