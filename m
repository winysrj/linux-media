Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49814 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbeADS0v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 13:26:51 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2]  Cleanup bad whitespaces along media tree
Date: Thu,  4 Jan 2018 13:26:40 -0500
Message-Id: <cover.1515089828.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From time to time, bad whitespaces end by being merged at the tree.
Instead of taking lots of individual patches fixing them, it is a way better
to remove them at once. That's what this patch series does.

Both use the script below. The first patch was made using it at its
"standard" mode, with checks only for identations, whitespaces at the
end and comments like " *<space><tab>".

The second one was generated using "--spacetab" with looks specifically for
"<space><tab>" patterns.

This script has other modes, but they aren't used, as the goal here is not to
replace all spaces by tabs. Just to fix the ones that violate our coding style.

#!/usr/bin/perl
use Getopt::Long;
use strict;
use autodie;
use Text::Tabs;

my $hard;
my $harder;
my $notab;
my $help;
my $diffmode;
my $spacetab;

GetOptions(
	    "--hard" => \$hard,
	    "--harder" => \$harder,
	    "--spacetab" => \$spacetab,
	    "--notabremoval" => \$notab,
	    "--help" => \$help,
	    "--diff" => \$diffmode);

$help = 1 if ($#ARGV < 0);

print "Usage: $ARGV[0] [--help] [--hard] [--spacetab] [--notabremoval] [--diff] files\n" if ($help);
print "Hard algorithm for remove spaces. May unalign spaces.\n" if ($hard);
print "Working with diff files\n" if ($diffmode);

foreach my $argnum (0 .. $#ARGV) {
	my $changed = 0;
	my $file=$ARGV[$argnum];

	my ($dev,$ino,$mode) = stat($file);

	open IN, "<$file";
	open OUT, ">$file.new";
	while (<IN>) {
		if ($diffmode) {
			if (!(/^[\+][^\+]/)) {
				print OUT $_;
 				next;
			}
			s,^[\+],,;
		}

		my $prev = $_;
		s/[ \t]+$//;
		s<^ {8}> <\t> if (!$notab);
		s<^ {1,7}\t> <\t> if (!$notab);
		s<^ \* {1,4}\t> < *\t>; # Handle Kernel-doc comments

		if ($spacetab) {
			while (m/^(.*)( +\t)/g) {
				my $t = expand($1);
				my ($o, $s) = ($2, $2);				

				my $pos = length($t) - 1;
				my $p = 7 - ($pos % 8);
#printf STDERR "pos $pos, tabstop up to $p\n$_";
				if (!$p) {
					$s =~ s<^ {1,7}> <>;
				} else {
					my $p1 = $p - 1;
					$s =~ s<\ {1,$p1}> <>;
					$s =~ s<\ {$p,7}> <\t>;
				}
				$s =~ s/\t {8}/\t\t/g;
				s/($o)/$s/;
#print STDERR $_;
			}
		}

		s< {1,7}\t> <\t> if ($hard);
		$_ = unexpand($_) if ($harder);

		if (!$notab) {
			while( s<\t {8}> <\t\t>g || s<\t {1,7}\t> <\t\t>g ) {}
		}

		$_ = "+$_" if ($diffmode);

		print OUT $_;

		$changed = 1 if ($prev ne $_);
	}
	close IN;
	close OUT;
	rename "$file.new", $file;

	chmod $mode, $file;

	print "whitespaces cleaned on $file\n" if ($changed);
}


Mauro Carvalho Chehab (2):
  media: fix usage of whitespaces and on indentation
  media: replace all <spaces><tab> occurrences

 drivers/media/Kconfig                              |   8 +-
 drivers/media/common/saa7146/saa7146_video.c       |   8 +-
 drivers/media/dvb-core/Makefile                    |   4 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |   2 +-
 drivers/media/dvb-frontends/au8522_priv.h          | 218 ++++++++---------
 drivers/media/dvb-frontends/cx24116.c              |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        |   2 +-
 drivers/media/dvb-frontends/drxk.h                 |   6 +-
 drivers/media/dvb-frontends/mb86a20s.c             |   2 +-
 drivers/media/dvb-frontends/mn88473.c              |   2 +-
 drivers/media/dvb-frontends/stb0899_drv.c          |  10 +-
 drivers/media/dvb-frontends/stb0899_drv.h          |   2 +-
 drivers/media/dvb-frontends/stb0899_priv.h         |   2 +-
 drivers/media/dvb-frontends/stv0900_core.c         |   2 +-
 drivers/media/dvb-frontends/stv0900_init.h         |  34 +--
 drivers/media/dvb-frontends/stv0900_priv.h         |   2 +-
 drivers/media/dvb-frontends/stv090x.c              |  12 +-
 drivers/media/dvb-frontends/stv090x_priv.h         |   2 +-
 drivers/media/dvb-frontends/stv6110x.c             |   2 +-
 drivers/media/dvb-frontends/stv6110x_priv.h        |   6 +-
 drivers/media/dvb-frontends/tda10023.c             |   2 +-
 drivers/media/dvb-frontends/tda18271c2dd.h         |   4 +-
 drivers/media/firewire/firedtv-avc.c               |   4 +-
 drivers/media/firewire/firedtv-fe.c                |   6 +-
 drivers/media/i2c/Kconfig                          |  10 +-
 drivers/media/i2c/adv7343.c                        |   2 +-
 drivers/media/i2c/adv7393.c                        |   2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   8 +-
 drivers/media/i2c/cx25840/cx25840-core.h           |   2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |   6 +-
 drivers/media/i2c/ks0127.c                         |   2 +-
 drivers/media/i2c/ov7670.c                         |  38 +--
 drivers/media/i2c/saa6752hs.c                      |   8 +-
 drivers/media/i2c/saa7115.c                        |   2 +-
 drivers/media/i2c/saa7127.c                        | 162 ++++++-------
 drivers/media/i2c/saa717x.c                        |  12 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   2 +-
 drivers/media/i2c/ths7303.c                        |   2 +-
 drivers/media/i2c/tvaudio.c                        |   2 +-
 drivers/media/i2c/tvp5150_reg.h                    |   4 +-
 drivers/media/i2c/tvp7002_reg.h                    |   6 +-
 drivers/media/i2c/vpx3220.c                        |   2 +-
 drivers/media/pci/bt8xx/bttv-cards.c               | 266 ++++++++++-----------
 drivers/media/pci/bt8xx/bttv-input.c               |   8 +-
 drivers/media/pci/bt8xx/bttv.h                     |   4 +-
 drivers/media/pci/bt8xx/bttvp.h                    |   6 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c             |   2 +-
 drivers/media/pci/cx18/cx18-av-audio.c             |   2 +-
 drivers/media/pci/cx18/cx18-av-core.c              |  18 +-
 drivers/media/pci/cx18/cx18-av-core.h              |   2 +-
 drivers/media/pci/cx18/cx18-cards.c                |   8 +-
 drivers/media/pci/cx18/cx18-cards.h                |  32 +--
 drivers/media/pci/cx18/cx18-driver.h               |  46 ++--
 drivers/media/pci/cx18/cx18-fileops.c              |   2 +-
 drivers/media/pci/cx18/cx18-firmware.c             |  88 +++----
 drivers/media/pci/cx18/cx18-mailbox.c              |   8 +-
 drivers/media/pci/cx18/cx18-streams.c              |   4 +-
 drivers/media/pci/cx18/cx18-vbi.c                  |   2 +-
 drivers/media/pci/cx18/cx23418.h                   |  86 +++----
 drivers/media/pci/cx23885/cimax2.c                 |   2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   2 +-
 drivers/media/pci/cx23885/cx23885.h                |   4 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |   6 +-
 drivers/media/pci/ivtv/ivtv-cards.c                |   2 +-
 drivers/media/pci/ivtv/ivtv-cards.h                | 126 +++++-----
 drivers/media/pci/ivtv/ivtv-driver.h               | 102 ++++----
 drivers/media/pci/ivtv/ivtv-firmware.c             |  34 +--
 drivers/media/pci/ivtv/ivtv-i2c.c                  |  26 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |  74 +++---
 drivers/media/pci/ivtv/ivtv-mailbox.c              | 182 +++++++-------
 drivers/media/pci/mantis/mantis_reg.h              |   6 +-
 drivers/media/pci/mantis/mantis_vp1041.c           | 210 ++++++++--------
 drivers/media/pci/meye/meye.c                      |   2 +-
 drivers/media/pci/pluto2/pluto2.c                  |   2 +-
 drivers/media/pci/pt1/pt1.c                        |   2 +-
 drivers/media/pci/pt1/va1j5jf8007s.c               |   2 +-
 drivers/media/pci/pt1/va1j5jf8007s.h               |   2 +-
 drivers/media/pci/pt1/va1j5jf8007t.c               |   2 +-
 drivers/media/pci/pt1/va1j5jf8007t.h               |   2 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |  64 ++---
 drivers/media/pci/saa7134/saa7134-dvb.c            |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   4 +-
 drivers/media/pci/saa7134/saa7134.h                |   8 +-
 drivers/media/pci/saa7146/hexium_gemini.c          |  22 +-
 drivers/media/pci/saa7146/hexium_orion.c           |  18 +-
 drivers/media/pci/saa7146/mxb.c                    |  26 +-
 drivers/media/pci/ttpci/av7110.h                   |   2 +-
 drivers/media/pci/ttpci/budget-av.c                |   6 +-
 drivers/media/pci/ttpci/budget-ci.c                | 210 ++++++++--------
 drivers/media/pci/tw5864/tw5864-video.c            |   2 +-
 drivers/media/pci/zoran/zoran_driver.c             |  38 +--
 drivers/media/pci/zoran/zr36057.h                  |   4 +-
 drivers/media/platform/Kconfig                     |  38 +--
 drivers/media/platform/Makefile                    |  14 +-
 drivers/media/platform/arv.c                       |  54 ++---
 drivers/media/platform/blackfin/ppi.c              |   2 +-
 drivers/media/platform/coda/coda_regs.h            |   2 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |   4 +-
 drivers/media/platform/davinci/dm355_ccdc_regs.h   |   6 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |   6 +-
 drivers/media/platform/davinci/dm644x_ccdc_regs.h  |   4 +-
 drivers/media/platform/davinci/isif_regs.h         |   6 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   8 +-
 drivers/media/platform/davinci/vpif.h              |   4 +-
 drivers/media/platform/davinci/vpss.c              |  10 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |   2 +-
 drivers/media/platform/exynos4-is/fimc-core.h      |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h      |   4 +-
 drivers/media/platform/m2m-deinterlace.c           |  12 +-
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h    |   2 +-
 drivers/media/platform/omap/omap_vout.c            |  12 +-
 drivers/media/platform/omap3isp/isp.c              |   2 +-
 drivers/media/platform/sh_vou.c                    |   2 +-
 drivers/media/platform/sti/hva/hva.h               |   2 +-
 drivers/media/platform/via-camera.h                |   2 +-
 drivers/media/radio/radio-aimslab.c                |   2 +-
 drivers/media/radio/radio-aztech.c                 |   2 +-
 drivers/media/radio/radio-cadet.c                  |   4 +-
 drivers/media/radio/radio-gemtek.c                 |   8 +-
 drivers/media/radio/radio-maxiradio.c              |   2 +-
 drivers/media/radio/radio-mr800.c                  |  24 +-
 drivers/media/radio/radio-rtrack2.c                |   2 +-
 drivers/media/radio/radio-sf16fmi.c                |   4 +-
 drivers/media/radio/radio-sf16fmr2.c               |   2 +-
 drivers/media/radio/radio-tea5764.c                |   2 +-
 drivers/media/radio/radio-terratec.c               |   6 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |  24 +-
 drivers/media/radio/tea575x.c                      |   2 +-
 drivers/media/radio/wl128x/fmdrv_common.h          |  10 +-
 drivers/media/rc/Kconfig                           |   8 +-
 drivers/media/rc/keymaps/rc-behold-columbus.c      |   6 +-
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |   2 +-
 drivers/media/tuners/mt2063.c                      |   4 +-
 drivers/media/tuners/mxl5005s.c                    |   6 +-
 drivers/media/tuners/si2157.c                      |   2 +-
 drivers/media/tuners/tda827x.h                     |   2 +-
 drivers/media/tuners/tda9887.c                     |   4 +-
 drivers/media/tuners/tuner-i2c.h                   |   2 +-
 drivers/media/tuners/tuner-simple.c                |   2 +-
 drivers/media/tuners/tuner-xc2028.c                |   6 +-
 drivers/media/tuners/tuner-xc2028.h                |   2 +-
 drivers/media/usb/as102/as10x_cmd_cfg.c            |   6 +-
 drivers/media/usb/au0828/au0828-cards.h            |   2 +-
 drivers/media/usb/au0828/au0828-video.c            |   2 +-
 drivers/media/usb/au0828/au0828.h                  |   6 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |  14 +-
 drivers/media/usb/cx231xx/cx231xx-audio.c          |   6 +-
 drivers/media/usb/cx231xx/cx231xx-avcore.c         |   4 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |   2 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c            |   2 +-
 drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h        |   2 +-
 drivers/media/usb/cx231xx/cx231xx-reg.h            |  20 +-
 drivers/media/usb/dvb-usb/az6027.c                 | 216 ++++++++---------
 drivers/media/usb/em28xx/Kconfig                   |  14 +-
 drivers/media/usb/gspca/autogain_functions.c       |  12 +-
 drivers/media/usb/gspca/cpia1.c                    |   2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |   2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.h          |   2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |  26 +-
 drivers/media/usb/hdpvr/hdpvr.h                    |  16 +-
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c        |  12 +-
 drivers/media/usb/pwc/pwc.h                        |   6 +-
 drivers/media/usb/siano/smsusb.c                   |   2 +-
 drivers/media/usb/stk1160/Makefile                 |   2 +-
 drivers/media/usb/stkwebcam/stk-sensor.c           |  44 ++--
 drivers/media/usb/tm6000/tm6000.h                  |   2 +-
 drivers/media/usb/usbtv/Kconfig                    |  16 +-
 drivers/media/usb/uvc/uvc_driver.c                 |  14 +-
 drivers/media/usb/uvc/uvc_isight.c                 |  10 +-
 drivers/media/v4l2-core/Kconfig                    |   4 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   8 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  62 ++---
 include/media/drv-intf/cx2341x.h                   | 144 +++++------
 include/media/drv-intf/msp3400.h                   |  62 ++---
 include/media/drv-intf/saa7146.h                   |   2 +-
 include/media/dvb_frontend.h                       |  12 +-
 include/media/dvb_vb2.h                            |   2 +-
 include/media/dvbdev.h                             |   4 +-
 include/media/i2c/bt819.h                          |   4 +-
 include/media/i2c/m52790.h                         |  52 ++--
 include/media/i2c/saa7115.h                        |  12 +-
 include/media/i2c/upd64031a.h                      |   6 +-
 include/media/v4l2-async.h                         |   8 +-
 include/media/v4l2-common.h                        |  12 +-
 include/media/v4l2-ctrls.h                         |   2 +-
 include/media/v4l2-dev.h                           |  16 +-
 include/media/v4l2-event.h                         |   2 +-
 include/media/v4l2-subdev.h                        |   8 +-
 include/uapi/linux/dvb/video.h                     |  20 +-
 include/uapi/linux/v4l2-controls.h                 |  96 ++++----
 include/uapi/linux/videodev2.h                     |  56 ++---
 193 files changed, 1900 insertions(+), 1900 deletions(-)

-- 
2.14.3
