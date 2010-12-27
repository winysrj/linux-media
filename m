Return-path: <mchehab@gaivota>
Received: from ns1.baycom.de ([109.125.67.67]:55005 "EHLO mail.baycom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab0L0T7W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 14:59:22 -0500
Message-ID: <4D18EDCA.7000700@fliegl.de>
Date: Mon, 27 Dec 2010 20:49:30 +0100
From: Deti Fliegl <deti@fliegl.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: archer@in.tum.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: removal of dabusb driver from Linux Kernel
References: <4C95FCD7.5060001@redhat.com> <4D18B325.7020904@redhat.com>
In-Reply-To: <4D18B325.7020904@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

sorry for not answering in time. Please feel free to remove this piece 
of unusable code from the kernel.

Deti

On 12/27/2010 04:39 PM, Mauro Carvalho Chehab wrote:
> Hi,
>
> I'm responsible for the multimedia support at Linux Kernel. I tried to contact the
> authors of the DABUSB driver back in september some time ago without any luck.
>
> We're considering the removal of dabusb driver from Linux Kernel, due to a few
> reasons:
>
> 1) The driver is for an engineering sample only which was never sold as a commercial
>     product.
> 2) The DAB API is completely undocumented and was never reviewed. Should other DAB
>     drivers ever appear, then I'd rather start from scratch defining an API then
>     continue this dubious API.
>
>  From our research, it seems that a variant of the driver is/where used on some hardware
> developed by you and used on some Terratec hardware (Dr Box 1).
>
> If we don't have any answer from you, we'll schedule the driver to be removed from
> Linux kernel on the next version, as we were unable to identify anyone using the
> hardware supported at the kernel driver.
>
> Thanks,
> Mauro
>
>
> Em 19-09-2010 09:06, Mauro Carvalho Chehab escreveu:
>> Hi Deti and Georg,
>>
>> The dabusb driver at the Linux kernel seems to be pretty much unmaintained. Since 2006, when I
>> moved it to /drivers/media, I received no patches from the driver authors. All the patches
>> we've got since then were usual trivial fixes and a few other drivers correcting some core
>> API changes.
>>
>> Also, I never found anyone with the hardware, in order to test if the driver keeps working.
>> Is there any commercial hardware using it?
>>
>> With the removal of BKL, the driver will need fixes or will likely be removed.
>>
>> So, if you still care about the driver, please contact me asap. Otherwise, I'll move it to
>> drivers/staging and mark it to die for 2.6.38.
>>
>> Thanks,
>> Mauro
>

