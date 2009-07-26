Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:51826 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZGZM3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2009 08:29:21 -0400
Received: by ewy26 with SMTP id 26so2622049ewy.37
        for <linux-media@vger.kernel.org>; Sun, 26 Jul 2009 05:29:19 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Subject: Re: TBS 8920 still fails to initialize - cx24116_readreg error
Date: Sun, 26 Jul 2009 15:29:13 +0300
Cc: Mark Zimmerman <markzimm@frii.com>
References: <20090724023315.GA96337@io.frii.com> <200907241906.11914.liplianin@me.by> <20090725022206.GA17704@io.frii.com>
In-Reply-To: <20090725022206.GA17704@io.frii.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907261529.13781.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25 июля 2009 05:22:06 Mark Zimmerman wrote:
> On Fri, Jul 24, 2009 at 07:06:11PM +0300, Igor M. Liplianin wrote:
> > On 24 ???? 2009 05:33:15 Mark Zimmerman wrote:
> > > Greetings:
> > >
> > > Using current current v4l-dvb drivers, I get the following in the
> > > dmesg:
> > >
> > > cx88[1]/2: subsystem: 8920:8888, board: TBS 8920 DVB-S/S2 [card=72]
> > > cx88[1]/2: cx2388x based DVB/ATSC card
> > > cx8802_alloc_frontends() allocating 1 frontend(s)
> > > cx24116_readreg: reg=0xff (error=-6)
> > > cx24116_readreg: reg=0xfe (error=-6)
> > > Invalid probe, probably not a CX24116 device
> > > cx88[1]/2: frontend initialization failed
> > > cx88[1]/2: dvb_register failed (err = -22)
> > > cx88[1]/2: cx8802 probe failed, err = -22
> > >
> > > Does this mean that one of the chips on this card is different than
> > > expected? How can I gather useful information about this?
> >
> > Hi
> > You can try:
> > http://www.tbsdtv.com/download/tbs6920_8920_v23_linux_x86_x64.rar
>
> This code did not compile as-is, but after I commented out some things
> in drivers I do not need, I managed to build something. The TBS card
> now seems to be initialized, but it also broke support for my DViCO
> FusionHDTV7 Dual Express card, which also uses a cx23885.
>
> I am going to move this card to another machine that does not have any
> other capture cards and repeat the process. This should make it easier
> to know what the TBS card/driver is doing.
>
> I am assuming that you are interested in using me to gather
> information to update the v4l-dvb drivers so that this card can be
> supported properly. Is this correct?  Please let me know what I can do
> to assist.
I've changed tbs 8920 initialization in http://mercurial.intuxication.org/hg/s2-liplianin.
I ask you to try it.
If it works, then I will commit it to linuxv.
Also pay attention to remote.

>
> -- Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
