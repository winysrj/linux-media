Return-path: <linux-media-owner@vger.kernel.org>
From: Haggai Eran <haggaie@mellanox.com>
To: "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "serguei.sagalovitch@amd.com" <serguei.sagalovitch@amd.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        "John.Bridgman@amd.com" <John.Bridgman@amd.com>,
        "Alexander.Deucher@amd.com" <Alexander.Deucher@amd.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Max Gurtovoy" <maxg@mellanox.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Paul.Blinzer@amd.com" <Paul.Blinzer@amd.com>,
        "Felix.Kuehling@amd.com" <Felix.Kuehling@amd.com>,
        "ben.sander@amd.com" <ben.sander@amd.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 28 Nov 2016 18:36:07 +0000
Message-ID: <1480358165.19407.26.camel@mellanox.com>
References: <20161123190515.GA12146@obsidianresearch.com>
         <7bc38037-b6ab-943f-59db-6280e16901ab@amd.com>
         <20161123193228.GC12146@obsidianresearch.com>
         <c2c88376-5ba7-37d1-4d3e-592383ebb00a@amd.com>
         <20161123203332.GA15062@obsidianresearch.com>
         <dd60bca8-0a35-7a3a-d3ab-b95bc3d9b973@deltatee.com>
         <20161123215510.GA16311@obsidianresearch.com>
         <91d28749-bc64-622f-56a1-26c00e6b462a@deltatee.com>
         <20161124164249.GD20818@obsidianresearch.com>
         <3f2d2db3-fb75-2422-2a18-a8497fd5d70e@amd.com>
         <20161125193252.GC16504@obsidianresearch.com>
         <d9e064a0-9c47-3e41-3154-cece8c70a119@mellanox.com>
         <314e9ef7-f60e-bf6b-d488-c585f1ea60e8@amd.com>
In-Reply-To: <314e9ef7-f60e-bf6b-d488-c585f1ea60e8@amd.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <B71F61EC93277048B844210572EA850F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-11-28 at 09:48 -0500, Serguei Sagalovitch wrote:
+AD4- On 2016-11-27 09:02 AM, Haggai Eran wrote
+AD4- +AD4-=20
+AD4- +AD4- On PeerDirect, we have some kind of a middle-ground solution fo=
r
+AD4- +AD4- pinning
+AD4- +AD4- GPU memory. We create a non-ODP MR pointing to VRAM but rely on
+AD4- +AD4- user-space and the GPU not to migrate it. If they do, the MR ge=
ts
+AD4- +AD4- destroyed immediately. This should work on legacy devices witho=
ut
+AD4- +AD4- ODP
+AD4- +AD4- support, and allows the system to safely terminate a process th=
at
+AD4- +AD4- misbehaves. The downside of course is that it cannot transparen=
tly
+AD4- +AD4- migrate memory but I think for user-space RDMA doing that
+AD4- +AD4- transparently
+AD4- +AD4- requires hardware support for paging, via something like HMM.
+AD4- +AD4-=20
+AD4- +AD4- ...
+AD4- May be I am wrong but my understanding is that PeerDirect logic
+AD4- basically
+AD4- follow+AKAAoAAi-RDMA register MR+ACI- logic=20
Yes. The only difference from regular MRs is the invalidation process I
mentioned, and the fact that we get the addresses not from
get+AF8-user+AF8-pages but from a peer driver.

+AD4- so basically nothing prevent to +ACI-terminate+ACI-
+AD4- process for +ACI-MMU notifier+ACI- case when we are very low on memor=
y
+AD4- not making it similar (not worse) then PeerDirect case.
I'm not sure I understand. I don't think any solution prevents
terminating an application. The paragraph above is just trying to
explain how a non-ODP device/MR can handle an invalidation.

+AD4- +AD4- +AD4- I'm hearing most people say ZONE+AF8-DEVICE is the way to=
 handle this,
+AD4- +AD4- +AD4- which means the missing remaing piece for RDMA is some ki=
nd of DMA
+AD4- +AD4- +AD4- core support for p2p address translation..
+AD4- +AD4- Yes, this is definitely something we need. I think Will Davis's
+AD4- +AD4- patches
+AD4- +AD4- are a good start.
+AD4- +AD4-=20
+AD4- +AD4- Another thing I think is that while HMM is good for user-space
+AD4- +AD4- applications, for kernel p2p use there is no need for that.
+AD4- About HMM: I do not think that in the current form HMM would+AKAAoA-f=
it in
+AD4- requirement for generic P2P transfer case. My understanding is that a=
t
+AD4- the current stage HMM is good for +ACI-caching+ACI- system memory
+AD4- in device memory for fast GPU access but in RDMA MR non-ODP case
+AD4- it will not work because+AKAAoA-the location of memory should not be
+AD4- changed so memory should be allocated directly in PCIe memory.
The way I see it there are two ways to handle non-ODP MRs. Either you
prevent the GPU from migrating / reusing the MR's VRAM pages for as long
as the MR is alive (if I understand correctly you didn't like this
solution), or you allow the GPU to somehow notify the HCA to invalidate
the MR. If you do that, you can use mmu notifiers or HMM or something
else, but HMM provides a nice framework to facilitate that notification.

+AD4- +AD4-=20
+AD4- +AD4- Using ZONE+AF8-DEVICE with or without something like DMA-BUF to=
 pin and
+AD4- +AD4- unpin
+AD4- +AD4- pages for the short duration as you wrote above could work fine=
 for
+AD4- +AD4- kernel uses in which we can guarantee they are short.
+AD4- Potentially there is another issue related to pin/unpin. If memory
+AD4- could
+AD4- be used a lot of time then there is no sense to rebuild and program
+AD4- s/g tables each time if location of memory was not changed.
Is this about the kernel use or user-space? In user-space I think the MR
concept captures a long-lived s/g table so you don't need to rebuild it
(unless the mapping changes).

Haggai=
