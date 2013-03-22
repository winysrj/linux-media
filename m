Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab3CVMr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 08:47:56 -0400
Date: Fri, 22 Mar 2013 09:47:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: gennarone@gmail.com
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: media-tree build is broken
Message-ID: <20130322094749.28791576@redhat.com>
In-Reply-To: <514C41F7.2020201@gmail.com>
References: <514B4E97.6010903@googlemail.com>
	<20130322062551.1c42d65c@redhat.com>
	<514C41F7.2020201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Mar 2013 12:35:19 +0100
Gianluca Gennari <gennarone@gmail.com> escreveu:

> Il 22/03/2013 10:25, Mauro Carvalho Chehab ha scritto:
> > Em Thu, 21 Mar 2013 19:16:55 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> > 
> >> ...
> >> Kernel: arch/x86/boot/bzImage is ready  (#2)
> >> ERROR: "__divdi3" [drivers/media/common/siano/smsdvb.ko] undefined!
> >> make[1]: *** [__modpost] Fehler 1
> >> make: *** [modules] Fehler 2
> >>
> >>
> >> Mauro, I assume this is caused by one of the recent Siano patches ?
> > 
> > I tried to debug this one, but I couldn't reproduce it here. Not sure why,
> > but I'm not capable of producing those errors here for a long time.
> > 
> > Maybe the gcc compiler version currently provided with Fedora 18 doesn't
> > require any library for 64-bit divisions, even when compiling for a
> > 32 bits Kernel.
> > 
> > Anyway, I'm almost sure that the following patch fixes the issue.
> > Please test.
> 
> Hi Mauro, Frank,
> I can confirm the patch fixes the compilation problem.
> Tested on a 32 bit Ubuntu 10.04, compiling the latest media_build tree.

Thanks! I'll add a tested-by on the patch.

Regards,
Mauro
