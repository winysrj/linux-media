Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35472 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043AbaIBAyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Sep 2014 20:54:41 -0400
Message-ID: <1409615932.1819.16.camel@palomino.walls.org>
Subject: Re: strange empia device
From: Andy Walls <awalls@md.metrocast.net>
To: Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Lorenzo Marcantonio <l.marcantonio@logossrl.com>,
	linux-media@vger.kernel.org
Date: Mon, 01 Sep 2014 19:58:52 -0400
In-Reply-To: <5403358C.4070504@googlemail.com>
References: <20140825190109.GB3372@aika.discordia.loc>
	 <5403358C.4070504@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2014-08-31 at 16:47 +0200, Frank Schäfer wrote:
> Hi Lorenzo,
> 
> Am 25.08.2014 um 21:01 schrieb Lorenzo Marcantonio:
> > Just bought a roxio video capture dongle. Read around that it was an
> > easycap clone (supported, then); it seems it's not so anymore :(
> >
> > It identifies as 1b80:e31d Roxio Video Capture USB
> >
> > (it also uses audio class for audio)
> >
> > Now comes the funny thing. Inside there is the usual E2P memory,
> > a regulator or two and an empia marked EM2980 (*not* em2890!); some
> > passive and nothing else.
> >
> > Digging around in the driver cab (emBDA.inf) shows that it seems an
> > em28285 driver rebranded by roxio... it installs emBDAA.sys and
> > emOEMA.sys (pretty big: about 1.5MB combined!); also a 16KB merlinFW.rom
> > (presumably a firmware for the em chip? 

A Merlin firmware of 16 kB strongly suggests that this chip has an
integarted Conexant CX25843 (Merlin Audio + Thresher Video = Mako)
Broadtcast A/V decoder core.  The chip might only have a Merlin
integrated, but so far I've never encountered that.  It will be easy
enough to tell, if the Thresher registers don't respond or only respond
with junk.

The Merlin has an integrated 8051 microcontroller that, if you are
decoding SIF audio from an analog tuner, will periodically reprogram
registers in the Merlin core to do spectral analysis of the SIF to
determine the broadcast audio standard (BTSC, etc.).

A public datasheet for the CX25843 is here:
http://dl.ivtvdriver.org/datasheets/video/cx25840.pdf

There appear to be at least two families of CX25843 cores:

- the core in the stand-alone CX2584[0123] chips and the '843 core
integrated into the CX23418

- the core integrated into the CX2388[578] and CX2310[012] chips, which
have a slightly different register defintion in some places 


The cx25840 driver under linux handles most of these, except that the
cx18 driver has it's own fork of the cx25840 driver in its cx18-av-*
files.  The core is normally I2C connected, except for the one
integrated into the CX23418.

If the empia device driver needs to support a CX25843 core, I highly
recommend forking a copy of the cx25840 driver specifically for the
empia devices, as opposed to trying to fit in yet another variant in the
cx25840 driver itself. 

FWIW, since the CX2310[012] devices are also USB connected, maybe that
driver can provide some basis for comparison along with the USB traces
you already have.  (I haven't compared them myself.)

Regards,
Andy

>  I tought they were fixed
> > function); also the usual directshow .ax filter and some exe in
> > autorun (emmona.exe: firmware/setup loader?).
> >
> > Looking in the em28xx gave me the idea that that thing is not
> > supported (at least in my current 3.6.6)... however the empia sites says
> > (here http://www.empiatech.com/wp/video-grabber-em282xx/) 28284 should
> > be linux supported. Nothing said about 28285. And the chip is marked
> > 2980?! by the way, forcing the driver to load I get this:
> >
> > [ 3439.787701] em28xx: New device  Roxio Video Capture USB @ 480 Mbps (1b80:e31d, interface 0, class 0)
> > [ 3439.787704] em28xx: Video interface 0 found
> > [ 3439.787705] em28xx: DVB interface 0 found
> > [ 3439.787866] em28xx #0: em28xx chip ID = 146
> >
> > Is there any hope to make it work (even on git kernel there is nothing
> > for chip id 146...)?
> >
> 
> See http://www.spinics.net/lists/linux-media/msg73699.html
> 
> HTH,
> Frank
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


