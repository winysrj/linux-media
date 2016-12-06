Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:35020 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751772AbcLFWCW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 17:02:22 -0500
Received: by mail-oi0-f52.google.com with SMTP id b126so395245796oia.2
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2016 14:02:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <bedaa7a2-e42d-da83-5c2b-9d639b0397c5@deltatee.com>
References: <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com> <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com> <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com> <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <ac07a73f2601f6ca35cecc83c553feb0.squirrel@webmail.raithlin.com>
 <20161206163850.GC28066@obsidianresearch.com> <ec136c34-417d-8a55-c176-2c1d759a5fb8@deltatee.com>
 <20161206172838.GB19318@obsidianresearch.com> <bedaa7a2-e42d-da83-5c2b-9d639b0397c5@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Dec 2016 14:02:19 -0800
Message-ID: <CAPcyv4gw0rsMNvG=xMRFV0=4MkGuXis5L17Jm3fU69EZAVAS4A@mail.gmail.com>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 6, 2016 at 1:47 PM, Logan Gunthorpe <logang@deltatee.com> wrote:
> Hey,
>
>> Okay, so clearly this needs a kernel side NVMe specific allocator
>> and locking so users don't step on each other..
>
> Yup, ideally. That's why device dax isn't ideal for this application: it
> doesn't provide any way to prevent users from stepping on each other.

On this particular point I'm in the process of posting patches that
allow device-dax sub-division, so you could carve up a bar into
multiple devices of various sizes.
