Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60095 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932339AbcIKNbi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 09:31:38 -0400
From: Christoph Hellwig <hch@lst.de>
To: hans.verkuil@cisco.com, brking@us.ibm.com,
        haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com,
        alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: replace pci_enable_msi_{exact_range} with pci_alloc_irq_vectors
Date: Sun, 11 Sep 2016 15:31:22 +0200
Message-Id: <1473600688-24043-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

this series switch the remaining users of pci_enable_msi_{exact_range}
(accounting for ahci and nvme being done through other channels) to
use the pci_alloc_irq_vectors helper instead and thus simplify the
interrupt code in those drivers a lot.  I decided to post it as a
series to everyone involved and linux-pci so that we can get a bit of
cross-review given that I have none of the involved hardware myself.

