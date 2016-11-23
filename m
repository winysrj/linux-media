Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Bart Van Assche <bart.vanassche@sandisk.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <CAPcyv4i_5r2RVuV4F6V3ETbpKsf8jnMyQviZ7Legz3N4-v+9Og@mail.gmail.com>
 <75a1f44f-c495-7d1e-7e1c-17e89555edba@amd.com>
 <45c6e878-bece-7987-aee7-0e940044158c@deltatee.com>
 <eca737c1-415c-bcd4-80b9-628010638051@sandisk.com>
CC: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Linux-media@vger.kernel.org" <Linux-media@vger.kernel.org>,
        <haggaie@mellanox.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <09c49114-914e-8257-746d-71e39d34b103@amd.com>
Date: Wed, 23 Nov 2016 14:06:34 -0500
MIME-Version: 1.0
In-Reply-To: <eca737c1-415c-bcd4-80b9-628010638051@sandisk.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-11-23 12:27 PM, Bart Van Assche wrote:
> On 11/23/2016 09:13 AM, Logan Gunthorpe wrote:
>> IMO any memory that has been registered for a P2P transaction should be
>> locked from being evicted. So if there's a get_user_pages call it needs
>> to be pinned until the put_page. The main issue being with the RDMA
>> case: handling an eviction when a chunk of memory has been registered as
>> an MR would be very tricky. The MR may be relied upon by another host
>> and the kernel would have to inform user-space the MR was invalid then
>> user-space would have to tell the remote application.
>
> Hello Logan,
>
> Are you aware that the Linux kernel already supports ODP (On Demand 
> Paging)? See also the output of git grep -nHi on.demand.paging. See 
> also 
> https://www.openfabrics.org/images/eventpresos/workshops2014/DevWorkshop/presos/Tuesday/pdf/04_ODP_update.pdf.
>
> Bart.
My understanding is that  the main problems are (a) h/w support (b) 
compatibility with IB Verbs semantic.

