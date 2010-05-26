Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55559 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab0EZDcf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 23:32:35 -0400
Date: Wed, 26 May 2010 00:32:26 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Helmut Auer <vdr@helmutauer.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: v4l-dvb does not compile with kernel 2.6.34
Message-ID: <20100526003226.4bd40da6@pedra>
In-Reply-To: <1274831033.3273.67.camel@pc07.localdom.local>
References: <4BFC4858.8060403@helmutauer.de>
	<1274831033.3273.67.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 May 2010 01:43:53 +0200
hermann pitton <hermann-pitton@arcor.de> escreveu:

> Hi Helmut,
> 
> Am Dienstag, den 25.05.2010, 23:59 +0200 schrieb Helmut Auer:
> > Hello
> > 
> > I just wanted to compile v4l-dvb for my Gen2VDR Ditribution with kernel 2.6.34, but it fails
> > because many modules are missing:
> > 
> > #include <linux/slab.h>
> > 
> > and are getting errors like:
> > 
> > /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
> > 'free_firmware':
> > /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:252: error: implicit
> > declaration of function 'kfree'
> > /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
> > 'load_all_firmwares':
> > /tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:314: error: implicit
> > declaration of function
> > 
> > Am I missing something or is v4l-dvb broken ?
> > 
> 
> I did not test on all, but had some rant few days ago and explanations
> followed and I likely missed some RFCs in that direction previously.
> 
> If I do get it right now, the released vanilla 2.6.34 should be stable.
> 
> For the upcoming 2.6.35, like always, only the first upcoming rc1 is a
> potential candidate for some first stability there.
> 
> On mercurial v4l-dvb, with all patch porting in this hybrid ;) situation
> with mixed up- and backports, after the git branch is official, only
> 2.6.33 is considered to be stable for now.
> 
> There are still "compatibility bugs" on all earlier kernels I guess,
> but /me agreed to have at least four weeks for "fixing" them.
> 
> An average kernel release cycle is about three months.
> 
> I asked, if we should not all go to latest stable vanilla and upcoming
> rc candidates instead. By that mass of devices we have now, those with
> relevant hardware must come back for testing on rc stuff anyway.
> 
> The decision for now was to keep backward compat, to allow to have more
> testers, this was always my point of view over all the years too.
> During all that, we changed a lot these days from "hacked" drivers to by
> chip manufacturers and OEMs fully supported ones.
> 
> This is the root cause for going to git and includes to stay in sync
> with other subsystems on git level doing the same.
> 
> For what is still trickling in from active users, I also have to say,
> that this throws one back into time consuming efforts again, even more
> time consuming than that times v4l and dvb did go out of sync on every
> new kernel in the past and if it is only about to avoid latest vanilla
> or upcoming rc stuff and keep staying on older kernels, is it worth it?
> 
> Testers will vote with their feet.
> 
> In other words, to keep bisecting reliable on Linus' git level is
> already a huge task, to keep mercurial v4l-dvb bisecting with all the
> compat stuff functional, ugh.
> 
> Also, no doubt, Hans' daily build reports are really helpful, but to
> assume only seeing warnings there now, after a first "fix" for some
> upper older kernel came in, and previously say eight did error out at
> the same point, is no replacement for testing with real devices on every
> such later kernel ...
> 
> The rest is pure luck and a rare case.
> 
> We likely should wait for two/three kernel release cycles, but I predict
> Douglas will have a very hard job, if not much more people come in to
> support backward compatibility on mercurial level.
> 
> Thanks for your report from the upper side ;)

For sure more help with patches sent to Douglas are welcome. In this
specific case, what should be done is to backport the upstream changes
(since those patches, among with others, come from upstream). 

While the most visible missing backport is the lack of the new gfp.h and slab.h 
includes, as usual, there are a bunch of other -git patches that touched at the 
drivers that came from other trees (mostly from trivial git tree, but also from 
other upstream kABI changes).

Also, there are some merge conflicts whose merge produced small diffs, when
comparing with the -hg patch backports. 

The diff file contains 3808 lines (see enclosed), and if applied as-is, it
will likely break compilation against kernels lower than 2.6.34.

The proper way to backport those changes is to identify what upstream git
changesets made the change, and backport one by one. Of course, trivial typo
changes can just be grouped altogether, to reduce the workload.

So, basically, for all files with significant changes, a git blame should be used,
in order to identify what git changeset changed some line.

I used to do this for every new kernel version. So, yes, it is a lot of work.
This time, the diff touches on almost 300 files and have almost 4000 lines. 

For example, firedtv-fw.c suffered some non-trivial changes.

This is the procedure I used to do, in order to properly backport it:

Use git blame to identify the patches that changed the code:
	$ git blame drivers/media/dvb/firewire/firedtv-fw.c 

And seek for one of the changed line. In this case:

1f8fef7b (Clemens Ladisch 2009-12-24 11:59:57 +0100 242) #define MAX_MODEL_NAME_LEN sizeof("FireDTV ????")

The patch in question touches not only the firewire driver, but also the firmware core:

 $ git show 1f8fef7b |diffstat
 drivers/firewire/core-device.c          |  110 ++++++++++++++++++++++----------
 drivers/media/dvb/firewire/firedtv-fw.c |   39 +----------
 include/linux/firewire.h                |    2 
 3 files changed, 84 insertions(+), 67 deletions(-)

So, if applied as-is, it would break compilation against older kernels. This means
that part of the changes should go to compat.h, or need some additional #ifdefs
to test for a specific kernel version.

So, a special patch needs to be created, in order to avoid backport breakage.
Eventually, there are more patches touching the same file, so, another diff is needed
(using gentree.pl, to remove the backport changes), in order to compare the file again,
and be sure that it now has fully backported.

After finishing the backport to firedtv-fw.c, the same procedure should be repeated
again, for other files.

Douglas said he is starting to do this job. Yet, he is abroad, participating
in a training, and probably suffering from jet leg, due to the time fuse
difference. So, it may take a while until he can backport all the changes.

As reference for those that are willing to help, I'm enclosing the current diff 
between -hg and -git. It was produced with my diffrev.sh script that I posted at
the ML some time ago [1], comparing the current -hg tree against git changeset
e8d0416796d43a950ec7b65629e53419b2e22453.

[1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg17096.html

Cheers,
Mauro.

---

diffstat -p1 /tmp/diff
 Documentation/DocBook/v4l/common.xml                 |    2 
 Documentation/DocBook/v4l/compat.xml                 |   56 +++++++++----------
 Documentation/DocBook/v4l/vidioc-dqevent.xml         |   22 +++----
 Documentation/DocBook/v4l/vidioc-g-parm.xml          |    2 
 Documentation/video4linux/CARDLIST.saa7134           |    4 -
 arch/arm/mach-mx1/Makefile                           |    5 +
 arch/arm/mach-pxa/pcm990-baseboard.c                 |    9 ++-
 arch/arm/plat-mxc/include/mach/memory.h              |   54 ++++++++++--------
 arch/sh/boards/mach-ap325rxa/setup.c                 |   20 +++---
 arch/sh/boards/mach-kfr2r09/setup.c                  |   16 ++---
 arch/sh/boards/mach-migor/setup.c                    |   38 +++++++-----
 drivers/media/IR/ir-core-priv.h                      |    1 
 drivers/media/IR/ir-keytable.c                       |    7 +-
 drivers/media/IR/ir-sysfs.c                          |    1 
 drivers/media/common/tuners/max2165.c                |    1 
 drivers/media/common/tuners/mc44s803.c               |    1 
 drivers/media/common/tuners/mt2060.c                 |    1 
 drivers/media/common/tuners/mt20xx.c                 |    1 
 drivers/media/common/tuners/mt2131.c                 |    1 
 drivers/media/common/tuners/mt2266.c                 |    1 
 drivers/media/common/tuners/tda827x.c                |    1 
 drivers/media/common/tuners/tda8290.c                |    1 
 drivers/media/common/tuners/tda9887.c                |    1 
 drivers/media/common/tuners/tea5761.c                |    1 
 drivers/media/common/tuners/tea5767.c                |    1 
 drivers/media/common/tuners/tuner-i2c.h              |    1 
 drivers/media/common/tuners/tuner-xc2028.c           |    1 
 drivers/media/dvb/bt8xx/dst_ca.c                     |    1 
 drivers/media/dvb/dm1105/dm1105.c                    |    1 
 drivers/media/dvb/dvb-core/dmxdev.h                  |    1 
 drivers/media/dvb/dvb-core/dvb_frontend.h            |    9 +--
 drivers/media/dvb/dvb-core/dvb_net.c                 |   15 ++---
 drivers/media/dvb/dvb-usb/af9015.c                   |    1 
 drivers/media/dvb/dvb-usb/cxusb.c                    |    1 
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c           |    4 -
 drivers/media/dvb/firewire/firedtv-1394.c            |    1 
 drivers/media/dvb/firewire/firedtv-fw.c              |   39 +------------
 drivers/media/dvb/firewire/firedtv-rc.c              |    1 
 drivers/media/dvb/frontends/au8522_dig.c             |    1 
 drivers/media/dvb/frontends/dib0070.c                |    1 
 drivers/media/dvb/frontends/dib0090.c                |    1 
 drivers/media/dvb/frontends/dib3000mc.c              |    1 
 drivers/media/dvb/frontends/dib7000m.c               |    1 
 drivers/media/dvb/frontends/dib7000p.c               |    1 
 drivers/media/dvb/frontends/dib8000.c                |    1 
 drivers/media/dvb/frontends/drx397xD.c               |    1 
 drivers/media/dvb/frontends/dvb-pll.c                |    1 
 drivers/media/dvb/frontends/itd1000.c                |    1 
 drivers/media/dvb/frontends/lgdt3304.c               |    1 
 drivers/media/dvb/frontends/lgdt3305.c               |    1 
 drivers/media/dvb/frontends/mb86a16.c                |    1 
 drivers/media/dvb/frontends/s921_module.c            |    1 
 drivers/media/dvb/frontends/stb0899_drv.c            |    1 
 drivers/media/dvb/frontends/stb6000.c                |    1 
 drivers/media/dvb/frontends/stb6100.c                |    1 
 drivers/media/dvb/frontends/stv090x.c                |    1 
 drivers/media/dvb/frontends/stv6110.c                |    1 
 drivers/media/dvb/frontends/stv6110x.c               |    1 
 drivers/media/dvb/frontends/tda665x.c                |    1 
 drivers/media/dvb/frontends/tda8261.c                |    1 
 drivers/media/dvb/frontends/tda826x.c                |    1 
 drivers/media/dvb/frontends/tua6100.c                |    1 
 drivers/media/dvb/frontends/zl10036.c                |    1 
 drivers/media/dvb/mantis/hopper_cards.c              |    1 
 drivers/media/dvb/mantis/mantis_ca.c                 |    1 
 drivers/media/dvb/mantis/mantis_cards.c              |    1 
 drivers/media/dvb/ngene/Makefile                     |    3 -
 drivers/media/dvb/ngene/ngene-core.c                 |    5 +
 drivers/media/dvb/ngene/ngene.h                      |    2 
 drivers/media/dvb/pluto2/pluto2.c                    |    1 
 drivers/media/dvb/pt1/pt1.c                          |    1 
 drivers/media/dvb/siano/smscoreapi.c                 |    1 
 drivers/media/dvb/siano/smsdvb.c                     |    1 
 drivers/media/dvb/siano/smssdio.c                    |    1 
 drivers/media/dvb/siano/smsusb.c                     |    1 
 drivers/media/dvb/ttpci/av7110.c                     |    1 
 drivers/media/dvb/ttpci/av7110_ca.c                  |    1 
 drivers/media/radio/radio-gemtek-pci.c               |    1 
 drivers/media/radio/radio-maestro.c                  |    1 
 drivers/media/radio/radio-maxiradio.c                |    1 
 drivers/media/radio/radio-si4713.c                   |    1 
 drivers/media/radio/radio-tea5764.c                  |    1 
 drivers/media/radio/radio-timb.c                     |    1 
 drivers/media/radio/saa7706h.c                       |    1 
 drivers/media/radio/si470x/radio-si470x-i2c.c        |    1 
 drivers/media/radio/si470x/radio-si470x-usb.c        |    1 
 drivers/media/radio/si4713-i2c.c                     |    1 
 drivers/media/radio/tef6862.c                        |    1 
 drivers/media/video/adv7170.c                        |    1 
 drivers/media/video/adv7175.c                        |    1 
 drivers/media/video/adv7180.c                        |    1 
 drivers/media/video/adv7343.c                        |    1 
 drivers/media/video/au0828/au0828-core.c             |    1 
 drivers/media/video/au0828/au0828-dvb.c              |    1 
 drivers/media/video/au0828/au0828-video.c            |    1 
 drivers/media/video/bt819.c                          |    1 
 drivers/media/video/bt856.c                          |    1 
 drivers/media/video/bt866.c                          |    1 
 drivers/media/video/bt8xx/bttv-cards.c               |    4 -
 drivers/media/video/bt8xx/bttv-driver.c              |    1 
 drivers/media/video/bt8xx/bttv-gpio.c                |    1 
 drivers/media/video/bt8xx/bttv-input.c               |    1 
 drivers/media/video/bt8xx/bttv-risc.c                |    1 
 drivers/media/video/cafe_ccic.c                      |    1 
 drivers/media/video/cpia_pp.c                        |    1 
 drivers/media/video/cs5345.c                         |    1 
 drivers/media/video/cs53l32a.c                       |    1 
 drivers/media/video/cx18/cx18-alsa-main.c            |    1 
 drivers/media/video/cx18/cx18-controls.c             |    1 
 drivers/media/video/cx18/cx18-driver.h               |    1 
 drivers/media/video/cx231xx/cx231xx-cards.c          |    1 
 drivers/media/video/cx231xx/cx231xx-core.c           |    1 
 drivers/media/video/cx231xx/cx231xx-dvb.c            |    1 
 drivers/media/video/cx231xx/cx231xx-input.c          |    1 
 drivers/media/video/cx231xx/cx231xx-vbi.c            |    1 
 drivers/media/video/cx231xx/cx231xx-video.c          |    1 
 drivers/media/video/cx231xx/cx231xx.h                |    1 
 drivers/media/video/cx23885/cx23885-417.c            |    1 
 drivers/media/video/cx23885/cx23885-input.c          |    1 
 drivers/media/video/cx23885/cx23885-vbi.c            |    1 
 drivers/media/video/cx23885/cx23885.h                |    1 
 drivers/media/video/cx23885/cx23888-ir.c             |    1 
 drivers/media/video/cx88/cx88-alsa.c                 |    1 
 drivers/media/video/cx88/cx88-blackbird.c            |    1 
 drivers/media/video/cx88/cx88-cards.c                |    1 
 drivers/media/video/cx88/cx88-dsp.c                  |    1 
 drivers/media/video/cx88/cx88-input.c                |    1 
 drivers/media/video/cx88/cx88-mpeg.c                 |    1 
 drivers/media/video/cx88/cx88-tvaudio.c              |    1 
 drivers/media/video/cx88/cx88-vbi.c                  |    1 
 drivers/media/video/cx88/cx88-vp3054-i2c.c           |    1 
 drivers/media/video/dabusb.c                         |    8 ++
 drivers/media/video/davinci/dm644x_ccdc.c            |    1 
 drivers/media/video/davinci/vpfe_capture.c           |    1 
 drivers/media/video/davinci/vpif_capture.c           |    1 
 drivers/media/video/davinci/vpif_display.c           |    1 
 drivers/media/video/em28xx/em28xx-cards.c            |    1 
 drivers/media/video/em28xx/em28xx-core.c             |    1 
 drivers/media/video/em28xx/em28xx-dvb.c              |    1 
 drivers/media/video/em28xx/em28xx-input.c            |    1 
 drivers/media/video/em28xx/em28xx-vbi.c              |    1 
 drivers/media/video/em28xx/em28xx-video.c            |    1 
 drivers/media/video/gspca/gspca.c                    |   15 ++++-
 drivers/media/video/gspca/gspca.h                    |    1 
 drivers/media/video/gspca/jeilinj.c                  |    1 
 drivers/media/video/gspca/m5602/m5602_s5k83a.c       |    1 
 drivers/media/video/gspca/ov519.c                    |    2 
 drivers/media/video/gspca/sn9c20x.c                  |    1 
 drivers/media/video/gspca/sonixj.c                   |    1 
 drivers/media/video/gspca/spca508.c                  |    1 
 drivers/media/video/gspca/spca561.c                  |    1 
 drivers/media/video/gspca/sq905.c                    |    1 
 drivers/media/video/gspca/sq905c.c                   |    1 
 drivers/media/video/gspca/zc3xx.c                    |    1 
 drivers/media/video/hdpvr/hdpvr-i2c.c                |    1 
 drivers/media/video/ivtv/ivtv-controls.c             |    1 
 drivers/media/video/ivtv/ivtv-driver.h               |    1 
 drivers/media/video/ivtv/ivtvfb.c                    |    1 
 drivers/media/video/ks0127.c                         |    1 
 drivers/media/video/m52790.c                         |    1 
 drivers/media/video/meye.c                           |    1 
 drivers/media/video/msp3400-kthreads.c               |    1 
 drivers/media/video/mt9v011.c                        |    1 
 drivers/media/video/mx1_camera.c                     |    9 +--
 drivers/media/video/omap24xxcam.c                    |    3 -
 drivers/media/video/ov7670.c                         |    1 
 drivers/media/video/pms.c                            |    1 
 drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c       |    1 
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c    |    1 
 drivers/media/video/pvrusb2/pvrusb2-debugifc.c       |    1 
 drivers/media/video/pvrusb2/pvrusb2-dvb.c            |    1 
 drivers/media/video/pvrusb2/pvrusb2-eeprom.c         |    1 
 drivers/media/video/pvrusb2/pvrusb2-main.c           |    1 
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c          |    8 ++
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c           |    1 
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c      |    1 
 drivers/media/video/pvrusb2/pvrusb2-wm8775.c         |    1 
 drivers/media/video/pwc/philips.txt                  |    2 
 drivers/media/video/pwc/pwc-dec23.c                  |    1 
 drivers/media/video/pwc/pwc-v4l.c                    |    1 
 drivers/media/video/pwc/pwc.h                        |    1 
 drivers/media/video/pxa_camera.c                     |   12 ++--
 drivers/media/video/s2255drv.c                       |    1 
 drivers/media/video/saa5246a.c                       |    1 
 drivers/media/video/saa5249.c                        |    1 
 drivers/media/video/saa7134/saa7134-dvb.c            |    1 
 drivers/media/video/saa7134/saa7134-empress.c        |    1 
 drivers/media/video/saa7134/saa7134-i2c.c            |    1 
 drivers/media/video/saa7134/saa7134-input.c          |    1 
 drivers/media/video/saa7134/saa7134-ts.c             |    1 
 drivers/media/video/saa7134/saa7134-tvaudio.c        |    1 
 drivers/media/video/saa7134/saa7134-vbi.c            |    1 
 drivers/media/video/saa7164/saa7164-api.c            |    1 
 drivers/media/video/saa7164/saa7164-buffer.c         |    2 
 drivers/media/video/saa7164/saa7164-fw.c             |    1 
 drivers/media/video/saa717x.c                        |    1 
 drivers/media/video/saa7185.c                        |    1 
 drivers/media/video/sh_mobile_ceu_camera.c           |    1 
 drivers/media/video/sn9c102/sn9c102_sensor.h         |    2 
 drivers/media/video/soc_camera.c                     |    1 
 drivers/media/video/tda9840.c                        |    1 
 drivers/media/video/tea6415c.c                       |    1 
 drivers/media/video/tea6420.c                        |    3 -
 drivers/media/video/ths7303.c                        |    1 
 drivers/media/video/tlg2300/pd-alsa.c                |    2 
 drivers/media/video/tlg2300/pd-dvb.c                 |    1 
 drivers/media/video/tlg2300/pd-video.c               |    1 
 drivers/media/video/tlv320aic23b.c                   |    1 
 drivers/media/video/tvp514x.c                        |    1 
 drivers/media/video/tvp5150.c                        |    1 
 drivers/media/video/tvp7002.c                        |    1 
 drivers/media/video/upd64031a.c                      |    1 
 drivers/media/video/upd64083.c                       |    1 
 drivers/media/video/usbvideo/konicawc.c              |    1 
 drivers/media/video/usbvideo/quickcam_messenger.c    |    1 
 drivers/media/video/usbvision/usbvision-core.c       |    2 
 drivers/media/video/usbvision/usbvision-i2c.c        |    1 
 drivers/media/video/uvc/uvc_ctrl.c                   |    1 
 drivers/media/video/uvc/uvc_driver.c                 |    1 
 drivers/media/video/uvc/uvc_status.c                 |    1 
 drivers/media/video/uvc/uvc_v4l2.c                   |    1 
 drivers/media/video/uvc/uvc_video.c                  |    1 
 drivers/media/video/v4l2-ioctl.c                     |    1 
 drivers/media/video/videobuf-dma-contig.c            |    1 
 drivers/media/video/videobuf-dvb.c                   |    1 
 drivers/media/video/vino.c                           |    1 
 drivers/media/video/vp27smpx.c                       |    1 
 drivers/media/video/vpx3220.c                        |    1 
 drivers/media/video/w9966.c                          |    1 
 drivers/media/video/wm8739.c                         |    1 
 drivers/media/video/wm8775.c                         |    1 
 drivers/media/video/zoran/zoran_card.c               |    1 
 drivers/staging/cx25821/cx25821-alsa.c               |    1 
 drivers/staging/cx25821/cx25821-audio-upstream.c     |    1 
 drivers/staging/cx25821/cx25821-audups11.c           |    5 +
 drivers/staging/cx25821/cx25821-core.c               |    1 
 drivers/staging/cx25821/cx25821-video-upstream-ch2.c |    1 
 drivers/staging/cx25821/cx25821-video-upstream.c     |    1 
 drivers/staging/cx25821/cx25821-video.c              |    4 -
 drivers/staging/go7007/go7007-driver.c               |    3 +
 drivers/staging/go7007/go7007-fw.c                   |    1 
 drivers/staging/go7007/go7007-usb.c                  |    4 +
 drivers/staging/go7007/go7007-v4l2.c                 |    1 
 drivers/staging/go7007/s2250-board.c                 |    3 -
 drivers/staging/go7007/s2250-loader.c                |    5 +
 drivers/staging/go7007/saa7134-go7007.c              |    1 
 drivers/staging/go7007/snd-go7007.c                  |    1 
 drivers/staging/go7007/wis-ov7640.c                  |    2 
 drivers/staging/go7007/wis-saa7113.c                 |    3 -
 drivers/staging/go7007/wis-saa7115.c                 |    3 -
 drivers/staging/go7007/wis-sony-tuner.c              |    3 -
 drivers/staging/go7007/wis-tw2804.c                  |    3 -
 drivers/staging/go7007/wis-tw9903.c                  |    3 -
 drivers/staging/go7007/wis-uda1342.c                 |    2 
 drivers/staging/tm6000/tm6000-video.c                |    4 -
 include/media/davinci/vpfe_capture.h                 |    2 
 include/media/ir-core.h                              |    1 
 sound/i2c/other/tea575x-tuner.c                      |    1 
 sound/pci/bt87x.c                                    |    4 -
 259 files changed, 421 insertions(+), 228 deletions(-)


diff -upr /home/v4l/tmp/oldtree/arch/arm/mach-mx1/Makefile ./arch/arm/mach-mx1/Makefile
--- /home/v4l/tmp/oldtree/arch/arm/mach-mx1/Makefile	2010-05-25 23:56:54.000000000 -0300
+++ ./arch/arm/mach-mx1/Makefile	2010-05-21 11:21:17.000000000 -0300
@@ -4,11 +4,12 @@
 
 # Object file lists.
 
+EXTRA_CFLAGS += -DIMX_NEEDS_DEPRECATED_SYMBOLS
 obj-y			+= generic.o clock.o devices.o
 
 # Support for CMOS sensor interface
 obj-$(CONFIG_MX1_VIDEO)	+= ksym_mx1.o mx1_camera_fiq.o
 
 # Specific board support
-obj-$(CONFIG_ARCH_MX1ADS) += mx1ads.o
-obj-$(CONFIG_MACH_SCB9328) += scb9328.o
\ No newline at end of file
+obj-$(CONFIG_ARCH_MX1ADS) += mach-mx1ads.o
+obj-$(CONFIG_MACH_SCB9328) += mach-scb9328.o
diff -upr /home/v4l/tmp/oldtree/arch/arm/mach-pxa/pcm990-baseboard.c ./arch/arm/mach-pxa/pcm990-baseboard.c
--- /home/v4l/tmp/oldtree/arch/arm/mach-pxa/pcm990-baseboard.c	2010-05-25 23:56:54.000000000 -0300
+++ ./arch/arm/mach-pxa/pcm990-baseboard.c	2010-05-21 11:21:18.000000000 -0300
@@ -58,6 +58,12 @@ static unsigned long pcm990_pin_config[]
 	/* I2C */
 	GPIO117_I2C_SCL,
 	GPIO118_I2C_SDA,
+
+	/* AC97 */
+	GPIO28_AC97_BITCLK,
+	GPIO29_AC97_SDATA_IN_0,
+	GPIO30_AC97_SDATA_OUT,
+	GPIO31_AC97_SYNC,
 };
 
 /*
@@ -259,8 +265,7 @@ static void pcm990_irq_handler(unsigned 
 	unsigned long pending = (~PCM990_INTSETCLR) & pcm990_irq_enabled;
 
 	do {
-		GEDR(PCM990_CTRL_INT_IRQ_GPIO) =
-					GPIO_bit(PCM990_CTRL_INT_IRQ_GPIO);
+		desc->chip->ack(irq);	/* clear our parent IRQ */
 		if (likely(pending)) {
 			irq = PCM027_IRQ(0) + __ffs(pending);
 			generic_handle_irq(irq);
diff -upr /home/v4l/tmp/oldtree/arch/arm/plat-mxc/include/mach/memory.h ./arch/arm/plat-mxc/include/mach/memory.h
--- /home/v4l/tmp/oldtree/arch/arm/plat-mxc/include/mach/memory.h	2010-05-25 23:56:54.000000000 -0300
+++ ./arch/arm/plat-mxc/include/mach/memory.h	2010-05-21 11:21:18.000000000 -0300
@@ -11,37 +11,45 @@
 #ifndef __ASM_ARCH_MXC_MEMORY_H__
 #define __ASM_ARCH_MXC_MEMORY_H__
 
-#if defined CONFIG_ARCH_MX1
-#define PHYS_OFFSET		UL(0x08000000)
-#elif defined CONFIG_ARCH_MX2
-#ifdef CONFIG_MACH_MX21
-#define PHYS_OFFSET		UL(0xC0000000)
-#endif
-#ifdef CONFIG_MACH_MX27
-#define PHYS_OFFSET		UL(0xA0000000)
-#endif
-#elif defined CONFIG_ARCH_MX3
-#define PHYS_OFFSET		UL(0x80000000)
-#elif defined CONFIG_ARCH_MX25
-#define PHYS_OFFSET		UL(0x80000000)
-#elif defined CONFIG_ARCH_MXC91231
-#define PHYS_OFFSET		UL(0x90000000)
+#define MX1_PHYS_OFFSET		UL(0x08000000)
+#define MX21_PHYS_OFFSET	UL(0xc0000000)
+#define MX25_PHYS_OFFSET	UL(0x80000000)
+#define MX27_PHYS_OFFSET	UL(0xa0000000)
+#define MX3x_PHYS_OFFSET	UL(0x80000000)
+#define MX51_PHYS_OFFSET	UL(0x90000000)
+#define MXC91231_PHYS_OFFSET	UL(0x90000000)
+
+#if !defined(CONFIG_RUNTIME_PHYS_OFFSET)
+# if defined CONFIG_ARCH_MX1
+#  define PHYS_OFFSET		MX1_PHYS_OFFSET
+# elif defined CONFIG_MACH_MX21
+#  define PHYS_OFFSET		MX21_PHYS_OFFSET
+# elif defined CONFIG_ARCH_MX25
+#  define PHYS_OFFSET		MX25_PHYS_OFFSET
+# elif defined CONFIG_MACH_MX27
+#  define PHYS_OFFSET		MX27_PHYS_OFFSET
+# elif defined CONFIG_ARCH_MX3
+#  define PHYS_OFFSET		MX3x_PHYS_OFFSET
+# elif defined CONFIG_ARCH_MXC91231
+#  define PHYS_OFFSET		MXC91231_PHYS_OFFSET
+# elif defined CONFIG_ARCH_MX5
+#  define PHYS_OFFSET		MX51_PHYS_OFFSET
+# endif
 #endif
 
-#if defined(CONFIG_MX1_VIDEO)
+#if defined(CONFIG_MX3_VIDEO)
 /*
  * Increase size of DMA-consistent memory region.
- * This is required for i.MX camera driver to capture at least four VGA frames.
+ * This is required for mx3 camera driver to capture at least two QXGA frames.
  */
-#define CONSISTENT_DMA_SIZE SZ_4M
-#endif /* CONFIG_MX1_VIDEO */
+#define CONSISTENT_DMA_SIZE SZ_8M
 
-#if defined(CONFIG_MX3_VIDEO)
+#elif defined(CONFIG_MX1_VIDEO)
 /*
  * Increase size of DMA-consistent memory region.
- * This is required for mx3 camera driver to capture at least two QXGA frames.
+ * This is required for i.MX camera driver to capture at least four VGA frames.
  */
-#define CONSISTENT_DMA_SIZE SZ_8M
-#endif /* CONFIG_MX3_VIDEO */
+#define CONSISTENT_DMA_SIZE SZ_4M
+#endif /* CONFIG_MX1_VIDEO */
 
 #endif /* __ASM_ARCH_MXC_MEMORY_H__ */
diff -upr /home/v4l/tmp/oldtree/arch/sh/boards/mach-ap325rxa/setup.c ./arch/sh/boards/mach-ap325rxa/setup.c
--- /home/v4l/tmp/oldtree/arch/sh/boards/mach-ap325rxa/setup.c	2010-05-25 23:56:54.000000000 -0300
+++ ./arch/sh/boards/mach-ap325rxa/setup.c	2010-05-21 11:21:18.000000000 -0300
@@ -159,21 +159,21 @@ static void ap320_wvga_power_on(void *bo
 	msleep(100);
 
 	/* ASD AP-320/325 LCD ON */
-	ctrl_outw(FPGA_LCDREG_VAL, FPGA_LCDREG);
+	__raw_writew(FPGA_LCDREG_VAL, FPGA_LCDREG);
 
 	/* backlight */
 	gpio_set_value(GPIO_PTS3, 0);
-	ctrl_outw(0x100, FPGA_BKLREG);
+	__raw_writew(0x100, FPGA_BKLREG);
 }
 
 static void ap320_wvga_power_off(void *board_data)
 {
 	/* backlight */
-	ctrl_outw(0, FPGA_BKLREG);
+	__raw_writew(0, FPGA_BKLREG);
 	gpio_set_value(GPIO_PTS3, 1);
 
 	/* ASD AP-320/325 LCD OFF */
-	ctrl_outw(0, FPGA_LCDREG);
+	__raw_writew(0, FPGA_LCDREG);
 }
 
 static struct sh_mobile_lcdc_info lcdc_info = {
@@ -420,7 +420,7 @@ static struct resource sdhi0_cn3_resourc
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= 101,
+		.start	= 100,
 		.flags  = IORESOURCE_IRQ,
 	},
 };
@@ -443,7 +443,7 @@ static struct resource sdhi1_cn7_resourc
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= 24,
+		.start	= 23,
 		.flags  = IORESOURCE_IRQ,
 	},
 };
@@ -595,7 +595,7 @@ static int __init ap325rxa_devices_setup
 	gpio_request(GPIO_PTZ4, NULL);
 	gpio_direction_output(GPIO_PTZ4, 0); /* SADDR */
 
-	ctrl_outw(ctrl_inw(PORT_MSELCRB) & ~0x0001, PORT_MSELCRB);
+	__raw_writew(__raw_readw(PORT_MSELCRB) & ~0x0001, PORT_MSELCRB);
 
 	/* FLCTL */
 	gpio_request(GPIO_FN_FCE, NULL);
@@ -613,9 +613,9 @@ static int __init ap325rxa_devices_setup
 	gpio_request(GPIO_FN_FWE, NULL);
 	gpio_request(GPIO_FN_FRB, NULL);
 
-	ctrl_outw(0, PORT_HIZCRC);
-	ctrl_outw(0xFFFF, PORT_DRVCRA);
-	ctrl_outw(0xFFFF, PORT_DRVCRB);
+	__raw_writew(0, PORT_HIZCRC);
+	__raw_writew(0xFFFF, PORT_DRVCRA);
+	__raw_writew(0xFFFF, PORT_DRVCRB);
 
 	platform_resource_setup_memory(&ceu_device, "ceu", 4 << 20);
 
diff -upr /home/v4l/tmp/oldtree/arch/sh/boards/mach-kfr2r09/setup.c ./arch/sh/boards/mach-kfr2r09/setup.c
--- /home/v4l/tmp/oldtree/arch/sh/boards/mach-kfr2r09/setup.c	2010-05-25 23:56:54.000000000 -0300
+++ ./arch/sh/boards/mach-kfr2r09/setup.c	2010-05-21 11:21:18.000000000 -0300
@@ -282,7 +282,7 @@ static int camera_power(struct device *d
 		 * use 1.8 V for VccQ_VIO
 		 * use 2.85V for VccQ_SR
 		 */
-		ctrl_outw((ctrl_inw(DRVCRB) & ~0x0003) | 0x0001, DRVCRB);
+		__raw_writew((__raw_readw(DRVCRB) & ~0x0003) | 0x0001, DRVCRB);
 
 		/* reset clear */
 		ret = gpio_request(GPIO_PTB4, NULL);
@@ -351,7 +351,7 @@ static struct resource kfr2r09_sh_sdhi0_
 		.flags  = IORESOURCE_MEM,
 	},
 	[1] = {
-		.start  = 101,
+		.start  = 100,
 		.flags  = IORESOURCE_IRQ,
 	},
 };
@@ -492,13 +492,13 @@ static int kfr2r09_usb0_gadget_setup(voi
 	if (kfr2r09_usb0_gadget_i2c_setup() != 0)
 		return -ENODEV; /* unable to configure using i2c */
 
-	ctrl_outw((ctrl_inw(PORT_MSELCRB) & ~0xc000) | 0x8000, PORT_MSELCRB);
+	__raw_writew((__raw_readw(PORT_MSELCRB) & ~0xc000) | 0x8000, PORT_MSELCRB);
 	gpio_request(GPIO_FN_PDSTATUS, NULL); /* R-standby disables USB clock */
 	gpio_request(GPIO_PTV6, NULL); /* USBCLK_ON */
 	gpio_direction_output(GPIO_PTV6, 1); /* USBCLK_ON = H */
 	msleep(20); /* wait 20ms to let the clock settle */
 	clk_enable(clk_get(NULL, "usb0"));
-	ctrl_outw(0x0600, 0xa40501d4);
+	__raw_writew(0x0600, 0xa40501d4);
 
 	return 0;
 }
@@ -526,12 +526,12 @@ static int __init kfr2r09_devices_setup(
 	gpio_direction_output(GPIO_PTG3, 1); /* HPON_ON = H */
 
 	/* setup NOR flash at CS0 */
-	ctrl_outl(0x36db0400, BSC_CS0BCR);
-	ctrl_outl(0x00000500, BSC_CS0WCR);
+	__raw_writel(0x36db0400, BSC_CS0BCR);
+	__raw_writel(0x00000500, BSC_CS0WCR);
 
 	/* setup NAND flash at CS4 */
-	ctrl_outl(0x36db0400, BSC_CS4BCR);
-	ctrl_outl(0x00000500, BSC_CS4WCR);
+	__raw_writel(0x36db0400, BSC_CS4BCR);
+	__raw_writel(0x00000500, BSC_CS4WCR);
 
 	/* setup KEYSC pins */
 	gpio_request(GPIO_FN_KEYOUT0, NULL);
diff -upr /home/v4l/tmp/oldtree/arch/sh/boards/mach-migor/setup.c ./arch/sh/boards/mach-migor/setup.c
--- /home/v4l/tmp/oldtree/arch/sh/boards/mach-migor/setup.c	2010-05-25 23:56:54.000000000 -0300
+++ ./arch/sh/boards/mach-migor/setup.c	2010-05-21 11:21:18.000000000 -0300
@@ -397,7 +397,7 @@ static struct resource sdhi_cn9_resource
 		.flags	= IORESOURCE_MEM,
 	},
 	[1] = {
-		.start	= 101,
+		.start	= 100,
 		.flags  = IORESOURCE_IRQ,
 	},
 };
@@ -419,6 +419,9 @@ static struct i2c_board_info migor_i2c_d
 		I2C_BOARD_INFO("migor_ts", 0x51),
 		.irq = 38, /* IRQ6 */
 	},
+	{
+		I2C_BOARD_INFO("wm8978", 0x1a),
+	},
 };
 
 static struct i2c_board_info migor_i2c_camera[] = {
@@ -496,28 +499,16 @@ static int __init migor_devices_setup(vo
 					&migor_sdram_enter_end,
 					&migor_sdram_leave_start,
 					&migor_sdram_leave_end);
-#ifdef CONFIG_PM
 	/* Let D11 LED show STATUS0 */
 	gpio_request(GPIO_FN_STATUS0, NULL);
 
 	/* Lit D12 LED show PDSTATUS */
 	gpio_request(GPIO_FN_PDSTATUS, NULL);
-#else
-	/* Lit D11 LED */
-	gpio_request(GPIO_PTJ7, NULL);
-	gpio_direction_output(GPIO_PTJ7, 1);
-	gpio_export(GPIO_PTJ7, 0);
-
-	/* Lit D12 LED */
-	gpio_request(GPIO_PTJ5, NULL);
-	gpio_direction_output(GPIO_PTJ5, 1);
-	gpio_export(GPIO_PTJ5, 0);
-#endif
 
 	/* SMC91C111 - Enable IRQ0, Setup CS4 for 16-bit fast access */
 	gpio_request(GPIO_FN_IRQ0, NULL);
-	ctrl_outl(0x00003400, BSC_CS4BCR);
-	ctrl_outl(0x00110080, BSC_CS4WCR);
+	__raw_writel(0x00003400, BSC_CS4BCR);
+	__raw_writel(0x00110080, BSC_CS4WCR);
 
 	/* KEYSC */
 	gpio_request(GPIO_FN_KEYOUT0, NULL);
@@ -533,7 +524,7 @@ static int __init migor_devices_setup(vo
 
 	/* NAND Flash */
 	gpio_request(GPIO_FN_CS6A_CE2B, NULL);
-	ctrl_outl((ctrl_inl(BSC_CS6ABCR) & ~0x0600) | 0x0200, BSC_CS6ABCR);
+	__raw_writel((__raw_readl(BSC_CS6ABCR) & ~0x0600) | 0x0200, BSC_CS6ABCR);
 	gpio_request(GPIO_PTA1, NULL);
 	gpio_direction_input(GPIO_PTA1);
 
@@ -627,10 +618,23 @@ static int __init migor_devices_setup(vo
 #else
 	gpio_direction_output(GPIO_PTT0, 1);
 #endif
-	ctrl_outw(ctrl_inw(PORT_MSELCRB) | 0x2000, PORT_MSELCRB); /* D15->D8 */
+	__raw_writew(__raw_readw(PORT_MSELCRB) | 0x2000, PORT_MSELCRB); /* D15->D8 */
 
 	platform_resource_setup_memory(&migor_ceu_device, "ceu", 4 << 20);
 
+	/* SIU: Port B */
+	gpio_request(GPIO_FN_SIUBOLR, NULL);
+	gpio_request(GPIO_FN_SIUBOBT, NULL);
+	gpio_request(GPIO_FN_SIUBISLD, NULL);
+	gpio_request(GPIO_FN_SIUBOSLD, NULL);
+	gpio_request(GPIO_FN_SIUMCKB, NULL);
+
+	/*
+	 * The original driver sets SIUB OLR/OBT, ILR/IBT, and SIUA OLR/OBT to
+	 * output. Need only SIUB, set to output for master mode (table 34.2)
+	 */
+	__raw_writew(__raw_readw(PORT_MSELCRA) | 1, PORT_MSELCRA);
+
 	i2c_register_board_info(0, migor_i2c_devices,
 				ARRAY_SIZE(migor_i2c_devices));
 
diff -upr /home/v4l/tmp/oldtree/Documentation/DocBook/v4l/common.xml ./Documentation/DocBook/v4l/common.xml
--- /home/v4l/tmp/oldtree/Documentation/DocBook/v4l/common.xml	2010-05-25 23:56:57.000000000 -0300
+++ ./Documentation/DocBook/v4l/common.xml	2010-05-21 11:21:17.000000000 -0300
@@ -1170,7 +1170,7 @@ frames per second. If less than this num
 captured or output, applications can request frame skipping or
 duplicating on the driver side. This is especially useful when using
 the &func-read; or &func-write;, which are not augmented by timestamps
-or sequence counters, and to avoid unneccessary data copying.</para>
+or sequence counters, and to avoid unnecessary data copying.</para>
 
     <para>Finally these ioctls can be used to determine the number of
 buffers used internally by a driver in read/write mode. For
diff -upr /home/v4l/tmp/oldtree/Documentation/DocBook/v4l/compat.xml ./Documentation/DocBook/v4l/compat.xml
--- /home/v4l/tmp/oldtree/Documentation/DocBook/v4l/compat.xml	2010-05-25 23:56:57.000000000 -0300
+++ ./Documentation/DocBook/v4l/compat.xml	2010-05-21 11:13:55.000000000 -0300
@@ -2349,9 +2349,9 @@ more information.</para>
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
       <section id="xvideo">
-	<title>X Video Extension</title>
+        <title>X Video Extension</title>
 
-	<para>The X Video Extension (abbreviated XVideo or just Xv) is
+        <para>The X Video Extension (abbreviated XVideo or just Xv) is
 an extension of the X Window system, implemented for example by the
 XFree86 project. Its scope is similar to V4L2, an API to video capture
 and output devices for X clients. Xv allows applications to display
@@ -2362,7 +2362,7 @@ capture or output still images in XPixma
 extension available across many operating systems and
 architectures.</para>
 
-	<para>Because the driver is embedded into the X server Xv has a
+        <para>Because the driver is embedded into the X server Xv has a
 number of advantages over the V4L2 <link linkend="overlay">video
 overlay interface</link>. The driver can easily determine the overlay
 target, &ie; visible graphics memory or off-screen buffers for a
@@ -2371,16 +2371,16 @@ overlay, scaling or color-keying, or the
 video capture hardware, always in sync with drawing operations or
 windows moving or changing their stacking order.</para>
 
-	<para>To combine the advantages of Xv and V4L a special Xv
+        <para>To combine the advantages of Xv and V4L a special Xv
 driver exists in XFree86 and XOrg, just programming any overlay capable
 Video4Linux device it finds. To enable it
 <filename>/etc/X11/XF86Config</filename> must contain these lines:</para>
-	<para><screen>
+        <para><screen>
 Section "Module"
     Load "v4l"
 EndSection</screen></para>
 
-	<para>As of XFree86 4.2 this driver still supports only V4L
+        <para>As of XFree86 4.2 this driver still supports only V4L
 ioctls, however it should work just fine with all V4L2 devices through
 the V4L2 backward-compatibility layer. Since V4L2 permits multiple
 opens it is possible (if supported by the V4L2 driver) to capture
@@ -2388,16 +2388,16 @@ video while an X client requested video 
 simultaneous capturing and overlay are discussed in <xref
 	  linkend="overlay" /> apply.</para>
 
-	<para>Only marginally related to V4L2, XFree86 extended Xv to
+        <para>Only marginally related to V4L2, XFree86 extended Xv to
 support hardware YUV to RGB conversion and scaling for faster video
 playback, and added an interface to MPEG-2 decoding hardware. This API
 is useful to display images captured with V4L2 devices.</para>
       </section>
 
       <section>
-	<title>Digital Video</title>
+        <title>Digital Video</title>
 
-	<para>V4L2 does not support digital terrestrial, cable or
+        <para>V4L2 does not support digital terrestrial, cable or
 satellite broadcast. A separate project aiming at digital receivers
 exists. You can find its homepage at <ulink
 url="http://linuxtv.org">http://linuxtv.org</ulink>. The Linux DVB API
@@ -2406,9 +2406,9 @@ hardware may support both.</para>
       </section>
 
       <section>
-	<title>Audio Interfaces</title>
+        <title>Audio Interfaces</title>
 
-	<para>[to do - OSS/ALSA]</para>
+        <para>[to do - OSS/ALSA]</para>
       </section>
     </section>
 
@@ -2419,36 +2419,36 @@ hardware may support both.</para>
 and may change in the future.</para>
 
       <itemizedlist>
-	<listitem>
+        <listitem>
 	  <para>Video Output Overlay (OSD) Interface, <xref
 	    linkend="osd" />.</para>
-	</listitem>
+        </listitem>
 	<listitem>
 	  <para><constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY</constant>,
 	&v4l2-buf-type;, <xref linkend="v4l2-buf-type" />.</para>
-	</listitem>
-	<listitem>
+        </listitem>
+        <listitem>
 	  <para><constant>V4L2_CAP_VIDEO_OUTPUT_OVERLAY</constant>,
 &VIDIOC-QUERYCAP; ioctl, <xref linkend="device-capabilities" />.</para>
-	</listitem>
-	<listitem>
+        </listitem>
+        <listitem>
 	  <para>&VIDIOC-ENUM-FRAMESIZES; and
 &VIDIOC-ENUM-FRAMEINTERVALS; ioctls.</para>
-	</listitem>
-	<listitem>
+        </listitem>
+        <listitem>
 	  <para>&VIDIOC-G-ENC-INDEX; ioctl.</para>
-	</listitem>
-	<listitem>
+        </listitem>
+        <listitem>
 	  <para>&VIDIOC-ENCODER-CMD; and &VIDIOC-TRY-ENCODER-CMD;
 ioctls.</para>
-	</listitem>
-	<listitem>
+        </listitem>
+        <listitem>
 	  <para>&VIDIOC-DBG-G-REGISTER; and &VIDIOC-DBG-S-REGISTER;
 ioctls.</para>
-	</listitem>
-	<listitem>
+        </listitem>
+        <listitem>
 	  <para>&VIDIOC-DBG-G-CHIP-IDENT; ioctl.</para>
-	</listitem>
+        </listitem>
       </itemizedlist>
     </section>
 
@@ -2459,11 +2459,11 @@ ioctls.</para>
 interfaces and should not be implemented in new drivers.</para>
 
       <itemizedlist>
-	<listitem>
+        <listitem>
 	  <para><constant>VIDIOC_G_MPEGCOMP</constant> and
 <constant>VIDIOC_S_MPEGCOMP</constant> ioctls. Use Extended Controls,
 <xref linkend="extended-controls" />.</para>
-	</listitem>
+        </listitem>
       </itemizedlist>
     </section>
   </section>
diff -upr /home/v4l/tmp/oldtree/Documentation/DocBook/v4l/vidioc-dqevent.xml ./Documentation/DocBook/v4l/vidioc-dqevent.xml
--- /home/v4l/tmp/oldtree/Documentation/DocBook/v4l/vidioc-dqevent.xml	2010-05-25 23:56:57.000000000 -0300
+++ ./Documentation/DocBook/v4l/vidioc-dqevent.xml	2010-05-21 11:13:55.000000000 -0300
@@ -63,40 +63,40 @@
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>type</structfield></entry>
-	    <entry></entry>
+            <entry></entry>
 	    <entry>Type of the event.</entry>
 	  </row>
 	  <row>
 	    <entry>union</entry>
 	    <entry><structfield>u</structfield></entry>
-	    <entry></entry>
+            <entry></entry>
 	    <entry></entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>&v4l2-event-vsync;</entry>
-	    <entry><structfield>vsync</structfield></entry>
+            <entry><structfield>vsync</structfield></entry>
 	    <entry>Event data for event V4L2_EVENT_VSYNC.
-	    </entry>
+            </entry>
 	  </row>
 	  <row>
 	    <entry></entry>
 	    <entry>__u8</entry>
-	    <entry><structfield>data</structfield>[64]</entry>
+            <entry><structfield>data</structfield>[64]</entry>
 	    <entry>Event data. Defined by the event type. The union
-	    should be used to define easily accessible type for
-	    events.</entry>
+            should be used to define easily accessible type for
+            events.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>pending</structfield></entry>
-	    <entry></entry>
+            <entry></entry>
 	    <entry>Number of pending events excluding this one.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>sequence</structfield></entry>
-	    <entry></entry>
+            <entry></entry>
 	    <entry>Event sequence number. The sequence number is
 	    incremented for every subscribed event that takes place.
 	    If sequence numbers are not contiguous it means that
@@ -106,13 +106,13 @@
 	  <row>
 	    <entry>struct timespec</entry>
 	    <entry><structfield>timestamp</structfield></entry>
-	    <entry></entry>
+            <entry></entry>
 	    <entry>Event timestamp.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>reserved</structfield>[9]</entry>
-	    <entry></entry>
+            <entry></entry>
 	    <entry>Reserved for future extensions. Drivers must set
 	    the array to zero.</entry>
 	  </row>
diff -upr /home/v4l/tmp/oldtree/Documentation/DocBook/v4l/vidioc-g-parm.xml ./Documentation/DocBook/v4l/vidioc-g-parm.xml
--- /home/v4l/tmp/oldtree/Documentation/DocBook/v4l/vidioc-g-parm.xml	2010-05-25 23:56:57.000000000 -0300
+++ ./Documentation/DocBook/v4l/vidioc-g-parm.xml	2010-05-21 11:21:17.000000000 -0300
@@ -55,7 +55,7 @@ captured or output, applications can req
 duplicating on the driver side. This is especially useful when using
 the <function>read()</function> or <function>write()</function>, which
 are not augmented by timestamps or sequence counters, and to avoid
-unneccessary data copying.</para>
+unnecessary data copying.</para>
 
     <para>Further these ioctls can be used to determine the number of
 buffers used internally by a driver in read/write mode. For
diff -upr /home/v4l/tmp/oldtree/Documentation/video4linux/CARDLIST.saa7134 ./Documentation/video4linux/CARDLIST.saa7134
--- /home/v4l/tmp/oldtree/Documentation/video4linux/CARDLIST.saa7134	2010-05-25 23:56:57.000000000 -0300
+++ ./Documentation/video4linux/CARDLIST.saa7134	2010-05-21 11:13:56.000000000 -0300
@@ -176,5 +176,5 @@
 175 -> Leadtek Winfast DTV1000S                 [107d:6655]
 176 -> Beholder BeholdTV 505 RDS                [0000:5051]
 177 -> Hawell HW-404M7
-178 -> Beholder BeholdTV H7                     [5ace:7190]
-179 -> Beholder BeholdTV A7                     [5ace:7090]
+179 -> Beholder BeholdTV H7			[5ace:7190]
+180 -> Beholder BeholdTV A7			[5ace:7090]
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/max2165.c ./drivers/media/common/tuners/max2165.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/max2165.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/max2165.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/mc44s803.c ./drivers/media/common/tuners/mc44s803.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/mc44s803.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/mc44s803.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/mt2060.c ./drivers/media/common/tuners/mt2060.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/mt2060.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/mt2060.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/mt20xx.c ./drivers/media/common/tuners/mt20xx.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/mt20xx.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/mt20xx.c	2010-05-21 11:21:19.000000000 -0300
@@ -6,6 +6,7 @@
  */
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include "tuner-i2c.h"
 #include "mt20xx.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/mt2131.c ./drivers/media/common/tuners/mt2131.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/mt2131.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/mt2131.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/mt2266.c ./drivers/media/common/tuners/mt2266.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/mt2266.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/mt2266.c	2010-05-21 11:21:19.000000000 -0300
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "mt2266.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/tda827x.c ./drivers/media/common/tuners/tda827x.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/tda827x.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/tda827x.c	2010-05-21 11:21:19.000000000 -0300
@@ -19,6 +19,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <asm/types.h>
 #include <linux/dvb/frontend.h>
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/tda8290.c ./drivers/media/common/tuners/tda8290.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/tda8290.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/tda8290.c	2010-05-21 11:21:19.000000000 -0300
@@ -21,6 +21,7 @@
 */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include "tuner-i2c.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/tda9887.c ./drivers/media/common/tuners/tda9887.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/tda9887.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/tda9887.c	2010-05-21 11:21:19.000000000 -0300
@@ -4,7 +4,6 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/errno.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/tea5761.c ./drivers/media/common/tuners/tea5761.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/tea5761.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/tea5761.c	2010-05-21 11:21:19.000000000 -0300
@@ -8,6 +8,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/tea5767.c ./drivers/media/common/tuners/tea5767.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/tea5767.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/tea5767.c	2010-05-21 11:21:19.000000000 -0300
@@ -11,6 +11,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include "tuner-i2c.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/tuner-i2c.h ./drivers/media/common/tuners/tuner-i2c.h
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/tuner-i2c.h	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/tuner-i2c.h	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #define __TUNER_I2C_H__
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 struct tuner_i2c_props {
 	u8 addr;
diff -upr /home/v4l/tmp/oldtree/drivers/media/common/tuners/tuner-xc2028.c ./drivers/media/common/tuners/tuner-xc2028.c
--- /home/v4l/tmp/oldtree/drivers/media/common/tuners/tuner-xc2028.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/common/tuners/tuner-xc2028.c	2010-05-21 11:21:19.000000000 -0300
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <media/tuner.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <asm/unaligned.h>
 #include "tuner-i2c.h"
 #include "tuner-xc2028.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/bt8xx/dst_ca.c ./drivers/media/dvb/bt8xx/dst_ca.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/bt8xx/dst_ca.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/bt8xx/dst_ca.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/dm1105/dm1105.c ./drivers/media/dvb/dm1105/dm1105.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/dm1105/dm1105.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/dm1105/dm1105.c	2010-05-21 11:21:19.000000000 -0300
@@ -27,6 +27,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/input.h>
+#include <linux/slab.h>
 #include <media/ir-core.h>
 
 #include "demux.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-core/dmxdev.h ./drivers/media/dvb/dvb-core/dmxdev.h
--- /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-core/dmxdev.h	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/dvb-core/dmxdev.h	2010-05-21 11:21:19.000000000 -0300
@@ -31,6 +31,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <linux/dvb/dmx.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-core/dvb_frontend.h ./drivers/media/dvb/dvb-core/dvb_frontend.h
--- /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-core/dvb_frontend.h	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/dvb-core/dvb_frontend.h	2010-05-21 11:21:19.000000000 -0300
@@ -36,6 +36,7 @@
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <linux/dvb/frontend.h>
 
@@ -214,14 +215,14 @@ struct dvb_tuner_ops {
 	int (*get_status)(struct dvb_frontend *fe, u32 *status);
 	int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);
 
-	/** These are provided seperately from set_params in order to facilitate silicon
-	 * tuners which require sophisticated tuning loops, controlling each parameter seperately. */
+	/** These are provided separately from set_params in order to facilitate silicon
+	 * tuners which require sophisticated tuning loops, controlling each parameter separately. */
 	int (*set_frequency)(struct dvb_frontend *fe, u32 frequency);
 	int (*set_bandwidth)(struct dvb_frontend *fe, u32 bandwidth);
 
 	/*
-	 * These are provided seperately from set_params in order to facilitate silicon
-	 * tuners which require sophisticated tuning loops, controlling each parameter seperately.
+	 * These are provided separately from set_params in order to facilitate silicon
+	 * tuners which require sophisticated tuning loops, controlling each parameter separately.
 	 */
 	int (*set_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
 	int (*get_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-core/dvb_net.c ./drivers/media/dvb/dvb-core/dvb_net.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-core/dvb_net.c	2010-05-25 23:56:58.000000000 -0300
+++ ./drivers/media/dvb/dvb-core/dvb_net.c	2010-05-21 11:21:19.000000000 -0300
@@ -504,6 +504,7 @@ static void dvb_net_ule( struct net_devi
 				       "bytes left in TS.  Resyncing.\n", ts_remain);
 				priv->ule_sndu_len = 0;
 				priv->need_pusi = 1;
+				ts += TS_SZ;
 				continue;
 			}
 
@@ -949,11 +950,8 @@ static int dvb_net_filter_sec_set(struct
 	(*secfilter)->filter_mask[10] = mac_mask[1];
 	(*secfilter)->filter_mask[11]=mac_mask[0];
 
-	dprintk("%s: filter mac=%02x %02x %02x %02x %02x %02x\n",
-	       dev->name, mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
-	dprintk("%s: filter mask=%02x %02x %02x %02x %02x %02x\n",
-	       dev->name, mac_mask[0], mac_mask[1], mac_mask[2],
-	       mac_mask[3], mac_mask[4], mac_mask[5]);
+	dprintk("%s: filter mac=%pM\n", dev->name, mac);
+	dprintk("%s: filter mask=%pM\n", dev->name, mac_mask);
 
 	return 0;
 }
@@ -1141,18 +1139,18 @@ static void wq_set_multicast_list (struc
 	} else if ((dev->flags & IFF_ALLMULTI)) {
 		dprintk("%s: allmulti mode\n", dev->name);
 		priv->rx_mode = RX_MODE_ALL_MULTI;
-	} else if (dev->mc_count) {
+	} else if (!netdev_mc_empty(dev)) {
 		int mci;
 		struct dev_mc_list *mc;
 
 		dprintk("%s: set_mc_list, %d entries\n",
-			dev->name, dev->mc_count);
+			dev->name, netdev_mc_count(dev));
 
 		priv->rx_mode = RX_MODE_MULTI;
 		priv->multi_num = 0;
 
 		for (mci = 0, mc=dev->mc_list;
-		     mci < dev->mc_count;
+		     mci < netdev_mc_count(dev);
 		     mc = mc->next, mci++) {
 			dvb_set_mc_filter(dev, mc);
 		}
@@ -1239,7 +1237,6 @@ static void dvb_net_setup(struct net_dev
 	dev->header_ops		= &dvb_header_ops;
 	dev->netdev_ops		= &dvb_netdev_ops;
 	dev->mtu		= 4096;
-	dev->mc_count           = 0;
 
 	dev->flags |= IFF_NOARP;
 }
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-usb/af9015.c ./drivers/media/dvb/dvb-usb/af9015.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-usb/af9015.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/dvb-usb/af9015.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
  */
 
 #include <linux/hash.h>
+#include <linux/slab.h>
 
 #include "af9015.h"
 #include "af9013.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-usb/cxusb.c ./drivers/media/dvb/dvb-usb/cxusb.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-usb/cxusb.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/dvb-usb/cxusb.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,6 +25,7 @@
  */
 #include <media/tuner.h>
 #include <linux/vmalloc.h>
+#include <linux/slab.h>
 
 #include "cxusb.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-usb/dvb-usb-remote.c ./drivers/media/dvb/dvb-usb/dvb-usb-remote.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/dvb-usb/dvb-usb-remote.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/dvb-usb/dvb-usb-remote.c	2010-05-21 11:21:19.000000000 -0300
@@ -9,7 +9,7 @@
 #include <linux/usb/input.h>
 
 static int dvb_usb_getkeycode(struct input_dev *dev,
-				    int scancode, int *keycode)
+				unsigned int scancode, unsigned int *keycode)
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
 
@@ -39,7 +39,7 @@ static int dvb_usb_getkeycode(struct inp
 }
 
 static int dvb_usb_setkeycode(struct input_dev *dev,
-				    int scancode, int keycode)
+				unsigned int scancode, unsigned int keycode)
 {
 	struct dvb_usb_device *d = input_get_drvdata(dev);
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/firewire/firedtv-1394.c ./drivers/media/dvb/firewire/firedtv-1394.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/firewire/firedtv-1394.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/firewire/firedtv-1394.c	2010-05-21 11:21:19.000000000 -0300
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/firewire/firedtv-fw.c ./drivers/media/dvb/firewire/firedtv-fw.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/firewire/firedtv-fw.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/firewire/firedtv-fw.c	2010-05-21 11:21:19.000000000 -0300
@@ -239,47 +239,18 @@ static const struct fw_address_region fc
 };
 
 /* Adjust the template string if models with longer names appear. */
-#define MAX_MODEL_NAME_LEN ((int)DIV_ROUND_UP(sizeof("FireDTV ????"), 4))
-
-static size_t model_name(u32 *directory, __be32 *buffer)
-{
-	struct fw_csr_iterator ci;
-	int i, length, key, value, last_key = 0;
-	u32 *block = NULL;
-
-	fw_csr_iterator_init(&ci, directory);
-	while (fw_csr_iterator_next(&ci, &key, &value)) {
-		if (last_key == CSR_MODEL &&
-		    key == (CSR_DESCRIPTOR | CSR_LEAF))
-			block = ci.p - 1 + value;
-		last_key = key;
-	}
-
-	if (block == NULL)
-		return 0;
-
-	length = min((int)(block[0] >> 16) - 2, MAX_MODEL_NAME_LEN);
-	if (length <= 0)
-		return 0;
-
-	/* fast-forward to text string */
-	block += 3;
-
-	for (i = 0; i < length; i++)
-		buffer[i] = cpu_to_be32(block[i]);
-
-	return length * 4;
-}
+#define MAX_MODEL_NAME_LEN sizeof("FireDTV ????")
 
 static int node_probe(struct device *dev)
 {
 	struct firedtv *fdtv;
-	__be32 name[MAX_MODEL_NAME_LEN];
+	char name[MAX_MODEL_NAME_LEN];
 	int name_len, err;
 
-	name_len = model_name(fw_unit(dev)->directory, name);
+	name_len = fw_csr_string(fw_unit(dev)->directory, CSR_MODEL,
+				 name, sizeof(name));
 
-	fdtv = fdtv_alloc(dev, &backend, (char *)name, name_len);
+	fdtv = fdtv_alloc(dev, &backend, name, name_len >= 0 ? name_len : 0);
 	if (!fdtv)
 		return -ENOMEM;
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/firewire/firedtv-rc.c ./drivers/media/dvb/firewire/firedtv-rc.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/firewire/firedtv-rc.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/firewire/firedtv-rc.c	2010-05-21 11:21:19.000000000 -0300
@@ -12,6 +12,7 @@
 #include <linux/bitops.h>
 #include <linux/input.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/au8522_dig.c ./drivers/media/dvb/frontends/au8522_dig.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/au8522_dig.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/au8522_dig.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,7 +23,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
 #include "dvb_frontend.h"
 #include "au8522.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib0070.c ./drivers/media/dvb/frontends/dib0070.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib0070.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/dib0070.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,6 +25,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 
 #include "dvb_frontend.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib0090.c ./drivers/media/dvb/frontends/dib0090.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib0090.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/dib0090.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,6 +25,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 
 #include "dvb_frontend.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib3000mc.c ./drivers/media/dvb/frontends/dib3000mc.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib3000mc.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/dib3000mc.c	2010-05-21 11:21:19.000000000 -0300
@@ -12,6 +12,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 
 #include "dvb_frontend.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib7000m.c ./drivers/media/dvb/frontends/dib7000m.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib7000m.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/dib7000m.c	2010-05-21 11:21:19.000000000 -0300
@@ -9,6 +9,7 @@
  *	published by the Free Software Foundation, version 2.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 
 #include "dvb_frontend.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib7000p.c ./drivers/media/dvb/frontends/dib7000p.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib7000p.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/dib7000p.c	2010-05-21 11:21:19.000000000 -0300
@@ -8,6 +8,7 @@
  *	published by the Free Software Foundation, version 2.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 
 #include "dvb_math.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib8000.c ./drivers/media/dvb/frontends/dib8000.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dib8000.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/dib8000.c	2010-05-21 11:21:19.000000000 -0300
@@ -8,6 +8,7 @@
  *  published by the Free Software Foundation, version 2.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include "dvb_math.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/drx397xD.c ./drivers/media/dvb/frontends/drx397xD.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/drx397xD.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/drx397xD.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/firmware.h>
+#include <linux/slab.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dvb-pll.c ./drivers/media/dvb/frontends/dvb-pll.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/dvb-pll.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/dvb-pll.c	2010-05-21 11:21:19.000000000 -0300
@@ -18,6 +18,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/itd1000.c ./drivers/media/dvb/frontends/itd1000.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/itd1000.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/itd1000.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/lgdt3304.c ./drivers/media/dvb/frontends/lgdt3304.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/lgdt3304.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/lgdt3304.c	2010-05-21 11:21:19.000000000 -0300
@@ -7,6 +7,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include "dvb_frontend.h"
 #include "lgdt3304.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/lgdt3305.c ./drivers/media/dvb/frontends/lgdt3305.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/lgdt3305.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/lgdt3305.c	2010-05-21 11:21:19.000000000 -0300
@@ -21,6 +21,7 @@
 
 #include <asm/div64.h>
 #include <linux/dvb/frontend.h>
+#include <linux/slab.h>
 #include "dvb_math.h"
 #include "lgdt3305.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/mb86a16.c ./drivers/media/dvb/frontends/mb86a16.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/mb86a16.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/mb86a16.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "mb86a16.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/s921_module.c ./drivers/media/dvb/frontends/s921_module.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/s921_module.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/s921_module.c	2010-05-21 11:21:19.000000000 -0300
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include "dvb_frontend.h"
 #include "s921_module.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stb0899_drv.c ./drivers/media/dvb/frontends/stb0899_drv.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stb0899_drv.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/stb0899_drv.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
 #include <linux/dvb/frontend.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stb6000.c ./drivers/media/dvb/frontends/stb6000.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stb6000.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/stb6000.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
 
   */
 
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stb6100.c ./drivers/media/dvb/frontends/stb6100.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stb6100.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/stb6100.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
 #include "dvb_frontend.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stv090x.c ./drivers/media/dvb/frontends/stv090x.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stv090x.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/stv090x.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/mutex.h>
 
 #include <linux/dvb/frontend.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stv6110.c ./drivers/media/dvb/frontends/stv6110.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stv6110.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/stv6110.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stv6110x.c ./drivers/media/dvb/frontends/stv6110x.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/stv6110x.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/stv6110x.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
 #include "dvb_frontend.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/tda665x.c ./drivers/media/dvb/frontends/tda665x.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/tda665x.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/tda665x.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "tda665x.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/tda8261.c ./drivers/media/dvb/frontends/tda8261.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/tda8261.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/tda8261.c	2010-05-21 11:21:19.000000000 -0300
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "tda8261.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/tda826x.c ./drivers/media/dvb/frontends/tda826x.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/tda826x.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/tda826x.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
 
   */
 
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/tua6100.c ./drivers/media/dvb/frontends/tua6100.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/tua6100.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/tua6100.c	2010-05-21 11:21:19.000000000 -0300
@@ -28,6 +28,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/zl10036.c ./drivers/media/dvb/frontends/zl10036.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/frontends/zl10036.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/frontends/zl10036.c	2010-05-21 11:21:19.000000000 -0300
@@ -29,6 +29,7 @@
 
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 
 #include "zl10036.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/mantis/hopper_cards.c ./drivers/media/dvb/mantis/hopper_cards.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/mantis/hopper_cards.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/mantis/hopper_cards.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/slab.h>
 #include <asm/irq.h>
 #include <linux/interrupt.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/mantis/mantis_ca.c ./drivers/media/dvb/mantis/mantis_ca.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/mantis/mantis_ca.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/mantis/mantis_ca.c	2010-05-21 11:21:19.000000000 -0300
@@ -19,6 +19,7 @@
 */
 
 #include <linux/signal.h>
+#include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/mantis/mantis_cards.c ./drivers/media/dvb/mantis/mantis_cards.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/mantis/mantis_cards.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/mantis/mantis_cards.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/slab.h>
 #include <asm/irq.h>
 #include <linux/interrupt.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/ngene/Makefile ./drivers/media/dvb/ngene/Makefile
--- /home/v4l/tmp/oldtree/drivers/media/dvb/ngene/Makefile	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/ngene/Makefile	2010-05-21 11:14:04.000000000 -0300
@@ -2,8 +2,7 @@
 # Makefile for the nGene device driver
 #
 
-ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-av.o \
-	ngene-eeprom.o ngene-dvb.o
+ngene-objs := ngene-core.o ngene-i2c.o ngene-cards.o ngene-dvb.o
 
 obj-$(CONFIG_DVB_NGENE) += ngene.o
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/ngene/ngene-core.c ./drivers/media/dvb/ngene/ngene-core.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/ngene/ngene-core.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/ngene/ngene-core.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-#include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/io.h>
 #include <asm/div64.h>
@@ -47,6 +46,7 @@ static int one_adapter = 1;
 module_param(one_adapter, int, 0444);
 MODULE_PARM_DESC(one_adapter, "Use only one adapter.");
 
+
 static int debug;
 module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "Print debugging information.");
@@ -1365,6 +1365,9 @@ fail:
 	return stat;
 }
 
+
+
+
 /****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/ngene/ngene.h ./drivers/media/dvb/ngene/ngene.h
--- /home/v4l/tmp/oldtree/drivers/media/dvb/ngene/ngene.h	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/ngene/ngene.h	2010-05-21 11:14:04.000000000 -0300
@@ -883,8 +883,6 @@ int my_dvb_dmxdev_ts_card_init(struct dm
 			       struct dmx_frontend *mem_frontend,
 			       struct dvb_adapter *dvb_adapter);
 
-/* Provided by ngene-eeprom.c */
-
 #endif
 
 /*  LocalWords:  Endif
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/pluto2/pluto2.c ./drivers/media/dvb/pluto2/pluto2.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/pluto2/pluto2.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/pluto2/pluto2.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
+#include <linux/slab.h>
 
 #include "demux.h"
 #include "dmxdev.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/pt1/pt1.c ./drivers/media/dvb/pt1/pt1.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/pt1/pt1.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/pt1/pt1.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/pci.h>
 #include <linux/kthread.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/siano/smscoreapi.c ./drivers/media/dvb/siano/smscoreapi.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/siano/smscoreapi.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/siano/smscoreapi.c	2010-05-21 11:21:19.000000000 -0300
@@ -28,6 +28,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #include <linux/firmware.h>
 #include <linux/wait.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/siano/smsdvb.c ./drivers/media/dvb/siano/smsdvb.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/siano/smsdvb.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/siano/smsdvb.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@ along with this program.  If not, see <h
 ****************************************************************/
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 
 #include "dmxdev.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/siano/smssdio.c ./drivers/media/dvb/siano/smssdio.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/siano/smssdio.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/siano/smssdio.c	2010-05-21 11:21:19.000000000 -0300
@@ -33,6 +33,7 @@
  */
 
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 #include <linux/firmware.h>
 #include <linux/delay.h>
 #include <linux/mmc/card.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/siano/smsusb.c ./drivers/media/dvb/siano/smsusb.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/siano/smsusb.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/siano/smsusb.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@ along with this program.  If not, see <h
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/firmware.h>
+#include <linux/slab.h>
 
 #include "smscoreapi.h"
 #include "sms-cards.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/ttpci/av7110.c ./drivers/media/dvb/ttpci/av7110.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/ttpci/av7110.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/ttpci/av7110.c	2010-05-21 11:21:19.000000000 -0300
@@ -49,6 +49,7 @@
 #include <linux/crc32.h>
 #include <linux/i2c.h>
 #include <linux/kthread.h>
+#include <linux/slab.h>
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/dvb/ttpci/av7110_ca.c ./drivers/media/dvb/ttpci/av7110_ca.c
--- /home/v4l/tmp/oldtree/drivers/media/dvb/ttpci/av7110_ca.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/dvb/ttpci/av7110_ca.c	2010-05-21 11:21:19.000000000 -0300
@@ -34,6 +34,7 @@
 #include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/poll.h>
+#include <linux/gfp.h>
 
 #include "av7110.h"
 #include "av7110_hw.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/IR/ir-core-priv.h ./drivers/media/IR/ir-core-priv.h
--- /home/v4l/tmp/oldtree/drivers/media/IR/ir-core-priv.h	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/IR/ir-core-priv.h	2010-05-21 11:21:19.000000000 -0300
@@ -16,6 +16,7 @@
 #ifndef _IR_RAW_EVENT
 #define _IR_RAW_EVENT
 
+#include <linux/slab.h>
 #include <media/ir-core.h>
 
 struct ir_raw_handler {
diff -upr /home/v4l/tmp/oldtree/drivers/media/IR/ir-keytable.c ./drivers/media/IR/ir-keytable.c
--- /home/v4l/tmp/oldtree/drivers/media/IR/ir-keytable.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/IR/ir-keytable.c	2010-05-21 11:21:19.000000000 -0300
@@ -14,6 +14,7 @@
 
 
 #include <linux/input.h>
+#include <linux/slab.h>
 #include "ir-core-priv.h"
 
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
@@ -85,7 +86,7 @@ static int ir_resize_table(struct ir_sca
  */
 static int ir_do_setkeycode(struct input_dev *dev,
 			    struct ir_scancode_table *rc_tab,
-			    int scancode, int keycode,
+			    unsigned scancode, unsigned keycode,
 			    bool resize)
 {
 	unsigned int i;
@@ -170,7 +171,7 @@ static int ir_do_setkeycode(struct input
  * This routine is used to handle evdev EVIOCSKEY ioctl.
  */
 static int ir_setkeycode(struct input_dev *dev,
-			 int scancode, int keycode)
+			 unsigned int scancode, unsigned int keycode)
 {
 	int rc;
 	unsigned long flags;
@@ -223,7 +224,7 @@ static int ir_setkeytable(struct input_d
  * This routine is used to handle evdev EVIOCGKEY ioctl.
  */
 static int ir_getkeycode(struct input_dev *dev,
-			 int scancode, int *keycode)
+			 unsigned int scancode, unsigned int *keycode)
 {
 	int start, end, mid;
 	unsigned long flags;
diff -upr /home/v4l/tmp/oldtree/drivers/media/IR/ir-sysfs.c ./drivers/media/IR/ir-sysfs.c
--- /home/v4l/tmp/oldtree/drivers/media/IR/ir-sysfs.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/IR/ir-sysfs.c	2010-05-21 11:21:19.000000000 -0300
@@ -12,6 +12,7 @@
  *  GNU General Public License for more details.
  */
 
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/device.h>
 #include "ir-core-priv.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/radio-gemtek-pci.c ./drivers/media/radio/radio-gemtek-pci.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/radio-gemtek-pci.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/radio-gemtek-pci.c	2010-05-21 11:21:19.000000000 -0300
@@ -48,6 +48,7 @@
 #include <linux/errno.h>
 #include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/radio-maestro.c ./drivers/media/radio/radio-maestro.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/radio-maestro.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/radio-maestro.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/radio-maxiradio.c ./drivers/media/radio/radio-maxiradio.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/radio-maxiradio.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/radio-maxiradio.c	2010-05-21 11:21:19.000000000 -0300
@@ -42,6 +42,7 @@
 #include <linux/videodev2.h>
 #include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/radio-si4713.c ./drivers/media/radio/radio-si4713.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/radio-si4713.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/radio-si4713.c	2010-05-21 11:21:19.000000000 -0300
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/radio-tea5764.c ./drivers/media/radio/radio-tea5764.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/radio-tea5764.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/radio-tea5764.c	2010-05-21 11:21:19.000000000 -0300
@@ -32,6 +32,7 @@
  *  add RDS support
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>			/* Initdata			*/
 #include <linux/videodev2.h>		/* kernel radio structs		*/
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/radio-timb.c ./drivers/media/radio/radio-timb.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/radio-timb.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/radio-timb.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #include <media/v4l2-device.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <media/timb_radio.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/saa7706h.c ./drivers/media/radio/saa7706h.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/saa7706h.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/saa7706h.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/si470x/radio-si470x-i2c.c ./drivers/media/radio/si470x/radio-si470x-i2c.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/si470x/radio-si470x-i2c.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/si470x/radio-si470x-i2c.c	2010-05-21 11:21:19.000000000 -0300
@@ -31,6 +31,7 @@
 
 /* kernel includes */
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/si470x/radio-si470x-usb.c ./drivers/media/radio/si470x/radio-si470x-usb.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/si470x/radio-si470x-usb.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/si470x/radio-si470x-usb.c	2010-05-21 11:21:19.000000000 -0300
@@ -37,6 +37,7 @@
 /* kernel includes */
 #include <linux/usb.h>
 #include <linux/hid.h>
+#include <linux/slab.h>
 
 #include "radio-si470x.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/si4713-i2c.c ./drivers/media/radio/si4713-i2c.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/si4713-i2c.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/si4713-i2c.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/radio/tef6862.c ./drivers/media/radio/tef6862.c
--- /home/v4l/tmp/oldtree/drivers/media/radio/tef6862.c	2010-05-25 23:56:57.000000000 -0300
+++ ./drivers/media/radio/tef6862.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/adv7170.c ./drivers/media/video/adv7170.c
--- /home/v4l/tmp/oldtree/drivers/media/video/adv7170.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/adv7170.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/adv7175.c ./drivers/media/video/adv7175.c
--- /home/v4l/tmp/oldtree/drivers/media/video/adv7175.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/adv7175.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/adv7180.c ./drivers/media/video/adv7180.c
--- /home/v4l/tmp/oldtree/drivers/media/video/adv7180.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/adv7180.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/adv7343.c ./drivers/media/video/adv7343.c
--- /home/v4l/tmp/oldtree/drivers/media/video/adv7343.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/adv7343.c	2010-05-21 11:21:19.000000000 -0300
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/device.h>
 #include <linux/delay.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/au0828/au0828-core.c ./drivers/media/video/au0828/au0828-core.c
--- /home/v4l/tmp/oldtree/drivers/media/video/au0828/au0828-core.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/au0828/au0828-core.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/au0828/au0828-dvb.c ./drivers/media/video/au0828/au0828-dvb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/au0828/au0828-dvb.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/au0828/au0828-dvb.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/au0828/au0828-video.c ./drivers/media/video/au0828/au0828-video.c
--- /home/v4l/tmp/oldtree/drivers/media/video/au0828/au0828-video.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/au0828/au0828-video.c	2010-05-21 11:21:19.000000000 -0300
@@ -29,6 +29,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/bt819.c ./drivers/media/video/bt819.c
--- /home/v4l/tmp/oldtree/drivers/media/video/bt819.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/bt819.c	2010-05-21 11:21:19.000000000 -0300
@@ -35,6 +35,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/bt856.c ./drivers/media/video/bt856.c
--- /home/v4l/tmp/oldtree/drivers/media/video/bt856.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/bt856.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/bt866.c ./drivers/media/video/bt866.c
--- /home/v4l/tmp/oldtree/drivers/media/video/bt866.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/bt866.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-cards.c ./drivers/media/video/bt8xx/bttv-cards.c
--- /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-cards.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/bt8xx/bttv-cards.c	2010-05-21 11:21:19.000000000 -0300
@@ -4408,7 +4408,7 @@ static void rv605_muxsel(struct bttv *bt
 /* Tibet Systems 'Progress DVR' CS16 muxsel helper [Chris Fanning]
  *
  * The CS16 (available on eBay cheap) is a PCI board with four Fusion
- * 878A chips, a PCI bridge, an Atmel microcontroller, four sync seperator
+ * 878A chips, a PCI bridge, an Atmel microcontroller, four sync separator
  * chips, ten eight input analog multiplexors, a not chip and a few
  * other components.
  *
@@ -4430,7 +4430,7 @@ static void rv605_muxsel(struct bttv *bt
  *
  * There is an ATMEL microcontroller with an 8031 core on board.  I have not
  * determined what function (if any) it provides.  With the microcontroller
- * and sync seperator chips a guess is that it might have to do with video
+ * and sync separator chips a guess is that it might have to do with video
  * switching and maybe some digital I/O.
  */
 static void tibetCS16_muxsel(struct bttv *btv, unsigned int input)
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-driver.c ./drivers/media/video/bt8xx/bttv-driver.c
--- /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-driver.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/bt8xx/bttv-driver.c	2010-05-21 11:21:19.000000000 -0300
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-gpio.c ./drivers/media/video/bt8xx/bttv-gpio.c
--- /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-gpio.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/bt8xx/bttv-gpio.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 #include <asm/io.h>
 
 #include "bttvp.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-input.c ./drivers/media/video/bt8xx/bttv-input.c
--- /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-input.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/bt8xx/bttv-input.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
+#include <linux/slab.h>
 
 #include "bttv.h"
 #include "bttvp.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-risc.c ./drivers/media/video/bt8xx/bttv-risc.c
--- /home/v4l/tmp/oldtree/drivers/media/video/bt8xx/bttv-risc.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/bt8xx/bttv-risc.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cafe_ccic.c ./drivers/media/video/cafe_ccic.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cafe_ccic.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/cafe_ccic.c	2010-05-21 11:21:19.000000000 -0300
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cpia_pp.c ./drivers/media/video/cpia_pp.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cpia_pp.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/cpia_pp.c	2010-05-21 11:21:19.000000000 -0300
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <linux/kmod.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cs5345.c ./drivers/media/video/cs5345.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cs5345.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/cs5345.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cs53l32a.c ./drivers/media/video/cs53l32a.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cs53l32a.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/cs53l32a.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx18/cx18-alsa-main.c ./drivers/media/video/cx18/cx18-alsa-main.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx18/cx18-alsa-main.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/cx18/cx18-alsa-main.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx18/cx18-controls.c ./drivers/media/video/cx18/cx18-controls.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx18/cx18-controls.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/cx18/cx18-controls.c	2010-05-21 11:21:19.000000000 -0300
@@ -21,6 +21,7 @@
  *  02111-1307  USA
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 
 #include "cx18-driver.h"
 #include "cx18-cards.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx18/cx18-driver.h ./drivers/media/video/cx18/cx18-driver.h
--- /home/v4l/tmp/oldtree/drivers/media/video/cx18/cx18-driver.h	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/cx18/cx18-driver.h	2010-05-21 11:21:19.000000000 -0300
@@ -42,6 +42,7 @@
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <asm/byteorder.h>
 
 #include <linux/dvb/video.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-cards.c ./drivers/media/video/cx231xx/cx231xx-cards.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-cards.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx231xx/cx231xx-cards.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/usb.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-core.c ./drivers/media/video/cx231xx/cx231xx-core.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-core.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx231xx/cx231xx-core.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
 #include <media/v4l2-common.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-dvb.c ./drivers/media/video/cx231xx/cx231xx-dvb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-dvb.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx231xx/cx231xx-dvb.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 
 #include "cx231xx.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx.h ./drivers/media/video/cx231xx/cx231xx.h
--- /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx.h	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx231xx/cx231xx.h	2010-05-21 11:14:04.000000000 -0300
@@ -27,7 +27,6 @@
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
-#include <media/ir-kbd-i2c.h>
 #include <linux/mutex.h>
 
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-input.c ./drivers/media/video/cx231xx/cx231xx-input.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-input.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx231xx/cx231xx-input.c	2010-05-21 11:21:19.000000000 -0300
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 
 #include "cx231xx.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-vbi.c ./drivers/media/video/cx231xx/cx231xx-vbi.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-vbi.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx231xx/cx231xx-vbi.c	2010-05-21 11:21:19.000000000 -0300
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-video.c ./drivers/media/video/cx231xx/cx231xx-video.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx231xx/cx231xx-video.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx231xx/cx231xx-video.c	2010-05-21 11:21:19.000000000 -0300
@@ -32,6 +32,7 @@
 #include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23885-417.c ./drivers/media/video/cx23885/cx23885-417.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23885-417.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx23885/cx23885-417.c	2010-05-21 11:21:19.000000000 -0300
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/smp_lock.h>
+#include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/cx2341x.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23885.h ./drivers/media/video/cx23885/cx23885.h
--- /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23885.h	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx23885/cx23885.h	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
 #include <linux/kdev_t.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-device.h>
 #include <media/tuner.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23885-input.c ./drivers/media/video/cx23885/cx23885-input.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23885-input.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx23885/cx23885-input.c	2010-05-21 11:21:19.000000000 -0300
@@ -36,6 +36,7 @@
  */
 
 #include <linux/input.h>
+#include <linux/slab.h>
 #include <media/ir-common.h>
 #include <media/v4l2-subdev.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23885-vbi.c ./drivers/media/video/cx23885/cx23885-vbi.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23885-vbi.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx23885/cx23885-vbi.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
-#include <linux/slab.h>
 
 #include "cx23885.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23888-ir.c ./drivers/media/video/cx23885/cx23888-ir.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx23885/cx23888-ir.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx23885/cx23888-ir.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
  */
 
 #include <linux/kfifo.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-alsa.c ./drivers/media/video/cx88/cx88-alsa.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-alsa.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-alsa.c	2010-05-21 11:21:19.000000000 -0300
@@ -31,6 +31,7 @@
 #include <linux/vmalloc.h>
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
+#include <linux/slab.h>
 
 #include <asm/delay.h>
 #include <sound/core.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-blackbird.c ./drivers/media/video/cx88/cx88-blackbird.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-blackbird.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-blackbird.c	2010-05-21 11:21:19.000000000 -0300
@@ -28,6 +28,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
 #include <linux/device.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-cards.c ./drivers/media/video/cx88/cx88-cards.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-cards.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-cards.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 #include "cx88.h"
 #include "tea5767.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-dsp.c ./drivers/media/video/cx88/cx88-dsp.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-dsp.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-dsp.c	2010-05-21 11:21:19.000000000 -0300
@@ -19,6 +19,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-input.c ./drivers/media/video/cx88/cx88-input.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-input.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-input.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
 #include <linux/hrtimer.h>
 #include <linux/input.h>
 #include <linux/pci.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 
 #include "cx88.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-mpeg.c ./drivers/media/video/cx88/cx88-mpeg.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-mpeg.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-mpeg.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-tvaudio.c ./drivers/media/video/cx88/cx88-tvaudio.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-tvaudio.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-tvaudio.c	2010-05-21 11:21:19.000000000 -0300
@@ -39,7 +39,6 @@
 #include <linux/errno.h>
 #include <linux/freezer.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/poll.h>
 #include <linux/signal.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-vbi.c ./drivers/media/video/cx88/cx88-vbi.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-vbi.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-vbi.c	2010-05-21 11:21:19.000000000 -0300
@@ -3,7 +3,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/slab.h>
 
 #include "cx88.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-vp3054-i2c.c ./drivers/media/video/cx88/cx88-vp3054-i2c.c
--- /home/v4l/tmp/oldtree/drivers/media/video/cx88/cx88-vp3054-i2c.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/cx88/cx88-vp3054-i2c.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 
 #include <asm/io.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/dabusb.c ./drivers/media/video/dabusb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/dabusb.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/dabusb.c	2010-05-21 11:21:19.000000000 -0300
@@ -616,10 +616,12 @@ static int dabusb_open (struct inode *in
 {
 	int devnum = iminor(inode);
 	pdabusb_t s;
+	int r;
 
 	if (devnum < DABUSB_MINOR || devnum >= (DABUSB_MINOR + NRDABUSB))
 		return -EIO;
 
+	lock_kernel();
 	s = &dabusb[devnum - DABUSB_MINOR];
 
 	dbg("dabusb_open");
@@ -634,6 +636,7 @@ static int dabusb_open (struct inode *in
 		msleep_interruptible(500);
 
 		if (signal_pending (current)) {
+			unlock_kernel();
 			return -EAGAIN;
 		}
 		mutex_lock(&s->mutex);
@@ -641,6 +644,7 @@ static int dabusb_open (struct inode *in
 	if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
 		mutex_unlock(&s->mutex);
 		dev_err(&s->usbdev->dev, "set_interface failed\n");
+		unlock_kernel();
 		return -EINVAL;
 	}
 	s->opened = 1;
@@ -649,7 +653,9 @@ static int dabusb_open (struct inode *in
 	file->f_pos = 0;
 	file->private_data = s;
 
-	return nonseekable_open(inode, file);
+	r = nonseekable_open(inode, file);
+	unlock_kernel();
+	return r;
 }
 
 static int dabusb_release (struct inode *inode, struct file *file)
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/davinci/dm644x_ccdc.c ./drivers/media/video/davinci/dm644x_ccdc.c
--- /home/v4l/tmp/oldtree/drivers/media/video/davinci/dm644x_ccdc.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/davinci/dm644x_ccdc.c	2010-05-21 11:21:19.000000000 -0300
@@ -37,6 +37,7 @@
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 #include <linux/videodev2.h>
+#include <linux/gfp.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/davinci/vpfe_capture.c ./drivers/media/video/davinci/vpfe_capture.c
--- /home/v4l/tmp/oldtree/drivers/media/video/davinci/vpfe_capture.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/davinci/vpfe_capture.c	2010-05-21 11:21:19.000000000 -0300
@@ -67,6 +67,7 @@
  *		- Support for control ioctls
  */
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/davinci/vpif_capture.c ./drivers/media/video/davinci/vpif_capture.c
--- /home/v4l/tmp/oldtree/drivers/media/video/davinci/vpif_capture.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/davinci/vpif_capture.c	2010-05-21 11:21:19.000000000 -0300
@@ -34,6 +34,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/version.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/davinci/vpif_display.c ./drivers/media/video/davinci/vpif_display.c
--- /home/v4l/tmp/oldtree/drivers/media/video/davinci/vpif_display.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/davinci/vpif_display.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/version.h>
+#include <linux/slab.h>
 
 #include <asm/irq.h>
 #include <asm/page.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-cards.c ./drivers/media/video/em28xx/em28xx-cards.c
--- /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-cards.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/em28xx/em28xx-cards.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,6 +24,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/usb.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-core.c ./drivers/media/video/em28xx/em28xx-core.c
--- /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-core.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/em28xx/em28xx-core.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/vmalloc.h>
 #include <media/v4l2-common.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-dvb.c ./drivers/media/video/em28xx/em28xx-dvb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-dvb.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/em28xx/em28xx-dvb.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 
 #include "em28xx.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-input.c ./drivers/media/video/em28xx/em28xx-input.c
--- /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-input.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/em28xx/em28xx-input.c	2010-05-21 11:21:19.000000000 -0300
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 
 #include "em28xx.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-vbi.c ./drivers/media/video/em28xx/em28xx-vbi.c
--- /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-vbi.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/em28xx/em28xx-vbi.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,7 +24,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/slab.h>
 
 #include "em28xx.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-video.c ./drivers/media/video/em28xx/em28xx-video.c
--- /home/v4l/tmp/oldtree/drivers/media/video/em28xx/em28xx-video.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/em28xx/em28xx-video.c	2010-05-21 11:21:19.000000000 -0300
@@ -35,6 +35,7 @@
 #include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include "em28xx.h"
 #include <media/v4l2-common.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/gspca.c ./drivers/media/video/gspca/gspca.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/gspca.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/gspca.c	2010-05-21 11:14:04.000000000 -0300
@@ -279,6 +279,19 @@ static void gspca_input_destroy_urb(stru
 		usb_free_urb(urb);
 	}
 }
+#else
+static inline void gspca_input_destroy_urb(struct gspca_dev *gspca_dev)
+{
+}
+
+static inline void gspca_input_create_urb(struct gspca_dev *gspca_dev)
+{
+}
+
+static inline int gspca_input_connect(struct gspca_dev *dev)
+{
+	return 0;
+}
 #endif
 
 /* get the current input frame buffer */
@@ -2295,12 +2308,10 @@ int gspca_dev_probe(struct usb_interface
 		goto out;
 	gspca_set_default_mode(gspca_dev);
 
-#ifdef CONFIG_INPUT
 	ret = gspca_input_connect(gspca_dev);
 	if (ret)
 		goto out;
 
-#endif
 	mutex_init(&gspca_dev->usb_lock);
 	mutex_init(&gspca_dev->read_lock);
 	mutex_init(&gspca_dev->queue_lock);
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/gspca.h ./drivers/media/video/gspca/gspca.h
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/gspca.h	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/gspca.h	2010-05-21 11:21:19.000000000 -0300
@@ -7,6 +7,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 /* compilation option */
 #define GSPCA_DEBUG 1
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/jeilinj.c ./drivers/media/video/gspca/jeilinj.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/jeilinj.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/jeilinj.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,6 +24,7 @@
 #define MODULE_NAME "jeilinj"
 
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include "gspca.h"
 #include "jpeg.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/m5602/m5602_s5k83a.c ./drivers/media/video/gspca/m5602/m5602_s5k83a.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/m5602/m5602_s5k83a.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/m5602/m5602_s5k83a.c	2010-05-21 11:21:19.000000000 -0300
@@ -17,6 +17,7 @@
  */
 
 #include <linux/kthread.h>
+#include <linux/slab.h>
 #include "m5602_s5k83a.h"
 
 static int s5k83a_set_gain(struct gspca_dev *gspca_dev, __s32 val);
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/ov519.c ./drivers/media/video/gspca/ov519.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/ov519.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/ov519.c	2010-05-21 11:21:19.000000000 -0300
@@ -512,7 +512,7 @@ static const struct v4l2_pix_format ovfx
 /*
  * The FX2 chip does not give us a zero length read at end of frame.
  * It does, however, give a short read at the end of a frame, if
- * neccessary, rather than run two frames together.
+ * necessary, rather than run two frames together.
  *
  * By choosing the right bulk transfer size, we are guaranteed to always
  * get a short read for the last read of each frame.  Frame sizes are
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/sn9c20x.c ./drivers/media/video/gspca/sn9c20x.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/sn9c20x.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/sn9c20x.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
 
 #ifdef CONFIG_INPUT
 #include <linux/input.h>
+#include <linux/slab.h>
 #endif
 
 #include "gspca.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/sonixj.c ./drivers/media/video/gspca/sonixj.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/sonixj.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/sonixj.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #define MODULE_NAME "sonixj"
 
 #include <linux/input.h>
+#include <linux/slab.h>
 #include "gspca.h"
 #include "jpeg.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/spca508.c ./drivers/media/video/gspca/spca508.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/spca508.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/spca508.c	2010-05-21 11:21:19.000000000 -0300
@@ -1513,7 +1513,6 @@ static const struct sd_desc sd_desc = {
 static const __devinitdata struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x0130, 0x0130), .driver_info = HamaUSBSightcam},
 	{USB_DEVICE(0x041e, 0x4018), .driver_info = CreativeVista},
-	{USB_DEVICE(0x0461, 0x0815), .driver_info = MicroInnovationIC200},
 	{USB_DEVICE(0x0733, 0x0110), .driver_info = ViewQuestVQ110},
 	{USB_DEVICE(0x0af9, 0x0010), .driver_info = HamaUSBSightcam},
 	{USB_DEVICE(0x0af9, 0x0011), .driver_info = HamaUSBSightcam2},
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/spca561.c ./drivers/media/video/gspca/spca561.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/spca561.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/spca561.c	2010-05-21 11:21:19.000000000 -0300
@@ -1065,6 +1065,7 @@ static const __devinitdata struct usb_de
 	{USB_DEVICE(0x041e, 0x401a), .driver_info = Rev072A},
 	{USB_DEVICE(0x041e, 0x403b), .driver_info = Rev012A},
 	{USB_DEVICE(0x0458, 0x7004), .driver_info = Rev072A},
+	{USB_DEVICE(0x0461, 0x0815), .driver_info = Rev072A},
 	{USB_DEVICE(0x046d, 0x0928), .driver_info = Rev012A},
 	{USB_DEVICE(0x046d, 0x0929), .driver_info = Rev012A},
 	{USB_DEVICE(0x046d, 0x092a), .driver_info = Rev012A},
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/sq905.c ./drivers/media/video/gspca/sq905.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/sq905.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/sq905.c	2010-05-21 11:21:19.000000000 -0300
@@ -36,6 +36,7 @@
 #define MODULE_NAME "sq905"
 
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include "gspca.h"
 
 MODULE_AUTHOR("Adam Baker <linux@baker-net.org.uk>, "
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/sq905c.c ./drivers/media/video/gspca/sq905c.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/sq905c.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/sq905c.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 #define MODULE_NAME "sq905c"
 
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include "gspca.h"
 
 MODULE_AUTHOR("Theodore Kilgore <kilgota@auburn.edu>");
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/gspca/zc3xx.c ./drivers/media/video/gspca/zc3xx.c
--- /home/v4l/tmp/oldtree/drivers/media/video/gspca/zc3xx.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/gspca/zc3xx.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #define MODULE_NAME "zc3xx"
 
 #include <linux/input.h>
+#include <linux/slab.h>
 #include "gspca.h"
 #include "jpeg.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/hdpvr/hdpvr-i2c.c ./drivers/media/video/hdpvr/hdpvr-i2c.c
--- /home/v4l/tmp/oldtree/drivers/media/video/hdpvr/hdpvr-i2c.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/hdpvr/hdpvr-i2c.c	2010-05-21 11:21:19.000000000 -0300
@@ -11,6 +11,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "hdpvr.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/ivtv/ivtv-controls.c ./drivers/media/video/ivtv/ivtv-controls.c
--- /home/v4l/tmp/oldtree/drivers/media/video/ivtv/ivtv-controls.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/ivtv/ivtv-controls.c	2010-05-21 11:21:19.000000000 -0300
@@ -18,6 +18,7 @@
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 
 #include "ivtv-driver.h"
 #include "ivtv-cards.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/ivtv/ivtv-driver.h ./drivers/media/video/ivtv/ivtv-driver.h
--- /home/v4l/tmp/oldtree/drivers/media/video/ivtv/ivtv-driver.h	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/ivtv/ivtv-driver.h	2010-05-21 11:21:19.000000000 -0300
@@ -53,6 +53,7 @@
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/byteorder.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/ivtv/ivtvfb.c ./drivers/media/video/ivtv/ivtvfb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/ivtv/ivtvfb.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/ivtv/ivtvfb.c	2010-05-21 11:21:19.000000000 -0300
@@ -42,6 +42,7 @@
 #include <linux/kernel.h>
 #include <linux/fb.h>
 #include <linux/ivtvfb.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/ks0127.c ./drivers/media/video/ks0127.c
--- /home/v4l/tmp/oldtree/drivers/media/video/ks0127.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/ks0127.c	2010-05-21 11:21:19.000000000 -0300
@@ -40,6 +40,7 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/m52790.c ./drivers/media/video/m52790.c
--- /home/v4l/tmp/oldtree/drivers/media/video/m52790.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/m52790.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/meye.c ./drivers/media/video/meye.c
--- /home/v4l/tmp/oldtree/drivers/media/video/meye.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/meye.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/gfp.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/msp3400-kthreads.c ./drivers/media/video/msp3400-kthreads.c
--- /home/v4l/tmp/oldtree/drivers/media/video/msp3400-kthreads.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/msp3400-kthreads.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,7 +22,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/freezer.h>
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/mt9v011.c ./drivers/media/video/mt9v011.c
--- /home/v4l/tmp/oldtree/drivers/media/video/mt9v011.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/mt9v011.c	2010-05-21 11:21:19.000000000 -0300
@@ -6,6 +6,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
 #include <asm/div64.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/mx1_camera.c ./drivers/media/video/mx1_camera.c
--- /home/v4l/tmp/oldtree/drivers/media/video/mx1_camera.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/mx1_camera.c	2010-05-21 11:21:19.000000000 -0300
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/version.h>
 #include <linux/videodev2.h>
@@ -48,8 +49,6 @@
 /*
  * CSI registers
  */
-#define DMA_CCR(x)	(0x8c + ((x) << 6))	/* Control Registers */
-#define DMA_DIMR	0x08			/* Interrupt mask Register */
 #define CSICR1		0x00			/* CSI Control Register 1 */
 #define CSISR		0x08			/* CSI Status Register */
 #define CSIRXR		0x10			/* CSI RxFIFO Register */
@@ -783,7 +782,7 @@ static int __init mx1_camera_probe(struc
 			       pcdev);
 
 	imx_dma_config_channel(pcdev->dma_chan, IMX_DMA_TYPE_FIFO,
-			       IMX_DMA_MEMSIZE_32, DMA_REQ_CSI_R, 0);
+			       IMX_DMA_MEMSIZE_32, MX1_DMA_REQ_CSI_R, 0);
 	/* burst length : 16 words = 64 bytes */
 	imx_dma_config_burstlen(pcdev->dma_chan, 0);
 
@@ -797,8 +796,8 @@ static int __init mx1_camera_probe(struc
 	set_fiq_handler(&mx1_camera_sof_fiq_start, &mx1_camera_sof_fiq_end -
 						   &mx1_camera_sof_fiq_start);
 
-	regs.ARM_r8 = DMA_BASE + DMA_DIMR;
-	regs.ARM_r9 = DMA_BASE + DMA_CCR(pcdev->dma_chan);
+	regs.ARM_r8 = (long)MX1_DMA_DIMR;
+	regs.ARM_r9 = (long)MX1_DMA_CCR(pcdev->dma_chan);
 	regs.ARM_r10 = (long)pcdev->base + CSICR1;
 	regs.ARM_fp = (long)pcdev->base + CSISR;
 	regs.ARM_sp = 1 << pcdev->dma_chan;
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/omap24xxcam.c ./drivers/media/video/omap24xxcam.c
--- /home/v4l/tmp/oldtree/drivers/media/video/omap24xxcam.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/omap24xxcam.c	2010-05-21 11:21:19.000000000 -0300
@@ -35,6 +35,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
@@ -1735,7 +1736,7 @@ static struct v4l2_int_device omap24xxca
  *
  */
 
-static int __init omap24xxcam_probe(struct platform_device *pdev)
+static int __devinit omap24xxcam_probe(struct platform_device *pdev)
 {
 	struct omap24xxcam_device *cam;
 	struct resource *mem;
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/ov7670.c ./drivers/media/video/ov7670.c
--- /home/v4l/tmp/oldtree/drivers/media/video/ov7670.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/ov7670.c	2010-05-21 11:21:19.000000000 -0300
@@ -12,6 +12,7 @@
  */
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pms.c ./drivers/media/video/pms.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pms.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/pms.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,7 +25,6 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c ./drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c	2010-05-21 11:21:19.000000000 -0300
@@ -34,7 +34,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/errno.h>
-#include <linux/slab.h>
 
 struct routing_scheme {
 	const int *def;
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c ./drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c	2010-05-21 11:21:19.000000000 -0300
@@ -36,7 +36,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/errno.h>
-#include <linux/slab.h>
 
 
 struct routing_scheme_item {
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-debugifc.c ./drivers/media/video/pvrusb2/pvrusb2-debugifc.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-debugifc.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-debugifc.c	2010-05-21 11:21:19.000000000 -0300
@@ -19,7 +19,6 @@
  */
 
 #include <linux/string.h>
-#include <linux/slab.h>
 #include "pvrusb2-debugifc.h"
 #include "pvrusb2-hdw.h"
 #include "pvrusb2-debug.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-dvb.c ./drivers/media/video/pvrusb2/pvrusb2-dvb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-dvb.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-dvb.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/slab.h>
 #include <linux/mm.h>
 #include "dvbdev.h"
 #include "pvrusb2-debug.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-eeprom.c ./drivers/media/video/pvrusb2/pvrusb2-eeprom.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-eeprom.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-eeprom.c	2010-05-21 11:21:19.000000000 -0300
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include "pvrusb2-eeprom.h"
 #include "pvrusb2-hdw-internal.h"
 #include "pvrusb2-debug.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-main.c ./drivers/media/video/pvrusb2/pvrusb2-main.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-main.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-main.c	2010-05-21 11:21:19.000000000 -0300
@@ -21,7 +21,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-sysfs.c ./drivers/media/video/pvrusb2/pvrusb2-sysfs.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-sysfs.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-sysfs.c	2010-05-21 11:21:19.000000000 -0300
@@ -423,10 +423,12 @@ static void pvr2_sysfs_add_debugifc(stru
 
 	dip = kzalloc(sizeof(*dip),GFP_KERNEL);
 	if (!dip) return;
+	sysfs_attr_init(&dip->attr_debugcmd.attr);
 	dip->attr_debugcmd.attr.name = "debugcmd";
 	dip->attr_debugcmd.attr.mode = S_IRUGO|S_IWUSR|S_IWGRP;
 	dip->attr_debugcmd.show = debugcmd_show;
 	dip->attr_debugcmd.store = debugcmd_store;
+	sysfs_attr_init(&dip->attr_debuginfo.attr);
 	dip->attr_debuginfo.attr.name = "debuginfo";
 	dip->attr_debuginfo.attr.mode = S_IRUGO;
 	dip->attr_debuginfo.show = debuginfo_show;
@@ -644,6 +646,7 @@ static void class_dev_create(struct pvr2
 		return;
 	}
 
+	sysfs_attr_init(&sfp->attr_v4l_minor_number.attr);
 	sfp->attr_v4l_minor_number.attr.name = "v4l_minor_number";
 	sfp->attr_v4l_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_minor_number.show = v4l_minor_number_show;
@@ -658,6 +661,7 @@ static void class_dev_create(struct pvr2
 		sfp->v4l_minor_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_v4l_radio_minor_number.attr);
 	sfp->attr_v4l_radio_minor_number.attr.name = "v4l_radio_minor_number";
 	sfp->attr_v4l_radio_minor_number.attr.mode = S_IRUGO;
 	sfp->attr_v4l_radio_minor_number.show = v4l_radio_minor_number_show;
@@ -672,6 +676,7 @@ static void class_dev_create(struct pvr2
 		sfp->v4l_radio_minor_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_unit_number.attr);
 	sfp->attr_unit_number.attr.name = "unit_number";
 	sfp->attr_unit_number.attr.mode = S_IRUGO;
 	sfp->attr_unit_number.show = unit_number_show;
@@ -685,6 +690,7 @@ static void class_dev_create(struct pvr2
 		sfp->unit_number_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_bus_info.attr);
 	sfp->attr_bus_info.attr.name = "bus_info_str";
 	sfp->attr_bus_info.attr.mode = S_IRUGO;
 	sfp->attr_bus_info.show = bus_info_show;
@@ -699,6 +705,7 @@ static void class_dev_create(struct pvr2
 		sfp->bus_info_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_hdw_name.attr);
 	sfp->attr_hdw_name.attr.name = "device_hardware_type";
 	sfp->attr_hdw_name.attr.mode = S_IRUGO;
 	sfp->attr_hdw_name.show = hdw_name_show;
@@ -713,6 +720,7 @@ static void class_dev_create(struct pvr2
 		sfp->hdw_name_created_ok = !0;
 	}
 
+	sysfs_attr_init(&sfp->attr_hdw_desc.attr);
 	sfp->attr_hdw_desc.attr.name = "device_hardware_description";
 	sfp->attr_hdw_desc.attr.mode = S_IRUGO;
 	sfp->attr_hdw_desc.show = hdw_desc_show;
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-v4l2.c ./drivers/media/video/pvrusb2/pvrusb2-v4l2.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-v4l2.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-v4l2.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/version.h>
 #include "pvrusb2-context.h"
 #include "pvrusb2-hdw.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c ./drivers/media/video/pvrusb2/pvrusb2-video-v4l.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-video-v4l.c	2010-05-21 11:21:19.000000000 -0300
@@ -37,7 +37,6 @@
 #include <media/v4l2-common.h>
 #include <media/saa7115.h>
 #include <linux/errno.h>
-#include <linux/slab.h>
 
 struct routing_scheme {
 	const int *def;
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-wm8775.c ./drivers/media/video/pvrusb2/pvrusb2-wm8775.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pvrusb2/pvrusb2-wm8775.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/pvrusb2/pvrusb2-wm8775.c	2010-05-21 11:21:19.000000000 -0300
@@ -34,7 +34,6 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/errno.h>
-#include <linux/slab.h>
 
 void pvr2_wm8775_subdev_update(struct pvr2_hdw *hdw, struct v4l2_subdev *sd)
 {
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pwc/philips.txt ./drivers/media/video/pwc/philips.txt
--- /home/v4l/tmp/oldtree/drivers/media/video/pwc/philips.txt	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/pwc/philips.txt	2010-05-21 11:21:19.000000000 -0300
@@ -33,7 +33,7 @@ a lot of extra information, a FAQ, and t
 contains decompression routines that allow you to use higher image sizes and
 framerates; in addition the webcam uses less bandwidth on the USB bus (handy
 if you want to run more than 1 camera simultaneously). These routines fall
-under a NDA, and may therefor not be distributed as source; however, its use
+under a NDA, and may therefore not be distributed as source; however, its use
 is completely optional.
 
 You can build this code either into your kernel, or as a module. I recommend
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pwc/pwc-dec23.c ./drivers/media/video/pwc/pwc-dec23.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pwc/pwc-dec23.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/pwc/pwc-dec23.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 #include <media/pwc-ioctl.h>
 
 #include <linux/string.h>
+#include <linux/slab.h>
 
 /*
  * USE_LOOKUP_TABLE_TO_CLAMP
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pwc/pwc.h ./drivers/media/video/pwc/pwc.h
--- /home/v4l/tmp/oldtree/drivers/media/video/pwc/pwc.h	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/pwc/pwc.h	2010-05-21 11:21:19.000000000 -0300
@@ -32,6 +32,7 @@
 #include <linux/version.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <asm/errno.h>
 #include <linux/videodev.h>
 #include <media/v4l2-common.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pwc/pwc-v4l.c ./drivers/media/video/pwc/pwc-v4l.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pwc/pwc-v4l.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/pwc/pwc-v4l.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,7 +30,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/poll.h>
-#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <asm/io.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/pxa_camera.c ./drivers/media/video/pxa_camera.c
--- /home/v4l/tmp/oldtree/drivers/media/video/pxa_camera.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/pxa_camera.c	2010-05-21 11:21:19.000000000 -0300
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -608,12 +609,9 @@ static void pxa_dma_add_tail_buf(struct 
  */
 static void pxa_camera_start_capture(struct pxa_camera_dev *pcdev)
 {
-	unsigned long cicr0, cifr;
+	unsigned long cicr0;
 
 	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
-	/* Reset the FIFOs */
-	cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
-	__raw_writel(cifr, pcdev->base + CIFR);
 	/* Enable End-Of-Frame Interrupt */
 	cicr0 = __raw_readl(pcdev->base + CICR0) | CICR0_ENB;
 	cicr0 &= ~CICR0_EOFM;
@@ -934,7 +932,7 @@ static void pxa_camera_deactivate(struct
 static irqreturn_t pxa_camera_irq(int irq, void *data)
 {
 	struct pxa_camera_dev *pcdev = data;
-	unsigned long status, cicr0;
+	unsigned long status, cifr, cicr0;
 	struct pxa_buffer *buf;
 	struct videobuf_buffer *vb;
 
@@ -948,6 +946,10 @@ static irqreturn_t pxa_camera_irq(int ir
 	__raw_writel(status, pcdev->base + CISR);
 
 	if (status & CISR_EOF) {
+		/* Reset the FIFOs */
+		cifr = __raw_readl(pcdev->base + CIFR) | CIFR_RESET_F;
+		__raw_writel(cifr, pcdev->base + CIFR);
+
 		pcdev->active = list_first_entry(&pcdev->capture,
 					   struct pxa_buffer, vb.queue);
 		vb = &pcdev->active->vb;
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/s2255drv.c ./drivers/media/video/s2255drv.c
--- /home/v4l/tmp/oldtree/drivers/media/video/s2255drv.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/s2255drv.c	2010-05-21 11:21:19.000000000 -0300
@@ -45,6 +45,7 @@
 #include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/version.h>
 #include <linux/mm.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa5246a.c ./drivers/media/video/saa5246a.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa5246a.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/saa5246a.c	2010-05-21 11:21:19.000000000 -0300
@@ -43,6 +43,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/videotext.h>
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa5249.c ./drivers/media/video/saa5249.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa5249.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/saa5249.c	2010-05-21 11:21:19.000000000 -0300
@@ -50,6 +50,7 @@
 #include <linux/delay.h>
 #include <linux/videotext.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ioctl.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-dvb.c ./drivers/media/video/saa7134/saa7134-dvb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-dvb.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/saa7134/saa7134-dvb.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,7 +24,6 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-empress.c ./drivers/media/video/saa7134/saa7134-empress.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-empress.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/saa7134/saa7134-empress.c	2010-05-21 11:21:19.000000000 -0300
@@ -21,7 +21,6 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/delay.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-i2c.c ./drivers/media/video/saa7134/saa7134-i2c.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-i2c.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/saa7134/saa7134-i2c.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,7 +24,6 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
 
 #include "saa7134-reg.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-input.c ./drivers/media/video/saa7134/saa7134-input.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-input.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/saa7134/saa7134-input.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
+#include <linux/slab.h>
 
 #include "saa7134-reg.h"
 #include "saa7134.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-ts.c ./drivers/media/video/saa7134/saa7134-ts.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-ts.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/saa7134/saa7134-ts.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,7 +24,6 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
 
 #include "saa7134-reg.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-tvaudio.c ./drivers/media/video/saa7134/saa7134-tvaudio.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-tvaudio.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/saa7134/saa7134-tvaudio.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/freezer.h>
 #include <asm/div64.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-vbi.c ./drivers/media/video/saa7134/saa7134-vbi.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7134/saa7134-vbi.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/saa7134/saa7134-vbi.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,7 +24,6 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
 
 #include "saa7134-reg.h"
 #include "saa7134.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7164/saa7164-api.c ./drivers/media/video/saa7164/saa7164-api.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7164/saa7164-api.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/saa7164/saa7164-api.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
  */
 
 #include <linux/wait.h>
+#include <linux/slab.h>
 
 #include "saa7164.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7164/saa7164-buffer.c ./drivers/media/video/saa7164/saa7164-buffer.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7164/saa7164-buffer.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/saa7164/saa7164-buffer.c	2010-05-21 11:21:19.000000000 -0300
@@ -19,6 +19,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
+
 #include "saa7164.h"
 
 /* The PCI address space for buffer handling looks like this:
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7164/saa7164-fw.c ./drivers/media/video/saa7164/saa7164-fw.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7164/saa7164-fw.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/saa7164/saa7164-fw.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
  */
 
 #include <linux/firmware.h>
+#include <linux/slab.h>
 
 #include "saa7164.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa717x.c ./drivers/media/video/saa717x.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa717x.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/saa717x.c	2010-05-21 11:21:19.000000000 -0300
@@ -32,6 +32,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/sched.h>
 
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/saa7185.c ./drivers/media/video/saa7185.c
--- /home/v4l/tmp/oldtree/drivers/media/video/saa7185.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/saa7185.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/sh_mobile_ceu_camera.c ./drivers/media/video/sh_mobile_ceu_camera.c
--- /home/v4l/tmp/oldtree/drivers/media/video/sh_mobile_ceu_camera.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/sh_mobile_ceu_camera.c	2010-05-21 11:21:19.000000000 -0300
@@ -27,6 +27,7 @@
 #include <linux/moduleparam.h>
 #include <linux/time.h>
 #include <linux/version.h>
+#include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/sn9c102/sn9c102_sensor.h ./drivers/media/video/sn9c102/sn9c102_sensor.h
--- /home/v4l/tmp/oldtree/drivers/media/video/sn9c102/sn9c102_sensor.h	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/sn9c102/sn9c102_sensor.h	2010-05-21 11:21:19.000000000 -0300
@@ -120,7 +120,7 @@ extern int sn9c102_write_regs(struct sn9
 /*
    Write multiple registers with constant values. For example:
    sn9c102_write_const_regs(cam, {0x00, 0x14}, {0x60, 0x17}, {0x0f, 0x18});
-   Register adresses must be < 256.
+   Register addresses must be < 256.
 */
 #define sn9c102_write_const_regs(sn9c102_device, data...)                     \
 	({ static const u8 _valreg[][2] = {data};                             \
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/soc_camera.c ./drivers/media/video/soc_camera.c
--- /home/v4l/tmp/oldtree/drivers/media/video/soc_camera.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/soc_camera.c	2010-05-21 11:21:19.000000000 -0300
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/vmalloc.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tda9840.c ./drivers/media/video/tda9840.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tda9840.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/tda9840.c	2010-05-21 11:21:19.000000000 -0300
@@ -28,6 +28,7 @@
 
 #include <linux/module.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tea6415c.c ./drivers/media/video/tea6415c.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tea6415c.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/tea6415c.c	2010-05-21 11:21:19.000000000 -0300
@@ -30,6 +30,7 @@
 
 #include <linux/module.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tea6420.c ./drivers/media/video/tea6420.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tea6420.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/tea6420.c	2010-05-21 11:21:19.000000000 -0300
@@ -6,7 +6,7 @@
 
     The tea6420 is a bus controlled audio-matrix with 5 stereo inputs,
     4 stereo outputs and gain control for each output.
-    It is cascadable, i.e. it can be found at the adresses 0x98
+    It is cascadable, i.e. it can be found at the addresses 0x98
     and 0x9a on the i2c-bus.
 
     For detailed informations download the specifications directly
@@ -30,6 +30,7 @@
 
 #include <linux/module.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/ths7303.c ./drivers/media/video/ths7303.c
--- /home/v4l/tmp/oldtree/drivers/media/video/ths7303.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/ths7303.c	2010-05-21 11:21:19.000000000 -0300
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/device.h>
 #include <linux/delay.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tlg2300/pd-alsa.c ./drivers/media/video/tlg2300/pd-alsa.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tlg2300/pd-alsa.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/tlg2300/pd-alsa.c	2010-05-21 11:21:19.000000000 -0300
@@ -4,10 +4,10 @@
 #include <linux/sound.h>
 #include <linux/spinlock.h>
 #include <linux/soundcard.h>
-#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
 #include <linux/module.h>
+#include <linux/gfp.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tlg2300/pd-dvb.c ./drivers/media/video/tlg2300/pd-dvb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tlg2300/pd-dvb.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/tlg2300/pd-dvb.c	2010-05-21 11:21:19.000000000 -0300
@@ -3,6 +3,7 @@
 #include <linux/usb.h>
 #include <linux/dvb/dmx.h>
 #include <linux/delay.h>
+#include <linux/gfp.h>
 
 #include "vendorcmds.h"
 #include <linux/sched.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tlg2300/pd-video.c ./drivers/media/video/tlg2300/pd-video.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tlg2300/pd-video.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/tlg2300/pd-video.c	2010-05-21 11:21:19.000000000 -0300
@@ -4,6 +4,7 @@
 #include <linux/usb.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tlv320aic23b.c ./drivers/media/video/tlv320aic23b.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tlv320aic23b.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/tlv320aic23b.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,6 +25,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tvp514x.c ./drivers/media/video/tvp514x.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tvp514x.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/tvp514x.c	2010-05-21 11:21:19.000000000 -0300
@@ -29,6 +29,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tvp5150.c ./drivers/media/video/tvp5150.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tvp5150.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/tvp5150.c	2010-05-21 11:21:19.000000000 -0300
@@ -6,6 +6,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
 #include <media/v4l2-device.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/tvp7002.c ./drivers/media/video/tvp7002.c
--- /home/v4l/tmp/oldtree/drivers/media/video/tvp7002.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/tvp7002.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
  */
 #include <linux/delay.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/tvp7002.h>
 #include <media/v4l2-device.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/upd64031a.c ./drivers/media/video/upd64031a.c
--- /home/v4l/tmp/oldtree/drivers/media/video/upd64031a.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/upd64031a.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/upd64083.c ./drivers/media/video/upd64083.c
--- /home/v4l/tmp/oldtree/drivers/media/video/upd64083.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/upd64083.c	2010-05-21 11:21:19.000000000 -0300
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/usbvideo/konicawc.c ./drivers/media/video/usbvideo/konicawc.c
--- /home/v4l/tmp/oldtree/drivers/media/video/usbvideo/konicawc.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/usbvideo/konicawc.c	2010-05-21 11:21:19.000000000 -0300
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/usb/input.h>
+#include <linux/gfp.h>
 
 #include "usbvideo.h"
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/usbvideo/quickcam_messenger.c ./drivers/media/video/usbvideo/quickcam_messenger.c
--- /home/v4l/tmp/oldtree/drivers/media/video/usbvideo/quickcam_messenger.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/usbvideo/quickcam_messenger.c	2010-05-21 11:21:19.000000000 -0300
@@ -34,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/usb/input.h>
+#include <linux/slab.h>
 
 #include "usbvideo.h"
 #include "quickcam_messenger.h"
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/usbvision/usbvision-core.c ./drivers/media/video/usbvision/usbvision-core.c
--- /home/v4l/tmp/oldtree/drivers/media/video/usbvision/usbvision-core.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/usbvision/usbvision-core.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,7 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/timer.h>
-#include <linux/slab.h>
+#include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/usbvision/usbvision-i2c.c ./drivers/media/video/usbvision/usbvision-i2c.c
--- /home/v4l/tmp/oldtree/drivers/media/video/usbvision/usbvision-i2c.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/usbvision/usbvision-i2c.c	2010-05-21 11:21:19.000000000 -0300
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
-#include <linux/slab.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <linux/ioport.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_ctrl.c ./drivers/media/video/uvc/uvc_ctrl.c
--- /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_ctrl.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/uvc/uvc_ctrl.c	2010-05-21 11:21:19.000000000 -0300
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_driver.c ./drivers/media/video/uvc/uvc_driver.c
--- /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_driver.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/uvc/uvc_driver.c	2010-05-21 11:21:19.000000000 -0300
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_status.c ./drivers/media/video/uvc/uvc_status.c
--- /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_status.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/uvc/uvc_status.c	2010-05-21 11:21:19.000000000 -0300
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/input.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_v4l2.c ./drivers/media/video/uvc/uvc_v4l2.c
--- /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_v4l2.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/uvc/uvc_v4l2.c	2010-05-21 11:21:19.000000000 -0300
@@ -15,6 +15,7 @@
 #include <linux/version.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_video.c ./drivers/media/video/uvc/uvc_video.c
--- /home/v4l/tmp/oldtree/drivers/media/video/uvc/uvc_video.c	2010-05-25 23:56:56.000000000 -0300
+++ ./drivers/media/video/uvc/uvc_video.c	2010-05-21 11:21:19.000000000 -0300
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/v4l2-ioctl.c ./drivers/media/video/v4l2-ioctl.c
--- /home/v4l/tmp/oldtree/drivers/media/video/v4l2-ioctl.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/v4l2-ioctl.c	2010-05-21 11:21:19.000000000 -0300
@@ -13,6 +13,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/videobuf-dma-contig.c ./drivers/media/video/videobuf-dma-contig.c
--- /home/v4l/tmp/oldtree/drivers/media/video/videobuf-dma-contig.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/videobuf-dma-contig.c	2010-05-21 11:21:19.000000000 -0300
@@ -20,6 +20,7 @@
 #include <linux/pagemap.h>
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/videobuf-dma-contig.h>
 
 struct videobuf_dma_contig_memory {
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/videobuf-dvb.c ./drivers/media/video/videobuf-dvb.c
--- /home/v4l/tmp/oldtree/drivers/media/video/videobuf-dvb.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/videobuf-dvb.c	2010-05-21 11:21:19.000000000 -0300
@@ -19,6 +19,7 @@
 #include <linux/fs.h>
 #include <linux/kthread.h>
 #include <linux/file.h>
+#include <linux/slab.h>
 
 #include <linux/freezer.h>
 
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/vino.c ./drivers/media/video/vino.c
--- /home/v4l/tmp/oldtree/drivers/media/video/vino.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/vino.c	2010-05-21 11:21:19.000000000 -0300
@@ -33,6 +33,7 @@
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/time.h>
 #include <linux/version.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/vp27smpx.c ./drivers/media/video/vp27smpx.c
--- /home/v4l/tmp/oldtree/drivers/media/video/vp27smpx.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/vp27smpx.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/vpx3220.c ./drivers/media/video/vpx3220.c
--- /home/v4l/tmp/oldtree/drivers/media/video/vpx3220.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/vpx3220.c	2010-05-21 11:21:19.000000000 -0300
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/w9966.c ./drivers/media/video/w9966.c
--- /home/v4l/tmp/oldtree/drivers/media/video/w9966.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/w9966.c	2010-05-21 11:21:19.000000000 -0300
@@ -59,6 +59,7 @@
 #include <linux/delay.h>
 #include <linux/version.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/wm8739.c ./drivers/media/video/wm8739.c
--- /home/v4l/tmp/oldtree/drivers/media/video/wm8739.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/wm8739.c	2010-05-21 11:21:19.000000000 -0300
@@ -23,6 +23,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/wm8775.c ./drivers/media/video/wm8775.c
--- /home/v4l/tmp/oldtree/drivers/media/video/wm8775.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/media/video/wm8775.c	2010-05-21 11:21:19.000000000 -0300
@@ -27,6 +27,7 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/ioctl.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/media/video/zoran/zoran_card.c ./drivers/media/video/zoran/zoran_card.c
--- /home/v4l/tmp/oldtree/drivers/media/video/zoran/zoran_card.c	2010-05-25 23:56:55.000000000 -0300
+++ ./drivers/media/video/zoran/zoran_card.c	2010-05-21 11:21:19.000000000 -0300
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/vmalloc.h>
+#include <linux/slab.h>
 
 #include <linux/proc_fs.h>
 #include <linux/i2c.h>
diff -upr /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-alsa.c ./drivers/staging/cx25821/cx25821-alsa.c
--- /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-alsa.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/cx25821/cx25821-alsa.c	2010-05-21 11:21:22.000000000 -0300
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
+#include <linux/slab.h>
 
 #include <linux/delay.h>
 #include <sound/core.h>
diff -upr /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-audio-upstream.c ./drivers/staging/cx25821/cx25821-audio-upstream.c
--- /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-audio-upstream.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/cx25821/cx25821-audio-upstream.c	2010-05-21 11:21:22.000000000 -0300
@@ -32,6 +32,7 @@
 #include <linux/file.h>
 #include <linux/fcntl.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
diff -upr /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-audups11.c ./drivers/staging/cx25821/cx25821-audups11.c
--- /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-audups11.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/cx25821/cx25821-audups11.c	2010-05-21 11:21:22.000000000 -0300
@@ -21,6 +21,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
+
 #include "cx25821-video.h"
 
 static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
@@ -343,10 +345,11 @@ static int vidioc_s_ctrl(struct file *fi
 			 struct v4l2_control *ctl)
 {
 	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_dev *dev;
 	int err;
 
 	if (fh) {
+		dev = fh->dev;
 		err = v4l2_prio_check(&dev->prio, fh->prio);
 		if (0 != err)
 			return err;
diff -upr /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-core.c ./drivers/staging/cx25821/cx25821-core.c
--- /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-core.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/cx25821/cx25821-core.c	2010-05-21 11:21:22.000000000 -0300
@@ -22,6 +22,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include "cx25821.h"
 #include "cx25821-sram.h"
 #include "cx25821-video.h"
diff -upr /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-video.c ./drivers/staging/cx25821/cx25821-video.c
--- /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-video.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/cx25821/cx25821-video.c	2010-05-21 11:21:22.000000000 -0300
@@ -876,7 +876,7 @@ int cx25821_enum_input(struct cx25821_de
 	dprintk(1, "%s()\n", __func__);
 
 	n = i->index;
-	if (n > 2)
+	if (n >= 2)
 		return -EINVAL;
 
 	if (0 == INPUT(n)->type)
@@ -963,7 +963,7 @@ int cx25821_set_freq(struct cx25821_dev 
 int cx25821_vidioc_s_frequency(struct file *file, void *priv, struct v4l2_frequency *f)
 {
 	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = fh->dev;
+	struct cx25821_dev *dev;
 	int err;
 
 	if (fh) {
diff -upr /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-video-upstream.c ./drivers/staging/cx25821/cx25821-video-upstream.c
--- /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-video-upstream.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/cx25821/cx25821-video-upstream.c	2010-05-21 11:21:22.000000000 -0300
@@ -31,6 +31,7 @@
 #include <linux/syscalls.h>
 #include <linux/file.h>
 #include <linux/fcntl.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
diff -upr /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-video-upstream-ch2.c ./drivers/staging/cx25821/cx25821-video-upstream-ch2.c
--- /home/v4l/tmp/oldtree/drivers/staging/cx25821/cx25821-video-upstream-ch2.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/cx25821/cx25821-video-upstream-ch2.c	2010-05-21 11:21:22.000000000 -0300
@@ -31,6 +31,7 @@
 #include <linux/syscalls.h>
 #include <linux/file.h>
 #include <linux/fcntl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/go7007-driver.c ./drivers/staging/go7007/go7007-driver.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/go7007-driver.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/go7007-driver.c	2010-05-21 11:21:22.000000000 -0300
@@ -29,6 +29,7 @@
 #include <linux/firmware.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 #include <asm/system.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
@@ -128,6 +129,8 @@ static int go7007_load_encoder(struct go
 	return rv;
 }
 
+MODULE_FIRMWARE("go7007fw.bin");
+
 /*
  * Boot the encoder and register the I2C adapter if requested.  Do the
  * minimum initialization necessary, since the board-specific code may
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/go7007-fw.c ./drivers/staging/go7007/go7007-fw.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/go7007-fw.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/go7007-fw.c	2010-05-21 11:21:22.000000000 -0300
@@ -31,6 +31,7 @@
 #include <linux/device.h>
 #include <linux/i2c.h>
 #include <linux/firmware.h>
+#include <linux/slab.h>
 #include <asm/byteorder.h>
 
 #include "go7007-priv.h"
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/go7007-usb.c ./drivers/staging/go7007/go7007-usb.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/go7007-usb.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/go7007-usb.c	2010-05-21 11:21:22.000000000 -0300
@@ -444,7 +444,9 @@ static struct go7007_usb_board board_sen
 	},
 };
 
-static struct usb_device_id go7007_usb_id_table[] = {
+MODULE_FIRMWARE("go7007tv.bin");
+
+static const struct usb_device_id go7007_usb_id_table[] = {
 	{
 		.match_flags	= USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION |
 					USB_DEVICE_ID_MATCH_INT_INFO,
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/go7007-v4l2.c ./drivers/staging/go7007/go7007-v4l2.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/go7007-v4l2.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/go7007-v4l2.c	2010-05-21 11:21:22.000000000 -0300
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
+#include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/unistd.h>
 #include <linux/time.h>
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/s2250-board.c ./drivers/staging/go7007/s2250-board.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/s2250-board.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/s2250-board.c	2010-05-21 11:21:22.000000000 -0300
@@ -20,6 +20,7 @@
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-i2c-drv.h>
@@ -667,7 +668,7 @@ static int s2250_remove(struct i2c_clien
 	return 0;
 }
 
-static struct i2c_device_id s2250_id[] = {
+static const struct i2c_device_id s2250_id[] = {
 	{ "s2250", 0 },
 	{ }
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/s2250-loader.c ./drivers/staging/go7007/s2250-loader.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/s2250-loader.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/s2250-loader.c	2010-05-21 11:21:22.000000000 -0300
@@ -17,6 +17,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <dvb-usb.h>
@@ -139,7 +140,7 @@ failed2:
 
 static void s2250loader_disconnect(struct usb_interface *interface)
 {
-	pdevice_extension_t s = usb_get_intfdata(interface);
+	pdevice_extension_t s;
 	printk(KERN_INFO "s2250: disconnect\n");
 	lock_kernel();
 	s = usb_get_intfdata(interface);
@@ -148,7 +149,7 @@ static void s2250loader_disconnect(struc
 	unlock_kernel();
 }
 
-static struct usb_device_id s2250loader_ids[] = {
+static const struct usb_device_id s2250loader_ids[] = {
 	{USB_DEVICE(0x1943, 0xa250)},
 	{}                          /* Terminating entry */
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/saa7134-go7007.c ./drivers/staging/go7007/saa7134-go7007.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/saa7134-go7007.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/saa7134-go7007.c	2010-05-21 11:21:22.000000000 -0300
@@ -84,6 +84,7 @@ static struct go7007_board_info board_vo
 		},
 	},
 };
+MODULE_FIRMWARE("go7007tv.bin");
 
 /********************* Driver for GPIO HPI interface *********************/
 
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/snd-go7007.c ./drivers/staging/go7007/snd-go7007.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/snd-go7007.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/snd-go7007.c	2010-05-21 11:21:22.000000000 -0300
@@ -28,6 +28,7 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 #include <asm/system.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-ov7640.c ./drivers/staging/go7007/wis-ov7640.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-ov7640.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/wis-ov7640.c	2010-05-21 11:21:22.000000000 -0300
@@ -77,7 +77,7 @@ static int wis_ov7640_remove(struct i2c_
 	return 0;
 }
 
-static struct i2c_device_id wis_ov7640_id[] = {
+static const struct i2c_device_id wis_ov7640_id[] = {
 	{ "wis_ov7640", 0 },
 	{ }
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-saa7113.c ./drivers/staging/go7007/wis-saa7113.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-saa7113.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/wis-saa7113.c	2010-05-21 11:21:22.000000000 -0300
@@ -20,6 +20,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 
 #include "wis-i2c.h"
 
@@ -304,7 +305,7 @@ static int wis_saa7113_remove(struct i2c
 	return 0;
 }
 
-static struct i2c_device_id wis_saa7113_id[] = {
+static const struct i2c_device_id wis_saa7113_id[] = {
 	{ "wis_saa7113", 0 },
 	{ }
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-saa7115.c ./drivers/staging/go7007/wis-saa7115.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-saa7115.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/wis-saa7115.c	2010-05-21 11:21:22.000000000 -0300
@@ -20,6 +20,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 
 #include "wis-i2c.h"
 
@@ -437,7 +438,7 @@ static int wis_saa7115_remove(struct i2c
 	return 0;
 }
 
-static struct i2c_device_id wis_saa7115_id[] = {
+static const struct i2c_device_id wis_saa7115_id[] = {
 	{ "wis_saa7115", 0 },
 	{ }
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-sony-tuner.c ./drivers/staging/go7007/wis-sony-tuner.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-sony-tuner.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/wis-sony-tuner.c	2010-05-21 11:21:22.000000000 -0300
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
+#include <linux/slab.h>
 #include <media/tuner.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
@@ -688,7 +689,7 @@ static int wis_sony_tuner_remove(struct 
 	return 0;
 }
 
-static struct i2c_device_id wis_sony_tuner_id[] = {
+static const struct i2c_device_id wis_sony_tuner_id[] = {
 	{ "wis_sony_tuner", 0 },
 	{ }
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-tw2804.c ./drivers/staging/go7007/wis-tw2804.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-tw2804.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/wis-tw2804.c	2010-05-21 11:21:22.000000000 -0300
@@ -20,6 +20,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 
 #include "wis-i2c.h"
 
@@ -327,7 +328,7 @@ static int wis_tw2804_remove(struct i2c_
 	return 0;
 }
 
-static struct i2c_device_id wis_tw2804_id[] = {
+static const struct i2c_device_id wis_tw2804_id[] = {
 	{ "wis_tw2804", 0 },
 	{ }
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-tw9903.c ./drivers/staging/go7007/wis-tw9903.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-tw9903.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/wis-tw9903.c	2010-05-21 11:21:22.000000000 -0300
@@ -20,6 +20,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 
 #include "wis-i2c.h"
 
@@ -309,7 +310,7 @@ static int wis_tw9903_remove(struct i2c_
 	return 0;
 }
 
-static struct i2c_device_id wis_tw9903_id[] = {
+static const struct i2c_device_id wis_tw9903_id[] = {
 	{ "wis_tw9903", 0 },
 	{ }
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-uda1342.c ./drivers/staging/go7007/wis-uda1342.c
--- /home/v4l/tmp/oldtree/drivers/staging/go7007/wis-uda1342.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/go7007/wis-uda1342.c	2010-05-21 11:21:22.000000000 -0300
@@ -82,7 +82,7 @@ static int wis_uda1342_remove(struct i2c
 	return 0;
 }
 
-static struct i2c_device_id wis_uda1342_id[] = {
+static const struct i2c_device_id wis_uda1342_id[] = {
 	{ "wis_uda1342", 0 },
 	{ }
 };
diff -upr /home/v4l/tmp/oldtree/drivers/staging/tm6000/tm6000-video.c ./drivers/staging/tm6000/tm6000-video.c
--- /home/v4l/tmp/oldtree/drivers/staging/tm6000/tm6000-video.c	2010-05-25 23:56:54.000000000 -0300
+++ ./drivers/staging/tm6000/tm6000-video.c	2010-05-21 11:21:23.000000000 -0300
@@ -585,7 +585,7 @@ static void tm6000_uninit_isoc(struct tm
 			usb_kill_urb(urb);
 			usb_unlink_urb(urb);
 			if (dev->isoc_ctl.transfer_buffer[i]) {
-				usb_buffer_free(dev->udev,
+				usb_free_coherent(dev->udev,
 						urb->transfer_buffer_length,
 						dev->isoc_ctl.transfer_buffer[i],
 						urb->transfer_dma);
@@ -672,7 +672,7 @@ static int tm6000_prepare_isoc(struct tm
 		}
 		dev->isoc_ctl.urb[i] = urb;
 
-		dev->isoc_ctl.transfer_buffer[i] = usb_buffer_alloc(dev->udev,
+		dev->isoc_ctl.transfer_buffer[i] = usb_alloc_coherent(dev->udev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!dev->isoc_ctl.transfer_buffer[i]) {
 			tm6000_err ("unable to allocate %i bytes for transfer"
diff -upr /home/v4l/tmp/oldtree/include/media/davinci/vpfe_capture.h ./include/media/davinci/vpfe_capture.h
--- /home/v4l/tmp/oldtree/include/media/davinci/vpfe_capture.h	2010-05-25 23:56:58.000000000 -0300
+++ ./include/media/davinci/vpfe_capture.h	2010-05-21 11:21:26.000000000 -0300
@@ -167,7 +167,7 @@ struct vpfe_device {
 	u8 started;
 	/*
 	 * offset where second field starts from the starting of the
-	 * buffer for field seperated YCbCr formats
+	 * buffer for field separated YCbCr formats
 	 */
 	u32 field_off;
 };
diff -upr /home/v4l/tmp/oldtree/include/media/ir-core.h ./include/media/ir-core.h
--- /home/v4l/tmp/oldtree/include/media/ir-core.h	2010-05-25 23:56:57.000000000 -0300
+++ ./include/media/ir-core.h	2010-05-21 11:14:09.000000000 -0300
@@ -21,7 +21,6 @@
 #include <linux/time.h>
 #include <linux/timer.h>
 #include <media/rc-map.h>
-#include <linux/workqueue.h>
 
 extern int ir_core_debug;
 #define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
diff -upr /home/v4l/tmp/oldtree/sound/i2c/other/tea575x-tuner.c ./sound/i2c/other/tea575x-tuner.c
--- /home/v4l/tmp/oldtree/sound/i2c/other/tea575x-tuner.c	2010-05-25 23:56:54.000000000 -0300
+++ ./sound/i2c/other/tea575x-tuner.c	2010-05-21 11:21:30.000000000 -0300
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/version.h>
 #include <sound/core.h>
 #include <sound/tea575x-tuner.h>
diff -upr /home/v4l/tmp/oldtree/sound/pci/bt87x.c ./sound/pci/bt87x.c
--- /home/v4l/tmp/oldtree/sound/pci/bt87x.c	2010-05-25 23:56:58.000000000 -0300
+++ ./sound/pci/bt87x.c	2010-05-21 11:21:30.000000000 -0300
@@ -795,7 +795,7 @@ fail:
 	  .driver_data = SND_BT87X_BOARD_ ## id }
 /* driver_data is the card id for that device */
 
-static struct pci_device_id snd_bt87x_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(snd_bt87x_ids) = {
 	/* Hauppauge WinTV series */
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, 0x0070, 0x13eb, GENERIC),
 	/* Hauppauge WinTV series */
@@ -964,7 +964,7 @@ static void __devexit snd_bt87x_remove(s
 
 /* default entries for all Bt87x cards - it's not exported */
 /* driver_data is set to 0 to call detection */
-static struct pci_device_id snd_bt87x_default_ids[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(snd_bt87x_default_ids) = {
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_878, PCI_ANY_ID, PCI_ANY_ID, UNKNOWN),
 	BT_DEVICE(PCI_DEVICE_ID_BROOKTREE_879, PCI_ANY_ID, PCI_ANY_ID, UNKNOWN),
 	{ }
