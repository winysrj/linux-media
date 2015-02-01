Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:33225 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbbBANHE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2015 08:07:04 -0500
Received: from mailo-proxy2.online.lv (smtp.online.lv [81.198.164.193])
	by fortimail.online.lv  with ESMTP id t11D70CV025209-t11D70CW025209
	for <linux-media@vger.kernel.org>; Sun, 1 Feb 2015 15:07:00 +0200
Message-ID: <54CE24F2.7090400@apollo.lv>
Date: Sun, 01 Feb 2015 15:06:58 +0200
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, hans.verkuil@cisco.com
CC: linux-media@vger.kernel.org
Subject: Re: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
References: <54B24370.6010004@apollo.lv> <54C9E238.9090101@xs4all.nl>
 <54CA1EB4.8000103@apollo.lv> <54CA23BE.7050609@xs4all.nl>
In-Reply-To: <54CA23BE.7050609@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29.01.2015 14:12, Hans Verkuil wrote:
> On 01/29/15 12:51, Raimonds Cicans wrote:
>> On 29.01.2015 09:33, Hans Verkuil wrote:
>>> On 01/11/2015 10:33 AM, Raimonds Cicans wrote:
>>>> I contacted you because I am hit by regression caused by your commit:
>>>> 453afdd "[media] cx23885: convert to vb2"
>>>>
>>>>
>>>> My system:
>>>> AMD Athlon(tm) II X2 240e Processor on Asus M5A97 LE R2.0 motherboard
>>>> TBS6981 card (Dual DVB-S/S2 PCIe receiver, cx23885 in kernel driver)
>>>>
>>>> After upgrade from kernel 3.13.10 (do not have commit) to 3.17.7
>>>> (have commit) I started receiving following IOMMU related messages:
>>>>
>>>> 1)
>>>> AMD-Vi: Event logged [IO_PAGE_FAULT device=0a:00.0 domain=0x001d
>>>> address=0x000000000637c000 flags=0x0000]
>>>>
>>>> where device=0a:00.0 is TBS6981 card
>>> As far as I can tell this has nothing to do with the cx23885 driver but is
>>> a bug in the amd iommu/BIOS. See e.g.:
>>>
>>> https://bbs.archlinux.org/viewtopic.php?pid=1309055
>>>
>>> I managed to reproduce the Intel equivalent if I enable CONFIG_IOMMU_SUPPORT.
>>>
>>> Most likely due to broken BIOS/ACPI/whatever information that's read by the
>>> kernel. I would recommend disabling this kernel option.
>>>
>> Maybe...
>>
>> But on other hand this did not happen on old kernel with old driver.
>> And when I did bisection on old kernel + media tree I started to
>> receive this message only on new driver.
> Was CONFIG_IOMMU_SUPPORT enabled in the old kernel?

zgrep CONFIG_IOMMU_SUPPORT /proc/config.gz
CONFIG_IOMMU_SUPPORT=y


Raimonds Cicans

