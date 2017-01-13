Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0053.outbound.protection.outlook.com ([104.47.33.53]:28878
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751107AbdAMV2Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 16:28:25 -0500
Subject: Re: kill off pci_enable_msi_{exact,range}
To: Christoph Hellwig <hch@lst.de>, Bjorn Helgaas <helgaas@kernel.org>
References: <1483994260-19797-1-git-send-email-hch@lst.de>
 <20170112212900.GE8312@bhelgaas-glaptop.roam.corp.google.com>
 <20170113075503.GA26014@lst.de> <20170113080553.GA26280@lst.de>
 <20170113171321.GA22776@bhelgaas-glaptop.roam.corp.google.com>
 <20170113171519.GA5857@lst.de>
CC: <linux-pci@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        <netdev@vger.kernel.org>, <linux-media@vger.kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d77a2602-3fd8-8db6-c9d9-3f7ed96db657@amd.com>
Date: Fri, 13 Jan 2017 15:28:17 -0600
MIME-Version: 1.0
In-Reply-To: <20170113171519.GA5857@lst.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 1/13/2017 11:15 AM, Christoph Hellwig wrote:
> On Fri, Jan 13, 2017 at 11:13:21AM -0600, Bjorn Helgaas wrote:
>> I dropped the empty commit and replaced the xgbe patch with the one below.
>> Can you take a look at [1] and make sure it's what you expected?
> 
> This looks great, thanks!
> 

Christoph and Bjorn, thanks for taking care of this!

Tom
