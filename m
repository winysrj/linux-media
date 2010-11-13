Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0KMO0q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 09:26:46 -0500
Message-ID: <4CDEA000.8020104@redhat.com>
Date: Sat, 13 Nov 2010 12:26:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-media@vger.kernel.org,
	Marko Ristola <marko.ristola@kolumbus.fi>,
	Manu Abraham <abraham.manu@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Niklas Claesson <nicke.claesson@gmail.com>,
	Tuxoholic <tuxoholic@hotmail.de>
Subject: Re: [GIT PATCHES FOR 2.6.38] mantis for_2.6.38
References: <4CBB689F.1070100@redhat.com> <874obmiov5.fsf@nemi.mork.no>
In-Reply-To: <874obmiov5.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-11-2010 12:43, Bjørn Mork escreveu:
> Hello, 
> 
> I've been waiting for this list of patchwork patches to be included for
> quite a while, and have now taken the liberty to clean them up as
> necessary and add them to a git tree, based on the current media_tree
> for_v2.6.38 branch, with exceptions as noted below:
> 
>> 		== mantis patches - Waiting for Manu Abraham <abraham.manu@gmail.com> == 
>>
>> Apr,15 2010: [5/8] ir-core: convert mantis from ir-functions.c                      http://patchwork.kernel.org/patch/92961   David HÃ¤rdeman <david@hardeman.nu>
> 
> already applied as commit f0bdee26a2dc904c463bae1c2ae9ad06f97f100d
> 
>> Jun,20 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/107036  Marko Ristola <marko.ristola@kolumbus.fi>
> 
> duplicate of http://patchwork.kernel.org/patch/118173
> 
>> Jun,20 2010: [2/2] DVB/V4L: mantis: remove unused files                             http://patchwork.kernel.org/patch/107062  BjÃ¸rn Mork <bjorn@mork.no>
>> Jun,20 2010: mantis: use dvb_attach to avoid double dereferencing on module removal http://patchwork.kernel.org/patch/107063  BjÃ¸rn Mork <bjorn@mork.no>
>> Jun,21 2010: Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to make modules  http://patchwork.kernel.org/patch/107147  Manu Abraham <abraham.manu@gmail.com>
>> Jul, 3 2010: mantis: Rename gpio_set_bits to mantis_gpio_set_bits                   http://patchwork.kernel.org/patch/109972  Ben Hutchings <ben@decadent.org.uk>
>> Jul, 8 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/110909  Marko Ristola <marko.ristola@kolumbus.fi>
> 
> another duplicate of http://patchwork.kernel.org/patch/118173
> 
>> Jul, 9 2010: Mantis: append tasklet maintenance for DVB stream delivery             http://patchwork.kernel.org/patch/111090  Marko Ristola <marko.ristola@kolumbus.fi>
>> Jul,10 2010: Mantis driver patch: use interrupt for I2C traffic instead of busy reg http://patchwork.kernel.org/patch/111245  Marko Ristola <marko.ristola@kolumbus.fi>
>> Jul,19 2010: Twinhan DTV Ter-CI (3030 mantis)                                       http://patchwork.kernel.org/patch/112708  Niklas Claesson <nicke.claesson@gmail.com>
> 
> Missing Signed-off-by, and I'm also a bit confused wrt what the patch
> actually is.  Needs further cleanup.
> 
>> Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>
>> Oct,10 2010: [v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod   http://patchwork.kernel.org/patch/244201  Tuxoholic <tuxoholic@hotmail.de>
> 

Patchwork updated. Thanks for checking those duplicated stuff.
> 
> 
> The following changes since commit 
> 
> af9f14f7fc31f0d7b7cdf8f7f7f15a3c3794aea3    [media] IR: add tv power scancode to rc6 mce keymap
> 
> are available in the git repository at:
> 
>   git://git.mork.no/mantis.git for_2.6.38

Didn't work:

git pull git://git.mork.no/mantis.git for_2.6.38
fatal: Couldn't find remote ref for_2.6.38

Cheers,
Mauro
