Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1IGDXhk027507
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 11:13:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1IGDHAf011399
	for <video4linux-list@redhat.com>; Mon, 18 Feb 2008 11:13:17 -0500
Date: Mon, 18 Feb 2008 13:13:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Message-ID: <20080218131300.529b9862@gaivota>
In-Reply-To: <200802171121.13119.toralf.foerster@gmx.de>
References: <200802171121.13119.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: build #355 issue for v2.6.25-rc2-15-g1309d4e in function
 v4l2_i2c_attach
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, 17 Feb 2008 11:21:09 +0100
Toralf Förster <toralf.foerster@gmx.de> wrote:

> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...
>   CC      arch/x86/lib/usercopy_32.o
>   AR      arch/x86/lib/lib.a
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `v4l2_i2c_attach':
> (.text+0x26c67): undefined reference to `i2c_attach_client'
> make: *** [.tmp_vmlinux1] Error 1

This bug were already fixed. I'm waiting for Linus to pull. The patches fixing
it are available at:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
