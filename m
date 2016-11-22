Return-path: <linux-media-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKMK7uF+k5LvcPEHvtdcXQFrpKVbFxwZ32EexoU3rZ9LFhVSow@mail.gmail.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com> <CAPcyv4htu4gayz_Dpe0pnfLN4v_Kcy-fTx3B-HEfadCHvzJnhA@mail.gmail.com>
 <CAKMK7uGoXAYoazyGLbGU7svVD10WmaBtpko8BpHeNpRhST8F7g@mail.gmail.com>
 <a99fd9ea-64d8-c5d3-0b96-f96c92369601@amd.com> <CAKMK7uF+k5LvcPEHvtdcXQFrpKVbFxwZ32EexoU3rZ9LFhVSow@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Nov 2016 13:21:03 -0800
Message-ID: <CAPcyv4ind0fxek7g25MX=49rDfT5X151tb4=TYudMBmUJFZZNQ@mail.gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Serguei Sagalovitch <serguei.sagalovitch@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 22, 2016 at 1:03 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, Nov 22, 2016 at 9:35 PM, Serguei Sagalovitch
> <serguei.sagalovitch@amd.com> wrote:
>>
>> On 2016-11-22 03:10 PM, Daniel Vetter wrote:
>>>
>>> On Tue, Nov 22, 2016 at 9:01 PM, Dan Williams <dan.j.williams@intel.com>
>>> wrote:
>>>>
>>>> On Tue, Nov 22, 2016 at 10:59 AM, Serguei Sagalovitch
>>>> <serguei.sagalovitch@amd.com> wrote:
>>>>>
>>>>> I personally like "device-DAX" idea but my concerns are:
>>>>>
>>>>> -  How well it will co-exists with the  DRM infrastructure /
>>>>> implementations
>>>>>     in part dealing with CPU pointers?
>>>>
>>>> Inside the kernel a device-DAX range is "just memory" in the sense
>>>> that you can perform pfn_to_page() on it and issue I/O, but the vma is
>>>> not migratable. To be honest I do not know how well that co-exists
>>>> with drm infrastructure.
>>>>
>>>>> -  How well we will be able to handle case when we need to
>>>>> "move"/"evict"
>>>>>     memory/data to the new location so CPU pointer should point to the
>>>>> new
>>>>> physical location/address
>>>>>      (and may be not in PCI device memory at all)?
>>>>
>>>> So, device-DAX deliberately avoids support for in-kernel migration or
>>>> overcommit. Those cases are left to the core mm or drm. The device-dax
>>>> interface is for cases where all that is needed is a direct-mapping to
>>>> a statically-allocated physical-address range be it persistent memory
>>>> or some other special reserved memory range.
>>>
>>> For some of the fancy use-cases (e.g. to be comparable to what HMM can
>>> pull off) I think we want all the magic in core mm, i.e. migration and
>>> overcommit. At least that seems to be the very strong drive in all
>>> general-purpose gpu abstractions and implementations, where memory is
>>> allocated with malloc, and then mapped/moved into vram/gpu address
>>> space through some magic,
>>
>> It is possible that there is other way around: memory is requested to be
>> allocated and should be kept in vram for  performance reason but due
>> to possible overcommit case we need at least temporally to "move" such
>> allocation to system memory.
>
> With migration I meant migrating both ways of course. And with stuff
> like numactl we can also influence where exactly the malloc'ed memory
> is allocated originally, at least if we'd expose the vram range as a
> very special numa node that happens to be far away and not hold any
> cpu cores.

I don't think we should be using numa distance to reverse engineer a
certain allocation behavior.  The latency data should be truthful, but
you're right we'll need a mechanism to keep general purpose
allocations out of that range by default. Btw, strict isolation is
another design point of device-dax, but I think in this case we're
describing something between the two extremes of full isolation and
full compatibility with existing numactl apis.
