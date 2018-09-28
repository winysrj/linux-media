Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:59480 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727234AbeI2ERx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 00:17:53 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Bad MAINTAINERS pattern in section 'CX2341X MPEG ENCODER HELPER MODULE'
Date: Fri, 28 Sep 2018 14:52:09 -0700
Message-Id: <20180928215210.29037-1-joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please fix this defect appropriately.

linux-next MAINTAINERS section:

	3857	CX2341X MPEG ENCODER HELPER MODULE
	3858	M:	Hans Verkuil <hverkuil@xs4all.nl>
	3859	L:	linux-media@vger.kernel.org
	3860	T:	git git://linuxtv.org/media_tree.git
	3861	W:	https://linuxtv.org
	3862	S:	Maintained
	3863	F:	drivers/media/common/cx2341x*
-->	3864	F:	include/media/cx2341x*

Commit that introduced this:

commit 3f101d916b5b2b95d36369e1b2505720db2dcecb
 Author: Hans Verkuil <hans.verkuil@cisco.com>
 Date:   Fri Nov 23 07:00:02 2012 -0300
 
     [media] MAINTAINERS: add cx2341x entry
     
     Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
 
  MAINTAINERS | 9 +++++++++
  1 file changed, 9 insertions(+)

Last commit with include/media/cx2341x*

commit d647f0b70ce2b4aeb443639dc92b2d859da697a7
Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date:   Fri Nov 13 19:40:07 2015 -0200

    [media] include/media: move driver interface headers to a separate dir
    
    Let's not mix headers used by the core with those headers that
    are needed by some driver-specific interface header.
    
    The headers used on drivers were manually moved using:
        mkdir include/media/drv-intf/
        git mv include/media/cx2341x.h include/media/cx25840.h \
            include/media/exynos-fimc.h include/media/msp3400.h \
            include/media/s3c_camif.h include/media/saa7146.h \
            include/media/saa7146_vv.h  include/media/sh_mobile_ceu.h \
            include/media/sh_mobile_csi2.h include/media/sh_vou.h \
            include/media/si476x.h include/media/soc_mediabus.h \
            include/media/tea575x.h include/media/drv-intf/
    
    And the references for those headers were corrected using:
    
        MAIN_DIR="media/"
        PREV_DIR="media/"
        DIRS="drv-intf/"
    
        echo "Checking affected files" >&2
        for i in $DIRS; do
            for j in $(find include/$MAIN_DIR/$i -type f -name '*.h'); do
                     n=`basename $j`
                    git grep -l $n
            done
        done|sort|uniq >files && (
            echo "Handling files..." >&2;
            echo "for i in \$(cat files|grep -v Documentation); do cat \$i | \\";
            (
                    cd include/$MAIN_DIR;
                    for j in $DIRS; do
                            for i in $(ls $j); do
                                    echo "perl -ne 's,(include [\\\"\\<])$PREV_DIR($i)([\\\"\\>]),\1$MAIN_DIR$j\2\3,; print \$_' |\\";
                            done;
                    done;
                    echo "cat > a && mv a \$i; done";
            );
            echo "Handling documentation..." >&2;
            echo "for i in MAINTAINERS \$(cat files); do cat \$i | \\";
            (
                    cd include/$MAIN_DIR;
                    for j in $DIRS; do
                            for i in $(ls $j); do
                                    echo "  perl -ne 's,include/$PREV_DIR($i)\b,include/$MAIN_DIR$j\1,; print \$_' |\\";
                            done;
                    done;
                    echo "cat > a && mv a \$i; done"
            );
        ) >script && . ./script
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>

 MAINTAINERS                                              | 4 ++--
 arch/sh/boards/mach-ap325rxa/setup.c                     | 2 +-
 arch/sh/boards/mach-ecovec24/setup.c                     | 4 ++--
 arch/sh/boards/mach-kfr2r09/setup.c                      | 2 +-
 arch/sh/boards/mach-migor/setup.c                        | 2 +-
 arch/sh/boards/mach-se/7724/setup.c                      | 4 ++--
 drivers/media/common/cx2341x.c                           | 2 +-
 drivers/media/common/saa7146/saa7146_core.c              | 2 +-
 drivers/media/common/saa7146/saa7146_fops.c              | 2 +-
 drivers/media/common/saa7146/saa7146_hlp.c               | 2 +-
 drivers/media/common/saa7146/saa7146_i2c.c               | 2 +-
 drivers/media/common/saa7146/saa7146_vbi.c               | 2 +-
 drivers/media/common/saa7146/saa7146_video.c             | 2 +-
 drivers/media/i2c/cx25840/cx25840-audio.c                | 2 +-
 drivers/media/i2c/cx25840/cx25840-core.c                 | 2 +-
 drivers/media/i2c/cx25840/cx25840-firmware.c             | 2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c                   | 2 +-
 drivers/media/i2c/cx25840/cx25840-vbi.c                  | 2 +-
 drivers/media/i2c/m5mols/m5mols_capture.c                | 2 +-
 drivers/media/i2c/msp3400-driver.c                       | 2 +-
 drivers/media/i2c/msp3400-driver.h                       | 2 +-
 drivers/media/i2c/msp3400-kthreads.c                     | 2 +-
 drivers/media/i2c/soc_camera/mt9m001.c                   | 2 +-
 drivers/media/i2c/soc_camera/mt9v022.c                   | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                    | 2 +-
 drivers/media/pci/bt8xx/bttvp.h                          | 2 +-
 drivers/media/pci/cx18/cx23418.h                         | 2 +-
 drivers/media/pci/cx23885/cx23885-417.c                  | 2 +-
 drivers/media/pci/cx23885/cx23885-cards.c                | 2 +-
 drivers/media/pci/cx23885/cx23885-video.c                | 2 +-
 drivers/media/pci/cx23885/cx23885.h                      | 2 +-
 drivers/media/pci/cx88/cx88-blackbird.c                  | 2 +-
 drivers/media/pci/cx88/cx88.h                            | 2 +-
 drivers/media/pci/ivtv/ivtv-cards.c                      | 4 ++--
 drivers/media/pci/ivtv/ivtv-driver.h                     | 2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                        | 2 +-
 drivers/media/pci/ivtv/ivtv-routing.c                    | 2 +-
 drivers/media/pci/saa7146/hexium_gemini.c                | 2 +-
 drivers/media/pci/saa7146/hexium_orion.c                 | 2 +-
 drivers/media/pci/saa7146/mxb.c                          | 2 +-
 drivers/media/pci/ttpci/av7110.h                         | 2 +-
 drivers/media/pci/ttpci/budget-av.c                      | 2 +-
 drivers/media/pci/ttpci/budget.h                         | 2 +-
 drivers/media/platform/exynos4-is/common.c               | 2 +-
 drivers/media/platform/exynos4-is/fimc-core.h            | 2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c       | 2 +-
 drivers/media/platform/exynos4-is/fimc-isp.h             | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite-reg.c        | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c            | 2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h            | 2 +-
 drivers/media/platform/exynos4-is/fimc-reg.c             | 2 +-
 drivers/media/platform/exynos4-is/media-dev.c            | 2 +-
 drivers/media/platform/exynos4-is/media-dev.h            | 2 +-
 drivers/media/platform/exynos4-is/mipi-csis.c            | 2 +-
 drivers/media/platform/s3c-camif/camif-core.h            | 2 +-
 drivers/media/platform/s3c-camif/camif-regs.h            | 2 +-
 drivers/media/platform/sh_vou.c                          | 2 +-
 drivers/media/platform/soc_camera/atmel-isi.c            | 2 +-
 drivers/media/platform/soc_camera/mx2_camera.c           | 2 +-
 drivers/media/platform/soc_camera/mx3_camera.c           | 2 +-
 drivers/media/platform/soc_camera/omap1_camera.c         | 2 +-
 drivers/media/platform/soc_camera/pxa_camera.c           | 2 +-
 drivers/media/platform/soc_camera/rcar_vin.c             | 2 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 6 +++---
 drivers/media/platform/soc_camera/sh_mobile_csi2.c       | 6 +++---
 drivers/media/platform/soc_camera/soc_camera.c           | 2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c         | 2 +-
 drivers/media/radio/radio-maxiradio.c                    | 2 +-
 drivers/media/radio/radio-sf16fmr2.c                     | 2 +-
 drivers/media/radio/radio-shark.c                        | 2 +-
 drivers/media/radio/radio-si476x.c                       | 2 +-
 drivers/media/radio/tea575x.c                            | 2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c                  | 2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c                | 2 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c                  | 2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                | 2 +-
 drivers/media/usb/cx231xx/cx231xx.h                      | 2 +-
 drivers/media/usb/em28xx/em28xx-cards.c                  | 2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-audio.c                | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c          | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h         | 2 +-
 include/media/{ => drv-intf}/cx2341x.h                   | 0
 include/media/{ => drv-intf}/cx25840.h                   | 0
 include/media/{ => drv-intf}/exynos-fimc.h               | 0
 include/media/{ => drv-intf}/msp3400.h                   | 1 -
 include/media/{ => drv-intf}/s3c_camif.h                 | 0
 include/media/{ => drv-intf}/saa7146.h                   | 0
 include/media/{ => drv-intf}/saa7146_vv.h                | 2 +-
 include/media/{ => drv-intf}/sh_mobile_ceu.h             | 0
 include/media/{ => drv-intf}/sh_mobile_csi2.h            | 0
 include/media/{ => drv-intf}/sh_vou.h                    | 0
 include/media/{ => drv-intf}/si476x.h                    | 2 +-
 include/media/{ => drv-intf}/soc_mediabus.h              | 0
 include/media/{ => drv-intf}/tea575x.h                   | 0
 include/uapi/linux/v4l2-controls.h                       | 6 ++++--
 sound/pci/es1968.c                                       | 2 +-
 sound/pci/fm801.c                                        | 2 +-
 98 files changed, 98 insertions(+), 97 deletions(-)
