Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759931Ab1FAVph (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 17:45:37 -0400
Message-ID: <4DE6B2F1.5080509@redhat.com>
Date: Wed, 01 Jun 2011 18:45:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Andy Walls <awalls@md.metrocast.net>,
	=?UTF-8?B?SGVybsOhbiBPcmRpYWxlcw==?= <h.ordiales@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Oliver Endriss <o.endriss@gmx.de>,
	"Tomasz G. Burak" <tomekbu@op.pl>
Subject: Media patches with review pending (14 patches)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the list of the patches currently on my queue (13 patches from
patchwork and one patch that patchwork lost due to a database corruption).

There's not much patches there, as I've applied most of the pending
stuff. Unfortunately, however, patchwork is not reliable. I noticed
at least 2 patches lost when reviewing the patch series. I've applied
one of them manually.

So, please point me if is there a pending patch that I didn't catch.

Thanks!
Mauro

		== Patches for Manu Abraham <abraham.manu@gmail.com> review == 

Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.kernel.org/patch/105621  Florent AUDEBERT <florent.audebert@anevia.com>
Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>
May, 4 2011: stb0899: Fix not locking DVB-S transponder                             http://patchwork.kernel.org/patch/753382  Lutz Sammer <johns98@gmx.net>
May,21 2011: Disable dynamic current limit for ttpci budget cards                   http://patchwork.kernel.org/patch/805872  Guy Martin <gmsoft@tuxicoman.be>
May,23 2011: Increase a timeout, so that bad scheduling does not accidentially caus http://patchwork.kernel.org/patch/809002  Hans Petter Selasky <hselasky@c2i.net>
May,25 2011: Add remote control support for mantis                                                                            Christoph Pinkl <christoph.pinkl@gmail.com>
May,24 2011: Fix the derot zig-zag to work with TT-USB2.0 TechnoTrend.              http://patchwork.kernel.org/patch/826102  Hans Petter Selasky <hselasky@c2i.net>
Jun, 1 2011: stv090x: set status bits when there is no lock                         http://patchwork.kernel.org/patch/840602  Guy Martin <gmsoft@tuxicoman.be>

The RC support for mantis is a patch that it used to be on patchwork, but got lost.

		== Waiting for Hernán Ordiales<h.ordiales@gmail.com> comments and new patch == 

May, 3 2011: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/751702  Mauro Carvalho Chehab <mchehab@redhat.com>

		== Waiting for Tomasz G. Burak <tomekbu@op.pl> comments and new patch == 

Feb, 7 2011: DVB-USB: Remote Control for TwinhanDTV StarBox DVB-S USB and clones    http://patchwork.kernel.org/patch/751832  Tomasz G. Burak <tomekbu@op.pl>

		== Patches for Andy Walls <awalls@md.metrocast.net> review == 

May,25 2011: ivtv: use display information in info not in var for panning           http://patchwork.kernel.org/patch/815492  Laurent Pinchart <laurent.pinchart@ideasonboard.com>

		== Patches waiting my tests with mb86a20s/ISDB-T == 

May,19 2011: saa7134-dvb.c kworld_sbtvd                                             http://patchwork.kernel.org/patch/798782  Manoel Pinheiro <pinusdtv@hotmail.com>
May,19 2011: [RFC] add i2c_gate_ctrl to mb86a20s.c                                  http://patchwork.kernel.org/patch/799532  Manoel Pinheiro <pinusdtv@hotmail.com>

		== Waiting for Oliver Endriss<o.endriss@gmx.de> review == 

May,12 2011: ngene: blocking and nonblocking io for sec0                            http://patchwork.kernel.org/patch/780072  Issa Gorissen <flop.m@usa.net>


Number of pending patches per reviewer:
  Manu Abraham <abraham.manu@gmail.com>                                 : 8
  Mauro Carvalho Chehab <mchehab@redhat.com>                            : 2
  Andy Walls <awalls@md.metrocast.net>                                  : 1
  Hernán Ordiales <h.ordiales@gmail.com>                                : 1
  Oliver Endriss <o.endriss@gmx.de>                                     : 1
  Tomasz G. Burak <tomekbu@op.pl>                                       : 1
