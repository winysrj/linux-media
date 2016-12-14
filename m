Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:40856 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755007AbcLNKze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 05:55:34 -0500
Subject: Re: [PATCH 6/6] media/cobalt: use pci_irq_allocate_vectors
To: Christoph Hellwig <hch@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
 <1473600688-24043-7-git-send-email-hch@lst.de>
 <1c24ae65-067f-52fc-edfa-af2d0e222a19@xs4all.nl>
 <20161214102913.GA30236@lst.de>
 <c5453c65-1256-338f-0ff1-6499d11987af@xs4all.nl>
 <20161214104731.GA30382@lst.de>
Cc: hans.verkuil@cisco.com, brking@us.ibm.com,
        haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b7143ae-1034-c247-0a94-184a050d137a@xs4all.nl>
Date: Wed, 14 Dec 2016 11:52:33 +0100
MIME-Version: 1.0
In-Reply-To: <20161214104731.GA30382@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/12/16 11:47, Christoph Hellwig wrote:
> On Wed, Dec 14, 2016 at 11:37:17AM +0100, Hans Verkuil wrote:
>> Completely forgot this. Is it OK to queue it for 4.11? Or is it blocking
>> other follow-up work you want to do for 4.10?
>
> My plan was to see if Bjorn would take the patch to do the trivial removal
> of pci_enable_msix_exact and pci_enable_msix_range even as a late 4.10 patch
> given it's so harmless, but either way there is follow work pending ASAP
> so getting it in for 4.10 would be very helpful.
>

OK, then I'll make a pull request for 4.10 tomorrow.

Regards,

	Hans
