Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33650 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdFHLXG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 07:23:06 -0400
Received: by mail-pf0-f193.google.com with SMTP id f27so4797018pfe.0
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 04:23:06 -0700 (PDT)
Date: Thu, 8 Jun 2017 21:23:19 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Matthias Schwarzott <zzam@gentoo.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Unknown symbol put_vaddr_frames when using media_build
Message-ID: <20170608112306.GA5611@ubuntu.windy>
References: <6ea4c402-9523-2345-9dd3-0fb041f07f27@gentoo.org>
 <20170607152338.5fd9d304@vento.lan>
 <cc11c60e-8a39-35f2-06e5-f6cb3b1cdc4a@gentoo.org>
 <20170607201201.3e9eef8f@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607201201.3e9eef8f@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 07, 2017 at 08:12:01PM -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 7 Jun 2017 22:17:50 +0200
> Matthias Schwarzott <zzam@gentoo.org> escreveu:
> 
> > Am 07.06.2017 um 20:23 schrieb Mauro Carvalho Chehab:
> > > Em Tue, 9 May 2017 06:56:25 +0200
> > > Matthias Schwarzott <zzam@gentoo.org> escreveu:
> > >   
> > >> Hi!
> > >>
> > >> Whenever I compile the media drivers using media_build against a recent
> > >> kernel, I get this message when loading them:
> > >>
> > >> [    5.848537] media: Linux media interface: v0.10
> > >> [    5.881440] Linux video capture interface: v2.00
> > >> [    5.881441] WARNING: You are using an experimental version of the
> > >> media stack.
> > >> ...
> > >> [    6.166390] videobuf2_memops: Unknown symbol put_vaddr_frames (err 0)
> > >> [    6.166394] videobuf2_memops: Unknown symbol get_vaddr_frames (err 0)
> > >> [    6.166396] videobuf2_memops: Unknown symbol frame_vector_destroy (err 0)
> > >> [    6.166398] videobuf2_memops: Unknown symbol frame_vector_create (err 0)
> > >>
> > >> That means I am not able to load any drivers being based on
> > >> videobuf2_memops without manual actions.
> > >>
> > >> I used kernel 4.11.0, but it does not matter which kernel version
> > >> exactly is used.
> > >>
> > >> My solution for that has been to modify mm/Kconfig of my kernel like
> > >> this and then enable FRAME_VECTOR in .config  
> > > 
> > > Well, if you build your Kernel with VB2 compiled, you'll have it.
> > >   
> > Sure.
> > 
> > So my question is:
> > How good do the kernel origin vb2 and the media_build vb2 play together?
> > 
> > Will modprobe always choose the media_build one?
> > Or will "make install" just overwrite the original file?
> 
> make install *should* overwrite the old one. If not, then there's a problem
> at the media-build makefile [1].
> 

There is a problem. make install has been broken for at least a week,
see the thread "media_build: fails to install"

The reason is that scripts/make_makefile.pl aborts

make[1]: Entering directory '/home/me/git/clones/media_build/v4l'
scripts/make_makefile.pl
Can't handle includes! In 
../linux/drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile at
scripts/          make_makefile.pl line 109, <GEN152> line 4.

is because that css2400/Makefile includes another:

$ cat ../linux/drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile

ccflags-y += -DISP2400B0
ISP2400B0 := y

include $(srctree)/$(src)/../Makefile.common

The abort of scripts/make_makefile.pl means that the v4l/Makefile
does not get completely written out, in particular the rules for
making the 'media-install' target.

I am not sure how to fix this. The make_makefile.pl deliberately
falls over when given an include to deal with, so there must be
some other mechanism in the media_build framework that handles
this kind of thing. But I am not aware of it. 

Vince
