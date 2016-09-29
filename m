Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48907 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751795AbcI2Sph (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Sep 2016 14:45:37 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8TIhF2I137535
        for <linux-media@vger.kernel.org>; Thu, 29 Sep 2016 14:45:37 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25s34v7vvh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Thu, 29 Sep 2016 14:45:36 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Thu, 29 Sep 2016 15:45:34 -0300
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
        <87twcyk1cd.fsf@linux.vnet.ibm.com> <20160929183757.GA4106@lst.de>
Date: Thu, 29 Sep 2016 15:45:29 -0300
In-Reply-To: <20160929183757.GA4106@lst.de> (Christoph Hellwig's message of
        "Thu, 29 Sep 2016 20:37:57 +0200")
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <87lgyak0ja.fsf@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph Hellwig <hch@lst.de> writes:

> On Thu, Sep 29, 2016 at 03:28:02PM -0300, Gabriel Krisman Bertazi wrote:
>> Christoph Hellwig <hch@lst.de> writes:
>> 
>> > Simply the interrupt setup by using the new PCI layer helpers.
>> 
>> Good clean up.  Tested and:
>> 
>> Acked-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
>
> Which tree should this go in through?

I'd say Greg's char-misc tree.

I'm stepping up to assist with the genwqe_card driver just now, since we
(ibm) missed some of the last patches that went in.  I'll add myself to
maintainers file.


-- 
Gabriel Krisman Bertazi

