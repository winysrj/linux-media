Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:61786 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3LCPjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 10:39:35 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX8001JVM5XNY10@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 10:39:33 -0500 (EST)
Date: Tue, 03 Dec 2013 13:39:27 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Dinesh Ram <dinesh.ram@cern.ch>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	edubezval@gmail.com, dinesh.ram086@gmail.com
Subject: Re: [REVIEW PATCH 1/9] si4713 : Reorganized drivers/media/radio
 directory
Message-id: <20131203133927.6b664f57.m.chehab@samsung.com>
In-reply-to: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
References: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch>
 <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Oct 2013 17:24:37 +0200
Dinesh Ram <dinesh.ram@cern.ch> escreveu:

> Added a new si4713 directory which will contain all si4713 related files.
> Also updated Makefile and Kconfig
> 
> Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
> ---
>  drivers/media/radio/Kconfig                        |   29 +-
>  drivers/media/radio/Makefile                       |    3 +-
>  drivers/media/radio/radio-si4713.c                 |  246 ----
>  drivers/media/radio/si4713-i2c.c                   | 1532 --------------------
>  drivers/media/radio/si4713-i2c.h                   |  238 ---
>  drivers/media/radio/si4713/Kconfig                 |   25 +
>  drivers/media/radio/si4713/Makefile                |    7 +
>  drivers/media/radio/si4713/radio-platform-si4713.c |  246 ++++
>  drivers/media/radio/si4713/si4713.c                | 1532 ++++++++++++++++++++
>  drivers/media/radio/si4713/si4713.h                |  238 +++
>  10 files changed, 2055 insertions(+), 2041 deletions(-)
>  delete mode 100644 drivers/media/radio/radio-si4713.c
>  delete mode 100644 drivers/media/radio/si4713-i2c.c
>  delete mode 100644 drivers/media/radio/si4713-i2c.h
>  create mode 100644 drivers/media/radio/si4713/Kconfig
>  create mode 100644 drivers/media/radio/si4713/Makefile
>  create mode 100644 drivers/media/radio/si4713/radio-platform-si4713.c
>  create mode 100644 drivers/media/radio/si4713/si4713.c
>  create mode 100644 drivers/media/radio/si4713/si4713.h
> 

Please submit rename patches like that using "git show -M", in order to show only
what changed. 

Btw, while here, I would expect a latter patch on this series fixing the
checkpatch.pl warnings/errors:

WARNING: please write a paragraph that describes the config symbol fully
#23: FILE: drivers/media/radio/Kconfig:24:
+config RADIO_SI4713

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#2181: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:19:
+ * You should have received a copy of the GNU General Public License$

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#2182: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:20:
+ * along with this program; if not, write to the Free Software$

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#2183: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:21:
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA$

WARNING: line over 80 characters
#2242: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:80:
+	capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;

WARNING: line over 80 characters
#2365: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:203:
+	if (video_register_device(&rsdev->radio_dev, VFL_TYPE_RADIO, radio_nr)) {

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#2433: FILE: drivers/media/radio/si4713/si4713.c:19:
+ * You should have received a copy of the GNU General Public License$

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#2434: FILE: drivers/media/radio/si4713/si4713.c:20:
+ * along with this program; if not, write to the Free Software$

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#2435: FILE: drivers/media/radio/si4713/si4713.c:21:
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA$

WARNING: please, no space before tabs
#2473: FILE: drivers/media/radio/si4713/si4713.c:59:
+#define DEFAULT_PILOT_FREQUENCY ^I0x4A38$

WARNING: please, no space before tabs
#2478: FILE: drivers/media/radio/si4713/si4713.c:64:
+#define DEFAULT_ACOMP_THRESHOLD ^I(-0x28)$

WARNING: please, no space before tabs
#2682: FILE: drivers/media/radio/si4713/si4713.c:268:
+^I * ^I.First byte = 0$

WARNING: please, no space before tabs
#2683: FILE: drivers/media/radio/si4713/si4713.c:269:
+^I * ^I.Second byte = property's MSB$

WARNING: please, no space before tabs
#2684: FILE: drivers/media/radio/si4713/si4713.c:270:
+^I * ^I.Third byte = property's LSB$

WARNING: please, no space before tabs
#2719: FILE: drivers/media/radio/si4713/si4713.c:305:
+^I * ^I.First byte = 0$

WARNING: please, no space before tabs
#2720: FILE: drivers/media/radio/si4713/si4713.c:306:
+^I * ^I.Second byte = property's MSB$

WARNING: please, no space before tabs
#2721: FILE: drivers/media/radio/si4713/si4713.c:307:
+^I * ^I.Third byte = property's LSB$

WARNING: please, no space before tabs
#2722: FILE: drivers/media/radio/si4713/si4713.c:308:
+^I * ^I.Fourth byte = value's MSB$

WARNING: please, no space before tabs
#2723: FILE: drivers/media/radio/si4713/si4713.c:309:
+^I * ^I.Fifth byte = value's LSB$

WARNING: please, no space before tabs
#2764: FILE: drivers/media/radio/si4713/si4713.c:350:
+^I * ^I.First byte = Enabled interrupts and boot function$

WARNING: please, no space before tabs
#2765: FILE: drivers/media/radio/si4713/si4713.c:351:
+^I * ^I.Second byte = Input operation mode$

WARNING: please, no space before tabs
#2913: FILE: drivers/media/radio/si4713/si4713.c:499:
+ * ^I^I^Ifrequency between 76 and 108 MHz in 10 kHz units and$

WARNING: please, no space before tabs
#2914: FILE: drivers/media/radio/si4713/si4713.c:500:
+ * ^I^I^Isteps of 50 kHz.$

WARNING: please, no space before tabs
#2923: FILE: drivers/media/radio/si4713/si4713.c:509:
+^I * ^I.First byte = 0$

WARNING: please, no space before tabs
#2924: FILE: drivers/media/radio/si4713/si4713.c:510:
+^I * ^I.Second byte = frequency's MSB$

WARNING: please, no space before tabs
#2925: FILE: drivers/media/radio/si4713/si4713.c:511:
+^I * ^I.Third byte = frequency's LSB$

WARNING: please, no space before tabs
#2953: FILE: drivers/media/radio/si4713/si4713.c:539:
+ * ^I^I^I1 dB units. A value of 0x00 indicates off. The command$

WARNING: please, no space before tabs
#2954: FILE: drivers/media/radio/si4713/si4713.c:540:
+ * ^I^I^Ialso sets the antenna tuning capacitance. A value of 0$

WARNING: please, no space before tabs
#2955: FILE: drivers/media/radio/si4713/si4713.c:541:
+ * ^I^I^Iindicates autotuning, and a value of 1 - 191 indicates$

WARNING: please, no space before tabs
#2956: FILE: drivers/media/radio/si4713/si4713.c:542:
+ * ^I^I^Ia manual override, which results in a tuning$

WARNING: please, no space before tabs
#2957: FILE: drivers/media/radio/si4713/si4713.c:543:
+ * ^I^I^Icapacitance of 0.25 pF x @antcap.$

WARNING: please, no space before tabs
#2968: FILE: drivers/media/radio/si4713/si4713.c:554:
+^I * ^I.First byte = 0$

WARNING: please, no space before tabs
#2969: FILE: drivers/media/radio/si4713/si4713.c:555:
+^I * ^I.Second byte = 0$

WARNING: please, no space before tabs
#2970: FILE: drivers/media/radio/si4713/si4713.c:556:
+^I * ^I.Third byte = power$

WARNING: please, no space before tabs
#2971: FILE: drivers/media/radio/si4713/si4713.c:557:
+^I * ^I.Fourth byte = antcap$

WARNING: please, no space before tabs
#3000: FILE: drivers/media/radio/si4713/si4713.c:586:
+ * ^I^I^Ilevel in units of dBuV on the selected frequency.$

WARNING: please, no space before tabs
#3001: FILE: drivers/media/radio/si4713/si4713.c:587:
+ * ^I^I^IThe Frequency must be between 76 and 108 MHz in 10 kHz$

WARNING: please, no space before tabs
#3002: FILE: drivers/media/radio/si4713/si4713.c:588:
+ * ^I^I^Iunits and steps of 50 kHz. The command also sets the$

WARNING: please, no space before tabs
#3003: FILE: drivers/media/radio/si4713/si4713.c:589:
+ * ^I^I^Iantenna^Ituning capacitance. A value of 0 means$

WARNING: please, no space before tabs
#3004: FILE: drivers/media/radio/si4713/si4713.c:590:
+ * ^I^I^Iautotuning, and a value of 1 to 191 indicates manual$

WARNING: please, no space before tabs
#3005: FILE: drivers/media/radio/si4713/si4713.c:591:
+ * ^I^I^Ioverride.$

WARNING: please, no space before tabs
#3016: FILE: drivers/media/radio/si4713/si4713.c:602:
+^I * ^I.First byte = 0$

WARNING: please, no space before tabs
#3017: FILE: drivers/media/radio/si4713/si4713.c:603:
+^I * ^I.Second byte = frequency's MSB$

WARNING: please, no space before tabs
#3018: FILE: drivers/media/radio/si4713/si4713.c:604:
+^I * ^I.Third byte = frequency's LSB$

WARNING: please, no space before tabs
#3019: FILE: drivers/media/radio/si4713/si4713.c:605:
+^I * ^I.Fourth byte = antcap$

WARNING: please, no space before tabs
#3049: FILE: drivers/media/radio/si4713/si4713.c:635:
+ * ^I^I^Itx_tune_power commands. This command return the current$

WARNING: please, no space before tabs
#3050: FILE: drivers/media/radio/si4713/si4713.c:636:
+ * ^I^I^Ifrequency, output voltage in dBuV, the antenna tunning$

WARNING: please, no space before tabs
#3051: FILE: drivers/media/radio/si4713/si4713.c:637:
+ * ^I^I^Icapacitance value and the received noise level. The$

WARNING: please, no space before tabs
#3052: FILE: drivers/media/radio/si4713/si4713.c:638:
+ * ^I^I^Icommand also clears the stcint interrupt bit when the$

WARNING: please, no space before tabs
#3053: FILE: drivers/media/radio/si4713/si4713.c:639:
+ * ^I^I^Ifirst bit of its arguments is high.$

WARNING: please, no space before tabs
#3068: FILE: drivers/media/radio/si4713/si4713.c:654:
+^I * ^I.First byte = intack bit$

WARNING: quoted string split across lines
#3087: FILE: drivers/media/radio/si4713/si4713.c:673:
+		v4l2_dbg(1, debug, &sdev->sd, "%s: response: %d x 10 kHz "
+				"(power %d, antcap %d, rnl %d)\n", __func__,

WARNING: quoted string split across lines
#3129: FILE: drivers/media/radio/si4713/si4713.c:715:
+		v4l2_dbg(1, debug, &sdev->sd, "%s: response: interrupts"
+				" 0x%02x cb avail: %d cb used %d fifo avail"

WARNING: line over 80 characters
#3250: FILE: drivers/media/radio/si4713/si4713.c:836:
+		if (t_index < (RDS_RADIOTEXT_INDEX_MAX * RDS_RADIOTEXT_BLK_SIZE)) {

WARNING: line over 80 characters
#3391: FILE: drivers/media/radio/si4713/si4713.c:977:
+static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f);

WARNING: line over 80 characters
#3392: FILE: drivers/media/radio/si4713/si4713.c:978:
+static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *);

WARNING: line over 80 characters
#3509: FILE: drivers/media/radio/si4713/si4713.c:1095:
+				sdev->tune_pwr_level->val, sdev->tune_ant_cap->val);

WARNING: line over 80 characters
#3518: FILE: drivers/media/radio/si4713/si4713.c:1104:
+			ret = si4713_choose_econtrol_action(sdev, ctrl->id, &bit,

WARNING: line over 80 characters
#3535: FILE: drivers/media/radio/si4713/si4713.c:1121:
+				ret = si4713_read_property(sdev, property, &val);

WARNING: line over 80 characters
#3636: FILE: drivers/media/radio/si4713/si4713.c:1222:
+static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_modulator *vm)

WARNING: line over 80 characters
#3706: FILE: drivers/media/radio/si4713/si4713.c:1292:
+static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequency *f)

WARNING: sizeof *sdev should be sizeof(*sdev)
#3762: FILE: drivers/media/radio/si4713/si4713.c:1348:
+	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);

WARNING: line over 80 characters
#3820: FILE: drivers/media/radio/si4713/si4713.c:1406:
+			V4L2_CID_RDS_TX_RADIO_TEXT, 0, MAX_RDS_RADIO_TEXT, 32, 0);

WARNING: line over 80 characters
#3837: FILE: drivers/media/radio/si4713/si4713.c:1423:
+			V4L2_CID_AUDIO_COMPRESSION_THRESHOLD, MIN_ACOMP_THRESHOLD,

WARNING: line over 80 characters
#3843: FILE: drivers/media/radio/si4713/si4713.c:1429:
+	sdev->compression_release_time = v4l2_ctrl_new_std(hdl, &si4713_ctrl_ops,

WARNING: line over 80 characters
#3860: FILE: drivers/media/radio/si4713/si4713.c:1446:
+			V4L2_CID_TUNE_POWER_LEVEL, 0, 120, 1, DEFAULT_POWER_LEVEL);

total: 6 errors, 60 warnings, 2101 lines checked

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.



-- 

Cheers,
Mauro
