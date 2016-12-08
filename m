Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43034 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751075AbcLHXVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 18:21:19 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 3797D60098
        for <linux-media@vger.kernel.org>; Fri,  9 Dec 2016 01:21:14 +0200 (EET)
Date: Fri, 9 Dec 2016 01:20:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 FOR v4.11] Remove FSF postal address
Message-ID: <20161208232043.GJ16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains a single patch, one that removes the FSF postal
address from the headers in source code files. The patch is rebased from
what I posted for review. The changes since that are done to the commit
message as you requested. It now looks like this:

----------------------------8<--------------------------------
commit 50937f09e90bce1dbba67fdffd79d8c2a525edfe
Author: Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Fri Oct 28 14:31:20 2016 +0300

    media: Drop FSF's postal address from the source code files
    
    Drop the FSF's postal address from the source code files that typically
    contain mostly the license text. Of the 628 removed instances, 578 are
    outdated.
    
    The patch has been created with the following command without manual edits:
    
    git grep -l "675 Mass Ave\|59 Temple Place\|51 Franklin St" -- \
        drivers/media/ include/media|while read i; do i=$i perl -e '
    open(F,"< $ENV{i}");
    $a=join("", <F>);
    $a =~ s/[ \t]*\*\n.*You should.*\n.*along with.*\n.*(\n.*USA.*$)?\n//m
        && $a =~ s/(^.*)Or, (point your browser to) /$1To obtain the license, $2\n$1/m;
    close(F);
    open(F, "> $ENV{i}");
    print F $a;
    close(F);'; done
    
    Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
----------------------------8<--------------------------------

Please pull.


The following changes since commit 365fe4e0ce218dc5ad10df17b150a366b6015499:

  [media] mn88472: fix chip id check on probe (2016-12-01 12:47:22 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git fsf-address

for you to fetch changes up to 50937f09e90bce1dbba67fdffd79d8c2a525edfe:

  media: Drop FSF's postal address from the source code files (2016-12-09 00:09:51 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      media: Drop FSF's postal address from the source code files

 drivers/media/common/b2c2/flexcop.c                | 4 ----
 drivers/media/common/cx2341x.c                     | 4 ----
 drivers/media/common/siano/sms-cards.c             | 4 ----
 drivers/media/common/siano/sms-cards.h             | 4 ----
 drivers/media/common/siano/smscoreapi.c            | 4 ----
 drivers/media/common/tveeprom.c                    | 4 ----
 drivers/media/dvb-core/demux.h                     | 4 ----
 drivers/media/dvb-core/dmxdev.c                    | 4 ----
 drivers/media/dvb-core/dmxdev.h                    | 4 ----
 drivers/media/dvb-core/dvb_ca_en50221.c            | 7 ++-----
 drivers/media/dvb-core/dvb_demux.c                 | 4 ----
 drivers/media/dvb-core/dvb_demux.h                 | 4 ----
 drivers/media/dvb-core/dvb_frontend.c              | 7 ++-----
 drivers/media/dvb-core/dvb_math.c                  | 4 ----
 drivers/media/dvb-core/dvb_math.h                  | 4 ----
 drivers/media/dvb-core/dvb_net.c                   | 7 ++-----
 drivers/media/dvb-core/dvb_net.h                   | 4 ----
 drivers/media/dvb-core/dvb_ringbuffer.c            | 4 ----
 drivers/media/dvb-core/dvbdev.c                    | 4 ----
 drivers/media/dvb-core/dvbdev.h                    | 4 ----
 drivers/media/dvb-frontends/af9013.c               | 4 ----
 drivers/media/dvb-frontends/af9013.h               | 4 ----
 drivers/media/dvb-frontends/af9013_priv.h          | 4 ----
 drivers/media/dvb-frontends/atbm8830.c             | 4 ----
 drivers/media/dvb-frontends/atbm8830.h             | 4 ----
 drivers/media/dvb-frontends/atbm8830_priv.h        | 4 ----
 drivers/media/dvb-frontends/au8522_decoder.c       | 5 -----
 drivers/media/dvb-frontends/bcm3510.h              | 4 ----
 drivers/media/dvb-frontends/bcm3510_priv.h         | 4 ----
 drivers/media/dvb-frontends/bsbe1-d01a.h           | 7 ++-----
 drivers/media/dvb-frontends/bsbe1.h                | 7 ++-----
 drivers/media/dvb-frontends/bsru6.h                | 7 ++-----
 drivers/media/dvb-frontends/cx24113.c              | 4 ----
 drivers/media/dvb-frontends/cx24113.h              | 4 ----
 drivers/media/dvb-frontends/cx24123.c              | 4 ----
 drivers/media/dvb-frontends/dib0070.c              | 4 ----
 drivers/media/dvb-frontends/dib0090.c              | 4 ----
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    | 4 ----
 drivers/media/dvb-frontends/drxd.h                 | 8 ++------
 drivers/media/dvb-frontends/drxd_firm.c            | 8 ++------
 drivers/media/dvb-frontends/drxd_firm.h            | 8 ++------
 drivers/media/dvb-frontends/drxd_hard.c            | 8 ++------
 drivers/media/dvb-frontends/drxd_map_firm.h        | 8 ++------
 drivers/media/dvb-frontends/drxk_hard.c            | 8 ++------
 drivers/media/dvb-frontends/dvb-pll.c              | 4 ----
 drivers/media/dvb-frontends/dvb_dummy_fe.c         | 4 ----
 drivers/media/dvb-frontends/dvb_dummy_fe.h         | 4 ----
 drivers/media/dvb-frontends/ec100.c                | 4 ----
 drivers/media/dvb-frontends/ec100.h                | 4 ----
 drivers/media/dvb-frontends/hd29l2.c               | 4 ----
 drivers/media/dvb-frontends/hd29l2.h               | 4 ----
 drivers/media/dvb-frontends/hd29l2_priv.h          | 4 ----
 drivers/media/dvb-frontends/isl6405.c              | 7 ++-----
 drivers/media/dvb-frontends/isl6405.h              | 7 ++-----
 drivers/media/dvb-frontends/isl6421.c              | 7 ++-----
 drivers/media/dvb-frontends/isl6421.h              | 7 ++-----
 drivers/media/dvb-frontends/itd1000.c              | 4 ----
 drivers/media/dvb-frontends/itd1000.h              | 4 ----
 drivers/media/dvb-frontends/itd1000_priv.h         | 4 ----
 drivers/media/dvb-frontends/ix2505v.c              | 4 ----
 drivers/media/dvb-frontends/ix2505v.h              | 4 ----
 drivers/media/dvb-frontends/lg2160.c               | 4 ----
 drivers/media/dvb-frontends/lg2160.h               | 4 ----
 drivers/media/dvb-frontends/lgdt3305.c             | 4 ----
 drivers/media/dvb-frontends/lgdt3305.h             | 4 ----
 drivers/media/dvb-frontends/lgdt330x.c             | 4 ----
 drivers/media/dvb-frontends/lgdt330x.h             | 4 ----
 drivers/media/dvb-frontends/lgdt330x_priv.h        | 4 ----
 drivers/media/dvb-frontends/lgs8gxx.c              | 4 ----
 drivers/media/dvb-frontends/lgs8gxx.h              | 4 ----
 drivers/media/dvb-frontends/lgs8gxx_priv.h         | 4 ----
 drivers/media/dvb-frontends/lnbh24.h               | 4 ----
 drivers/media/dvb-frontends/lnbp21.c               | 7 ++-----
 drivers/media/dvb-frontends/lnbp21.h               | 7 ++-----
 drivers/media/dvb-frontends/lnbp22.c               | 7 ++-----
 drivers/media/dvb-frontends/lnbp22.h               | 7 ++-----
 drivers/media/dvb-frontends/mt352.c                | 4 ----
 drivers/media/dvb-frontends/mt352.h                | 4 ----
 drivers/media/dvb-frontends/mt352_priv.h           | 4 ----
 drivers/media/dvb-frontends/nxt200x.c              | 4 ----
 drivers/media/dvb-frontends/nxt200x.h              | 4 ----
 drivers/media/dvb-frontends/or51132.c              | 4 ----
 drivers/media/dvb-frontends/or51132.h              | 4 ----
 drivers/media/dvb-frontends/or51211.c              | 4 ----
 drivers/media/dvb-frontends/or51211.h              | 4 ----
 drivers/media/dvb-frontends/s5h1420.c              | 4 ----
 drivers/media/dvb-frontends/s5h1420.h              | 4 ----
 drivers/media/dvb-frontends/s5h1432.c              | 4 ----
 drivers/media/dvb-frontends/s5h1432.h              | 4 ----
 drivers/media/dvb-frontends/stv0367.c              | 4 ----
 drivers/media/dvb-frontends/stv0367.h              | 4 ----
 drivers/media/dvb-frontends/stv0367_priv.h         | 4 ----
 drivers/media/dvb-frontends/stv0367_regs.h         | 4 ----
 drivers/media/dvb-frontends/stv0900.h              | 4 ----
 drivers/media/dvb-frontends/stv0900_core.c         | 4 ----
 drivers/media/dvb-frontends/stv0900_init.h         | 4 ----
 drivers/media/dvb-frontends/stv0900_priv.h         | 4 ----
 drivers/media/dvb-frontends/stv0900_reg.h          | 4 ----
 drivers/media/dvb-frontends/stv0900_sw.c           | 4 ----
 drivers/media/dvb-frontends/stv6110.c              | 4 ----
 drivers/media/dvb-frontends/stv6110.h              | 4 ----
 drivers/media/dvb-frontends/tda18271c2dd.c         | 8 ++------
 drivers/media/dvb-frontends/tdhd1.h                | 7 ++-----
 drivers/media/dvb-frontends/tua6100.c              | 4 ----
 drivers/media/dvb-frontends/tua6100.h              | 4 ----
 drivers/media/dvb-frontends/zl10036.c              | 4 ----
 drivers/media/dvb-frontends/zl10036.h              | 4 ----
 drivers/media/dvb-frontends/zl10039.c              | 4 ----
 drivers/media/dvb-frontends/zl10353.c              | 4 ----
 drivers/media/dvb-frontends/zl10353.h              | 4 ----
 drivers/media/dvb-frontends/zl10353_priv.h         | 4 ----
 drivers/media/i2c/adp1653.c                        | 5 -----
 drivers/media/i2c/adv7170.c                        | 4 ----
 drivers/media/i2c/adv7175.c                        | 4 ----
 drivers/media/i2c/adv7180.c                        | 4 ----
 drivers/media/i2c/adv7183.c                        | 4 ----
 drivers/media/i2c/adv7183_regs.h                   | 4 ----
 drivers/media/i2c/aptina-pll.c                     | 5 -----
 drivers/media/i2c/aptina-pll.h                     | 5 -----
 drivers/media/i2c/as3645a.c                        | 5 -----
 drivers/media/i2c/bt819.c                          | 4 ----
 drivers/media/i2c/bt856.c                          | 4 ----
 drivers/media/i2c/cs5345.c                         | 4 ----
 drivers/media/i2c/cs53l32a.c                       | 4 ----
 drivers/media/i2c/cx25840/cx25840-audio.c          | 4 ----
 drivers/media/i2c/cx25840/cx25840-core.c           | 4 ----
 drivers/media/i2c/cx25840/cx25840-core.h           | 4 ----
 drivers/media/i2c/cx25840/cx25840-firmware.c       | 4 ----
 drivers/media/i2c/cx25840/cx25840-ir.c             | 5 -----
 drivers/media/i2c/cx25840/cx25840-vbi.c            | 4 ----
 drivers/media/i2c/ir-kbd-i2c.c                     | 4 ----
 drivers/media/i2c/ks0127.c                         | 4 ----
 drivers/media/i2c/ks0127.h                         | 4 ----
 drivers/media/i2c/m52790.c                         | 4 ----
 drivers/media/i2c/msp3400-driver.c                 | 5 -----
 drivers/media/i2c/msp3400-kthreads.c               | 5 -----
 drivers/media/i2c/mt9m032.c                        | 5 -----
 drivers/media/i2c/ov7640.c                         | 4 ----
 drivers/media/i2c/saa7110.c                        | 4 ----
 drivers/media/i2c/saa7115.c                        | 4 ----
 drivers/media/i2c/saa7127.c                        | 4 ----
 drivers/media/i2c/saa717x.c                        | 4 ----
 drivers/media/i2c/saa7185.c                        | 4 ----
 drivers/media/i2c/sony-btf-mpx.c                   | 4 ----
 drivers/media/i2c/tlv320aic23b.c                   | 4 ----
 drivers/media/i2c/tvp514x.c                        | 4 ----
 drivers/media/i2c/tvp514x_regs.h                   | 4 ----
 drivers/media/i2c/tvp7002.c                        | 4 ----
 drivers/media/i2c/tvp7002_reg.h                    | 4 ----
 drivers/media/i2c/tw2804.c                         | 4 ----
 drivers/media/i2c/tw9903.c                         | 4 ----
 drivers/media/i2c/tw9906.c                         | 4 ----
 drivers/media/i2c/uda1342.c                        | 4 ----
 drivers/media/i2c/upd64031a.c                      | 4 ----
 drivers/media/i2c/upd64083.c                       | 5 -----
 drivers/media/i2c/vp27smpx.c                       | 4 ----
 drivers/media/i2c/vpx3220.c                        | 4 ----
 drivers/media/i2c/vs6624.c                         | 4 ----
 drivers/media/i2c/vs6624_regs.h                    | 4 ----
 drivers/media/i2c/wm8739.c                         | 4 ----
 drivers/media/i2c/wm8775.c                         | 4 ----
 drivers/media/media-device.c                       | 4 ----
 drivers/media/media-devnode.c                      | 4 ----
 drivers/media/media-entity.c                       | 4 ----
 drivers/media/pci/bt8xx/bttv-input.c               | 4 ----
 drivers/media/pci/bt8xx/dvb-bt8xx.c                | 4 ----
 drivers/media/pci/bt8xx/dvb-bt8xx.h                | 4 ----
 drivers/media/pci/cx18/cx18-alsa-main.c            | 5 -----
 drivers/media/pci/cx18/cx18-alsa-mixer.c           | 5 -----
 drivers/media/pci/cx18/cx18-alsa-mixer.h           | 5 -----
 drivers/media/pci/cx18/cx18-alsa-pcm.c             | 5 -----
 drivers/media/pci/cx18/cx18-alsa-pcm.h             | 5 -----
 drivers/media/pci/cx18/cx18-alsa.h                 | 5 -----
 drivers/media/pci/cx18/cx18-audio.c                | 5 -----
 drivers/media/pci/cx18/cx18-audio.h                | 5 -----
 drivers/media/pci/cx18/cx18-av-audio.c             | 5 -----
 drivers/media/pci/cx18/cx18-av-core.c              | 5 -----
 drivers/media/pci/cx18/cx18-av-core.h              | 5 -----
 drivers/media/pci/cx18/cx18-av-firmware.c          | 5 -----
 drivers/media/pci/cx18/cx18-av-vbi.c               | 5 -----
 drivers/media/pci/cx18/cx18-cards.c                | 5 -----
 drivers/media/pci/cx18/cx18-cards.h                | 4 ----
 drivers/media/pci/cx18/cx18-controls.c             | 5 -----
 drivers/media/pci/cx18/cx18-driver.c               | 5 -----
 drivers/media/pci/cx18/cx18-driver.h               | 5 -----
 drivers/media/pci/cx18/cx18-dvb.c                  | 4 ----
 drivers/media/pci/cx18/cx18-dvb.h                  | 4 ----
 drivers/media/pci/cx18/cx18-fileops.c              | 5 -----
 drivers/media/pci/cx18/cx18-fileops.h              | 5 -----
 drivers/media/pci/cx18/cx18-firmware.c             | 5 -----
 drivers/media/pci/cx18/cx18-firmware.h             | 5 -----
 drivers/media/pci/cx18/cx18-gpio.c                 | 5 -----
 drivers/media/pci/cx18/cx18-gpio.h                 | 4 ----
 drivers/media/pci/cx18/cx18-i2c.c                  | 5 -----
 drivers/media/pci/cx18/cx18-i2c.h                  | 5 -----
 drivers/media/pci/cx18/cx18-io.c                   | 5 -----
 drivers/media/pci/cx18/cx18-io.h                   | 5 -----
 drivers/media/pci/cx18/cx18-ioctl.c                | 5 -----
 drivers/media/pci/cx18/cx18-ioctl.h                | 5 -----
 drivers/media/pci/cx18/cx18-irq.c                  | 5 -----
 drivers/media/pci/cx18/cx18-irq.h                  | 5 -----
 drivers/media/pci/cx18/cx18-mailbox.c              | 5 -----
 drivers/media/pci/cx18/cx18-mailbox.h              | 5 -----
 drivers/media/pci/cx18/cx18-queue.c                | 5 -----
 drivers/media/pci/cx18/cx18-queue.h                | 5 -----
 drivers/media/pci/cx18/cx18-scb.c                  | 5 -----
 drivers/media/pci/cx18/cx18-scb.h                  | 5 -----
 drivers/media/pci/cx18/cx18-streams.c              | 5 -----
 drivers/media/pci/cx18/cx18-streams.h              | 5 -----
 drivers/media/pci/cx18/cx18-vbi.c                  | 5 -----
 drivers/media/pci/cx18/cx18-vbi.h                  | 5 -----
 drivers/media/pci/cx18/cx18-version.h              | 5 -----
 drivers/media/pci/cx18/cx18-video.c                | 5 -----
 drivers/media/pci/cx18/cx18-video.h                | 5 -----
 drivers/media/pci/cx18/cx23418.h                   | 5 -----
 drivers/media/pci/cx25821/cx25821-alsa.c           | 4 ----
 drivers/media/pci/cx25821/cx25821-audio-upstream.c | 4 ----
 drivers/media/pci/cx25821/cx25821-audio-upstream.h | 4 ----
 drivers/media/pci/cx25821/cx25821-audio.h          | 4 ----
 drivers/media/pci/cx25821/cx25821-biffuncs.h       | 4 ----
 drivers/media/pci/cx25821/cx25821-cards.c          | 4 ----
 drivers/media/pci/cx25821/cx25821-core.c           | 4 ----
 drivers/media/pci/cx25821/cx25821-gpio.c           | 4 ----
 drivers/media/pci/cx25821/cx25821-i2c.c            | 4 ----
 drivers/media/pci/cx25821/cx25821-medusa-defines.h | 4 ----
 drivers/media/pci/cx25821/cx25821-medusa-reg.h     | 4 ----
 drivers/media/pci/cx25821/cx25821-medusa-video.c   | 4 ----
 drivers/media/pci/cx25821/cx25821-medusa-video.h   | 4 ----
 drivers/media/pci/cx25821/cx25821-reg.h            | 4 ----
 drivers/media/pci/cx25821/cx25821-sram.h           | 4 ----
 drivers/media/pci/cx25821/cx25821-video-upstream.c | 4 ----
 drivers/media/pci/cx25821/cx25821-video-upstream.h | 4 ----
 drivers/media/pci/cx25821/cx25821-video.c          | 4 ----
 drivers/media/pci/cx25821/cx25821-video.h          | 4 ----
 drivers/media/pci/cx25821/cx25821.h                | 4 ----
 drivers/media/pci/ddbridge/ddbridge-core.c         | 8 ++------
 drivers/media/pci/ddbridge/ddbridge-regs.h         | 8 ++------
 drivers/media/pci/ddbridge/ddbridge.h              | 8 ++------
 drivers/media/pci/dm1105/dm1105.c                  | 4 ----
 drivers/media/pci/ivtv/ivtv-alsa-main.c            | 5 -----
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c           | 5 -----
 drivers/media/pci/ivtv/ivtv-alsa-mixer.h           | 5 -----
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             | 5 -----
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h             | 5 -----
 drivers/media/pci/ivtv/ivtv-alsa.h                 | 5 -----
 drivers/media/pci/meye/meye.c                      | 4 ----
 drivers/media/pci/meye/meye.h                      | 4 ----
 drivers/media/pci/ngene/ngene-cards.c              | 8 ++------
 drivers/media/pci/ngene/ngene-core.c               | 8 ++------
 drivers/media/pci/ngene/ngene-dvb.c                | 8 ++------
 drivers/media/pci/ngene/ngene-i2c.c                | 8 ++------
 drivers/media/pci/ngene/ngene.h                    | 8 ++------
 drivers/media/pci/pluto2/pluto2.c                  | 4 ----
 drivers/media/pci/pt1/pt1.c                        | 4 ----
 drivers/media/pci/pt1/va1j5jf8007s.c               | 4 ----
 drivers/media/pci/pt1/va1j5jf8007s.h               | 4 ----
 drivers/media/pci/pt1/va1j5jf8007t.c               | 4 ----
 drivers/media/pci/pt1/va1j5jf8007t.h               | 4 ----
 drivers/media/pci/saa7134/saa7134-alsa.c           | 4 ----
 drivers/media/pci/saa7134/saa7134-cards.c          | 4 ----
 drivers/media/pci/saa7134/saa7134-core.c           | 4 ----
 drivers/media/pci/saa7134/saa7134-dvb.c            | 4 ----
 drivers/media/pci/saa7134/saa7134-empress.c        | 4 ----
 drivers/media/pci/saa7134/saa7134-i2c.c            | 4 ----
 drivers/media/pci/saa7134/saa7134-input.c          | 4 ----
 drivers/media/pci/saa7134/saa7134-ts.c             | 4 ----
 drivers/media/pci/saa7134/saa7134-tvaudio.c        | 4 ----
 drivers/media/pci/saa7134/saa7134-vbi.c            | 4 ----
 drivers/media/pci/saa7134/saa7134-video.c          | 4 ----
 drivers/media/pci/saa7134/saa7134.h                | 4 ----
 drivers/media/pci/saa7164/saa7164-api.c            | 4 ----
 drivers/media/pci/saa7164/saa7164-buffer.c         | 4 ----
 drivers/media/pci/saa7164/saa7164-bus.c            | 4 ----
 drivers/media/pci/saa7164/saa7164-cards.c          | 4 ----
 drivers/media/pci/saa7164/saa7164-cmd.c            | 4 ----
 drivers/media/pci/saa7164/saa7164-core.c           | 4 ----
 drivers/media/pci/saa7164/saa7164-dvb.c            | 4 ----
 drivers/media/pci/saa7164/saa7164-encoder.c        | 4 ----
 drivers/media/pci/saa7164/saa7164-fw.c             | 4 ----
 drivers/media/pci/saa7164/saa7164-i2c.c            | 4 ----
 drivers/media/pci/saa7164/saa7164-reg.h            | 4 ----
 drivers/media/pci/saa7164/saa7164-types.h          | 4 ----
 drivers/media/pci/saa7164/saa7164-vbi.c            | 4 ----
 drivers/media/pci/saa7164/saa7164.h                | 4 ----
 drivers/media/pci/sta2x11/sta2x11_vip.h            | 4 ----
 drivers/media/pci/ttpci/av7110.c                   | 7 ++-----
 drivers/media/pci/ttpci/av7110_av.c                | 7 ++-----
 drivers/media/pci/ttpci/av7110_ca.c                | 7 ++-----
 drivers/media/pci/ttpci/av7110_hw.c                | 7 ++-----
 drivers/media/pci/ttpci/av7110_ir.c                | 7 ++-----
 drivers/media/pci/ttpci/av7110_v4l.c               | 7 ++-----
 drivers/media/pci/ttpci/budget-av.c                | 7 ++-----
 drivers/media/pci/ttpci/budget-ci.c                | 7 ++-----
 drivers/media/pci/ttpci/budget-core.c              | 7 ++-----
 drivers/media/pci/ttpci/budget-patch.c             | 7 ++-----
 drivers/media/pci/ttpci/budget.c                   | 7 ++-----
 drivers/media/pci/ttpci/dvb_filter.h               | 4 ----
 drivers/media/pci/zoran/videocodec.c               | 4 ----
 drivers/media/pci/zoran/videocodec.h               | 4 ----
 drivers/media/pci/zoran/zoran.h                    | 4 ----
 drivers/media/pci/zoran/zoran_card.c               | 4 ----
 drivers/media/pci/zoran/zoran_card.h               | 4 ----
 drivers/media/pci/zoran/zoran_device.c             | 4 ----
 drivers/media/pci/zoran/zoran_device.h             | 4 ----
 drivers/media/pci/zoran/zoran_driver.c             | 4 ----
 drivers/media/pci/zoran/zoran_procfs.c             | 4 ----
 drivers/media/pci/zoran/zoran_procfs.h             | 4 ----
 drivers/media/pci/zoran/zr36016.c                  | 4 ----
 drivers/media/pci/zoran/zr36016.h                  | 4 ----
 drivers/media/pci/zoran/zr36050.c                  | 4 ----
 drivers/media/pci/zoran/zr36050.h                  | 4 ----
 drivers/media/pci/zoran/zr36057.h                  | 4 ----
 drivers/media/pci/zoran/zr36060.c                  | 4 ----
 drivers/media/pci/zoran/zr36060.h                  | 4 ----
 drivers/media/platform/blackfin/bfin_capture.c     | 4 ----
 drivers/media/platform/blackfin/ppi.c              | 4 ----
 drivers/media/platform/davinci/ccdc_hw_device.h    | 4 ----
 drivers/media/platform/davinci/dm355_ccdc.c        | 4 ----
 drivers/media/platform/davinci/dm355_ccdc_regs.h   | 4 ----
 drivers/media/platform/davinci/dm644x_ccdc.c       | 4 ----
 drivers/media/platform/davinci/dm644x_ccdc_regs.h  | 4 ----
 drivers/media/platform/davinci/isif.c              | 4 ----
 drivers/media/platform/davinci/isif_regs.h         | 4 ----
 drivers/media/platform/davinci/vpbe.c              | 4 ----
 drivers/media/platform/davinci/vpbe_osd.c          | 4 ----
 drivers/media/platform/davinci/vpbe_osd_regs.h     | 4 ----
 drivers/media/platform/davinci/vpbe_venc.c         | 4 ----
 drivers/media/platform/davinci/vpbe_venc_regs.h    | 4 ----
 drivers/media/platform/davinci/vpfe_capture.c      | 4 ----
 drivers/media/platform/davinci/vpif_capture.c      | 4 ----
 drivers/media/platform/davinci/vpif_capture.h      | 4 ----
 drivers/media/platform/davinci/vpss.c              | 4 ----
 drivers/media/radio/dsbr100.c                      | 4 ----
 drivers/media/radio/radio-isa.c                    | 5 -----
 drivers/media/radio/radio-isa.h                    | 5 -----
 drivers/media/radio/radio-keene.c                  | 4 ----
 drivers/media/radio/radio-ma901.c                  | 4 ----
 drivers/media/radio/radio-mr800.c                  | 4 ----
 drivers/media/radio/radio-shark.c                  | 4 ----
 drivers/media/radio/radio-shark2.c                 | 4 ----
 drivers/media/radio/radio-tea5764.c                | 4 ----
 drivers/media/radio/radio-tea5777.c                | 4 ----
 drivers/media/radio/radio-tea5777.h                | 4 ----
 drivers/media/radio/radio-timb.c                   | 4 ----
 drivers/media/radio/radio-wl1273.c                 | 4 ----
 drivers/media/radio/saa7706h.c                     | 4 ----
 drivers/media/radio/si470x/radio-si470x-common.c   | 4 ----
 drivers/media/radio/si470x/radio-si470x-i2c.c      | 4 ----
 drivers/media/radio/si470x/radio-si470x-usb.c      | 4 ----
 drivers/media/radio/si470x/radio-si470x.h          | 4 ----
 drivers/media/radio/si4713/radio-platform-si4713.c | 4 ----
 drivers/media/radio/si4713/si4713.c                | 4 ----
 drivers/media/radio/tef6862.c                      | 4 ----
 drivers/media/radio/wl128x/fmdrv.h                 | 4 ----
 drivers/media/radio/wl128x/fmdrv_common.c          | 4 ----
 drivers/media/radio/wl128x/fmdrv_common.h          | 4 ----
 drivers/media/radio/wl128x/fmdrv_rx.c              | 4 ----
 drivers/media/radio/wl128x/fmdrv_rx.h              | 4 ----
 drivers/media/radio/wl128x/fmdrv_tx.c              | 4 ----
 drivers/media/radio/wl128x/fmdrv_tx.h              | 4 ----
 drivers/media/radio/wl128x/fmdrv_v4l2.c            | 4 ----
 drivers/media/radio/wl128x/fmdrv_v4l2.h            | 4 ----
 drivers/media/rc/ati_remote.c                      | 4 ----
 drivers/media/rc/ene_ir.c                          | 5 -----
 drivers/media/rc/ene_ir.h                          | 5 -----
 drivers/media/rc/fintek-cir.c                      | 5 -----
 drivers/media/rc/fintek-cir.h                      | 5 -----
 drivers/media/rc/iguanair.c                        | 4 ----
 drivers/media/rc/imon.c                            | 4 ----
 drivers/media/rc/ite-cir.c                         | 5 -----
 drivers/media/rc/ite-cir.h                         | 5 -----
 drivers/media/rc/keymaps/rc-technisat-usb2.c       | 4 ----
 drivers/media/rc/lirc_dev.c                        | 4 ----
 drivers/media/rc/mceusb.c                          | 4 ----
 drivers/media/rc/nuvoton-cir.c                     | 5 -----
 drivers/media/rc/nuvoton-cir.h                     | 5 -----
 drivers/media/rc/rc-loopback.c                     | 4 ----
 drivers/media/rc/redrat3.c                         | 4 ----
 drivers/media/rc/streamzap.c                       | 4 ----
 drivers/media/rc/ttusbir.c                         | 4 ----
 drivers/media/rc/winbond-cir.c                     | 4 ----
 drivers/media/tuners/fc0011.c                      | 4 ----
 drivers/media/tuners/fc0012-priv.h                 | 4 ----
 drivers/media/tuners/fc0012.c                      | 4 ----
 drivers/media/tuners/fc0012.h                      | 4 ----
 drivers/media/tuners/fc0013-priv.h                 | 4 ----
 drivers/media/tuners/fc0013.c                      | 4 ----
 drivers/media/tuners/fc0013.h                      | 4 ----
 drivers/media/tuners/fc001x-common.h               | 4 ----
 drivers/media/tuners/it913x.c                      | 4 ----
 drivers/media/tuners/it913x.h                      | 4 ----
 drivers/media/tuners/max2165.c                     | 4 ----
 drivers/media/tuners/max2165.h                     | 4 ----
 drivers/media/tuners/max2165_priv.h                | 4 ----
 drivers/media/tuners/mc44s803.c                    | 4 ----
 drivers/media/tuners/mc44s803.h                    | 4 ----
 drivers/media/tuners/mc44s803_priv.h               | 4 ----
 drivers/media/tuners/mt2060.c                      | 4 ----
 drivers/media/tuners/mt2060.h                      | 4 ----
 drivers/media/tuners/mt2060_priv.h                 | 4 ----
 drivers/media/tuners/mt2131.c                      | 4 ----
 drivers/media/tuners/mt2131.h                      | 4 ----
 drivers/media/tuners/mt2131_priv.h                 | 4 ----
 drivers/media/tuners/mxl5007t.c                    | 4 ----
 drivers/media/tuners/mxl5007t.h                    | 4 ----
 drivers/media/tuners/qt1010.c                      | 4 ----
 drivers/media/tuners/qt1010.h                      | 4 ----
 drivers/media/tuners/qt1010_priv.h                 | 4 ----
 drivers/media/tuners/tda18218.c                    | 4 ----
 drivers/media/tuners/tda18218.h                    | 4 ----
 drivers/media/tuners/tda18218_priv.h               | 4 ----
 drivers/media/tuners/tda827x.c                     | 4 ----
 drivers/media/tuners/xc4000.c                      | 4 ----
 drivers/media/tuners/xc4000.h                      | 4 ----
 drivers/media/tuners/xc5000.c                      | 4 ----
 drivers/media/tuners/xc5000.h                      | 4 ----
 drivers/media/usb/au0828/au0828-cards.c            | 4 ----
 drivers/media/usb/au0828/au0828-cards.h            | 4 ----
 drivers/media/usb/au0828/au0828-core.c             | 4 ----
 drivers/media/usb/au0828/au0828-dvb.c              | 4 ----
 drivers/media/usb/au0828/au0828-i2c.c              | 4 ----
 drivers/media/usb/au0828/au0828-reg.h              | 4 ----
 drivers/media/usb/au0828/au0828-video.c            | 5 -----
 drivers/media/usb/au0828/au0828.h                  | 4 ----
 drivers/media/usb/cpia2/cpia2.h                    | 4 ----
 drivers/media/usb/cpia2/cpia2_core.c               | 4 ----
 drivers/media/usb/cpia2/cpia2_registers.h          | 4 ----
 drivers/media/usb/cpia2/cpia2_usb.c                | 4 ----
 drivers/media/usb/cpia2/cpia2_v4l.c                | 4 ----
 drivers/media/usb/cx231xx/cx231xx-417.c            | 4 ----
 drivers/media/usb/cx231xx/cx231xx-audio.c          | 4 ----
 drivers/media/usb/cx231xx/cx231xx-dif.h            | 4 ----
 drivers/media/usb/dvb-usb-v2/af9015.c              | 4 ----
 drivers/media/usb/dvb-usb-v2/af9015.h              | 4 ----
 drivers/media/usb/dvb-usb-v2/anysee.c              | 4 ----
 drivers/media/usb/dvb-usb-v2/anysee.h              | 4 ----
 drivers/media/usb/dvb-usb-v2/au6610.c              | 4 ----
 drivers/media/usb/dvb-usb-v2/au6610.h              | 4 ----
 drivers/media/usb/dvb-usb-v2/ce6230.c              | 4 ----
 drivers/media/usb/dvb-usb-v2/ce6230.h              | 4 ----
 drivers/media/usb/dvb-usb-v2/dvbsky.c              | 4 ----
 drivers/media/usb/dvb-usb-v2/ec168.c               | 4 ----
 drivers/media/usb/dvb-usb-v2/ec168.h               | 4 ----
 drivers/media/usb/dvb-usb-v2/lmedm04.c             | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c      | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h      | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c       | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h       | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c        | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h        | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c        | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h        | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h        | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c      | 4 ----
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h      | 4 ----
 drivers/media/usb/dvb-usb/af9005-fe.c              | 4 ----
 drivers/media/usb/dvb-usb/af9005-remote.c          | 4 ----
 drivers/media/usb/dvb-usb/af9005.c                 | 4 ----
 drivers/media/usb/dvb-usb/af9005.h                 | 4 ----
 drivers/media/usb/dvb-usb/cinergyT2-core.c         | 4 ----
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           | 4 ----
 drivers/media/usb/dvb-usb/cinergyT2.h              | 4 ----
 drivers/media/usb/dvb-usb/dtv5100.c                | 4 ----
 drivers/media/usb/dvb-usb/dtv5100.h                | 4 ----
 drivers/media/usb/dvb-usb/technisat-usb2.c         | 4 ----
 drivers/media/usb/em28xx/em28xx-audio.c            | 4 ----
 drivers/media/usb/gspca/autogain_functions.c       | 4 ----
 drivers/media/usb/gspca/benq.c                     | 4 ----
 drivers/media/usb/gspca/conex.c                    | 4 ----
 drivers/media/usb/gspca/cpia1.c                    | 4 ----
 drivers/media/usb/gspca/etoms.c                    | 4 ----
 drivers/media/usb/gspca/finepix.c                  | 4 ----
 drivers/media/usb/gspca/gspca.c                    | 4 ----
 drivers/media/usb/gspca/jeilinj.c                  | 4 ----
 drivers/media/usb/gspca/jl2005bcd.c                | 4 ----
 drivers/media/usb/gspca/jpeg.h                     | 4 ----
 drivers/media/usb/gspca/kinect.c                   | 4 ----
 drivers/media/usb/gspca/konica.c                   | 4 ----
 drivers/media/usb/gspca/mars.c                     | 4 ----
 drivers/media/usb/gspca/mr97310a.c                 | 4 ----
 drivers/media/usb/gspca/nw80x.c                    | 4 ----
 drivers/media/usb/gspca/ov519.c                    | 4 ----
 drivers/media/usb/gspca/ov534.c                    | 4 ----
 drivers/media/usb/gspca/ov534_9.c                  | 4 ----
 drivers/media/usb/gspca/pac207.c                   | 4 ----
 drivers/media/usb/gspca/pac7302.c                  | 4 ----
 drivers/media/usb/gspca/pac7311.c                  | 4 ----
 drivers/media/usb/gspca/pac_common.h               | 4 ----
 drivers/media/usb/gspca/se401.c                    | 4 ----
 drivers/media/usb/gspca/se401.h                    | 4 ----
 drivers/media/usb/gspca/sn9c2028.c                 | 4 ----
 drivers/media/usb/gspca/sn9c2028.h                 | 4 ----
 drivers/media/usb/gspca/sn9c20x.c                  | 4 ----
 drivers/media/usb/gspca/sonixb.c                   | 4 ----
 drivers/media/usb/gspca/sonixj.c                   | 4 ----
 drivers/media/usb/gspca/spca1528.c                 | 4 ----
 drivers/media/usb/gspca/spca500.c                  | 4 ----
 drivers/media/usb/gspca/spca501.c                  | 4 ----
 drivers/media/usb/gspca/spca505.c                  | 4 ----
 drivers/media/usb/gspca/spca506.c                  | 4 ----
 drivers/media/usb/gspca/spca508.c                  | 4 ----
 drivers/media/usb/gspca/spca561.c                  | 4 ----
 drivers/media/usb/gspca/sq905.c                    | 4 ----
 drivers/media/usb/gspca/sq905c.c                   | 4 ----
 drivers/media/usb/gspca/sq930x.c                   | 4 ----
 drivers/media/usb/gspca/stk014.c                   | 4 ----
 drivers/media/usb/gspca/stk1135.c                  | 4 ----
 drivers/media/usb/gspca/stk1135.h                  | 4 ----
 drivers/media/usb/gspca/stv0680.c                  | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx.c          | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx.h          | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c     | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h     | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h   | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h   | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c   | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_st6422.h   | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c   | 4 ----
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.h   | 4 ----
 drivers/media/usb/gspca/sunplus.c                  | 4 ----
 drivers/media/usb/gspca/t613.c                     | 4 ----
 drivers/media/usb/gspca/tv8532.c                   | 4 ----
 drivers/media/usb/gspca/vc032x.c                   | 4 ----
 drivers/media/usb/gspca/vicam.c                    | 4 ----
 drivers/media/usb/gspca/w996Xcf.c                  | 4 ----
 drivers/media/usb/gspca/xirlink_cit.c              | 4 ----
 drivers/media/usb/gspca/zc3xx.c                    | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-audio.c          | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-audio.h          | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-context.c        | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-context.h        | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c       | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h       | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.c           | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-ctrl.h           | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c    | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h    | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-debug.h          | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c       | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.h       | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c        | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-devattr.h        | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-dvb.c            | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c         | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.h         | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c        | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-encoder.h        | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h        | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h   | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h            | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h       | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-io.c             | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-io.h             | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c         | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-ioread.h         | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-main.c           | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-std.c            | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-std.h            | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.c          | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-sysfs.h          | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-util.h           | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.h           | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c      | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h      | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c         | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.h         | 4 ----
 drivers/media/usb/pvrusb2/pvrusb2.h                | 4 ----
 drivers/media/usb/s2255/s2255drv.c                 | 4 ----
 drivers/media/usb/stkwebcam/stk-sensor.c           | 4 ----
 drivers/media/usb/stkwebcam/stk-webcam.c           | 4 ----
 drivers/media/usb/stkwebcam/stk-webcam.h           | 4 ----
 drivers/media/usb/tm6000/tm6000-cards.c            | 4 ----
 drivers/media/usb/tm6000/tm6000-core.c             | 4 ----
 drivers/media/usb/tm6000/tm6000-dvb.c              | 4 ----
 drivers/media/usb/tm6000/tm6000-i2c.c              | 4 ----
 drivers/media/usb/tm6000/tm6000-input.c            | 4 ----
 drivers/media/usb/tm6000/tm6000-regs.h             | 4 ----
 drivers/media/usb/tm6000/tm6000-stds.c             | 4 ----
 drivers/media/usb/tm6000/tm6000-usb-isoc.h         | 4 ----
 drivers/media/usb/tm6000/tm6000-video.c            | 4 ----
 drivers/media/usb/tm6000/tm6000.h                  | 4 ----
 drivers/media/usb/ttusb-dec/ttusb_dec.c            | 4 ----
 drivers/media/usb/ttusb-dec/ttusbdecfe.c           | 4 ----
 drivers/media/usb/ttusb-dec/ttusbdecfe.h           | 4 ----
 drivers/media/usb/usbvision/usbvision-cards.c      | 4 ----
 drivers/media/usb/usbvision/usbvision-core.c       | 4 ----
 drivers/media/usb/usbvision/usbvision-i2c.c        | 4 ----
 drivers/media/usb/usbvision/usbvision-video.c      | 4 ----
 drivers/media/usb/usbvision/usbvision.h            | 4 ----
 drivers/media/usb/zr364xx/zr364xx.c                | 4 ----
 drivers/media/v4l2-core/v4l2-event.c               | 5 -----
 drivers/media/v4l2-core/v4l2-fh.c                  | 5 -----
 drivers/media/v4l2-core/v4l2-subdev.c              | 4 ----
 include/media/blackfin/ppi.h                       | 4 ----
 include/media/davinci/ccdc_types.h                 | 4 ----
 include/media/davinci/dm355_ccdc.h                 | 4 ----
 include/media/davinci/dm644x_ccdc.h                | 4 ----
 include/media/davinci/isif.h                       | 4 ----
 include/media/davinci/vpbe.h                       | 4 ----
 include/media/davinci/vpbe_osd.h                   | 4 ----
 include/media/davinci/vpbe_types.h                 | 4 ----
 include/media/davinci/vpbe_venc.h                  | 4 ----
 include/media/davinci/vpfe_capture.h               | 4 ----
 include/media/davinci/vpfe_types.h                 | 4 ----
 include/media/davinci/vpif_types.h                 | 4 ----
 include/media/davinci/vpss.h                       | 4 ----
 include/media/drv-intf/tea575x.h                   | 4 ----
 include/media/i2c/adp1653.h                        | 5 -----
 include/media/i2c/adv7183.h                        | 4 ----
 include/media/i2c/as3645a.h                        | 5 -----
 include/media/i2c/lm3560.h                         | 5 -----
 include/media/i2c/mt9m032.h                        | 5 -----
 include/media/i2c/smiapp.h                         | 5 -----
 include/media/i2c/ths7303.h                        | 4 ----
 include/media/i2c/tvp514x.h                        | 4 ----
 include/media/i2c/tvp7002.h                        | 4 ----
 include/media/i2c/upd64031a.h                      | 4 ----
 include/media/i2c/upd64083.h                       | 4 ----
 include/media/media-device.h                       | 4 ----
 include/media/media-devnode.h                      | 4 ----
 include/media/media-entity.h                       | 4 ----
 include/media/v4l2-event.h                         | 5 -----
 include/media/v4l2-fh.h                            | 5 -----
 627 files changed, 82 insertions(+), 2644 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
