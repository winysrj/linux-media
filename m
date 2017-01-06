Return-path: <linux-media-owner@vger.kernel.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jerome Glisse <jglisse@redhat.com>
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <20170105183927.GA5324@gmail.com>
 <20170105190113.GA12587@obsidianresearch.com>
 <20170105195424.GB2166@redhat.com>
 <20170105200719.GB31047@obsidianresearch.com>
 <20170105201935.GC2166@redhat.com>
 <20170105224215.GA3855@obsidianresearch.com>
 <20170105232352.GB6426@redhat.com>
 <20170106003034.GB4670@obsidianresearch.com>
CC: Jerome Glisse <j.glisse@gmail.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>,
        "'linux-nvdimm@lists.01.org'" <linux-nvdimm@ml01.01.org>,
        "'Linux-media@vger.kernel.org'" <Linux-media@vger.kernel.org>,
        "'dri-devel@lists.freedesktop.org'" <dri-devel@lists.freedesktop.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>,
        "Kuehling, Felix" <Felix.Kuehling@amd.com>,
        "Blinzer, Paul" <Paul.Blinzer@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Sander, Ben" <ben.sander@amd.com>, <hch@infradead.org>,
        <david1.zhou@amd.com>, <qiang.yu@amd.com>
From: Serguei Sagalovitch <serguei.sagalovitch@amd.com>
Message-ID: <26f86650-5302-0df2-9b51-dd967f3e5a7b@amd.com>
Date: Thu, 5 Jan 2017 19:41:26 -0500
MIME-Version: 1.0
In-Reply-To: <20170106003034.GB4670@obsidianresearch.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-01-05 07:30 PM, Jason Gunthorpe wrote:
> ........ but I am opposed to
> the idea we need two API paths that the *driver* has to figure out.
> That is fundamentally not what I want as a driver developer.
>
> Give me a common API to convert '__user *' to a scatter list and pin
> the pages.
Completely agreed. IMHO there is no sense to duplicate the same logic
everywhere as well as  trying to find places where it is missing.

Sincerely yours,
Serguei Sagalovitch

