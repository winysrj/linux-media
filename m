Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56584 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbeDRTR7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 15:17:59 -0400
Date: Wed, 18 Apr 2018 16:17:53 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Douglas Fischer <fischerdouglasc@gmail.com>, jasmin@anw.at
Subject: Re: [PATCH v2 18/19] media: si470x: allow build both USB and I2C at
 the same time
Message-ID: <20180418161753.6814e941@vento.lan>
In-Reply-To: <20180418210612.20bb8199@lt530>
References: <9e596fe9e1fd9d2c27ae9abaeb900b2e0cd49011.1522959716.git.mchehab@s-opensource.com>
        <201804062347.x9zW4zaa%fengguang.wu@intel.com>
        <20180406134603.40d8d055@vento.lan>
        <20180418190740.092c2344@perian.wuest.de>
        <20180418155309.274fe735@vento.lan>
        <20180418210612.20bb8199@lt530>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 18 Apr 2018 21:06:12 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> Am Wed, 18 Apr 2018 15:53:09 -0300
> schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > Em Wed, 18 Apr 2018 19:07:40 +0200
> > Daniel Scheller <d.scheller.oss@gmail.com> escreveu:
> >   
> > > Am Fri, 6 Apr 2018 13:46:03 -0300
> > > schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> > >     
> > > > Em Sat, 7 Apr 2018 00:21:07 +0800
> > > > kbuild test robot <lkp@intel.com> escreveu:
> > > >       
> > > > > Hi Mauro,
> > > > > 
> > > > > I love your patch! Yet something to improve:
> > > > > [...]      
> > > > 
> > > > Fixed patch enclosed.
> > > > 
> > > > Thanks,
> > > > Mauro
> > > > 
> > > > [PATCH] media: si470x: allow build both USB and I2C at the same
> > > > time
> > > > 
> > > > Currently, either USB or I2C is built. Change it to allow
> > > > having both enabled at the same time.
> > > > 
> > > > The main reason is that COMPILE_TEST all[yes/mod]builds will
> > > > now contain all drivers under drivers/media.
> > > > 
> > > > Signed-off-by: Mauro Carvalho Chehab
> > > > <mchehab@s-opensource.com>      
> > > 
> > > FWIW, this patch (which seemingly is commit
> > > 58757984ca3c73284a45dd53ac66f1414057cd09 in media_tree.git) seems
> > > to break media_build in a way that on my systems only 20 drivers
> > > and modules are built now, while it should be in the 650+ modules
> > > range. Hans' automated daily testbuilds suffer from the same issue,
> > > looking at todays daily build logs (Wednesday.tar.bz2). I
> > > personally build against Kernel 4.16.2 on Gentoo.
> > > 
> > > This specific commit/patch was found using
> > > 
> > >   # git bisect good v4.17-rc1
> > >   # git bisect bad media_tree/master
> > > 
> > > And, "git revert 58767984..." makes all drivers being built again by
> > > media_build.
> > > 
> > > Not sure if there's something other for which this patch acts as the
> > > trigger of if this needs adaption in media_build, though I thought
> > > reporting this doesn't hurt.
> > > 
> > > Best regards,
> > > Daniel Scheller    
> > 
> > Please try this:
> > 
> > diff --git a/drivers/media/radio/si470x/Makefile
> > b/drivers/media/radio/si470x/Makefile index
> > 563500823e04..682b3146397e 100644 ---
> > a/drivers/media/radio/si470x/Makefile +++
> > b/drivers/media/radio/si470x/Makefile @@ -2,6 +2,6 @@
> >  # Makefile for radios with Silicon Labs Si470x FM Radio Receivers
> >  #
> >  
> > -obj-$(CONFIG_RADIO_SI470X) := radio-si470x-common.o
> > +obj-$(CONFIG_RADIO_SI470X) += radio-si470x-common.o
> >  obj-$(CONFIG_USB_SI470X) += radio-si470x-usb.o
> >  obj-$(CONFIG_I2C_SI470X) += radio-si470x-i2c.o  
> 
> That (ontop of media_tree.git HEAD) fixes it, back to 656 modules.

Good! I'll merge this with a proper description and apply ASAP.

Regards,
Mauro
