Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1CF0jJK019209
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 10:00:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m1CF0AWI005264
	for <video4linux-list@redhat.com>; Tue, 12 Feb 2008 10:00:10 -0500
Date: Tue, 12 Feb 2008 12:59:48 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080212125948.7e1dbf0a@gaivota>
In-Reply-To: <47B105B8.7010900@linuxtv.org>
References: <200802111154.31760.toralf.foerster@gmx.de>
	<20080212004251.GT6887@bakeyournoodle.com>
	<47B105B8.7010900@linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com,
	Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>,
	Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org,
	Steven Toth <stoth@hauppauge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: build #345 issue for v2.6.25-rc1 in tuner-core.c
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

On Mon, 11 Feb 2008 21:34:32 -0500
Michael Krufky <mkrufky@linuxtv.org> wrote:

> Tony Breeds wrote:
> > On Mon, Feb 11, 2008 at 11:54:31AM +0100, Toralf Förster wrote:
> >   
> >> Hello,
> >>
> >> the build with the attached .config failed, make ending with:
> >> ...
> >>   MODPOST vmlinux.o
> >> WARNING: modpost: Found 12 section mismatch(es).
> >> To see full details build your kernel with:
> >> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >>   GEN     .version
> >>   CHK     include/linux/compile.h
> >>   UPD     include/linux/compile.h
> >>   CC      init/version.o
> >>   LD      init/built-in.o
> >>   LD      .tmp_vmlinux1
> >> drivers/built-in.o: In function `set_type':
> >> tuner-core.c:(.text+0x8879d): undefined reference to `xc5000_attach'
> >> make: *** [.tmp_vmlinux1] Error 1
> >>     
> >
> > <snip>
> > Fix Build error for xc5000 tuner when built as module.
> >
> > Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> >   
> Patch is correct.  Not sure which tag is appropriate.....
> 
> Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
> 
> This should go straight to Linus.....  Andrew or Mauro, can one of you
> take care of it?

I should forward today some patches to Linus. I'll add this one to the list.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
