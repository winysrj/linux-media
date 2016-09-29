Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755480AbcI2S2M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Sep 2016 14:28:12 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8TIMm1V101904
        for <linux-media@vger.kernel.org>; Thu, 29 Sep 2016 14:28:11 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25s40v4k0m-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 29 Sep 2016 14:28:11 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Thu, 29 Sep 2016 15:28:08 -0300
From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: hans.verkuil@cisco.com, brking@us.ibm.com,
        haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] genwqe: use pci_irq_allocate_vectors
References: <1473600688-24043-1-git-send-email-hch@lst.de>
        <1473600688-24043-6-git-send-email-hch@lst.de>
Date: Thu, 29 Sep 2016 15:28:02 -0300
In-Reply-To: <1473600688-24043-6-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Sun, 11 Sep 2016 15:31:27 +0200")
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <87twcyk1cd.fsf@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph Hellwig <hch@lst.de> writes:

> Simply the interrupt setup by using the new PCI layer helpers.

Good clean up.  Tested and:

Acked-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

> One odd thing about this driver is that it looks like it could request
> multiple MSI vectors, but it will then only ever use a single one.

I'll take a look at this.

-- 
Gabriel Krisman Bertazi

