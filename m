Return-path: <linux-media-owner@vger.kernel.org>
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
        "'linux-nvdimm@lists.01.org'" <linux-nvdimm@lists.01.org>,
        "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>,
        "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>
CC: "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Sagalovitch, Serguei" <Serguei.Sagalovitch@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>
Subject: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 21 Nov 2016 20:36:25 +0000
Message-ID: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is certainly not the first time this has been brought up, but I'd like=
 to try and get some consensus on the best way to move this forward.  Allow=
ing devices to talk directly improves performance and reduces latency by av=
oiding the use of staging buffers in system memory.  Also in cases where bo=
th devices are behind a switch, it avoids the CPU entirely.  Most current A=
PIs (DirectGMA, PeerDirect, CUDA, HSA) that deal with this are pointer base=
d.  Ideally we'd be able to take a CPU virtual address and be able to get t=
o a physical address taking into account IOMMUs, etc.  Having struct pages =
for the memory would allow it to work more generally and wouldn't require a=
s much explicit support in drivers that wanted to use it.
=20
Some use cases:
1. Storage devices streaming directly to GPU device memory
2. GPU device memory to GPU device memory streaming
3. DVB/V4L/SDI devices streaming directly to GPU device memory
4. DVB/V4L/SDI devices streaming directly to storage devices
=20
Here is a relatively simple example of how this could work for testing.  Th=
is is obviously not a complete solution.
- Device memory will be registered with Linux memory sub-system by created =
corresponding struct page structures for device memory
- get_user_pages_fast() will  return corresponding struct pages when CPU ad=
dress points to the device memory
- put_page() will deal with struct pages for device memory
=20
Previously proposed solutions and related proposals:
1.P2P DMA
DMA-API/PCI map_peer_resource support for peer-to-peer (http://www.spinics.=
net/lists/linux-pci/msg44560.html)
Pros: Low impact, already largely reviewed.
Cons: requires explicit support in all drivers that want to support it, doe=
sn't handle S/G in device memory.
=20
2. ZONE_DEVICE IO
Direct I/O and DMA for persistent memory (https://lwn.net/Articles/672457/)
Add support for ZONE_DEVICE IO memory with struct pages. (https://patchwork=
.kernel.org/patch/8583221/)
Pro: Doesn't waste system memory for ZONE metadata
Cons: CPU access to ZONE metadata slow, may be lost, corrupted on device re=
set.
=20
3. DMA-BUF
RDMA subsystem DMA-BUF support (http://www.spinics.net/lists/linux-rdma/msg=
38748.html)
Pros: uses existing dma-buf interface
Cons: dma-buf is handle based, requires explicit dma-buf support in drivers=
.

4. iopmem
iopmem : A block device for PCIe memory (https://lwn.net/Articles/703895/)
=20
5. HMM
Heterogeneous Memory Management (http://lkml.iu.edu/hypermail/linux/kernel/=
1611.2/02473.html)

6. Some new mmap-like interface that takes a userptr and a length and retur=
ns a dma-buf and offset?
=20
Alex

