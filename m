Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38762 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751710AbcI2Ss2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Sep 2016 14:48:28 -0400
Date: Thu, 29 Sep 2016 20:48:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, hans.verkuil@cisco.com,
        brking@us.ibm.com, haver@linux.vnet.ibm.com,
        ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com,
        kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] genwqe: use pci_irq_allocate_vectors
Message-ID: <20160929184824.GA4380@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de> <1473600688-24043-6-git-send-email-hch@lst.de> <87twcyk1cd.fsf@linux.vnet.ibm.com> <20160929183757.GA4106@lst.de> <87lgyak0ja.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lgyak0ja.fsf@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 29, 2016 at 03:45:29PM -0300, Gabriel Krisman Bertazi wrote:
> I'm stepping up to assist with the genwqe_card driver just now, since we
> (ibm) missed some of the last patches that went in.  I'll add myself to
> maintainers file.

Can your forward it to Greg together with whatever other changes are
pending for the driver?
