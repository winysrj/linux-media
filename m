Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.vodamail.co.za ([196.11.146.226]:60543 "EHLO
	vodamail.co.za" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752599Ab0ABKdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jan 2010 05:33:39 -0500
Subject: Re: Fwd: Compro S300 - ZL10313
From: JD Louw <jd.louw@mweb.co.za>
To: Theunis Potgieter <theunis.potgieter@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <23582ca1001012339h6efa3b88k5eea2799b5b739dc@mail.gmail.com>
References: <23582ca0912291306v11d0631fia6ad442918961b48@mail.gmail.com>
	 <23582ca0912291307l53ff8d74j928f9e22ce09311@mail.gmail.com>
	 <23582ca0912291323s1be512ebnd60bf2ea1988799@mail.gmail.com>
	 <1262297232.1913.31.camel@Core2Duo>
	 <23582ca1001012339h6efa3b88k5eea2799b5b739dc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 12:33:24 +0200
Message-ID: <1262428404.1944.22.camel@Core2Duo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-01-02 at 09:39 +0200, Theunis Potgieter wrote:
> 2010/1/1 JD Louw <jd.louw@mweb.co.za>:
> > On Tue, 2009-12-29 at 23:23 +0200, Theunis Potgieter wrote:
> >> Hi mailing list,
> >>
> >> I have a problem with my Compro S300 pci card under Linux 2.6.32.
> >>
> >> I cannot tune with this card and STR/SNRA is very bad compared to my
> >> Technisat SkyStar 2 pci card, connected to the same dish.
> >>
> >> I have this card and are willing to run tests, tested drivers etc to
> >> make this work.
> >>
> >> I currently load the module saa7134 with options: card=169
> >>
> >> I enabled some debug parameters on the saa7134, not sure what else I
> >> should enable. Please find my dmesg log attached.
> >>
> >> lsmod shows :
> >>
> >> # lsmod
> >> Module                  Size  Used by
> >> zl10039                 6268  2
> >> mt312                  12048  2
> >> saa7134_dvb            41549  11
> >> saa7134               195664  1 saa7134_dvb
> >> nfsd                  416819  11
> >> videobuf_dvb            8187  1 saa7134_dvb
> >> dvb_core              148140  1 videobuf_dvb
> >> ir_common              40625  1 saa7134
> >> v4l2_common            21544  1 saa7134
> >> videodev               58341  2 saa7134,v4l2_common
> >> v4l1_compat            24473  1 videodev
> >> videobuf_dma_sg        17830  2 saa7134_dvb,saa7134
> >> videobuf_core          26534  3 saa7134,videobuf_dvb,videobuf_dma_sg
> >> tveeprom               12550  1 saa7134
> >> thermal                20547  0
> >> processor              54638  1
> >>
> >> # uname -a
> >> Linux vbox 2.6.32-gentoo #4 Sat Dec 19 00:54:19 SAST 2009 i686 Pentium
> >> III (Coppermine) GenuineIntel GNU/Linux
> >>
> >> Thanks,
> >> Theunis
> >
> > Hi,
> >
> > It's probably the GPIO settings that are wrong for your SAA7133 based
> > card revision. See http://osdir.com/ml/linux-media/2009-06/msg01256.html
> > for an explanation. For quick confirmation check if you have 12V - 20V
> > DC going to your LNB. The relevant lines of code is in
> > ~/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c:
> >
> > case SAA7134_BOARD_VIDEOMATE_S350:
> > dev->has_remote = SAA7134_REMOTE_GPIO;
> > saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
> > saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
> > break;
> >
> Hi thanks for the hint. I changed it to the following:
> 
>  case SAA7134_BOARD_VIDEOMATE_S350:
>  dev->has_remote = SAA7134_REMOTE_GPIO;
>  saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000c000, 0x0000c000);
>  saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0000c000, 0x0000c000);
>  break;
> 
> I now get the same SNR as on my skystar2 card, signal is still
> indicating 17% where as the skystar2 would show 68%. At least I'm
> getting a LOCK on channels :)
> 
> Thanks!
> 
> >
> > Looking at your log, at least the demodulator and tuner is responding
> > correctly. You can see this by looking at the i2c traffic addressed to
> > 0x1c (demodulator) and 0xc0 (tuner). Attached is a dmesg trace from my
> > working SAA7130 based card.
> >
> > Regards
> > JD
> >

Hi,

Just to clarify, can you now watch channels?

At the moment the signal strength measurement is a bit whacked, so don't
worry too much about it. I also get the 75%/17% figures you mentioned
when tuning to strong signals. The figure is simply reported wrongly:
even weaker signals should tune fine. If you want you can have a look in
~/v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c at
mt312_read_signal_strength().

Also, if you have a multimeter handy, can you confirm that the
0x0000c000 GPIO fix enables LNB voltage? I'd like to issue a patch for
this. I've already tested this on my older card with no ill effect.

Regards
JD



