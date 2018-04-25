Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754638AbeDYOpK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 10:45:10 -0400
Date: Wed, 25 Apr 2018 11:45:05 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: mjs <mjstork@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add new dvb-t board ":Zolid Hybrid Tv Stick"
Message-ID: <20180425114505.5f34ca05@vento.lan>
In-Reply-To: <5ae0736a.46a7500a.f10d6.eeaf@mx.google.com>
References: <5ae045df.ddf5500a.22ca5.10bb@mx.google.com>
        <20180425061620.19037894@vento.lan>
        <5ae0543f.cebe500a.d570c.a01a@mx.google.com>
        <20180425081855.5ba4fc79@vento.lan>
        <5ae0736a.46a7500a.f10d6.eeaf@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 25 Apr 2018 14:24:09 +0200
mjs <mjstork@gmail.com> escreveu:

> Op Wed, 25 Apr 2018 08:18:55 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> schreef:
> 
> > Em Wed, 25 Apr 2018 12:11:10 +0200
> > mjs <mjstork@gmail.com> escreveu:
> >   
> > > Op Wed, 25 Apr 2018 06:16:20 -0300
> > > Mauro Carvalho Chehab <mchehab+samsung@kernel.org> schreef:
> > >     
> > > > Em Wed, 25 Apr 2018 11:09:50 +0200
> > > > mjs <mjstork@gmail.com> escreveu:
> > > >       
> > > > > From 0a3355b47dc465c6372d30fa4a36d1c5db6c0fe2 Mon Sep 17 00:00:00 2001
> > > > > From: Marcel Stork <mjstork@gmail.com>
> > > > > Date: Wed, 25 Apr 2018 10:53:34 +0200
> > > > > Subject: [PATCH] Add new dvb-t board ":Zolid Hybrid Tv Stick".
> > > > > 
> > > > > Extra code to be able to use this stick, only digital, not analog nor remote-control.
> > > > > 
> > > > > Changes to be committed:
> > > > > 	modified:   em28xx-cards.c
> > > > > 	modified:   em28xx-dvb.c
> > > > > 	modified:   em28xx.h        
> > > > 
> > > > You forgot to add your Signed-off-by. That's mandatory for patches to
> > > > be acepted.      
> > > 
> > > Ok, still learning
> > >     
> > > >       
> > > > > 
> > > > > ---
> > > > >  em28xx-cards.c | 30 +++++++++++++++++++++++++++++-
> > > > >  em28xx-dvb.c   |  1 +
> > > > >  em28xx.h       |  1 +
> > > > >  3 files changed, 31 insertions(+), 1 deletion(-)        
> > > > 
> > > > 
> > > > use git diff against upstream tree. This should be using
> > > > a different paths there, e.g. drivers/media/usb/em28xx/...      
> > > 
> > > This is actually against the upstream tree, in line with your advice in a previous mail.
> > > After git clone... and ./build, I did not do "make install" but copy-paste out of the /media_build/linux/drivers/media/usb/em28xx
> > > Reason, I do not have an experimental pc and some parts are experimental.
> > > I did not want to take the risk to crash my working pc at this moment in time.
> > > 
> > > I will try to work around this problem.    
> > 
> > Upstream is actually this tree:
> > 
> > 	https://git.linuxtv.org/media_tree.git/
> > 
> > The media_build tree is what we call a "backport tree" :-)  
> 
> I started with "https://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches" in line with your advice in a previous mail.

The first line there at "Patch preparation" says:

	"For Kernel media patches, they should be created against the Linux Kernel master linux_media git tree[1]"

[1] With links to: http://git.linuxtv.org/media_tree.git

> Followed the text to "https://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device Drivers" basic approach.

I see... here, information were indeed incomplete.

I just updated it.


> Also to "https://git.linuxtv.org/media_build.git/about/"
> I have used "git clone --depth=1 git://linuxtv.org/media_build.git" followed by ./build and copy/paste files mentioned above.
> This is not the required upstream tree ?

There's a similar instruction at media_tree.git/about, with is the one you
would be using instead.

> 
> Work around:
> Added the path to all files manually.
> This is acceptable ?

An acceptable workaround would be to create another tree at the place
it untars the driver's tarball (under linux dir), and do the
diffs there.

The ./build script actually does something similar to that, if used
with the --main-git option, but, if you're willing to use it, be
careful to do on a separate clone, as otherwise it may destroy your
work, as it will setup a different environment, and you'll lose
any changes you've made inside that media_build cloned tree.

Thanks,
Mauro
