Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.47.125]:56207 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751689AbcLFKIE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:08:04 -0500
Received: from cm2.websitewelcome.com (cm2.websitewelcome.com [192.185.178.13])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id CF9223BFA1304
        for <linux-media@vger.kernel.org>; Tue,  6 Dec 2016 02:06:17 -0600 (CST)
Message-ID: <ac07a73f2601f6ca35cecc83c553feb0.squirrel@webmail.raithlin.com>
In-Reply-To: <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
References: <20161128165751.GB28381@obsidianresearch.com>
    <1480357179.19407.13.camel@mellanox.com>
    <20161128190244.GA21975@obsidianresearch.com>
    <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
    <20161130162353.GA24639@obsidianresearch.com>
    <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
    <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
    <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
    <20161205171830.GB27784@obsidianresearch.com>
    <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
    <20161205180231.GA28133@obsidianresearch.com>
    <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
    <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
    <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
Date: Tue, 6 Dec 2016 02:06:14 -0600
Subject: Re: Enabling peer to peer device transactions for PCIe devices
From: "Stephen Bates" <sbates@raithlin.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Logan Gunthorpe" <logang@deltatee.com>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        "Haggai Eran" <haggaie@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "Suravee.Suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "John.Bridgman@amd.com" <john.bridgman@amd.com>,
        "Alexander.Deucher@amd.com" <alexander.deucher@amd.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Max Gurtovoy" <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <paul.blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <felix.kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>> I've already recommended that iopmem not be a block device and
>>> instead be a device-dax instance. I also don't think it should claim
>>> the PCI ID, rather the driver that wants to map one of its bars this
>>> way can register the memory region with the device-dax core.
>>>
>>> I'm not sure there are enough device drivers that want to do this to
>>> have it be a generic /sys/.../resource_dmableX capability. It still
>>> seems to be an exotic one-off type of configuration.
>>
>>
>> Yes, this is essentially my thinking. Except I think the userspace
>> interface should really depend on the device itself. Device dax is a
>> good  choice for many and I agree the block device approach wouldn't be
>> ideal.

I tend to agree here. The block device interface has seen quite a bit of
resistance and /dev/dax looks like a better approach for most. We can look
at doing it that way in v2.

>>
>> Specifically for NVME CMB: I think it would make a lot of sense to just
>> hand out these mappings with an mmap call on /dev/nvmeX. I expect CMB
>> buffers would be volatile and thus you wouldn't need to keep track of
>> where in the BAR the region came from. Thus, the mmap call would just be
>> an allocator from BAR memory. If device-dax were used, userspace would
>> need to lookup which device-dax instance corresponds to which nvme
>> drive.
>>
>
> I'm not opposed to mapping /dev/nvmeX.  However, the lookup is trivial
> to accomplish in sysfs through /sys/dev/char to find the sysfs path of the
> device-dax instance under the nvme device, or if you already have the nvme
> sysfs path the dax instance(s) will appear under the "dax" sub-directory.
>

Personally I think mapping the dax resource in the sysfs tree is a nice
way to do this and a bit more intuitive than mapping a /dev/nvmeX.


