Return-path: <linux-media-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Nov 2016 10:11:51 -0800
Message-ID: <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 21, 2016 at 12:36 PM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
> This is certainly not the first time this has been brought up, but I'd li=
ke to try and get some consensus on the best way to move this forward.  All=
owing devices to talk directly improves performance and reduces latency by =
avoiding the use of staging buffers in system memory.  Also in cases where =
both devices are behind a switch, it avoids the CPU entirely.  Most current=
 APIs (DirectGMA, PeerDirect, CUDA, HSA) that deal with this are pointer ba=
sed.  Ideally we'd be able to take a CPU virtual address and be able to get=
 to a physical address taking into account IOMMUs, etc.  Having struct page=
s for the memory would allow it to work more generally and wouldn't require=
 as much explicit support in drivers that wanted to use it.
>
> Some use cases:
> 1. Storage devices streaming directly to GPU device memory
> 2. GPU device memory to GPU device memory streaming
> 3. DVB/V4L/SDI devices streaming directly to GPU device memory
> 4. DVB/V4L/SDI devices streaming directly to storage devices
>
> Here is a relatively simple example of how this could work for testing.  =
This is obviously not a complete solution.
> - Device memory will be registered with Linux memory sub-system by create=
d corresponding struct page structures for device memory
> - get_user_pages_fast() will  return corresponding struct pages when CPU =
address points to the device memory
> - put_page() will deal with struct pages for device memory
>
[..]
> 4. iopmem
> iopmem : A block device for PCIe memory (https://lwn.net/Articles/703895/=
)

The change I suggest for this particular approach is to switch to
"device-DAX" [1]. I.e. a character device for establishing DAX
mappings rather than a block device plus a DAX filesystem. The pro of
this approach is standard user pointers and struct pages rather than a
new construct. The con is that this is done via an interface separate
from the existing gpu and storage device. For example it would require
a /dev/dax instance alongside a /dev/nvme interface, but I don't see
that as a significant blocking concern.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-October/007496.html
