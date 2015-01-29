Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42589 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751554AbbA2Hds (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 02:33:48 -0500
Message-ID: <54C9E238.9090101@xs4all.nl>
Date: Thu, 29 Jan 2015 08:33:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Raimonds Cicans <ray@apollo.lv>, hans.verkuil@cisco.com
CC: linux-media@vger.kernel.org
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
References: <54B24370.6010004@apollo.lv>
In-Reply-To: <54B24370.6010004@apollo.lv>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Raimonds,

On 01/11/2015 10:33 AM, Raimonds Cicans wrote:
> Hello.
> 
> I contacted you because I am hit by regression caused by your commit:
> 453afdd "[media] cx23885: convert to vb2"
> 
> 
> My system:
> AMD Athlon(tm) II X2 240e Processor on Asus M5A97 LE R2.0 motherboard
> TBS6981 card (Dual DVB-S/S2 PCIe receiver, cx23885 in kernel driver)
> 
> After upgrade from kernel 3.13.10 (do not have commit) to 3.17.7
> (have commit) I started receiving following IOMMU related messages:
> 
> 1)
> AMD-Vi: Event logged [IO_PAGE_FAULT device=0a:00.0 domain=0x001d 
> address=0x000000000637c000 flags=0x0000]
> 
> where device=0a:00.0 is TBS6981 card

As far as I can tell this has nothing to do with the cx23885 driver but is
a bug in the amd iommu/BIOS. See e.g.:

https://bbs.archlinux.org/viewtopic.php?pid=1309055

I managed to reproduce the Intel equivalent if I enable CONFIG_IOMMU_SUPPORT.

Most likely due to broken BIOS/ACPI/whatever information that's read by the
kernel. I would recommend disabling this kernel option.

Regards,

	Hans

> 
> sometimes this message was followed by storm of following messages:
> cx23885[0]: mpeg risc op code error
> ...

