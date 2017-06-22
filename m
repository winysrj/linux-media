Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:21635 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753649AbdFVVfj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 17:35:39 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <22860.14367.464168.657791@morden.metzler>
Date: Thu, 22 Jun 2017 23:35:27 +0200
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi, "Jasmin J." <jasmin@anw.at>
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
In-Reply-To: <20170621225712.426d3a17@audiostation.wuest.de>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
        <20170619221821.022fc473@macbox>
        <20170620093645.6f72fd1a@vento.lan>
        <20170620204121.4cff42d1@macbox>
        <20170620161043.1e6a1364@vento.lan>
        <20170621225712.426d3a17@audiostation.wuest.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Scheller writes:
 > Am Tue, 20 Jun 2017 16:10:43 -0300
 > schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
 > ...
 > > > - Maybe for 4.14: Support for the CineS2 V7 and FlexV4 line of
 > > >   cards/modules. This mainly involves a new demod driver (stv0910) and
 > > >   a new tuner driver (stv6111). Permissions for this are cleared with
 > > >   Ralph already. The glue code needed in ddbridge is rather easy, and
 > > >   as some ground work (mostly the MachXO2 support from the 2841 series)
 > > >   is now in, the changes are quite small. Patches are ready so far but
 > > >   need more cleanup (checkpatch fixes, camel case and such things).  
 > > 
 > > Please try to sync it with Ralph, in a way that his code won't
 > > diverge from the upstream one, as this will make easier for both
 > > sides to keep the Kernel in track with driver improvements.
 > 
 > This is not going to work. DD (Ralph and Manfred Voelkel) sort of maintain a shared code base between their Windows driver and the Linux kernel driver sources. While they didn't explicitely stated this, this can be noticed by the remarks and commented code in their OSS code, and the commit messages in their dddvb GIT (e.g. "sync with windows driver"). I've already cleaned up a lot of this (I believe no one wants to see such stuff in the linux kernel tree). If we're additionally going to replace all things camel case, with some more cleaning and maybe code shuffling after like a V4 patch series, those two sources are out of sync in a way that no automatic sync by applying patches will be possible anymore. So, pushing from vendor's upstream to the kernel seems to be the only option, and in fact, if the whole driver/package stack completely lives in the kernel sources, maybe DD even decide to directly commit upstream (kernel) again.
 > 
 > Putting Ralph into "To:", really like to hear an opinion from him on this whole subject.

Regarding divergence in the tuner/demod drivers I see some concerns. 
The TDA18212 driver as they are presently in kernel and Daniel's  github tree still seems to be missing features
like calibration and spur avoidance. This problem was already discussed here a few years ago.
I would not want to move to these versions if those features are still missing.

I also already told Daniel about our concerns regarding the CXD drivers in private mail.
Sony did not want us to use their code directly and we had to get our code approved
before publishing it. I do not know how the arrangement is regarding the in-kernel driver.
DVB-C2 support also seems to be missing in this.


 > > - you'll still need to patch DD tree, as I'm pretty sure there are
 > >   changes on the upstream driver that will need to be ported there;
 > 
 > The same as for the stv0910 code applies here, in addition that it's not sure if DD even wants this. DD even has KERNEL_VERSION_CODE ifdefs in some places. And - most importantly - they carry around an old version of the DVB core API (from what it looks, around linux-3.10, not exactly sure) which even was modified by some IOCTLs, vars, defines and the netstream and modulator support. I managed to remove all core API change deps from everything tuner related (and thats the reason things work in harmony with and in current kernels), but getting all this over to DD or even merge things from DD into the media subsystem will get "interesting".

We certainly will want to keep supporting older kernels via KERNEL_VERSION.
But I can change the dvb core version in dddvb to a newer version.

Also, some of the new tuning defines and properties are generally useful and
should be added to the kernel.

e.g.:

- adding SYS_DVBC2 to fe_delivery_system 

- DTV_INPUT

  to select an input on cards were demods can choose from several inputs

- DTV_PLS

  to set the gold code used for DVB-S2 physical layer scrambling.
  (btw. the sometimes used root and combo codes are redundant)
  Some driver mods misuse the upper bits of DTV_STREAM_ID (which is for MIS in DVB-S2) for this, but
  PLS and MIS are independent.


I know that the netstream and modulator support are proprietary but we will of course also need to keep
them dddvb package.
Btw., are there any standard APIs for modulator cards in the kernel now?


Regards,
Ralph
