Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw.crowfest.net ([52.42.241.221]:57792 "EHLO gw.crowfest.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753242AbdCTQGn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 12:06:43 -0400
Message-ID: <1490024411.11105.5.camel@crowfest.net>
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
From: Michael Zoran <mzoran@crowfest.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Eric Anholt <eric@anholt.net>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 08:40:11 -0700
In-Reply-To: <20170320123345.5a7ac931@vento.lan>
References: <20170127215503.13208-1-eric@anholt.net>
         <20170315110128.37e2bc5a@vento.lan> <87a88m19om.fsf@eliezer.anholt.net>
         <20170315220834.7019fd8b@vento.lan> <1489628784.8127.1.camel@crowfest.net>
         <20170316062900.0e835118@vento.lan> <87shmbv2w3.fsf@eliezer.anholt.net>
         <20170319135846.395feef8@vento.lan> <1489943068.13607.5.camel@crowfest.net>
         <20170319221107.05227532@vento.lan> <20170320075831.65189ed7@vento.lan>
         <1490008101.28090.5.camel@crowfest.net> <20170320115821.736931ee@vento.lan>
         <1490022701.11105.3.camel@crowfest.net> <20170320123345.5a7ac931@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-03-20 at 12:33 -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 20 Mar 2017 08:11:41 -0700
> Michael Zoran <mzoran@crowfest.net> escreveu:
> 
> > On Mon, 2017-03-20 at 11:58 -0300, Mauro Carvalho Chehab wrote:
> > > Em Mon, 20 Mar 2017 04:08:21 -0700
> > > Michael Zoran <mzoran@crowfest.net> escreveu:
> > >   
> > > > On Mon, 2017-03-20 at 07:58 -0300, Mauro Carvalho Chehab
> > > > wrote:  
> > > > > Em Sun, 19 Mar 2017 22:11:07 -0300
> > > > > Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> > > > >     
> > > > > > Em Sun, 19 Mar 2017 10:04:28 -0700
> > > > > > Michael Zoran <mzoran@crowfest.net> escreveu:
> > > > > >     
> > > > > > > A working DT that I tried this morning with the current
> > > > > > > firmware
> > > > > > > is
> > > > > > > posted here:
> > > > > > > http://lists.infradead.org/pipermail/linux-rpi-kernel/201
> > > > > > > 7-Ma
> > > > > > > rch/
> > > > > > > 005924
> > > > > > > .html
> > > > > > > 
> > > > > > > It even works with minecraft_pi!      
> > > > > 
> > > > >     
> > > > 
> > > > Hi, can you e-mail out your config.txt?  Do you have audio
> > > > enabled
> > > > in
> > > > config.txt?  
> > > 
> > > yes, I have this:
> > > 
> > > $ cat config.txt |grep -i audio
> > > # uncomment to force a HDMI mode rather than DVI. This can make
> > > audio
> > > work in
> > > # Enable audio (loads snd_bcm2835)
> > > dtparam=audio=on
> > > 
> > > Full config attached.
> > > 
> > > Thanks,
> > > Mauro
> > >   
> > 
> > Are you using Eric Anholt's HDMI Audio driver that's included in
> > VC4? 
> > That could well be incompatible with the firmware driver. Or are
> > you
> > using a half mode of VC4 for audio and VCHIQ for video?
> 
> I'm using vanilla staging Kernel, from Greg's tree:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.
> git/commit/?h=staging-
> next&id=7bc49cb9b9b8bad32536c4b6d1aff1824c1adc6c
> 
> Plus the DWC2 fixup I wrote and DT changes you pointed
> (see enclosed).
> 
> I can disable the audio overlay here, as I don't have anything 
> connected to audio inputs/outputs.
> 
> Regards,
> Mauro
> 

Why is the vchiq node in the tree twice? For me to even respond anymore
you you going to have to include your entire dtb(whatever you are
using) run through dtc -I dtb -O dts.  You are also going to have to
include your exact .config file you used for building, and exactly what
these DWC2 fixeups are.

You don't even state exactly what platform you are using, Is it even an
RPI of some kind.
