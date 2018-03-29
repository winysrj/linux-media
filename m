Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:52829 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbeC2Ohq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 10:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_P-z=Noos_jaME9_CERri3C-m2hPPvx2bArr36O=1FnrA@mail.gmail.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-2-christian.koenig@amd.com> <20180328123830.GB25060@infradead.org>
 <613a6c91-7e72-5589-77e6-587ec973d553@gmail.com> <c81df70d-191d-bf8e-293a-413dd633e1fc@deltatee.com>
 <5498e9b5-8fe5-8999-a44e-f7dc483bc9ce@amd.com> <16c7bef8-5f03-9e89-1f50-b62fb139a36f@deltatee.com>
 <6a5c9a10-50fe-b03d-dfc1-791d62d79f8e@amd.com> <e751cd28-f115-569f-5248-d24f30dee3cb@deltatee.com>
 <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com> <1b08c13e-b4a2-08f2-6194-93e6c21b7965@deltatee.com>
 <CADnq5_P-z=Noos_jaME9_CERri3C-m2hPPvx2bArr36O=1FnrA@mail.gmail.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Thu, 29 Mar 2018 10:37:44 -0400
Message-ID: <CADnq5_PP_COGHxLdDtfnLrho8RNXLQFHc5s07+g55d9oXvB6rg@mail.gmail.com>
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linaro-mm-sig@lists.linaro.org,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, didn't mean to drop the lists here. re-adding.

On Wed, Mar 28, 2018 at 4:05 PM, Alex Deucher <alexdeucher@gmail.com> wrote=
:
> On Wed, Mar 28, 2018 at 3:53 PM, Logan Gunthorpe <logang@deltatee.com> wr=
ote:
>>
>>
>> On 28/03/18 01:44 PM, Christian K=C3=B6nig wrote:
>>> Well, isn't that exactly what dma_map_resource() is good for? As far as
>>> I can see it makes sure IOMMU is aware of the access route and
>>> translates a CPU address into a PCI Bus address.
>>
>>> I'm using that with the AMD IOMMU driver and at least there it works
>>> perfectly fine.
>>
>> Yes, it would be nice, but no arch has implemented this yet. We are just
>> lucky in the x86 case because that arch is simple and doesn't need to do
>> anything for P2P (partially due to the Bus and CPU addresses being the
>> same). But in the general case, you can't rely on it.
>
> Could we do something for the arches where it works?  I feel like peer
> to peer has dragged out for years because everyone is trying to boil
> the ocean for all arches.  There are a huge number of use cases for
> peer to peer on these "simple" architectures which actually represent
> a good deal of the users that want this.
>
> Alex
>
>>
>>>>> Yeah, but not for ours. See if you want to do real peer 2 peer you ne=
ed
>>>>> to keep both the operation as well as the direction into account.
>>>> Not sure what you are saying here... I'm pretty sure we are doing "rea=
l"
>>>> peer 2 peer...
>>>>
>>>>> For example when you can do writes between A and B that doesn't mean
>>>>> that writes between B and A work. And reads are generally less likely=
 to
>>>>> work than writes. etc...
>>>> If both devices are behind a switch then the PCI spec guarantees that =
A
>>>> can both read and write B and vice versa.
>>>
>>> Sorry to say that, but I know a whole bunch of PCI devices which
>>> horrible ignores that.
>>
>> Can you elaborate? As far as the device is concerned it shouldn't know
>> whether a request comes from a peer or from the host. If it does do
>> crazy stuff like that it's well out of spec. It's up to the switch (or
>> root complex if good support exists) to route the request to the device
>> and it's the root complex that tends to be what drops the load requests
>> which causes the asymmetries.
>>
>> Logan
>> _______________________________________________
>> amd-gfx mailing list
>> amd-gfx@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/amd-gfx
