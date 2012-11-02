Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab2KBNNV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Nov 2012 09:13:21 -0400
Date: Fri, 2 Nov 2012 11:13:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, media-workshop@linuxtv.org,
	linux-media <linux-media@vger.kernel.org>
Subject: drivers without explicit MAINTAINERS entry - was: Re:
 [media-workshop] Tentative Agenda for the November workshop
Message-ID: <20121102111310.755e38aa@gaivota.chehab>
In-Reply-To: <20121101141244.6c72242c@redhat.com>
References: <201210221035.56897.hverkuil@xs4all.nl>
	<20121025152701.0f4145c8@redhat.com>
	<201211011644.50882.hverkuil@xs4all.nl>
	<20121101141244.6c72242c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 1 Nov 2012 14:12:44 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Thu, 1 Nov 2012 16:44:50 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Thu October 25 2012 19:27:01 Mauro Carvalho Chehab wrote:
> > > Hi Hans,
> > > 
> > > Em Mon, 22 Oct 2012 10:35:56 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > 
> > > > Hi all,
> > > > 
> > > > This is the tentative agenda for the media workshop on November 8, 2012.
> > > > If you have additional things that you want to discuss, or something is wrong
> > > > or incomplete in this list, please let me know so I can update the list.
> > > 
> > > Thank you for taking care of it.
> > > 
> > > > - Explain current merging process (Mauro)
> > > > - Open floor for discussions on how to improve it (Mauro)
> > > > - Write down minimum requirements for new V4L2 (and DVB?) drivers, both for
> > > >   staging and mainline acceptance: which frameworks to use, v4l2-compliance,
> > > >   etc. (Hans Verkuil)
> > > > - V4L2 ambiguities (Hans Verkuil)
> > > > - TSMux device (a mux rather than a demux): Alain Volmat
> > > > - dmabuf status, esp. with regards to being able to test (Mauro/Samsung)
> > > > - Device tree support (Guennadi, not known yet whether this topic is needed)
> > > > - Creating/selecting contexts for hardware that supports this (Samsung, only
> > > >   if time is available)
> > > 
> > > I have an extra theme for discussions there: what should we do with the drivers
> > > that don't have any MAINTAINERS entry.
> > 
> > I've added this topic to the list.
> 
> Thanks!
> 
> > > It probably makes sense to mark them as "Orphan" (or, at least, have some
> > > criteria to mark them as such). Perhaps before doing that, we could try
> > > to see if are there any developer at the community with time and patience
> > > to handle them.
> > > 
> > > This could of course be handled as part of the discussions about how to improve
> > > the merge process, but I suspect that this could generate enough discussions
> > > to be handled as a separate theme.
> > 
> > Do we have a 'Maintainer-Light' category? I have a lot of hardware that I can
> > test. So while I wouldn't like to be marked as 'The Maintainer of driver X'
> > (since I simply don't have the time for that), I wouldn't mind being marked as
> > someone who can at least test patches if needed.
> 
> There are several "maintainance" status there: 
> 
> 	S: Status, one of the following:
> 	   Supported:	Someone is actually paid to look after this.
> 	   Maintained:	Someone actually looks after it.
> 	   Odd Fixes:	It has a maintainer but they don't have time to do
> 			much other than throw the odd patch in. See below..
> 	   Orphan:	No current maintainer [but maybe you could take the
> 			role as you write your new code].
> 	   Obsolete:	Old code. Something tagged obsolete generally means
> 			it has been replaced by a better system and you
> 			should be using that.
> 
> (btw, I just realized that I should be changing the EDAC drivers I maintain
>  to Supported; the media drivers I maintain should be kept as Maintained).
> 
> I suspect that the "maintainer-light" category for those radio and similar
> old stuff is likely "Odd Fixes".
> 
> > > There are some issues by not having a MAINTAINERS entry:
> > > 	- patches may not flow into the driver maintainer;
> > > 	- patches will likely be applied without tests/reviews or may
> > > 	  stay for a long time queued;
> > > 	- ./scripts/get_maintainer.pl at --no-git-fallback won't return
> > > 	  any maintainer[1].
> > > 
> > > [1] Letting get_maintainer.pl is very time/CPU consuming. Letting it would 
> > > delay a lot the patch review process, if applied for every patch, with
> > > unreliable and doubtful results. I don't do it, due to the large volume
> > > of patches, and because the 'other' results aren't typically the driver
> > > maintainer.
> > > 
> > > An example of this is the results for a patch I just applied
> > > (changeset 2866aed103b915ca8ba0ff76d5790caea4e62ced):
> > > 
> > > 	$ git show --pretty=email|./scripts/get_maintainer.pl
> > > 	Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT INFRA...,commit_signer:7/7=100%)
> > > 	Hans Verkuil <hans.verkuil@cisco.com> (commit_signer:4/7=57%)
> > > 	Anatolij Gustschin <agust@denx.de> (commit_signer:1/7=14%)
> > > 	Wei Yongjun <yongjun_wei@trendmicro.com.cn> (commit_signer:1/7=14%)
> > > 	Hans de Goede <hdegoede@redhat.com> (commit_signer:1/7=14%)
> > > 	linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
> > > 	linux-kernel@vger.kernel.org (open list)
> > > 
> > > According with this driver's copyrights:
> > > 
> > >  * Copyright 2008-2010 Freescale Semiconductor, Inc. All Rights Reserved.
> > >  *
> > >  *  Freescale VIU video driver
> > >  *
> > >  *  Authors: Hongjun Chen <hong-jun.chen@freescale.com>
> > >  *	     Porting to 2.6.35 by DENX Software Engineering,
> > >  *	     Anatolij Gustschin <agust@denx.de>
> > > 
> > > The driver author (Hongjun Chen <hong-jun.chen@freescale.com>) was not even
> > > shown there, and the co-author got only 15% hit, while I got 100% and Hans
> > > got 57%.
> > > 
> > > This happens not only to this driver. In a matter of fact, on most cases where
> > > no MAINTAINERS entry exist, the driver's author gets a very small hit chance,
> > > as, on several of those drivers, the author doesn't post anything else but
> > > the initial patch series.
> > 
> > We probably need to have an entry for all the media drivers, even if it just
> > points to the linux-media mailinglist as being the 'collective default maintainer'.
> 
> Yes, I think that all media drivers should be there. I prefer to tag the ones
> that nobody sends us a MAINTAINERS entry with "Orphan", as this tag indicates
> that help is wanted. 

I wrote a small shell script to see what's missing, using the analyze_build.pl script
at media-build devel_scripts dir:

	DIR=$(dirname $0)

	$DIR/analyze_build.pl --path drivers/media/ --show_files_per_module >/tmp/all_drivers
	grep drivers/media/ MAINTAINERS | perl -ne 's/F:\s+//;s,drivers/media/,,; print $_ if (!/^\n/)' >maintained
	grep -v -f maintained /tmp/all_drivers |grep -v -e keymaps -e v4l2-core/ -e dvb-core/ -e media.ko -e rc-core.ko -e ^#| sort >without_maint

I excluded the core files from the list, as they don't need any specific entry. RC
keymaps is also a special case, as I don't think any maintainer is needed for them.

Basically, analyze_build.pl says that there are 613 drivers under drivers/media.
The above script shows 348 drivers without an explicit maintainer. So, only 43%
of the drivers have a formal maintainer.

Yet, on the list below, I think several of them can be easily tagged as
"Odd fixes", like cx88 and saa7134. 

I think I'll send today a few RFC MAINTAINERS patches for some stuff below that
I can myself be added as "Odd fixes". Yet, I would very much prefer if someone
with more time than me could be taking over the "Odd fixes" patches I'll propose.

Regards,
Mauro

common/b2c2/b2c2-flexcop.ko    = common/b2c2/flexcop-hw-filter.c common/b2c2/flexcop-sram.c common/b2c2/flexcop-eeprom.c common/b2c2/flexcop-misc.c common/b2c2/flexcop.c common/b2c2/flexcop-fe-tuner.c common/b2c2/flexcop-i2c.c
common/siano/smsdvb.ko         = common/siano/smsdvb.c
common/siano/smsir.ko          = common/siano/smsir.c
common/siano/smsmdtv.ko        = common/siano/smscoreapi.c common/siano/sms-cards.c common/siano/smsendian.c
dvb-frontends/atbm8830.ko      = dvb-frontends/atbm8830.c
dvb-frontends/au8522_common.ko = dvb-frontends/au8522_common.c
dvb-frontends/au8522_decoder.ko = dvb-frontends/au8522_decoder.c
dvb-frontends/au8522_dig.ko    = dvb-frontends/au8522_dig.c
dvb-frontends/bcm3510.ko       = dvb-frontends/bcm3510.c
dvb-frontends/cx22700.ko       = dvb-frontends/cx22700.c
dvb-frontends/cx22702.ko       = dvb-frontends/cx22702.c
dvb-frontends/cx24110.ko       = dvb-frontends/cx24110.c
dvb-frontends/cx24113.ko       = dvb-frontends/cx24113.c
dvb-frontends/cx24116.ko       = dvb-frontends/cx24116.c
dvb-frontends/cx24123.ko       = dvb-frontends/cx24123.c
dvb-frontends/dib0070.ko       = dvb-frontends/dib0070.c
dvb-frontends/dib0090.ko       = dvb-frontends/dib0090.c
dvb-frontends/dib3000mb.ko     = dvb-frontends/dib3000mb.c
dvb-frontends/dib3000mc.ko     = dvb-frontends/dib3000mc.c
dvb-frontends/dib7000m.ko      = dvb-frontends/dib7000m.c
dvb-frontends/dib7000p.ko      = dvb-frontends/dib7000p.c
dvb-frontends/dib8000.ko       = dvb-frontends/dib8000.c
dvb-frontends/dib9000.ko       = dvb-frontends/dib9000.c
dvb-frontends/dibx000_common.ko = dvb-frontends/dibx000_common.c
dvb-frontends/drxd.ko          = dvb-frontends/drxd_firm.c dvb-frontends/drxd_hard.c
dvb-frontends/drxk.ko          = dvb-frontends/drxk_hard.c
dvb-frontends/ds3000.ko        = dvb-frontends/ds3000.c
dvb-frontends/dvb_dummy_fe.ko  = dvb-frontends/dvb_dummy_fe.c
dvb-frontends/dvb-pll.ko       = dvb-frontends/dvb-pll.c
dvb-frontends/isl6405.ko       = dvb-frontends/isl6405.c
dvb-frontends/isl6421.ko       = dvb-frontends/isl6421.c
dvb-frontends/isl6423.ko       = dvb-frontends/isl6423.c
dvb-frontends/it913x-fe.ko     = dvb-frontends/it913x-fe.c
dvb-frontends/itd1000.ko       = dvb-frontends/itd1000.c
dvb-frontends/ix2505v.ko       = dvb-frontends/ix2505v.c
dvb-frontends/l64781.ko        = dvb-frontends/l64781.c
dvb-frontends/lgdt330x.ko      = dvb-frontends/lgdt330x.c
dvb-frontends/lgs8gl5.ko       = dvb-frontends/lgs8gl5.c
dvb-frontends/lgs8gxx.ko       = dvb-frontends/lgs8gxx.c
dvb-frontends/lnbp21.ko        = dvb-frontends/lnbp21.c
dvb-frontends/lnbp22.ko        = dvb-frontends/lnbp22.c
dvb-frontends/m88rs2000.ko     = dvb-frontends/m88rs2000.c
dvb-frontends/mb86a16.ko       = dvb-frontends/mb86a16.c
dvb-frontends/mb86a20s.ko      = dvb-frontends/mb86a20s.c
dvb-frontends/mt312.ko         = dvb-frontends/mt312.c
dvb-frontends/mt352.ko         = dvb-frontends/mt352.c
dvb-frontends/nxt200x.ko       = dvb-frontends/nxt200x.c
dvb-frontends/nxt6000.ko       = dvb-frontends/nxt6000.c
dvb-frontends/or51132.ko       = dvb-frontends/or51132.c
dvb-frontends/or51211.ko       = dvb-frontends/or51211.c
dvb-frontends/s5h1409.ko       = dvb-frontends/s5h1409.c
dvb-frontends/s5h1411.ko       = dvb-frontends/s5h1411.c
dvb-frontends/s5h1420.ko       = dvb-frontends/s5h1420.c
dvb-frontends/s5h1432.ko       = dvb-frontends/s5h1432.c
dvb-frontends/s921.ko          = dvb-frontends/s921.c
dvb-frontends/si21xx.ko        = dvb-frontends/si21xx.c
dvb-frontends/sp8870.ko        = dvb-frontends/sp8870.c
dvb-frontends/sp887x.ko        = dvb-frontends/sp887x.c
dvb-frontends/stb0899.ko       = dvb-frontends/stb0899_drv.c dvb-frontends/stb0899_algo.c
dvb-frontends/stb6000.ko       = dvb-frontends/stb6000.c
dvb-frontends/stb6100.ko       = dvb-frontends/stb6100.c
dvb-frontends/stv0288.ko       = dvb-frontends/stv0288.c
dvb-frontends/stv0297.ko       = dvb-frontends/stv0297.c
dvb-frontends/stv0299.ko       = dvb-frontends/stv0299.c
dvb-frontends/stv0367.ko       = dvb-frontends/stv0367.c
dvb-frontends/stv0900.ko       = dvb-frontends/stv0900_core.c dvb-frontends/stv0900_sw.c
dvb-frontends/stv090x.ko       = dvb-frontends/stv090x.c
dvb-frontends/stv6110.ko       = dvb-frontends/stv6110.c
dvb-frontends/stv6110x.ko      = dvb-frontends/stv6110x.c
dvb-frontends/tda10021.ko      = dvb-frontends/tda10021.c
dvb-frontends/tda10023.ko      = dvb-frontends/tda10023.c
dvb-frontends/tda10048.ko      = dvb-frontends/tda10048.c
dvb-frontends/tda1004x.ko      = dvb-frontends/tda1004x.c
dvb-frontends/tda10086.ko      = dvb-frontends/tda10086.c
dvb-frontends/tda18271c2dd.ko  = dvb-frontends/tda18271c2dd.c
dvb-frontends/tda665x.ko       = dvb-frontends/tda665x.c
dvb-frontends/tda8083.ko       = dvb-frontends/tda8083.c
dvb-frontends/tda8261.ko       = dvb-frontends/tda8261.c
dvb-frontends/tda826x.ko       = dvb-frontends/tda826x.c
dvb-frontends/tua6100.ko       = dvb-frontends/tua6100.c
dvb-frontends/ves1820.ko       = dvb-frontends/ves1820.c
dvb-frontends/ves1x93.ko       = dvb-frontends/ves1x93.c
dvb-frontends/zl10036.ko       = dvb-frontends/zl10036.c
dvb-frontends/zl10039.ko       = dvb-frontends/zl10039.c
dvb-frontends/zl10353.ko       = dvb-frontends/zl10353.c
firewire/firedtv.ko            = +
firewire/firedtv-rc.ko         = firewire/firedtv-rc.c
i2c/ad9389b.ko                 = i2c/ad9389b.c
i2c/adp1653.ko                 = i2c/adp1653.c
i2c/adv7170.ko                 = i2c/adv7170.c
i2c/adv7175.ko                 = i2c/adv7175.c
i2c/adv7180.ko                 = i2c/adv7180.c
i2c/adv7183.ko                 = i2c/adv7183.c
i2c/adv7343.ko                 = i2c/adv7343.c
i2c/adv7393.ko                 = i2c/adv7393.c
i2c/adv7604.ko                 = i2c/adv7604.c
i2c/ak881x.ko                  = i2c/ak881x.c
i2c/aptina-pll.ko              = i2c/aptina-pll.c
i2c/as3645a.ko                 = i2c/as3645a.c
i2c/bt819.ko                   = i2c/bt819.c
i2c/bt856.ko                   = i2c/bt856.c
i2c/bt866.ko                   = i2c/bt866.c
i2c/btcx-risc.ko               = i2c/btcx-risc.c
i2c/cs5345.ko                  = i2c/cs5345.c
i2c/cs53l32a.ko                = i2c/cs53l32a.c
i2c/cx2341x.ko                 = i2c/cx2341x.c
i2c/cx25840/cx25840.ko         = i2c/cx25840/cx25840-core.c i2c/cx25840/cx25840-audio.c i2c/cx25840/cx25840-firmware.c i2c/cx25840/cx25840-vbi.c i2c/cx25840/cx25840-ir.c
i2c/ir-kbd-i2c.ko              = i2c/ir-kbd-i2c.c
i2c/ks0127.ko                  = i2c/ks0127.c
i2c/m52790.ko                  = i2c/m52790.c
i2c/msp3400.ko                 = i2c/msp3400-driver.c i2c/msp3400-kthreads.c
i2c/mt9m032.ko                 = i2c/mt9m032.c
i2c/mt9p031.ko                 = i2c/mt9p031.c
i2c/mt9t001.ko                 = i2c/mt9t001.c
i2c/mt9v011.ko                 = i2c/mt9v011.c
i2c/mt9v032.ko                 = i2c/mt9v032.c
i2c/noon010pc30.ko             = i2c/noon010pc30.c
i2c/s5k4ecgx.ko                = i2c/s5k4ecgx.c
i2c/s5k6aa.ko                  = i2c/s5k6aa.c
i2c/saa6588.ko                 = i2c/saa6588.c
i2c/saa7110.ko                 = i2c/saa7110.c
i2c/saa7115.ko                 = i2c/saa7115.c
i2c/saa7127.ko                 = i2c/saa7127.c
i2c/saa717x.ko                 = i2c/saa717x.c
i2c/saa7185.ko                 = i2c/saa7185.c
i2c/saa7191.ko                 = i2c/saa7191.c
i2c/smiapp-pll.ko              = i2c/smiapp-pll.c
i2c/smiapp/smiapp.ko           = i2c/smiapp/smiapp-core.c i2c/smiapp/smiapp-regs.c i2c/smiapp/smiapp-quirk.c i2c/smiapp/smiapp-limits.c
i2c/sr030pc30.ko               = i2c/sr030pc30.c
i2c/tcm825x.ko                 = i2c/tcm825x.c
i2c/tda7432.ko                 = i2c/tda7432.c
i2c/tda9840.ko                 = i2c/tda9840.c
i2c/tea6415c.ko                = i2c/tea6415c.c
i2c/tea6420.ko                 = i2c/tea6420.c
i2c/ths7303.ko                 = i2c/ths7303.c
i2c/tlv320aic23b.ko            = i2c/tlv320aic23b.c
i2c/tvaudio.ko                 = i2c/tvaudio.c
i2c/tveeprom.ko                = i2c/tveeprom.c
i2c/tvp514x.ko                 = i2c/tvp514x.c
i2c/tvp5150.ko                 = i2c/tvp5150.c
i2c/tvp7002.ko                 = i2c/tvp7002.c
i2c/upd64031a.ko               = i2c/upd64031a.c
i2c/upd64083.ko                = i2c/upd64083.c
i2c/vp27smpx.ko                = i2c/vp27smpx.c
i2c/vpx3220.ko                 = i2c/vpx3220.c
i2c/vs6624.ko                  = i2c/vs6624.c
i2c/wm8739.ko                  = i2c/wm8739.c
i2c/wm8775.ko                  = i2c/wm8775.c
mmc/siano/smssdio.ko           = mmc/siano/smssdio.c
parport/bw-qcam.ko             = parport/bw-qcam.c
parport/c-qcam.ko              = parport/c-qcam.c
parport/pms.ko                 = parport/pms.c
parport/w9966.ko               = parport/w9966.c
pci/b2c2/b2c2-flexcop-pci.ko   = pci/b2c2/flexcop-pci.c pci/b2c2/flexcop-dma.c
pci/bt8xx/bt878.ko             = pci/bt8xx/bt878.c
pci/bt8xx/dst_ca.ko            = pci/bt8xx/dst_ca.c
pci/bt8xx/dst.ko               = pci/bt8xx/dst.c
pci/bt8xx/dvb-bt8xx.ko         = pci/bt8xx/dvb-bt8xx.c
pci/cx23885/altera-ci.ko       = pci/cx23885/altera-ci.c
pci/cx23885/cx23885.ko         = pci/cx23885/cx23885-cards.c pci/cx23885/cx23885-video.c pci/cx23885/cx23885-vbi.c pci/cx23885/cx23885-core.c pci/cx23885/cx23885-i2c.c pci/cx23885/cx23885-dvb.c pci/cx23885/cx23885-417.c pci/cx23885/cx23885-ioctl.c pci/cx23885/cx23885-ir.c pci/cx23885/cx23885-av.c pci/cx23885/cx23885-input.c pci/cx23885/cx23888-ir.c pci/cx23885/netup-init.c pci/cx23885/cimax2.c pci/cx23885/netup-eeprom.c pci/cx23885/cx23885-f300.c pci/cx23885/cx23885-alsa.c
pci/cx25821/cx25821-alsa.ko    = pci/cx25821/cx25821-alsa.c
pci/cx25821/cx25821.ko         = pci/cx25821/cx25821-core.c pci/cx25821/cx25821-cards.c pci/cx25821/cx25821-i2c.c pci/cx25821/cx25821-gpio.c pci/cx25821/cx25821-medusa-video.c pci/cx25821/cx25821-video.c pci/cx25821/cx25821-video-upstream.c pci/cx25821/cx25821-video-upstream-ch2.c pci/cx25821/cx25821-audio-upstream.c
pci/cx88/cx8800.ko             = pci/cx88/cx88-video.c pci/cx88/cx88-vbi.c
pci/cx88/cx8802.ko             = pci/cx88/cx88-mpeg.c
pci/cx88/cx88-alsa.ko          = pci/cx88/cx88-alsa.c
pci/cx88/cx88-blackbird.ko     = pci/cx88/cx88-blackbird.c
pci/cx88/cx88-dvb.ko           = pci/cx88/cx88-dvb.c
pci/cx88/cx88-vp3054-i2c.ko    = pci/cx88/cx88-vp3054-i2c.c
pci/cx88/cx88xx.ko             = pci/cx88/cx88-cards.c pci/cx88/cx88-core.c pci/cx88/cx88-i2c.c pci/cx88/cx88-tvaudio.c pci/cx88/cx88-dsp.c pci/cx88/cx88-input.c
pci/ddbridge/ddbridge.ko       = pci/ddbridge/ddbridge-core.c
pci/dm1105/dm1105.ko           = pci/dm1105/dm1105.c
pci/mantis/hopper.ko           = pci/mantis/hopper_cards.c pci/mantis/hopper_vp3028.c
pci/mantis/mantis_core.ko      = pci/mantis/mantis_ioc.c pci/mantis/mantis_uart.c pci/mantis/mantis_dma.c pci/mantis/mantis_pci.c pci/mantis/mantis_i2c.c pci/mantis/mantis_dvb.c pci/mantis/mantis_evm.c pci/mantis/mantis_hif.c pci/mantis/mantis_ca.c pci/mantis/mantis_pcmcia.c pci/mantis/mantis_input.c
pci/mantis/mantis.ko           = pci/mantis/mantis_cards.c pci/mantis/mantis_vp1033.c pci/mantis/mantis_vp1034.c pci/mantis/mantis_vp1041.c pci/mantis/mantis_vp2033.c pci/mantis/mantis_vp2040.c pci/mantis/mantis_vp3030.c
pci/ngene/ngene.ko             = pci/ngene/ngene-core.c pci/ngene/ngene-i2c.c pci/ngene/ngene-cards.c pci/ngene/ngene-dvb.c
pci/pluto2/pluto2.ko           = pci/pluto2/pluto2.c
pci/pt1/earth-pt1.ko           = pci/pt1/pt1.c pci/pt1/va1j5jf8007s.c pci/pt1/va1j5jf8007t.c
pci/saa7134/saa6752hs.ko       = pci/saa7134/saa6752hs.c
pci/saa7134/saa7134-alsa.ko    = pci/saa7134/saa7134-alsa.c
pci/saa7134/saa7134-dvb.ko     = pci/saa7134/saa7134-dvb.c
pci/saa7134/saa7134-empress.ko = pci/saa7134/saa7134-empress.c
pci/saa7134/saa7134-input.ko   = pci/saa7134/saa7134-input.c
pci/saa7134/saa7134.ko         = +
pci/saa7164/saa7164.ko         = pci/saa7164/saa7164-cards.c pci/saa7164/saa7164-core.c pci/saa7164/saa7164-i2c.c pci/saa7164/saa7164-dvb.c pci/saa7164/saa7164-fw.c pci/saa7164/saa7164-bus.c pci/saa7164/saa7164-cmd.c pci/saa7164/saa7164-api.c pci/saa7164/saa7164-buffer.c pci/saa7164/saa7164-encoder.c pci/saa7164/saa7164-vbi.c
pci/sta2x11/sta2x11_vip.ko     = pci/sta2x11/sta2x11_vip.c
pci/ttpci/budget-av.ko         = pci/ttpci/budget-av.c
pci/ttpci/budget-ci.ko         = pci/ttpci/budget-ci.c
pci/ttpci/budget-core.ko       = pci/ttpci/budget-core.c
pci/ttpci/budget.ko            = pci/ttpci/budget.c
pci/ttpci/budget-patch.ko      = pci/ttpci/budget-patch.c
pci/ttpci/dvb-ttpci.ko         = pci/ttpci/av7110_ir.c pci/ttpci/av7110_hw.c pci/ttpci/av7110_v4l.c pci/ttpci/av7110_av.c pci/ttpci/av7110_ca.c pci/ttpci/av7110.c pci/ttpci/av7110_ipack.c
pci/ttpci/ttpci-eeprom.ko      = pci/ttpci/ttpci-eeprom.c
platform/arv.ko                = platform/arv.c
platform/blackfin/bfin_video_capture.ko = platform/blackfin/bfin_capture.c platform/blackfin/ppi.c
platform/coda.ko               = platform/coda.c
platform/davinci/dm355_ccdc.ko = platform/davinci/dm355_ccdc.c
platform/davinci/dm644x_ccdc.ko = platform/davinci/dm644x_ccdc.c
platform/davinci/isif.ko       = platform/davinci/isif.c
platform/davinci/vpbe_display.ko = platform/davinci/vpbe_display.c
platform/davinci/vpbe.ko       = platform/davinci/vpbe.c
platform/davinci/vpbe_osd.ko   = platform/davinci/vpbe_osd.c
platform/davinci/vpbe_venc.ko  = platform/davinci/vpbe_venc.c
platform/davinci/vpfe_capture.ko = platform/davinci/vpfe_capture.c
platform/davinci/vpif_capture.ko = platform/davinci/vpif_capture.c
platform/davinci/vpif_display.ko = platform/davinci/vpif_display.c
platform/davinci/vpif.ko       = platform/davinci/vpif.c
platform/davinci/vpss.ko       = platform/davinci/vpss.c
platform/exynos-gsc/exynos-gsc.ko = platform/exynos-gsc/gsc-core.c platform/exynos-gsc/gsc-m2m.c platform/exynos-gsc/gsc-regs.c
platform/fsl-viu.ko            = platform/fsl-viu.c
platform/indycam.ko            = platform/indycam.c
platform/m2m-deinterlace.ko    = platform/m2m-deinterlace.c
platform/mem2mem_testdev.ko    = platform/mem2mem_testdev.c
platform/mx2_emmaprp.ko        = platform/mx2_emmaprp.c
platform/omap2cam.ko           = platform/omap24xxcam.c platform/omap24xxcam-dma.c
platform/omap/omap-vout.ko     = +
platform/omap/omap_vout_vrfb.ko = platform/omap/omap_vout_vrfb.c
platform/s5p-g2d/s5p-g2d.ko    = platform/s5p-g2d/g2d.c platform/s5p-g2d/g2d-hw.c
platform/s5p-jpeg/s5p-jpeg.ko  = platform/s5p-jpeg/jpeg-core.c
platform/sh_vou.ko             = platform/sh_vou.c
platform/timblogiw.ko          = platform/timblogiw.c
platform/via-camera.ko         = platform/via-camera.c
platform/vino.ko               = platform/vino.c
platform/vivi.ko               = platform/vivi.c
radio/dsbr100.ko               = radio/dsbr100.c
radio/radio-aimslab.ko         = radio/radio-aimslab.c
radio/radio-aztech.ko          = radio/radio-aztech.c
radio/radio-cadet.ko           = radio/radio-cadet.c
radio/radio-gemtek.ko          = radio/radio-gemtek.c
radio/radio-isa.ko             = radio/radio-isa.c
radio/radio-keene.ko           = radio/radio-keene.c
radio/radio-maxiradio.ko       = radio/radio-maxiradio.c
radio/radio-miropcm20.ko       = radio/radio-miropcm20.c
radio/radio-mr800.ko           = radio/radio-mr800.c
radio/radio-rtrack2.ko         = radio/radio-rtrack2.c
radio/radio-sf16fmi.ko         = radio/radio-sf16fmi.c
radio/radio-sf16fmr2.ko        = radio/radio-sf16fmr2.c
radio/radio-shark.ko           = radio/radio-shark.c
radio/radio-si4713.ko          = radio/radio-si4713.c
radio/radio-tea5764.ko         = radio/radio-tea5764.c
radio/radio-terratec.ko        = radio/radio-terratec.c
radio/radio-timb.ko            = radio/radio-timb.c
radio/radio-trust.ko           = radio/radio-trust.c
radio/radio-typhoon.ko         = radio/radio-typhoon.c
radio/radio-wl1273.ko          = radio/radio-wl1273.c
radio/radio-zoltrix.ko         = radio/radio-zoltrix.c
radio/saa7706h.ko              = radio/saa7706h.c
radio/shark2.ko                = radio/radio-shark2.c radio/radio-tea5777.c
radio/si470x/radio-i2c-si470x.ko = radio/si470x/radio-si470x-i2c.c radio/si470x/radio-si470x-common.c
radio/si470x/radio-usb-si470x.ko = radio/si470x/radio-si470x-usb.c radio/si470x/radio-si470x-common.c
radio/si4713-i2c.ko            = radio/si4713-i2c.c
radio/tef6862.ko               = radio/tef6862.c
radio/wl128x/fm_drv.ko         = radio/wl128x/fmdrv_common.c radio/wl128x/fmdrv_rx.c radio/wl128x/fmdrv_tx.c radio/wl128x/fmdrv_v4l2.c
rc/ati_remote.ko               = rc/ati_remote.c
rc/fintek-cir.ko               = rc/fintek-cir.c
rc/gpio-ir-recv.ko             = rc/gpio-ir-recv.c
rc/iguanair.ko                 = rc/iguanair.c
rc/imon.ko                     = rc/imon.c
rc/ir-jvc-decoder.ko           = rc/ir-jvc-decoder.c
rc/ir-lirc-codec.ko            = rc/ir-lirc-codec.c
rc/ir-mce_kbd-decoder.ko       = rc/ir-mce_kbd-decoder.c
rc/ir-nec-decoder.ko           = rc/ir-nec-decoder.c
rc/ir-rc5-decoder.ko           = rc/ir-rc5-decoder.c
rc/ir-rc5-sz-decoder.ko        = rc/ir-rc5-sz-decoder.c
rc/ir-rc6-decoder.ko           = rc/ir-rc6-decoder.c
rc/ir-rx51.ko                  = rc/ir-rx51.c
rc/ir-sanyo-decoder.ko         = rc/ir-sanyo-decoder.c
rc/ir-sony-decoder.ko          = rc/ir-sony-decoder.c
rc/ite-cir.ko                  = rc/ite-cir.c
rc/lirc_dev.ko                 = rc/lirc_dev.c
rc/mceusb.ko                   = rc/mceusb.c
rc/nuvoton-cir.ko              = rc/nuvoton-cir.c
rc/rc-loopback.ko              = rc/rc-loopback.c
rc/redrat3.ko                  = rc/redrat3.c
rc/streamzap.ko                = rc/streamzap.c
rc/ttusbir.ko                  = rc/ttusbir.c
tuners/fc0012.ko               = tuners/fc0012.c
tuners/fc0013.ko               = tuners/fc0013.c
tuners/max2165.ko              = tuners/max2165.c
tuners/mc44s803.ko             = tuners/mc44s803.c
tuners/mt2060.ko               = tuners/mt2060.c
tuners/mt2063.ko               = tuners/mt2063.c
tuners/mt20xx.ko               = tuners/mt20xx.c
tuners/mt2131.ko               = tuners/mt2131.c
tuners/mt2266.ko               = tuners/mt2266.c
tuners/mxl5005s.ko             = tuners/mxl5005s.c
tuners/tda827x.ko              = tuners/tda827x.c
tuners/tda9887.ko              = tuners/tda9887.c
tuners/tea5761.ko              = tuners/tea5761.c
tuners/tea5767.ko              = tuners/tea5767.c
tuners/tuner-simple.ko         = tuners/tuner-simple.c
tuners/tuner-types.ko          = tuners/tuner-types.c
tuners/tuner-xc2028.ko         = tuners/tuner-xc2028.c
tuners/xc4000.ko               = tuners/xc4000.c
tuners/xc5000.ko               = tuners/xc5000.c
usb/au0828/au0828.ko           = usb/au0828/au0828-core.c usb/au0828/au0828-i2c.c usb/au0828/au0828-cards.c usb/au0828/au0828-dvb.c usb/au0828/au0828-video.c usb/au0828/au0828-vbi.c
usb/b2c2/b2c2-flexcop-usb.ko   = usb/b2c2/flexcop-usb.c
usb/cpia2/cpia2.ko             = usb/cpia2/cpia2_v4l.c usb/cpia2/cpia2_usb.c usb/cpia2/cpia2_core.c
usb/cx231xx/cx231xx-alsa.ko    = usb/cx231xx/cx231xx-audio.c
usb/cx231xx/cx231xx-dvb.ko     = usb/cx231xx/cx231xx-dvb.c
usb/cx231xx/cx231xx-input.ko   = usb/cx231xx/cx231xx-input.c
usb/cx231xx/cx231xx.ko         = +
usb/dvb-usb/dvb-usb-a800.ko    = usb/dvb-usb/a800.c
usb/dvb-usb/dvb-usb-af9005.ko  = usb/dvb-usb/af9005.c usb/dvb-usb/af9005-fe.c
usb/dvb-usb/dvb-usb-af9005-remote.ko = usb/dvb-usb/af9005-remote.c
usb/dvb-usb/dvb-usb-az6027.ko  = usb/dvb-usb/az6027.c
usb/dvb-usb/dvb-usb-cinergyT2.ko = usb/dvb-usb/cinergyT2-core.c usb/dvb-usb/cinergyT2-fe.c
usb/dvb-usb/dvb-usb-cxusb.ko   = usb/dvb-usb/cxusb.c
usb/dvb-usb/dvb-usb-dib0700.ko = usb/dvb-usb/dib0700_core.c usb/dvb-usb/dib0700_devices.c
usb/dvb-usb/dvb-usb-dibusb-common.ko = usb/dvb-usb/dibusb-common.c
usb/dvb-usb/dvb-usb-dibusb-mb.ko = usb/dvb-usb/dibusb-mb.c
usb/dvb-usb/dvb-usb-dibusb-mc.ko = usb/dvb-usb/dibusb-mc.c
usb/dvb-usb/dvb-usb-digitv.ko  = usb/dvb-usb/digitv.c
usb/dvb-usb/dvb-usb-dtt200u.ko = usb/dvb-usb/dtt200u.c usb/dvb-usb/dtt200u-fe.c
usb/dvb-usb/dvb-usb-dtv5100.ko = usb/dvb-usb/dtv5100.c
usb/dvb-usb/dvb-usb-dw2102.ko  = usb/dvb-usb/dw2102.c
usb/dvb-usb/dvb-usb-friio.ko   = usb/dvb-usb/friio.c usb/dvb-usb/friio-fe.c
usb/dvb-usb/dvb-usb-gp8psk.ko  = usb/dvb-usb/gp8psk.c usb/dvb-usb/gp8psk-fe.c
usb/dvb-usb/dvb-usb.ko         = usb/dvb-usb/dvb-usb-dvb.c usb/dvb-usb/dvb-usb-remote.c usb/dvb-usb/usb-urb.c usb/dvb-usb/dvb-usb-firmware.c usb/dvb-usb/dvb-usb-init.c usb/dvb-usb/dvb-usb-urb.c usb/dvb-usb/dvb-usb-i2c.c
usb/dvb-usb/dvb-usb-m920x.ko   = usb/dvb-usb/m920x.c
usb/dvb-usb/dvb-usb-nova-t-usb2.ko = usb/dvb-usb/nova-t-usb2.c
usb/dvb-usb/dvb-usb-opera.ko   = usb/dvb-usb/opera1.c
usb/dvb-usb/dvb-usb-pctv452e.ko = usb/dvb-usb/pctv452e.c
usb/dvb-usb/dvb-usb-technisat-usb2.ko = usb/dvb-usb/technisat-usb2.c
usb/dvb-usb/dvb-usb-ttusb2.ko  = usb/dvb-usb/ttusb2.c
usb/dvb-usb/dvb-usb-umt-010.ko = usb/dvb-usb/umt-010.c
usb/dvb-usb/dvb-usb-vp702x.ko  = usb/dvb-usb/vp702x.c usb/dvb-usb/vp702x-fe.c
usb/dvb-usb/dvb-usb-vp7045.ko  = usb/dvb-usb/vp7045.c usb/dvb-usb/vp7045-fe.c
usb/dvb-usb-v2/dvb-usb-az6007.ko = usb/dvb-usb-v2/az6007.c
usb/dvb-usb-v2/dvb-usb-gl861.ko = usb/dvb-usb-v2/gl861.c
usb/dvb-usb-v2/dvb-usb-it913x.ko = usb/dvb-usb-v2/it913x.c
usb/dvb-usb-v2/dvb-usb-lmedm04.ko = usb/dvb-usb-v2/lmedm04.c
usb/em28xx/em28xx-alsa.ko      = usb/em28xx/em28xx-audio.c
usb/em28xx/em28xx-dvb.ko       = usb/em28xx/em28xx-dvb.c
usb/em28xx/em28xx.ko           = usb/em28xx/em28xx-core.c usb/em28xx/em28xx-vbi.c usb/em28xx/em28xx-video.c usb/em28xx/em28xx-i2c.c usb/em28xx/em28xx-cards.c
usb/em28xx/em28xx-rc.ko        = usb/em28xx/em28xx-input.c
usb/hdpvr/hdpvr.ko             = usb/hdpvr/hdpvr-control.c usb/hdpvr/hdpvr-core.c usb/hdpvr/hdpvr-video.c usb/hdpvr/hdpvr-i2c.c
usb/pwc/pwc.ko                 = usb/pwc/pwc-dec1.c usb/pwc/pwc-dec23.c usb/pwc/pwc-kiara.c usb/pwc/pwc-timon.c usb/pwc/pwc-if.c usb/pwc/pwc-misc.c usb/pwc/pwc-ctrl.c usb/pwc/pwc-v4l.c usb/pwc/pwc-uncompress.c
usb/s2255/s2255drv.ko          = usb/s2255/s2255drv.c
usb/siano/smsusb.ko            = usb/siano/smsusb.c
usb/stkwebcam/stkwebcam.ko     = usb/stkwebcam/stk-webcam.c usb/stkwebcam/stk-sensor.c
usb/tm6000/tm6000-alsa.ko      = usb/tm6000/tm6000-alsa.c
usb/tm6000/tm6000-dvb.ko       = usb/tm6000/tm6000-dvb.c
usb/tm6000/tm6000.ko           = usb/tm6000/tm6000-cards.c usb/tm6000/tm6000-core.c usb/tm6000/tm6000-i2c.c usb/tm6000/tm6000-video.c usb/tm6000/tm6000-stds.c usb/tm6000/tm6000-input.c
usb/ttusb-budget/dvb-ttusb-budget.ko = usb/ttusb-budget/dvb-ttusb-budget.c
usb/ttusb-dec/ttusbdecfe.ko    = usb/ttusb-dec/ttusbdecfe.c
usb/ttusb-dec/ttusb_dec.ko     = usb/ttusb-dec/ttusb_dec.c
usb/usbvision/usbvision.ko     = usb/usbvision/usbvision-core.c usb/usbvision/usbvision-video.c usb/usbvision/usbvision-i2c.c usb/usbvision/usbvision-cards.c

