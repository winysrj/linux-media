Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58443 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1IEAZB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 20:25:01 -0400
Message-ID: <4E6416D6.2060706@iki.fi>
Date: Mon, 05 Sep 2011 03:24:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko]
 undefined!
References: <4E640DBB.8010504@iki.fi> <4E64148A.3010704@yahoo.com>
In-Reply-To: <4E64148A.3010704@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2011 03:15 AM, Chris Rankin wrote:
> On 05/09/11 00:46, Antti Palosaari wrote:
>> Moikka,
>> Current linux-media make gives error. Any idea what's wrong?
>>
>>
>> Kernel: arch/x86/boot/bzImage is ready (#1)
>> Building modules, stage 2.
>> MODPOST 1907 modules
>> ERROR: "em28xx_add_into_devlist"
>> [drivers/media/video/em28xx/em28xx.ko] undefined!
>> WARNING: modpost: Found 2 section mismatch(es).
>> To see full details build your kernel with:
>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
>
> The function em28xx_add_into_devlist() should have been deleted as part
> of this change:
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=6c03e38b34dcfcdfa2f10cf984995a48f030f039
>
>
> Its only reference should have been removed at the same time.

git grep m28xx_add_into_devlis drivers/media/
drivers/media/video/em28xx/em28xx-cards.c: 
em28xx_add_into_devlist(dev);
drivers/media/video/em28xx/em28xx.h:void em28xx_add_into_devlist(struct 
em28xx *dev);

If you select em28xx-cards.c blob link you give you can see it is there 
still for some reason.

regards
Antti

-- 
http://palosaari.fi/
