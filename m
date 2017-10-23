Return-path: <linux-media-owner@vger.kernel.org>
To: David Laight <David.Laight@ACULAB.COM>,
        "'Petrosyan, Ludwig'" <ludwig.petrosyan@desy.de>
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
References: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
 <7f5e0303-f4ea-781a-8dec-74b30990d54f@desy.de>
 <be9f2dee-bb37-9e8f-af72-6ee1127ba8d4@deltatee.com>
 <1381807327.12461494.1508652825239.JavaMail.zimbra@desy.de>
 <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d61b6829-0515-a809-2a43-c41add4b1594@deltatee.com>
Date: Mon, 23 Oct 2017 16:04:26 -0600
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DD00A04EA@AcuExch.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 23/10/17 10:08 AM, David Laight wrote:
> It is also worth checking that the hardware actually supports p2p transfers.
> Writes are more likely to be supported then reads.
> ISTR that some intel cpus support some p2p writes, but there could easily
> be errata against them.

Ludwig mentioned a PCIe switch. The few switches I'm aware of support 
P2P transfers. So if everything is setup correctly, the TLPs shouldn't 
even touch the CPU.

But, yes, generally it's a good idea to start with writes and see if 
they work first.

Logan
