Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m614CB01000572
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:12:11 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m614Bxi6017523
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 00:12:00 -0400
Date: Tue, 1 Jul 2008 00:11:59 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean-Francois Moine <moinejf@free.fr>
In-Reply-To: <1214858407.1677.27.camel@localhost>
Message-ID: <alpine.LFD.1.10.0806302315350.25144@bombadil.infradead.org>
References: <1214858407.1677.27.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com
Subject: Re: [PULL] gspca v4l2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Jean-Francois,

To make it easier for me and others to review, I'm committing it as-is. A 
+30K lines on this driver will take some time for we all digest it ;)

Anyway, I did a "quick" overview (it took me more than one hour on it) 
and, in general, it seems ok to my eyes. I hope that people at the 
community will help to review it better.

There are a few issues at the driver to comment.

1) First one is CodingStyle:

ERROR: "foo * bar" should be "foo *bar"
#1636: FILE: linux/drivers/media/video/gspca/etoms.c:236:
+static int Et_i2cwrite(struct usb_device *dev, __u8 reg, __u8 * buffer,

ERROR: "foo * bar" should be "foo *bar"
#1659: FILE: linux/drivers/media/video/gspca/etoms.c:259:
+static int Et_i2cread(struct usb_device *dev, __u8 reg, __u8 * buffer,

WARNING: Use #include <linux/io.h> instead of <asm/io.h>
#2503: FILE: linux/drivers/media/video/gspca/gspca.c:31:
+#include <asm/io.h>

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
#2505: FILE: linux/drivers/media/video/gspca/gspca.c:33:
+#include <asm/uaccess.h>

WARNING: line over 80 characters
#5224: FILE: linux/drivers/media/video/gspca/mars.c:223:
+		data[3] = 0x3f;		/* reg 96, Y Gain/UV Gain/disable auto dark-gain */

WARNING: line over 80 characters
#5230: FILE: linux/drivers/media/video/gspca/mars.c:229:
+		data[3] = 0x78;		/* reg 96, Y Gain/UV Gain/disable auto dark-gain */

WARNING: braces {} are not necessary for any arm of this statement
#8147: FILE: linux/drivers/media/video/gspca/pac207.c:455:
+			if (sd->gain > PAC207_GAIN_KNEE) {
[...]
+			} else if (sd->exposure > PAC207_EXPOSURE_KNEE) {
[...]
+			} else if (sd->gain > PAC207_GAIN_DEFAULT) {
[...]
+			} else if (sd->exposure > PAC207_EXPOSURE_MIN) {
[...]
+			} else if (sd->gain > PAC207_GAIN_MIN) {
[...]
+			} else
[...]

WARNING: braces {} are not necessary for any arm of this statement
#8160: FILE: linux/drivers/media/video/gspca/pac207.c:468:
+			if (sd->gain < PAC207_GAIN_DEFAULT) {
[...]
+			} else if (sd->exposure < PAC207_EXPOSURE_KNEE) {
[...]
+			} else if (sd->gain < PAC207_GAIN_KNEE) {
[...]
+			} else if (sd->exposure < PAC207_EXPOSURE_MAX) {
[...]
+			} else if (sd->gain < PAC207_GAIN_MAX) {
[...]
+			} else
[...]

WARNING: line over 80 characters
#9372: FILE: linux/drivers/media/video/gspca/pac7311.c:733:
+	{USB_DEVICE(0x093a, 0x260e), DVNM("Gigaware VGA PC Camera, Trust WB-3350p, SIGMA cam 2350")},

WARNING: line over 80 characters
#10255: FILE: linux/drivers/media/video/gspca/sonixb.c:842:
+	{USB_DEVICE(0x0c45, 0x6011), DVNM("MAX Webcam Microdia-OV6650-SN9C101G")},

ERROR: space required after that ',' (ctx:VxV)
#11399: FILE: linux/drivers/media/video/gspca/sonixj.c:1095:
+		PDEBUG(D_CONF," set exposure %d",
  		             ^

WARNING: line over 80 characters
#12314: FILE: linux/drivers/media/video/gspca/spca500.c:356:
+	{			/* Q-table Y-components start registers 0x8800 */

WARNING: line over 80 characters
#12324: FILE: linux/drivers/media/video/gspca/spca500.c:366:
+	{			/* Q-table C-components start registers 0x8840 */

ERROR: do not use assignment in if condition
#12811: FILE: linux/drivers/media/video/gspca/spca500.c:853:
+		if ((err = spca500_full_reset(gspca_dev)) < 0)

ERROR: space required after that ',' (ctx:VxV)
#12896: FILE: linux/drivers/media/video/gspca/spca500.c:938:
+		spca500_setmode(gspca_dev,xmult,ymult);
  		                         ^

ERROR: space required after that ',' (ctx:VxV)
#12896: FILE: linux/drivers/media/video/gspca/spca500.c:938:
+		spca500_setmode(gspca_dev,xmult,ymult);
  		                               ^

WARNING: space prohibited between function name and open parenthesis '('
#16384: FILE: linux/drivers/media/video/gspca/spca505.c:976:
+	return gspca_dev_probe(intf, id, &sd_desc, sizeof (struct sd),

ERROR: Macros with complex values should be enclosed in parenthesis
#33753: FILE: linux/include/asm-arm/arch-pxa/pxa-regs.h:50:
+#define _PCMCIA(Nb)			/* PCMCIA [0..1]                   */ \

WARNING: space prohibited between function name and open parenthesis '('
#33760: FILE: linux/include/asm-arm/arch-pxa/pxa-regs.h:53:
+			(_PCMCIA (Nb) + 2*PCMCIAPrtSp)

ERROR: Macros with complex values should be enclosed in parenthesis
#33760: FILE: linux/include/asm-arm/arch-pxa/pxa-regs.h:53:
+#define _PCMCIAAttr(Nb)			/* PCMCIA Attribute [0..1]         */ \

WARNING: space prohibited between function name and open parenthesis '('
#33762: FILE: linux/include/asm-arm/arch-pxa/pxa-regs.h:55:
+			(_PCMCIA (Nb) + 3*PCMCIAPrtSp)

ERROR: Macros with complex values should be enclosed in parenthesis
#33762: FILE: linux/include/asm-arm/arch-pxa/pxa-regs.h:55:
+#define _PCMCIAMem(Nb)			/* PCMCIA Memory [0..1]            */ \

ERROR: space required after that ',' (ctx:VxV)
#33773: FILE: linux/include/linux/videodev2.h:327:
+#define V4L2_PIX_FMT_SPCA501  v4l2_fourcc('S','5','0','1') /* YUYV per line */
                                               ^

ERROR: space required after that ',' (ctx:VxV)
#33773: FILE: linux/include/linux/videodev2.h:327:
+#define V4L2_PIX_FMT_SPCA501  v4l2_fourcc('S','5','0','1') /* YUYV per line */
                                                   ^

ERROR: space required after that ',' (ctx:VxV)
#33773: FILE: linux/include/linux/videodev2.h:327:
+#define V4L2_PIX_FMT_SPCA501  v4l2_fourcc('S','5','0','1') /* YUYV per line */
                                                       ^

WARNING: line over 80 characters
#33774: FILE: linux/include/linux/videodev2.h:328:
+#define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S','5','6','1') /* compressed BGGR bayer */

ERROR: space required after that ',' (ctx:VxV)
#33774: FILE: linux/include/linux/videodev2.h:328:
+#define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S','5','6','1') /* compressed BGGR bayer */
                                               ^

ERROR: space required after that ',' (ctx:VxV)
#33774: FILE: linux/include/linux/videodev2.h:328:
+#define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S','5','6','1') /* compressed BGGR bayer */
                                                   ^

ERROR: space required after that ',' (ctx:VxV)
#33774: FILE: linux/include/linux/videodev2.h:328:
+#define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S','5','6','1') /* compressed BGGR bayer */
                                                       ^

2) You don't need to have PDEBUG() inside vidioc_* callbacks. All you need 
is to setup vfd.debug to a modprobe param. videodev core itself produces a 
very nice set of debug functions;

3) Some callbacks were renamed. Also, compilation were failing for 
kernel's bellow 2.6.22. I've fixed this;

4) There are still a few format conversions inside the sub-drivers (I 
noticed some rgb to yuyv conversion somewhere);

5) copy_to_user error were discarded:
/home/v4l/master/v4l/gspca.c: In function 'gspca_frame_add':
/home/v4l/master/v4l/gspca.c:293: warning: ignoring return value of copy_to_user', declared with attribute warn_unused_result

On some tests I did with copy_to_user, it sometimes fail at interrupt 
context. I suggest to migrate to videobuf-vmalloc, since this were 
corrected there.

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
