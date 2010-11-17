Return-path: <mchehab@pedra>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:52104 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab0KQTvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:51:48 -0500
Message-ID: <4CE43049.1030704@kolumbus.fi>
Date: Wed, 17 Nov 2010 21:43:05 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Niklas Claesson <nicke.claesson@gmail.com>,
	Tuxoholic <tuxoholic@hotmail.de>
Subject: Re: [GIT PATCHES FOR 2.6.38] mantis for_2.6.38
References: <4CBB689F.1070100@redhat.com> <874obmiov5.fsf@nemi.mork.no> <4CDEA000.8020104@redhat.com>
In-Reply-To: <4CDEA000.8020104@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi Bjørn Mork and Mauro Carvalho Chehab.

The following patch was an experiment and wasn't actually meant for inclusion into the Kernel.

>>> Jul,10 2010: Mantis driver patch: use interrupt for I2C traffic instead of busy reg http://patchwork.kernel.org/patch/111245  Marko Ristola <marko.ristola@kolumbus.fi>

Would you please drop it from the Patchwork?
Would you Bjørn remove it from your Git repository?
The patch is ugly and it doesn't work, the broken part is active only with vp2033.

I'm sorry for the hassle.
Cheers, Marko Ristola

13.11.2010 16:26, Mauro Carvalho Chehab wrote:
> Em 12-11-2010 12:43, Bjørn Mork escreveu:
>> Hello, 
>>
>> I've been waiting for this list of patchwork patches to be included for
>> quite a while, and have now taken the liberty to clean them up as
>> necessary and add them to a git tree, based on the current media_tree
>> for_v2.6.38 branch, with exceptions as noted below:
>>
>>> 		== mantis patches - Waiting for Manu Abraham <abraham.manu@gmail.com> == 
>>>
>>> Jul,10 2010: Mantis driver patch: use interrupt for I2C traffic instead of busy reg http://patchwork.kernel.org/patch/111245  Marko Ristola <marko.ristola@kolumbus.fi>

>> The following changes since commit 
>>
>> af9f14f7fc31f0d7b7cdf8f7f7f15a3c3794aea3    [media] IR: add tv power scancode to rc6 mce keymap
>>
>> are available in the git repository at:
>>
>>   git://git.mork.no/mantis.git for_2.6.38
> 
