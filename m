Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30323 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753232AbcJKUSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 16:18:31 -0400
To: Christoph Hellwig <hch@lst.de>
Cc: hans.verkuil@cisco.com, brking@us.ibm.com,
        haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ipr: use pci_irq_allocate_vectors
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
        <1473600688-24043-3-git-send-email-hch@lst.de>
Date: Tue, 11 Oct 2016 16:18:05 -0400
In-Reply-To: <1473600688-24043-3-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Sun, 11 Sep 2016 15:31:24 +0200")
Message-ID: <yq1twciod1e.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Switch the ipr driver to use pci_alloc_irq_vectors.  We need
Christoph> to two calls to pci_alloc_irq_vectors as ipr only supports
Christoph> multiple MSI-X vectors, but not multiple MSI vectors.

Christoph> Otherwise this cleans up a lot of cruft and allows to use a
Christoph> common request_irq loop for irq types, which happens to only
Christoph> iterate over a single line in the non MSI-X case.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
