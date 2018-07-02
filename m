Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:37014 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbeGBNMr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 09:12:47 -0400
Subject: Re: [PATCH v4 0/9] xen: dma-buf support for grant device
To: Juergen Gross <jgross@suse.com>, boris.ostrovsky@oracle.com
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        konrad.wilk@oracle.com, daniel.vetter@intel.com,
        dongwon.kim@intel.com, matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
 <0d314f2f-e0c1-1017-5ba9-83489038b544@gmail.com>
 <ae597938-6d2a-9b4c-de7f-ec66429847bd@suse.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <1b714e02-8225-b091-bd14-079a35d02a12@gmail.com>
Date: Mon, 2 Jul 2018 16:12:43 +0300
MIME-Version: 1.0
In-Reply-To: <ae597938-6d2a-9b4c-de7f-ec66429847bd@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/02/2018 11:20 AM, Juergen Gross wrote:
> On 02/07/18 09:10, Oleksandr Andrushchenko wrote:
>> Hello, Boris, Juergen!
>>
>> Do you think I can re-base the series (which already has
>> all required R-b's from Xen community) onto the latest kernel
>> with API changes to patches 5 (of_dma_configure) and 8
>> (dma-buf atomic ops) and we can merge it to the Xen's kernel tree?
> Rebase: yes.
>
> Merging to the Xen kernel tree: only after setting up the
> for-linus-4.19 branch, which will be done by Boris later this
> month.
Then I'll probably have to wait until for-linus-4.19 branch
Boris, do you have any dates in mind for that?
>
> Juergen
Thank you,
Oleksandr
