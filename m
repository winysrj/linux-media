Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39833
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751353AbdFZKq4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 06:46:56 -0400
Date: Mon, 26 Jun 2017 07:46:47 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi,
        "Jasmin J.\" <jasmin@anw.at>, "@s-opensource.com,
        Yasunari@s-opensource.com, Takiguchi@s-opensource.com,
        " <Yasunari.Takiguchi@sony.com>, "@s-opensource.com,
        Bird@s-opensource.com, Timothy@s-opensource.com,
        " <Tim.Bird@sony.com>"@s-opensource.com
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170626073944.1102ceb5@vento.lan>
In-Reply-To: <22864.55204.841821.456223@morden.metzler>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
        <20170619221821.022fc473@macbox>
        <20170620093645.6f72fd1a@vento.lan>
        <20170620204121.4cff42d1@macbox>
        <20170620161043.1e6a1364@vento.lan>
        <20170621225712.426d3a17@audiostation.wuest.de>
        <22860.14367.464168.657791@morden.metzler>
        <20170624135001.5bcafb64@vento.lan>
        <22864.55204.841821.456223@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Jun 2017 11:45:08 +0200
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Mauro Carvalho Chehab writes:
>  > Em Thu, 22 Jun 2017 23:35:27 +0200
>  > Ralph Metzler <rjkm@metzlerbros.de> escreveu:
>  >   
>  > > Daniel Scheller writes:  
>  > >  > Am Tue, 20 Jun 2017 16:10:43 -0300
>  > >  > schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>  > >  > ...    
>  > >  > > > - Maybe for 4.14: Support for the CineS2 V7 and FlexV4 line of
>  > >  > > >   cards/modules. This mainly involves a new demod driver (stv0910) and
>  > >  > > >   a new tuner driver (stv6111). Permissions for this are cleared with
>  > >  > > >   Ralph already. The glue code needed in ddbridge is rather easy, and
>  > >  > > >   as some ground work (mostly the MachXO2 support from the 2841 series)
>  > >  > > >   is now in, the changes are quite small. Patches are ready so far but
>  > >  > > >   need more cleanup (checkpatch fixes, camel case and such things).      
>  > >  > > 
>  > >  > > Please try to sync it with Ralph, in a way that his code won't
>  > >  > > diverge from the upstream one, as this will make easier for both
>  > >  > > sides to keep the Kernel in track with driver improvements.    
>  > >  > 
>  > >  > This is not going to work. DD (Ralph and Manfred Voelkel) sort of maintain a shared code base between their Windows 
>  > >  > driver and the Linux kernel driver sources. While they didn't explicitely stated this, this can be noticed by the 
>  > >  > remarks and commented code in their OSS code, and the commit messages in their dddvb GIT (e.g. "sync with windows driver"). 
>  > >  > I've already cleaned up a lot of this (I believe no one wants to see such stuff in the linux kernel tree). If we're 
>  > >  > additionally going to replace all things camel case, with some more cleaning and maybe code shuffling after like a V4 
>  > >  > patch series, those two sources are out of sync in a way that no automatic sync by applying patches will be possible 
>  > >  > anymore. So, pushing from vendor's upstream to the kernel seems to be the only option, and in fact, if the whole 
>  > >  > driver/package stack completely lives in the kernel sources, maybe DD even decide to directly commit upstream (kernel) again.  
>  > 
>  > Ralph, do you share Linux code with Windows, or are you just getting
>  > drivers from the manufacturer and converting them to Linux at dddvb
>  > tree?  
> 
> It differs from case to case.
> Digital Devices gets drivers and/or documetation from the manufacturer.
> Sometimes from this a Windows driver is written which we convert
> to Linux or a Linux driver is written directly.
> 
> 
> 
>  > Would it be possible to change things at the dddvb tree to make
>  > it to use our coding style (for example, replacing CamelCase by the
>  > kernel_style), in order to minimize the amount of work to sync from
>  > your tree?  
> 
> Yes

Good! With that, it should be easier to keep both versions containing
the same stuff.

> 
>  > > I also already told Daniel about our concerns regarding the CXD drivers in private mail.
>  > > Sony did not want us to use their code directly and we had to get our code approved
>  > > before publishing it. I do not know how the arrangement is regarding the in-kernel driver.
>  > > DVB-C2 support also seems to be missing in this.  
>  > 
>  > Sony recently started submitting CXD drivers to us directly (for cxd2880).
>  > 
>  > The upstream verson for cx2841 came from NetUP. I guess they develop
>  > the drivers themselves, but not really sure.
>  > 
>  > Perhaps we can ask Sony's help to make easier add the features that are 
>  > missing at the existing driver in a way that DDbridge could also use
>  > the upstream driver, or to do some other sort of agreement that would 
>  > make possible for us to use the same driver as you at the upstream Kernel.
>  > 
>  > (c/c Takiguchi-san and Tim Bird from Sony)  
> 
> 
> All I know is that they were strict with Digital Devices. We could not use
> their code directly. That's why I am surprised the Netup code contains
> Sony code.

I didn't say they're using Sony code. I actually suspect that they
did the same as you (but I have no means to be sure).

Yet, as Sony recently approached us for cxd2880, and they're now
developing an official driver to be upstreamed, I'm wandering if we
can get a better way to handle the cxd2841 driver in a way that will
make easier for everyone to use the same code.

>  > >  > > - you'll still need to patch DD tree, as I'm pretty sure there are
>  > >  > >   changes on the upstream driver that will need to be ported there;    
>  > >  > 
>  > >  > The same as for the stv0910 code applies here, in addition that it's
>  > >  > not sure if DD even wants this. DD even has KERNEL_VERSION_CODE ifdefs 
>  > >  > in some places. And - most importantly - they carry around an old 
>  > >  > version of the DVB core API (from what it looks, around linux-3.10,
>  > >  >  not exactly sure) which even was modified by some IOCTLs, vars, 
>  > >  > defines and the netstream and modulator support. I managed to
>  > >  >  remove all core API change deps from everything tuner related
>  > >  >  (and thats the reason things work in harmony with and in current
>  > >  >  kernels), but getting all this over to DD or even merge things
>  > >  >  from DD into the media subsystem will get "interesting".    
>  > > 
>  > > We certainly will want to keep supporting older kernels via KERNEL_VERSION.  
>  > 
>  > In the past, we used a script that "solves" KERNEL_VERSION on our Mercurial
>  > tree (https://linuxtv.org/hg/v4l-dvb) and gets rid of other ifdefs:
>  > 
>  > 	https://linuxtv.org/hg/v4l-dvb/file/3724e93f7af5/v4l/scripts/gentree.pl
>  > 
>  > I don't use it for ages, but I guess it shouldn't be hard to modify it to
>  > get rid of KERNEL_VERSION when submitting stuff from DD tree upstream.  
> 
> I'll see if that works.
> 
>  > > e.g.:
>  > > 
>  > > - adding SYS_DVBC2 to fe_delivery_system   
>  > 
>  > OK, we can do that, when adding a driver needing such feature.
>  >   
>  > > 
>  > > - DTV_INPUT
>  > > 
>  > >   to select an input on cards were demods can choose from several inputs  
>  > 
>  > We're actually wanting to use the media controller to change the
>  > pipeline (selecting inputs and outputs, directing output to a MPEG
>  > decoding pipeline and descrambler, etc).  
> 
> I this also for selecting frontend inputs?
> It sounds more like switching transport stream data paths after the demod.

The media controller is generic enough to control all pipelines at
the hardware level. It can be used to select frontend inputs, to
dynamically add/remove CAM modules, etc.

If I remember well, in the case of the hardware I was working on that
time, each frontend had 3 inputs (and the hardware had 2 identical
sets of tuner/demod),  plus 3 MPEG-TS demuxes) and 2 CAM modules.

With the media controller, any arrangement between input, tuner,
demod, demux and CAM is possible, as long as supported by
the hardware.

On your case, as you also have a modulator, you could even
use the modulator as a frontend input, as a way to test if
demodulator hardware is OK (again, if your hardware allows
wiring on such way).

The big advantage of using the media controller is that, as all
components of the pipeline are visible, you don't need to have
an enum (or something like that) to identify what each input
number means at the hardware.

Btw, that's an example of a MC pipeline:
	https://www.infradead.org/~mchehab/mc-next-gen/cx231xx_hvr930c_hd.png

The graph is automatically generated from the information
reported by the Kernel.

Unfortunately, the project I was working was shut down before
I was able to implement the MC bits on it, so I don't have
any MC pipelines from any advanced hardware.

So, on all pipelines there at
https://www.infradead.org/~mchehab/mc-next-gen/ have just one input.


>  > The needed bits are there already at the DVB core upstream (although
>  > we don't have, currently, any DVB driver allowing changes at the
>  > pipeline). My original intention were to upstream some embedded
>  > drivers with such usage, but, unfortunately, the MC changes took
>  > too many time to be applied. by the time it got merged, it was too
>  > late, due to some internal changes that happened about the same time.
>  >   
>  > > 
>  > > - DTV_PLS
>  > > 
>  > >   to set the gold code used for DVB-S2 physical layer scrambling.
>  > >   (btw. the sometimes used root and combo codes are redundant)
>  > >   Some driver mods misuse the upper bits of DTV_STREAM_ID (which is for MIS in DVB-S2) for this, but
>  > >   PLS and MIS are independent.  
>  > 
>  > In principle, sounds ok, but we need to take some care to avoid
>  > regressions here.  
> 
> I also support this old method in the stv0900 and stv0910 drivers.

OK!

>  > > I know that the netstream and modulator support are proprietary but we will of course also need to keep
>  > > them dddvb package.
>  > > Btw., are there any standard APIs for modulator cards in the kernel now?  
>  > 
>  > Right now, we don't have. Feel free to propose what you're using at the
>  > dddvb package as standard, if you think it is generic enough to support
>  > other modulators in the future.  
> 
> OK

Thanks,
Mauro
