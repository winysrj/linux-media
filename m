Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0051.outbound.protection.outlook.com ([104.47.0.51]:64224
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754458AbeFRGRT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 02:17:19 -0400
Subject: Re: [PATCH v4 5/9] xen/gntdev: Allow mappings for DMA buffers
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        konrad.wilk@oracle.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com, Sumit Semwal <sumit.semwal@linaro.org>
Cc: daniel.vetter@intel.com
References: <20180615062753.9229-1-andr2000@gmail.com>
 <20180615062753.9229-6-andr2000@gmail.com>
 <e892748a-c268-9622-e568-4c361366bce1@epam.com>
 <b9c3f740-dea1-638b-49d9-60cf5880619d@suse.com>
 <38f10738-63b6-89ce-07a8-7791b2a7e4dc@epam.com>
 <03e078b0-62a3-5d11-987b-7472f841c44d@oracle.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <b78ab715-f117-77d3-d54e-8a078b8319e7@epam.com>
Date: Mon, 18 Jun 2018 09:17:08 +0300
MIME-Version: 1.0
In-Reply-To: <03e078b0-62a3-5d11-987b-7472f841c44d@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2018 12:07 AM, Boris Ostrovsky wrote:
> On 06/15/2018 02:50 AM, Oleksandr Andrushchenko wrote:
>> On 06/15/2018 09:46 AM, Juergen Gross wrote:
>>> On 15/06/18 08:32, Oleksandr Andrushchenko wrote:
>>>> Please note, that this will need a change (attached) while
>>>> applying to the mainline kernel because of API changes [1].
>>>>
>>>> Unfortunately, current Xen tip kernel tree is v4.17-rc5 based,
>>>> so I cannot make the change in this patch now.
>>> I don't see any chance this series could go into 4.18, as the merge
>>> window is just closing. So please post the patch based on current
>>> Linux master of torvalds/linux.git
>> Ok, I'll wait for any comments/r-b's and then rebase to
>> torvalds/linux.git and push v5?
> As I mentioned earlier, I would very much like at least a review of the
> new interfaces by someone more knowledgeable than me.
I am adding "DMA BUFFER SHARING FRAMEWORK" maintainer to the list.
Sumit, could please help reviewing this? The whole work here
is to add dma-buf to Xen's grant device driver.

Intel could probably also say couple of words as they also
might re-use this work.
>
>> BTW, is there any plan to rebase Xen tip kernel?
>
> It is typically rebased to rc5 or r6, at which point patches for the
> next merge window are applied.
>
> -borsi
