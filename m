Return-path: <linux-media-owner@vger.kernel.org>
Date: Sun, 22 Oct 2017 08:13:45 +0200 (CEST)
From: "Petrosyan, Ludwig" <ludwig.petrosyan@desy.de>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>
Message-ID: <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
In-Reply-To: <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com> <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de> <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Logan

Thank You very much for respond.
Could be I have done is stupid...
But at first sight it has to be simple:
The PCIe Write transactions are address routed, so if in the packet header =
the other endpoint address is written the TLP has to be routed (by PCIe Swi=
tch to the endpoint), the DMA reading from the end point is really write tr=
ansactions from the endpoint, usually (Xilinx core) to start DMA one has to=
 write to the DMA control register of the endpoint the destination address.=
 So I have change the device driver to set in this register the physical ad=
dress of the other endpoint (get_resource start called to other endpoint, a=
nd it is the same address which I could see in lspci -vvvv -s bus-address o=
f the switch port, memories behind bridge), so now the endpoint has to star=
t send writes TLP with the other endpoint address in the TLP header.
But this is not working (I want to understand why ...), but I could see the=
 first address of the destination endpoint is changed (with the wrong value=
 0xFF),
now I want to try prepare in the driver of one endpoint the DMA buffer , bu=
t using physical address of the other endpoint,
Could be it will never work, but I want to understand why, there is my erro=
r ...

with best regards

Ludwig

----- Original Message -----
From: "Logan Gunthorpe" <logang@deltatee.com>
To: "Ludwig Petrosyan" <ludwig.petrosyan@desy.de>, "Deucher, Alexander" <Al=
exander.Deucher@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger=
.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "l=
inux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Linux-media@vger.ke=
rnel.org" <Linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org" =
<dri-devel@lists.freedesktop.org>, "linux-pci@vger.kernel.org" <linux-pci@v=
ger.kernel.org>
Cc: "Bridgman, John" <John.Bridgman@amd.com>, "Kuehling, Felix" <Felix.Kueh=
ling@amd.com>, "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>, "Blinz=
er, Paul" <Paul.Blinzer@amd.com>, "Koenig, Christian" <Christian.Koenig@amd=
.com>, "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>, "Sander, B=
en" <ben.sander@amd.com>
Sent: Friday, 20 October, 2017 17:48:58
Subject: Re: Enabling peer to peer device transactions for PCIe devices

Hi Ludwig,

P2P transactions are still *very* experimental at the moment and take a=20
lot of expertise to get working in a general setup. It will definitely=20
require changes to the kernel, including the drivers of all the devices=20
you are trying to make talk to eachother. If you're up for it you can=20
take a look at:

https://github.com/sbates130272/linux-p2pmem/

Which has our current rough work making NVMe fabrics use p2p transactions.

Logan

On 10/20/2017 6:36 AM, Ludwig Petrosyan wrote:
> Dear Linux kernel group
>=20
> my name is Ludwig Petrosyan I am working in DESY (Germany)
>=20
> we are responsible for the control system of=C2=A0 all accelerators in DE=
SY.
>=20
> For a 7-8 years we have switched to MTCA.4 systems and using PCIe as a=20
> central Bus.
>=20
> I am mostly responsible for the Linux drivers of the AMC Cards (PCIe=20
> endpoints).
>=20
> The idea is start to use peer to peer transaction for PCIe endpoint (DMA=
=20
> and/or usual Read/Write)
>=20
> Could You please advise me where to start, is there some Documentation=20
> how to do it.
>=20
>=20
> with best regards
>=20
>=20
> Ludwig
>=20
>=20
> On 11/21/2016 09:36 PM, Deucher, Alexander wrote:
>> This is certainly not the first time this has been brought up, but I'd=
=20
>> like to try and get some consensus on the best way to move this=20
>> forward.=C2=A0 Allowing devices to talk directly improves performance an=
d=20
>> reduces latency by avoiding the use of staging buffers in system=20
>> memory.=C2=A0 Also in cases where both devices are behind a switch, it=
=20
>> avoids the CPU entirely.=C2=A0 Most current APIs (DirectGMA, PeerDirect,=
=20
>> CUDA, HSA) that deal with this are pointer based.=C2=A0 Ideally we'd be=
=20
>> able to take a CPU virtual address and be able to get to a physical=20
>> address taking into account IOMMUs, etc.=C2=A0 Having struct pages for t=
he=20
>> memory would allow it to work more generally and wouldn't require as=20
>> much explicit support in drivers that wanted to use it.
>> Some use cases:
>> 1. Storage devices streaming directly to GPU device memory
>> 2. GPU device memory to GPU device memory streaming
>> 3. DVB/V4L/SDI devices streaming directly to GPU device memory
>> 4. DVB/V4L/SDI devices streaming directly to storage devices
>> Here is a relatively simple example of how this could work for=20
>> testing.=C2=A0 This is obviously not a complete solution.
>> - Device memory will be registered with Linux memory sub-system by=20
>> created corresponding struct page structures for device memory
>> - get_user_pages_fast() will=C2=A0 return corresponding struct pages whe=
n=20
>> CPU address points to the device memory
>> - put_page() will deal with struct pages for device memory
>> Previously proposed solutions and related proposals:
>> 1.P2P DMA
>> DMA-API/PCI map_peer_resource support for peer-to-peer=20
>> (http://www.spinics.net/lists/linux-pci/msg44560.html)
>> Pros: Low impact, already largely reviewed.
>> Cons: requires explicit support in all drivers that want to support=20
>> it, doesn't handle S/G in device memory.
>> 2. ZONE_DEVICE IO
>> Direct I/O and DMA for persistent memory=20
>> (https://lwn.net/Articles/672457/)
>> Add support for ZONE_DEVICE IO memory with struct pages.=20
>> (https://patchwork.kernel.org/patch/8583221/)
>> Pro: Doesn't waste system memory for ZONE metadata
>> Cons: CPU access to ZONE metadata slow, may be lost, corrupted on=20
>> device reset.
>> 3. DMA-BUF
>> RDMA subsystem DMA-BUF support=20
>> (http://www.spinics.net/lists/linux-rdma/msg38748.html)
>> Pros: uses existing dma-buf interface
>> Cons: dma-buf is handle based, requires explicit dma-buf support in=20
>> drivers.
>>
>> 4. iopmem
>> iopmem : A block device for PCIe memory=20
>> (https://lwn.net/Articles/703895/)
>> 5. HMM
>> Heterogeneous Memory Management=20
>> (http://lkml.iu.edu/hypermail/linux/kernel/1611.2/02473.html)
>>
>> 6. Some new mmap-like interface that takes a userptr and a length and=20
>> returns a dma-buf and offset?
>> Alex
>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html
>=20
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
