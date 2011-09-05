Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.92]:31171
	"HELO nm2-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752829Ab1IEAPN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 20:15:13 -0400
Message-ID: <4E64148A.3010704@yahoo.com>
Date: Mon, 05 Sep 2011 01:15:06 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko]
 undefined!
References: <4E640DBB.8010504@iki.fi>
In-Reply-To: <4E640DBB.8010504@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/09/11 00:46, Antti Palosaari wrote:
> Moikka,
> Current linux-media make gives error. Any idea what's wrong?
>
>
> Kernel: arch/x86/boot/bzImage is ready (#1)
> Building modules, stage 2.
> MODPOST 1907 modules
> ERROR: "em28xx_add_into_devlist" [drivers/media/video/em28xx/em28xx.ko] undefined!
> WARNING: modpost: Found 2 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

The function em28xx_add_into_devlist() should have been deleted as part of this 
change:

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=6c03e38b34dcfcdfa2f10cf984995a48f030f039

Its only reference should have been removed at the same time.

Cheers,
Chris

