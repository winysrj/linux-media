Return-path: <linux-media-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:62918 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3H3IeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 04:34:04 -0400
Message-ID: <522058B5.5020100@asianux.com>
Date: Fri, 30 Aug 2013 16:32:53 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: usb: b2c2: Kconfig: add PCI dependancy to DVB_B2C2_FLEXCOP_USB
References: <5220021C.2050700@asianux.com> <3939732.OJKiKvCJjt@dibcom294>
In-Reply-To: <3939732.OJKiKvCJjt@dibcom294>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2013 04:06 PM, Patrick Boettcher wrote:
> Hi,
> 
>  
> 
> On Friday 30 August 2013 10:23:24 Chen Gang wrote:
> 
>> DVB_B2C2_FLEXCOP_USB need depend on PCI, or can not pass compiling with
> 
>> allmodconfig for h8300.
> 
>>
> 
>> The related error:
> 
>>
> 
>> drivers/media/usb/b2c2/flexcop-usb.c: In function
> 
>> 'flexcop_usb_transfer_exit': drivers/media/usb/b2c2/flexcop-usb.c:393:3:
> 
>> error: implicit declaration of function 'pci_free_consistent'
> 
>> [-Werror=implicit-function-declaration] pci_free_consistent(NULL,
> 
>>
> 
>> [..]
> 
>>
> 
>> config DVB_B2C2_FLEXCOP_USB
> 
>> tristate "Technisat/B2C2 Air/Sky/Cable2PC USB"
> 
>> - depends on DVB_CORE && I2C
> 
>> + depends on DVB_CORE && I2C && PCI
> 
>> help
> 
>> Support for the Air/Sky/Cable2PC USB1.1 box (DVB/ATSC) by
> 
>> Technisat/B2C2,
> 
>  
> 
> Instead of selecting PCI we could/should use usb_alloc_coherent() and
> usb_free_cohrerent(), shouldn't we?
> 

Hmm... maybe it is a good idea, but I am just trying another ways.

Just now, I find that the module which calls pci*consistent() may not be
pci dependent module (e.g. may depend on ISA or EISA instead of).

So "arch/h8300/include/asm/pci.h" has related issues, I am just fixing.

Maybe our case is not an issue, after "asm/pci.h" fixed (although for
our case only, it can be improved, too, and if you are sure about it,
please help improving it, thanks).

>  
> 
> --
> 
> Patrick
> 


Thanks.
-- 
Chen Gang
