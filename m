Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:35021 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752752AbcLNKiw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 05:38:52 -0500
Subject: Re: [PATCH 6/6] media/cobalt: use pci_irq_allocate_vectors
To: Christoph Hellwig <hch@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
 <1473600688-24043-7-git-send-email-hch@lst.de>
 <1c24ae65-067f-52fc-edfa-af2d0e222a19@xs4all.nl>
 <20161214102913.GA30236@lst.de>
Cc: hans.verkuil@cisco.com, brking@us.ibm.com,
        haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c5453c65-1256-338f-0ff1-6499d11987af@xs4all.nl>
Date: Wed, 14 Dec 2016 11:37:17 +0100
MIME-Version: 1.0
In-Reply-To: <20161214102913.GA30236@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/12/16 11:29, Christoph Hellwig wrote:
> Hi Hans,
>
> just checked the current Linux tree and cobalt still uses the old
> pci_enable_msi_range call.  Did you queue this patch up for 4.10?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Completely forgot this. Is it OK to queue it for 4.11? Or is it blocking
other follow-up work you want to do for 4.10?

Regards,

	Hans
