Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdKVOFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 09:05:12 -0500
Subject: Re: [PATCH 23/30] [media] atomisp: deprecate pci_get_bus_and_slot()
To: Alan Cox <alan@linux.intel.com>, linux-pci@vger.kernel.org,
        timur@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Arushi Singhal <arushisinghal19971997@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Valentin Vidic <Valentin.Vidic@CARNet.hr>,
        "open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB)"
        <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1511328675-21981-1-git-send-email-okaya@codeaurora.org>
 <1511328675-21981-24-git-send-email-okaya@codeaurora.org>
 <1511353247.3539.10.camel@linux.intel.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <b87604f8-07f5-5cdc-b022-286c17ea66eb@codeaurora.org>
Date: Wed, 22 Nov 2017 09:05:08 -0500
MIME-Version: 1.0
In-Reply-To: <1511353247.3539.10.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 11/22/2017 7:20 AM, Alan Cox wrote:
> On Wed, 2017-11-22 at 00:31 -0500, Sinan Kaya wrote:
>> pci_get_bus_and_slot() is restrictive such that it assumes domain=0
>> as
>> where a PCI device is present. This restricts the device drivers to
>> be
>> reused for other domain numbers.
> 
> The ISP v2 will always been in domain 0.
> 

Sorry, I didn't get what you mean. Do you mean that you are OK with the
change (thus, can I get a reviewed by) or do you mean that I should fix
the commit message?

I wrote a generic commit message and applied it to all 30 patches that
are more or less similar. I can certainly tailor the message a little
bit for atomisp since you confirmed domain 0.

> Alan
> 
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
