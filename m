Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51719 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbeEDMpy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 08:45:54 -0400
Message-ID: <1525437928.3373.16.camel@pengutronix.de>
Subject: Re: [Linaro-mm-sig] [PATCH 4/8] dma-buf: add peer2peer flag
From: Lucas Stach <l.stach@pengutronix.de>
To: Alex Deucher <alexdeucher@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Date: Fri, 04 May 2018 14:45:28 +0200
In-Reply-To: <CADnq5_O5t8aSJE6SFzyjw-6Pmba7B2aYMztVMOOQCF3drBHR5Q@mail.gmail.com>
References: <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
         <20180420101755.GA11400@infradead.org>
         <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
         <20180420124625.GA31078@infradead.org>
         <20180420152111.GR31310@phenom.ffwll.local>
         <20180424184847.GA3247@infradead.org>
         <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
         <20180425054855.GA17038@infradead.org>
         <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
         <CADnq5_P3bT0TStSXpKh11ydifv=KwKtRj-7tDS=GQXey+8tBPw@mail.gmail.com>
         <20180425064118.GA28100@infradead.org>
         <CADnq5_O5t8aSJE6SFzyjw-6Pmba7B2aYMztVMOOQCF3drBHR5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 25.04.2018, 13:44 -0400 schrieb Alex Deucher:
> On Wed, Apr 25, 2018 at 2:41 AM, Christoph Hellwig <hch@infradead.org
> > wrote:
> > On Wed, Apr 25, 2018 at 02:24:36AM -0400, Alex Deucher wrote:
> > > > It has a non-coherent transaction mode (which the chipset can opt to
> > > > not implement and still flush), to make sure the AGP horror show
> > > > doesn't happen again and GPU folks are happy with PCIe. That's at
> > > > least my understanding from digging around in amd the last time we had
> > > > coherency issues between intel and amd gpus. GPUs have some bits
> > > > somewhere (in the pagetables, or in the buffer object description
> > > > table created by userspace) to control that stuff.
> > > 
> > > Right.  We have a bit in the GPU page table entries that determines
> > > whether we snoop the CPU's cache or not.
> > 
> > I can see how that works with the GPU on the same SOC or SOC set as the
> > CPU.  But how is that going to work for a GPU that is a plain old PCIe
> > card?  The cache snooping in that case is happening in the PCIe root
> > complex.
> 
> I'm not a pci expert, but as far as I know, the device sends either a
> snooped or non-snooped transaction on the bus.  I think the
> transaction descriptor supports a no snoop attribute.  Our GPUs have
> supported this feature for probably 20 years if not more, going back
> to PCI.  Using non-snooped transactions have lower latency and faster
> throughput compared to snooped transactions.

PCI-X (as in the thing which as all the rage before PCIe) added a
attribute phase to each transaction where the requestor can enable
relaxed ordering and/or no-snoop on a transaction basis. As those are
strictly performance optimizations the root-complex isn't required to
honor those attributes, but implementations that care about performance
 usually will.

Regards,
Lucas
