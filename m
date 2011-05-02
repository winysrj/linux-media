Return-path: <mchehab@pedra>
Received: from csmtp3.one.com ([91.198.169.23]:8670 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab1EBH6T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 03:58:19 -0400
Received: from Jantjes-MacBook.local (ip51ce01a5.speed.planet.nl [81.206.1.165])
	by csmtp3.one.com (Postfix) with ESMTPA id AC7F42406B5E
	for <linux-media@vger.kernel.org>; Mon,  2 May 2011 07:50:49 +0000 (UTC)
Message-ID: <4DBE6259.6050001@x34.nl>
Date: Mon, 02 May 2011 09:50:49 +0200
From: Jan <jan@x34.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: "new" tt s-1500 diseqc
References: <4DB98AE7.6020404@x34.nl> <201104300424.53244@orion.escape-edv.de>
In-Reply-To: <201104300424.53244@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks Oliver for pointing this out.

After applying the patch I managed to get the card working.

On 4/30/11 4:24 AM, Oliver Endriss wrote:
> On Thursday 28 April 2011 17:42:31 Jan wrote:
>> I try to get the "new" tt-1500 model using the BSBE1-D01A tuner to work with a diseqc switch.
>>
>> Currently I am working with a Gentoo 2.6.36 kernel patched with this patch
>> (http://www.mail-archive.com/linux-media@vger.kernel.org/msg29871.html) by Oliver Endriss. This runs
>> great if the card is directly connected to the dish.
>>
>> Once connected trough a diseqc switch dvblast-1.2.0 no longer gets a lock. Where this was possible
>> when using the "old" tt-1500 using the BSBE1-502A tuner.
>>
>> Does anyone have the "new" tt-1500 working using a diseqc switch?
>
> Yes, I verified that DiSEqC works with this card,
> before I submitted the patch.
>
> You need the latest version of the stv0288 frontend driver.
>
> The DiSEqC bug was fixed in this commit:
>
> commit 352a587ccdd4690b4465e29fef91942d8c94826d
> Author: Malcolm Priestley<tvboxspy@gmail.com>
> Date:   Sun Sep 26 15:16:20 2010 -0300
>
>      [media] DiSEqC bug fixed for stv0288 based interfaces
>
>      Fixed problem with DiSEqC communication. The message was wrongly modulated,
>      so the DiSEqC switch was not work.
>
>      This patch fixes DiSEqC messages, simple tone burst and tone on/off.
>      I verified it with osciloscope against the DiSEqC documentation.
>
>      Interface: PCI DVB-S TV tuner TeVii S420
>      Kernel: 2.6.32-24-generic (UBUNTU 10.4)
>
>      Signed-off-by: Josef Pavlik<josef@pavlik.it>
>      Tested-by: Malcolm Priestley<tvboxspy@gmail.com>
>      Cc: Igor M. Liplianin<liplianin@me.by>
>      Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
>
> HTH,
> Oliver
>
