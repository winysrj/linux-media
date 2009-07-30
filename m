Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52747 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZG3OqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 10:46:04 -0400
Received: by ewy10 with SMTP id 10so799534ewy.37
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2009 07:46:03 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Subject: Re: TBS 8920 still fails to initialize - cx24116_readreg error
Date: Thu, 30 Jul 2009 17:45:54 +0300
Cc: Mark Zimmerman <markzimm@frii.com>
References: <20090724023315.GA96337@io.frii.com> <200907300122.22215.liplianin@me.by> <20090730041707.GA38134@io.frii.com>
In-Reply-To: <20090730041707.GA38134@io.frii.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907301745.54939.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30 июля 2009 07:17:07 Mark Zimmerman wrote:
> On Thu, Jul 30, 2009 at 01:22:21AM +0300, Igor M. Liplianin wrote:
> > On 28 ???? 2009 04:21:54 Mark Zimmerman wrote:
> > > On Mon, Jul 27, 2009 at 08:50:20PM +0300, Igor M. Liplianin wrote:
> > > > On 27 ???? 2009 04:43:16 Mark Zimmerman wrote:
> > > > > On Sun, Jul 26, 2009 at 03:29:13PM +0300, Igor M. Liplianin wrote:
> > > > > > On 25 ???? 2009 05:22:06 Mark Zimmerman wrote:
> > > > > > > On Fri, Jul 24, 2009 at 07:06:11PM +0300, Igor M. Liplianin wrote:
> > > > > > > > On 24 ???? 2009 05:33:15 Mark Zimmerman wrote:
> > > > > > > > > Greetings:
> > > > > > > > >
> > > > > > > > > Using current current v4l-dvb drivers, I get the following
> > > > > > > > > in the dmesg:
> > > > > > > > >
> > > > > > > > > cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2
> > > > > > > > > [card=72] cx88[1]/2: cx2388x based DVB/ATSC card
> > > > > > > > > cx8802_alloc_frontends() allocating 1 frontend(s)
> > > > > > > > > cx24116_readreg: reg=0xff (error=-6)
> > > > > > > > > cx24116_readreg: reg=0xfe (error=-6)
> > > > > > > > > Invalid probe, probably not a CX24116 device
> > > > > > > > > cx88[1]/2: frontend initialization failed
> > > > > > > > > cx88[1]/2: dvb_register failed (err = -22)
> > > > > > > > > cx88[1]/2: cx8802 probe failed, err = -22
> > > > > > > > >
> > > > > > > > > Does this mean that one of the chips on this card is
> > > > > > > > > different than expected? How can I gather useful
> > > > > > > > > information about this?
> >
> > Please try attached patch against recent v4l-dvb.
> > It does matter to set explicitly gpio0 value in cx88_board structure for
> > TBS 8920 card.
> >
> > Igor
> >
> >
> >
> > # HG changeset patch
> > # User Igor M. Liplianin <liplianin@me.by>
> > # Date 1248905908 -10800
> > # Node ID d2dee95e2da26a145cca2d081be86793cc9b07ea
> > # Parent  ee6cf88cb5d3faf861289fce0ef0385846adcc7c
> > fix TBS 8920 card support
>
> Looks good now. dmesg follows:
>
> Linux video capture interface: v2.00
> cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
> cx88[0]: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2
> [card=72,autodetected], frontend(s): 1 cx88[0]: TV tuner type 4, Radio
> tuner type -1
> input: ImPS/2 Generic Wheel Mouse as
> /devices/platform/i8042/serio1/input/input5 cx88/0: cx2388x v4l2 driver
> version 0.0.7 loaded
> cx88[0]/2: cx2388x 8802 Driver Manager
>   alloc irq_desc for 17 on cpu 0 node 0
>   alloc kstat_irqs on cpu 0 node 0
> cx88-mpeg driver manager 0000:00:08.2: PCI INT A -> GSI 17 (level, low) ->
> IRQ 17 cx88[0]/2: found at 0000:00:08.2, rev: 5, irq: 17, latency: 32,
> mmio: 0xf9000000 IRQ 17/cx88[0]: IRQF_DISABLED is not guaranteed on shared
> IRQs
> cx8800 0000:00:08.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> cx88[0]/0: found at 0000:00:08.0, rev: 5, irq: 17, latency: 32, mmio:
> 0xfa000000 IRQ 17/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> cx88[0]/0: registered device video0 [v4l2]
> cx88[0]/0: registered device vbi0
> cx88/2: cx2388x dvb driver version 0.0.7 loaded
> cx88/2: registering cx8802 driver, type: dvb access: shared
> cx88[0]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
> cx88[0]/2: cx2388x based DVB/ATSC card
> cx8802_alloc_frontends() allocating 1 frontend(s)
> DVB: registering new adapter (cx88[0])
> DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...
>
> ...
>
> cx24116_firmware_ondemand: Waiting for firmware upload
> (dvb-fe-cx24116.fw)... cx88-mpeg driver manager 0000:00:08.2: firmware:
> requesting dvb-fe-cx24116.fw cx24116_firmware_ondemand: Waiting for
> firmware upload(2)...
> cx24116_load_firmware: FW version 1.23.86.1
> cx24116_firmware_ondemand: Firmware upload complete
>
> vtest$ ls -laR /dev/dvb
> /dev/dvb:
> total 0
> drwxr-xr-x  3 root root   60 2009-07-29 21:13 .
> drwxr-xr-x 18 root root 3480 2009-07-29 21:14 ..
> drwxr-xr-x  2 root root  120 2009-07-29 21:13 adapter0
>
> /dev/dvb/adapter0:
> total 0
> drwxr-xr-x 2 root root     120 2009-07-29 21:13 .
> drwxr-xr-x 3 root root      60 2009-07-29 21:13 ..
> crw-rw---- 1 root video 212, 1 2009-07-29 21:13 demux0
> crw-rw---- 1 root video 212, 2 2009-07-29 21:13 dvr0
> crw-rw---- 1 root video 212, 0 2009-07-29 21:13 frontend0
> crw-rw---- 1 root video 212, 3 2009-07-29 21:13 net0
>
> Thank you for working through this.
> -- Mark
So I will commit.
Thank you for testing.
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
