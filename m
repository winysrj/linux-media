Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.88]:21739
	"HELO nm3-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752829Ab1IEAYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 20:24:14 -0400
Message-ID: <4E6416A9.9020206@yahoo.com>
Date: Mon, 05 Sep 2011 01:24:09 +0100
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

I think I see what's happened here. An extra reference to 
em28xx_add_into_devlist() has been added to em28xx_init_dev() at line 2888. This 
reference can be deleted because em28xx_init_extension() has been modified to 
add the struct em28xx to the devlist and then pass it to each extension's init() 
function all as a single operation.

Cheers,
Chris

