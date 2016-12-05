Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:46010 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752037AbcLET7k (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 14:59:40 -0500
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
References: <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <20161205191438.GA20464@obsidianresearch.com>
 <10356964-c454-47fb-7fb3-8bf2a418b11b@deltatee.com>
 <20161205194614.GA21132@obsidianresearch.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Stephen Bates <sbates@raithlin.com>,
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
Message-ID: <d8795aa9-f93d-feff-8189-34b9d5b70287@deltatee.com>
Date: Mon, 5 Dec 2016 12:59:29 -0700
MIME-Version: 1.0
In-Reply-To: <20161205194614.GA21132@obsidianresearch.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/12/16 12:46 PM, Jason Gunthorpe wrote:
> NVMe might have to deal with pci-e hot-unplug, which is a similar
> problem-class to the GPU case..

Sure, but if the NVMe device gets hot-unplugged it means that all the 
CMB mappings are useless and need to be torn down. This probably means 
killing any process that has mappings open.

> In any event the allocator still needs to track which regions are in
> use and be able to hook 'free' from userspace. That does suggest it
> should be integrated into the nvme driver and not a bolt on driver..

Yup, that's correct. And yes, I've never suggested this to be a bolt on 
driver -- I always expected for it to get integrated into the nvme 
driver. (iopmem was not meant for this.)

Logan
