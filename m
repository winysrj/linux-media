Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:49201 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbcLFQwJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 11:52:09 -0500
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stephen Bates <sbates@raithlin.com>
References: <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
 <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <ac07a73f2601f6ca35cecc83c553feb0.squirrel@webmail.raithlin.com>
 <20161206163850.GC28066@obsidianresearch.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Haggai Eran <haggaie@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "Suravee.Suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "John.Bridgman@amd.com" <john.bridgman@amd.com>,
        "Alexander.Deucher@amd.com" <alexander.deucher@amd.com>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>,
        "Paul.Blinzer@amd.com" <paul.blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <felix.kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ec136c34-417d-8a55-c176-2c1d759a5fb8@deltatee.com>
Date: Tue, 6 Dec 2016 09:51:15 -0700
MIME-Version: 1.0
In-Reply-To: <20161206163850.GC28066@obsidianresearch.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey,

On 06/12/16 09:38 AM, Jason Gunthorpe wrote:
>>> I'm not opposed to mapping /dev/nvmeX.  However, the lookup is trivial
>>> to accomplish in sysfs through /sys/dev/char to find the sysfs path of the
>>> device-dax instance under the nvme device, or if you already have the nvme
>>> sysfs path the dax instance(s) will appear under the "dax" sub-directory.
>>
>> Personally I think mapping the dax resource in the sysfs tree is a nice
>> way to do this and a bit more intuitive than mapping a /dev/nvmeX.
> 
> It is still not at all clear to me what userpsace is supposed to do
> with this on nvme.. How is the CMB usable from userspace?

The flow is pretty simple. For example to write to NVMe from an RDMA device:

1) Obtain a chunk of the CMB to use as a buffer(either by mmaping
/dev/nvmx, the device dax char device or through a block layer interface
(which sounds like a good suggestion from Christoph, but I'm not really
sure how it would look).

2) Create an MR with the buffer and use an RDMA function to fill it with
data from a remote host. This will cause the RDMA hardware to write
directly to the memory in the NVMe card.

3) Using O_DIRECT, write the buffer to a file on the NVMe filesystem.
When the address reaches hardware the NVMe will recognize it as local
memory and copy it directly there.

Thus we are able to transfer data to any file on an NVMe device without
going through system memory. This has benefits on systems with lots of
activity in system memory but step 3 is likely to be slowish due to the
need to pin/unpin the memory for every transaction.

Logan

