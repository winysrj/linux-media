Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:43374 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbZG0Rub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 13:50:31 -0400
Received: by ewy26 with SMTP id 26so3364790ewy.37
        for <linux-media@vger.kernel.org>; Mon, 27 Jul 2009 10:50:30 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Subject: Re: TBS 8920 still fails to initialize - cx24116_readreg error
Date: Mon, 27 Jul 2009 20:50:20 +0300
Cc: Mark Zimmerman <markzimm@frii.com>
References: <20090724023315.GA96337@io.frii.com> <200907261529.13781.liplianin@me.by> <20090727014316.GA97600@io.frii.com>
In-Reply-To: <20090727014316.GA97600@io.frii.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907272050.20827.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27 июля 2009 04:43:16 Mark Zimmerman wrote:
> On Sun, Jul 26, 2009 at 03:29:13PM +0300, Igor M. Liplianin wrote:
> > On 25 ???? 2009 05:22:06 Mark Zimmerman wrote:
> > > On Fri, Jul 24, 2009 at 07:06:11PM +0300, Igor M. Liplianin wrote:
> > > > On 24 ???? 2009 05:33:15 Mark Zimmerman wrote:
> > > > > Greetings:
> > > > >
> > > > > Using current current v4l-dvb drivers, I get the following in the
> > > > > dmesg:
> > > > >
> > > > > cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
> > > > > cx88[1]/2: cx2388x based DVB/ATSC card
> > > > > cx8802_alloc_frontends() allocating 1 frontend(s)
> > > > > cx24116_readreg: reg=0xff (error=-6)
> > > > > cx24116_readreg: reg=0xfe (error=-6)
> > > > > Invalid probe, probably not a CX24116 device
> > > > > cx88[1]/2: frontend initialization failed
> > > > > cx88[1]/2: dvb_register failed (err = -22)
> > > > > cx88[1]/2: cx8802 probe failed, err = -22
> > > > >
> > > > > Does this mean that one of the chips on this card is different than
> > > > > expected? How can I gather useful information about this?
> > > >
> > > > Hi
> > > > You can try:
> > > > http://www.tbsdtv.com/download/tbs6920_8920_v23_linux_x86_x64.rar
> > >
> > > This code did not compile as-is, but after I commented out some things
> > > in drivers I do not need, I managed to build something. The TBS card
> > > now seems to be initialized, but it also broke support for my DViCO
> > > FusionHDTV7 Dual Express card, which also uses a cx23885.
> > >
> > > I am going to move this card to another machine that does not have any
> > > other capture cards and repeat the process. This should make it easier
> > > to know what the TBS card/driver is doing.
> > >
> > > I am assuming that you are interested in using me to gather
> > > information to update the v4l-dvb drivers so that this card can be
> > > supported properly. Is this correct?  Please let me know what I can do
> > > to assist.
> >
> > I've changed tbs 8920 initialization in
> > http://mercurial.intuxication.org/hg/s2-liplianin. I ask you to try it.
> > If it works, then I will commit it to linuxv.
> > Also pay attention to remote.
>
> Unfortunately, there appears to be no change:
>
> Just for reference, here is how it looks when using the drivers
> compiled from the source in tbs6920_8920_v23_linux_x86_x64.rar:
>
> Also, here are the diffs of cx88-dvb.c between your version and the one
> from the manufacturer.  I wonder if the magic number writes at line 1142
> could be what makes it work. I can try adding them to your source if you
> think it is advisable.
It is advisable to try.
I forgot about voltage control. It must preserve that "magic" number.

http://mercurial.intuxication.org/hg/s2-liplianin/rev/b1ca288a0600 

> --- linux/drivers/media/video/cx88/cx88-dvb.c   2009-07-26
> 18:00:00.000000000 -0600 +++
> /home/mark/tbs8920/linux-s2api-tbs6920-8920-v23/linux/drivers/media/video/c
>x88/cx88-dvb.c   2009-06-07 18:15:11.000000000 -0600 @@ -428,14 +428,17 @@
>         switch (voltage) {
>                 case SEC_VOLTAGE_13:
>                         printk("LNB Voltage SEC_VOLTAGE_13\n");
> -                       cx_write(MO_GP0_IO, 0x00006040);
> +                       cx_set(MO_GP0_IO, 0x00006040);
> +                       cx_clear(MO_GP0_IO, 0x00000020);
>                         break;
>                 case SEC_VOLTAGE_18:
>                         printk("LNB Voltage SEC_VOLTAGE_18\n");
> -                       cx_write(MO_GP0_IO, 0x00006060);
> +                       cx_set(MO_GP0_IO, 0x00006020);
> +                       cx_set(MO_GP0_IO, 0x00000040);
>                         break;
>                 case SEC_VOLTAGE_OFF:
>                         printk("LNB Voltage SEC_VOLTAGE_off\n");
> +                       cx_clear(MO_GP0_IO, 0x00000020);
>                         break;
>         }
>
> @@ -1142,6 +1144,15 @@
>         case CX88_BOARD_TBS_8920:
>         case CX88_BOARD_PROF_7300:
>         case CX88_BOARD_SATTRADE_ST4200:
> +               printk(KERN_INFO "%s() setup TBS8920\n", __func__);
> +               cx_write(MO_GP0_IO, 0x00008000);
> +               msleep(100);
> +               cx_write(MO_SRST_IO, 0);
> +               msleep(10);
> +               cx_write(MO_GP0_IO, 0x00008080);
> +               msleep(100);
> +               cx_write(MO_SRST_IO, 1);
> +               msleep(100);
>                 fe0->dvb.frontend = dvb_attach(cx24116_attach,
>                                                &hauppauge_hvr4000_config,
>                                                &core->i2c_adap);

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
