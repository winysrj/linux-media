Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33270 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdFCF0n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Jun 2017 01:26:43 -0400
Received: by mail-pf0-f182.google.com with SMTP id 83so2755158pfr.0
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 22:26:43 -0700 (PDT)
Date: Sat, 3 Jun 2017 15:26:51 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>, hans.verkuil@cisco.com
Subject: Re: media_build: fails to install
Message-ID: <20170603052648.GA15483@ubuntu.windy>
References: <CAAZRmGw=S+SGAHUOOL7wYNj040n9h6B9qNtSakHqzLpJMCGx1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAZRmGw=S+SGAHUOOL7wYNj040n9h6B9qNtSakHqzLpJMCGx1A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 31, 2017 at 03:57:04AM +0300, Olli Salonen wrote:
> It seems that I'm able to build the media_build correctly on Ubuntu
> 16.04.2 with kernel 4.8, but make install fails:
> 
> ~/src/media_build$ sudo make install
> make -C /home/olli/src/media_build/v4l install
> make[1]: Entering directory '/home/olli/src/media_build/v4l'
> make[1]: *** No rule to make target 'media-install', needed by 'install'.  Stop.
> make[1]: Leaving directory '/home/olli/src/media_build/v4l'
> Makefile:15: recipe for target 'install' failed
> make: *** [install] Error 2
> 

I can confirm this issue.

The reason is that scripts/make_makefile.pl aborts

make[1]: Entering directory '/home/me/git/clones/media_build/v4l'^M            
scripts/make_makefile.pl^M                                                      
Can't handle includes! In ../linux/drivers/staging/media/atomisp/pci/atomisp2/css2400/Makefile at scripts/          make_makefile.pl line 109, <GEN152> line 4.^M

because that css2400/Makefile includes another:

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
this kind of thing. But I am not aware of it. Hans, help pretty please?

Vince
