Return-path: <linux-media-owner@vger.kernel.org>
Received: from cernmx13.cern.ch ([188.184.36.46]:23836 "EHLO CERNMX13.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab3LCQL0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 11:11:26 -0500
From: Dinesh Ram <Dinesh.Ram@cern.ch>
To: Linux-Media <linux-media@vger.kernel.org>
Subject: FW: [REVIEW PATCH 1/9] si4713 : Reorganized drivers/media/radio
 directory
Date: Tue, 3 Dec 2013 16:06:08 +0000
Message-ID: <C40DBE54484849439FC5081A05AEF5F5979F9B9E@PLOXCHG24.cern.ch>
References: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch>
 <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
 <20131203133927.6b664f57.m.chehab@samsung.com>,<CAP_RhzeRgLir1FGL6UN2-yXXaS-1knsS2BP20MjfMJRAEyDqeg@mail.gmail.com>
In-Reply-To: <CAP_RhzeRgLir1FGL6UN2-yXXaS-1knsS2BP20MjfMJRAEyDqeg@mail.gmail.com>
Content-Language: en-GB
Content-Type: multipart/mixed;
	boundary="_002_C40DBE54484849439FC5081A05AEF5F5979F9B9EPLOXCHG24cernch_"
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--_002_C40DBE54484849439FC5081A05AEF5F5979F9B9EPLOXCHG24cernch_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Mail to the mailing list from my gmail id bounce back.
Trying with this ID.

From: d ram [dinesh.ram086@gmail.com]
Sent: 03 December 2013 16:57
To: Mauro Carvalho Chehab
Cc: Dinesh Ram; Linux-Media; Hans Verkuil; Eduardo Valentin
Subject: Re: [REVIEW PATCH 1/9] si4713 : Reorganized drivers/media/radio di=
rectory

Hello Mauro,

I am not sure what happened here. Maybe the patch got mixed up.
I had corrected all of the errors / warnings. But maybe I mailed the incorr=
ect one (beats me how !)
Please find the correct one attached with this email.

checkpatch.pl<http://checkpatch.pl> on this one gives :

scripts/checkpatch.pl<http://checkpatch.pl> 0001-si4713-Reorganized-drivers=
-media-radio-directory.patch
WARNING: please write a paragraph that describes the config symbol fully
#34: FILE: drivers/media/radio/Kconfig:18:
+config RADIO_SI4713

total: 0 errors, 1 warnings, 112 lines checked

0001-si4713-Reorganized-drivers-media-radio-directory.patch has style probl=
ems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


Regards,
Dinesh Ram


On Tue, Dec 3, 2013 at 4:39 PM, Mauro Carvalho Chehab <m.chehab@samsung.com=
<mailto:m.chehab@samsung.com>> wrote:
Em Tue, 15 Oct 2013 17:24:37 +0200
Dinesh Ram <dinesh.ram@cern.ch<mailto:dinesh.ram@cern.ch>> escreveu:

> Added a new si4713 directory which will contain all si4713 related files.
> Also updated Makefile and Kconfig
>
> Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch<mailto:dinesh.ram@cern.ch>>
> ---
>  drivers/media/radio/Kconfig                        |   29 +-
>  drivers/media/radio/Makefile                       |    3 +-
>  drivers/media/radio/radio-si4713.c                 |  246 ----
>  drivers/media/radio/si4713-i2c.c                   | 1532 --------------=
------
>  drivers/media/radio/si4713-i2c.h                   |  238 ---
>  drivers/media/radio/si4713/Kconfig                 |   25 +
>  drivers/media/radio/si4713/Makefile                |    7 +
>  drivers/media/radio/si4713/radio-platform-si4713.c |  246 ++++
>  drivers/media/radio/si4713/si4713.c                | 1532 ++++++++++++++=
++++++
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

Please submit rename patches like that using "git show -M", in order to sho=
w only
what changed.

Btw, while here, I would expect a latter patch on this series fixing the
checkpatch.pl<http://checkpatch.pl> warnings/errors:

WARNING: please write a paragraph that describes the config symbol fully
#23: FILE: drivers/media/radio/Kconfig:24:
+config RADIO_SI4713

ERROR: Do not include the paragraph about writing to the Free Software Foun=
dation's mailing address from the sample GPL notice. The FSF has changed ad=
dresses in the past, and may do so again. Linux already includes a copy of =
the GPL.
#2181: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:19:
+ * You should have received a copy of the GNU General Public License$

ERROR: Do not include the paragraph about writing to the Free Software Foun=
dation's mailing address from the sample GPL notice. The FSF has changed ad=
dresses in the past, and may do so again. Linux already includes a copy of =
the GPL.
#2182: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:20:
+ * along with this program; if not, write to the Free Software$

ERROR: Do not include the paragraph about writing to the Free Software Foun=
dation's mailing address from the sample GPL notice. The FSF has changed ad=
dresses in the past, and may do so again. Linux already includes a copy of =
the GPL.
#2183: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:21:
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA=
$

WARNING: line over 80 characters
#2242: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:80:
+       capability->capabilities =3D capability->device_caps | V4L2_CAP_DEV=
ICE_CAPS;

WARNING: line over 80 characters
#2365: FILE: drivers/media/radio/si4713/radio-platform-si4713.c:203:
+       if (video_register_device(&rsdev->radio_dev, VFL_TYPE_RADIO, radio_=
nr)) {

ERROR: Do not include the paragraph about writing to the Free Software Foun=
dation's mailing address from the sample GPL notice. The FSF has changed ad=
dresses in the past, and may do so again. Linux already includes a copy of =
the GPL.
#2433: FILE: drivers/media/radio/si4713/si4713.c:19:
+ * You should have received a copy of the GNU General Public License$

ERROR: Do not include the paragraph about writing to the Free Software Foun=
dation's mailing address from the sample GPL notice. The FSF has changed ad=
dresses in the past, and may do so again. Linux already includes a copy of =
the GPL.
#2434: FILE: drivers/media/radio/si4713/si4713.c:20:
+ * along with this program; if not, write to the Free Software$

ERROR: Do not include the paragraph about writing to the Free Software Foun=
dation's mailing address from the sample GPL notice. The FSF has changed ad=
dresses in the past, and may do so again. Linux already includes a copy of =
the GPL.
#2435: FILE: drivers/media/radio/si4713/si4713.c:21:
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA=
$

WARNING: please, no space before tabs
#2473: FILE: drivers/media/radio/si4713/si4713.c:59:
+#define DEFAULT_PILOT_FREQUENCY ^I0x4A38$

WARNING: please, no space before tabs
#2478: FILE: drivers/media/radio/si4713/si4713.c:64:
+#define DEFAULT_ACOMP_THRESHOLD ^I(-0x28)$

WARNING: please, no space before tabs
#2682: FILE: drivers/media/radio/si4713/si4713.c:268:
+^I * ^I.First byte =3D 0$

WARNING: please, no space before tabs
#2683: FILE: drivers/media/radio/si4713/si4713.c:269:
+^I * ^I.Second byte =3D property's MSB$

WARNING: please, no space before tabs
#2684: FILE: drivers/media/radio/si4713/si4713.c:270:
+^I * ^I.Third byte =3D property's LSB$

WARNING: please, no space before tabs
#2719: FILE: drivers/media/radio/si4713/si4713.c:305:
+^I * ^I.First byte =3D 0$

WARNING: please, no space before tabs
#2720: FILE: drivers/media/radio/si4713/si4713.c:306:
+^I * ^I.Second byte =3D property's MSB$

WARNING: please, no space before tabs
#2721: FILE: drivers/media/radio/si4713/si4713.c:307:
+^I * ^I.Third byte =3D property's LSB$

WARNING: please, no space before tabs
#2722: FILE: drivers/media/radio/si4713/si4713.c:308:
+^I * ^I.Fourth byte =3D value's MSB$

WARNING: please, no space before tabs
#2723: FILE: drivers/media/radio/si4713/si4713.c:309:
+^I * ^I.Fifth byte =3D value's LSB$

WARNING: please, no space before tabs
#2764: FILE: drivers/media/radio/si4713/si4713.c:350:
+^I * ^I.First byte =3D Enabled interrupts and boot function$

WARNING: please, no space before tabs
#2765: FILE: drivers/media/radio/si4713/si4713.c:351:
+^I * ^I.Second byte =3D Input operation mode$

WARNING: please, no space before tabs
#2913: FILE: drivers/media/radio/si4713/si4713.c:499:
+ * ^I^I^Ifrequency between 76 and 108 MHz in 10 kHz units and$

WARNING: please, no space before tabs
#2914: FILE: drivers/media/radio/si4713/si4713.c:500:
+ * ^I^I^Isteps of 50 kHz.$

WARNING: please, no space before tabs
#2923: FILE: drivers/media/radio/si4713/si4713.c:509:
+^I * ^I.First byte =3D 0$

WARNING: please, no space before tabs
#2924: FILE: drivers/media/radio/si4713/si4713.c:510:
+^I * ^I.Second byte =3D frequency's MSB$

WARNING: please, no space before tabs
#2925: FILE: drivers/media/radio/si4713/si4713.c:511:
+^I * ^I.Third byte =3D frequency's LSB$

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
+^I * ^I.First byte =3D 0$

WARNING: please, no space before tabs
#2969: FILE: drivers/media/radio/si4713/si4713.c:555:
+^I * ^I.Second byte =3D 0$

WARNING: please, no space before tabs
#2970: FILE: drivers/media/radio/si4713/si4713.c:556:
+^I * ^I.Third byte =3D power$

WARNING: please, no space before tabs
#2971: FILE: drivers/media/radio/si4713/si4713.c:557:
+^I * ^I.Fourth byte =3D antcap$

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
+^I * ^I.First byte =3D 0$

WARNING: please, no space before tabs
#3017: FILE: drivers/media/radio/si4713/si4713.c:603:
+^I * ^I.Second byte =3D frequency's MSB$

WARNING: please, no space before tabs
#3018: FILE: drivers/media/radio/si4713/si4713.c:604:
+^I * ^I.Third byte =3D frequency's LSB$

WARNING: please, no space before tabs
#3019: FILE: drivers/media/radio/si4713/si4713.c:605:
+^I * ^I.Fourth byte =3D antcap$

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
+^I * ^I.First byte =3D intack bit$

WARNING: quoted string split across lines
#3087: FILE: drivers/media/radio/si4713/si4713.c:673:
+               v4l2_dbg(1, debug, &sdev->sd, "%s: response: %d x 10 kHz "
+                               "(power %d, antcap %d, rnl %d)\n", __func__=
,

WARNING: quoted string split across lines
#3129: FILE: drivers/media/radio/si4713/si4713.c:715:
+               v4l2_dbg(1, debug, &sdev->sd, "%s: response: interrupts"
+                               " 0x%02x cb avail: %d cb used %d fifo avail=
"

WARNING: line over 80 characters
#3250: FILE: drivers/media/radio/si4713/si4713.c:836:
+               if (t_index < (RDS_RADIOTEXT_INDEX_MAX * RDS_RADIOTEXT_BLK_=
SIZE)) {

WARNING: line over 80 characters
#3391: FILE: drivers/media/radio/si4713/si4713.c:977:
+static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_fr=
equency *f);

WARNING: line over 80 characters
#3392: FILE: drivers/media/radio/si4713/si4713.c:978:
+static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_mo=
dulator *);

WARNING: line over 80 characters
#3509: FILE: drivers/media/radio/si4713/si4713.c:1095:
+                               sdev->tune_pwr_level->val, sdev->tune_ant_c=
ap->val);

WARNING: line over 80 characters
#3518: FILE: drivers/media/radio/si4713/si4713.c:1104:
+                       ret =3D si4713_choose_econtrol_action(sdev, ctrl->i=
d, &bit,

WARNING: line over 80 characters
#3535: FILE: drivers/media/radio/si4713/si4713.c:1121:
+                               ret =3D si4713_read_property(sdev, property=
, &val);

WARNING: line over 80 characters
#3636: FILE: drivers/media/radio/si4713/si4713.c:1222:
+static int si4713_s_modulator(struct v4l2_subdev *sd, const struct v4l2_mo=
dulator *vm)

WARNING: line over 80 characters
#3706: FILE: drivers/media/radio/si4713/si4713.c:1292:
+static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_fr=
equency *f)

WARNING: sizeof *sdev should be sizeof(*sdev)
#3762: FILE: drivers/media/radio/si4713/si4713.c:1348:
+       sdev =3D kzalloc(sizeof *sdev, GFP_KERNEL);

WARNING: line over 80 characters
#3820: FILE: drivers/media/radio/si4713/si4713.c:1406:
+                       V4L2_CID_RDS_TX_RADIO_TEXT, 0, MAX_RDS_RADIO_TEXT, =
32, 0);

WARNING: line over 80 characters
#3837: FILE: drivers/media/radio/si4713/si4713.c:1423:
+                       V4L2_CID_AUDIO_COMPRESSION_THRESHOLD, MIN_ACOMP_THR=
ESHOLD,

WARNING: line over 80 characters
#3843: FILE: drivers/media/radio/si4713/si4713.c:1429:
+       sdev->compression_release_time =3D v4l2_ctrl_new_std(hdl, &si4713_c=
trl_ops,

WARNING: line over 80 characters
#3860: FILE: drivers/media/radio/si4713/si4713.c:1446:
+                       V4L2_CID_TUNE_POWER_LEVEL, 0, 120, 1, DEFAULT_POWER=
_LEVEL);

total: 6 errors, 60 warnings, 2101 lines checked

Your patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.



--

Cheers,
Mauro


--_002_C40DBE54484849439FC5081A05AEF5F5979F9B9EPLOXCHG24cernch_
Content-Type: text/x-patch;
	name="0001-si4713-Reorganized-drivers-media-radio-directory.patch"
Content-Description: 0001-si4713-Reorganized-drivers-media-radio-directory.patch
Content-Disposition: attachment;
	filename="0001-si4713-Reorganized-drivers-media-radio-directory.patch";
	size=6847; creation-date="Tue, 03 Dec 2013 15:57:34 GMT";
	modification-date="Tue, 03 Dec 2013 15:57:34 GMT"
Content-ID: <A492EA851220A94B88650F107A322627@cern.ch>
Content-Transfer-Encoding: base64

RnJvbSBlMGM0MmMyMjllMDg0MjVhMDc0ODEwOTY0ZWYxZjZiOTA1MDQ3MTVlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZTBjNDJjMjI5ZTA4NDI1YTA3NDgxMDk2NGVmMWY2
YjkwNTA0NzE1ZS4xMzgxODQ4NzYyLmdpdC5kaW5lc2gucmFtQGNlcm4uY2g+CkZyb206IERpbmVz
aCBSYW0gPGRpbmVzaC5yYW1AY2Vybi5jaD4KRGF0ZTogU2F0LCA1IE9jdCAyMDEzIDE5OjI0OjAx
ICswMjAwClN1YmplY3Q6IFtQQVRDSCAxLzldIHNpNDcxMyA6IFJlb3JnYW5pemVkIGRyaXZlcnMv
bWVkaWEvcmFkaW8gZGlyZWN0b3J5CgpBZGRlZCBhIG5ldyBzaTQ3MTMgZGlyZWN0b3J5IHdoaWNo
IHdpbGwgY29udGFpbiBhbGwgc2k0NzEzIHJlbGF0ZWQgZmlsZXMuCkFsc28gdXBkYXRlZCBNYWtl
ZmlsZSBhbmQgS2NvbmZpZwoKU2lnbmVkLW9mZi1ieTogRGluZXNoIFJhbSA8ZGluZXNoLnJhbUBj
ZXJuLmNoPgotLS0KIGRyaXZlcnMvbWVkaWEvcmFkaW8vS2NvbmZpZyAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAyOSArKysrLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9tZWRpYS9yYWRpby9N
YWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICAgfCAgICAzICstCiBkcml2ZXJzL21lZGlhL3Jh
ZGlvL3NpNDcxMy9LY29uZmlnICAgICAgICAgICAgICAgICB8ICAgMjUgKysrKysrKysrKysrKysr
KysKIGRyaXZlcnMvbWVkaWEvcmFkaW8vc2k0NzEzL01ha2VmaWxlICAgICAgICAgICAgICAgIHwg
ICAgNyArKysrKwogLi4uL3JhZGlvLXBsYXRmb3JtLXNpNDcxMy5jfSAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAyICstCiAuLi4vbWVkaWEvcmFkaW8ve3NpNDcxMy1pMmMuYyA9PiBzaTQ3MTMv
c2k0NzEzLmN9ICB8ICAgIDQgKy0tCiAuLi4vbWVkaWEvcmFkaW8ve3NpNDcxMy1pMmMuaCA9PiBz
aTQ3MTMvc2k0NzEzLmh9ICB8ICAgIDIgKy0KIDcgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9u
cygrKSwgMjkgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZWRpYS9y
YWRpby9zaTQ3MTMvS2NvbmZpZwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWVkaWEvcmFk
aW8vc2k0NzEzL01ha2VmaWxlCiByZW5hbWUgZHJpdmVycy9tZWRpYS9yYWRpby97cmFkaW8tc2k0
NzEzLmMgPT4gc2k0NzEzL3JhZGlvLXBsYXRmb3JtLXNpNDcxMy5jfSAoOTklKQogcmVuYW1lIGRy
aXZlcnMvbWVkaWEvcmFkaW8ve3NpNDcxMy1pMmMuYyA9PiBzaTQ3MTMvc2k0NzEzLmN9ICg5OSUp
CiByZW5hbWUgZHJpdmVycy9tZWRpYS9yYWRpby97c2k0NzEzLWkyYy5oID0+IHNpNDcxMy9zaTQ3
MTMuaH0gKDk5JSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3JhZGlvL0tjb25maWcgYi9k
cml2ZXJzL21lZGlhL3JhZGlvL0tjb25maWcKaW5kZXggNmVjZGMzOS4uNTdlYTljMyAxMDA2NDQK
LS0tIGEvZHJpdmVycy9tZWRpYS9yYWRpby9LY29uZmlnCisrKyBiL2RyaXZlcnMvbWVkaWEvcmFk
aW8vS2NvbmZpZwpAQCAtMTUsNiArMTUsMTIgQEAgaWYgUkFESU9fQURBUFRFUlMgJiYgVklERU9f
VjRMMgogY29uZmlnIFJBRElPX1RFQTU3NVgKIAl0cmlzdGF0ZQogCitjb25maWcgUkFESU9fU0k0
NzEzCisJdHJpc3RhdGUgIlNpbGljb24gTGFicyBTaTQ3MTMgRk0gUmFkaW8gd2l0aCBSRFMgVHJh
bnNtaXR0ZXIgc3VwcG9ydCIKKwlkZXBlbmRzIG9uIFZJREVPX1Y0TDIKKworc291cmNlICJkcml2
ZXJzL21lZGlhL3JhZGlvL3NpNDcxMy9LY29uZmlnIgorCiBjb25maWcgUkFESU9fU0k0NzBYCiAJ
Ym9vbCAiU2lsaWNvbiBMYWJzIFNpNDcweCBGTSBSYWRpbyBSZWNlaXZlciBzdXBwb3J0IgogCWRl
cGVuZHMgb24gVklERU9fVjRMMgpAQCAtMTEzLDI5ICsxMTksNiBAQCBjb25maWcgUkFESU9fU0hB
UksyCiAJICBUbyBjb21waWxlIHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBjaG9vc2UgTSBoZXJl
OiB0aGUKIAkgIG1vZHVsZSB3aWxsIGJlIGNhbGxlZCByYWRpby1zaGFyazIuCiAKLWNvbmZpZyBJ
MkNfU0k0NzEzCi0JdHJpc3RhdGUgIkkyQyBkcml2ZXIgZm9yIFNpbGljb24gTGFicyBTaTQ3MTMg
ZGV2aWNlIgotCWRlcGVuZHMgb24gSTJDICYmIFZJREVPX1Y0TDIKLQktLS1oZWxwLS0tCi0JICBT
YXkgWSBoZXJlIGlmIHlvdSB3YW50IHN1cHBvcnQgdG8gU2k0NzEzIEkyQyBkZXZpY2UuCi0JICBU
aGlzIGRldmljZSBkcml2ZXIgc3VwcG9ydHMgb25seSBpMmMgYnVzLgotCi0JICBUbyBjb21waWxl
IHRoaXMgZHJpdmVyIGFzIGEgbW9kdWxlLCBjaG9vc2UgTSBoZXJlOiB0aGUKLQkgIG1vZHVsZSB3
aWxsIGJlIGNhbGxlZCBzaTQ3MTMuCi0KLWNvbmZpZyBSQURJT19TSTQ3MTMKLQl0cmlzdGF0ZSAi
U2lsaWNvbiBMYWJzIFNpNDcxMyBGTSBSYWRpbyBUcmFuc21pdHRlciBzdXBwb3J0IgotCWRlcGVu
ZHMgb24gSTJDICYmIFZJREVPX1Y0TDIKLQlzZWxlY3QgSTJDX1NJNDcxMwotCS0tLWhlbHAtLS0K
LQkgIFNheSBZIGhlcmUgaWYgeW91IHdhbnQgc3VwcG9ydCB0byBTaTQ3MTMgRk0gUmFkaW8gVHJh
bnNtaXR0ZXIuCi0JICBUaGlzIGRldmljZSBjYW4gdHJhbnNtaXQgYXVkaW8gdGhyb3VnaCBGTS4g
SXQgY2FuIHRyYW5zbWl0Ci0JICBSRFMgYW5kIFJCRFMgc2lnbmFscyBhcyB3ZWxsLiBUaGlzIG1v
ZHVsZSBpcyB0aGUgdjRsMiByYWRpbwotCSAgaW50ZXJmYWNlIGZvciB0aGUgaTJjIGRyaXZlciBv
ZiB0aGlzIGRldmljZS4KLQotCSAgVG8gY29tcGlsZSB0aGlzIGRyaXZlciBhcyBhIG1vZHVsZSwg
Y2hvb3NlIE0gaGVyZTogdGhlCi0JICBtb2R1bGUgd2lsbCBiZSBjYWxsZWQgcmFkaW8tc2k0NzEz
LgotCiBjb25maWcgVVNCX0tFRU5FCiAJdHJpc3RhdGUgIktlZW5lIEZNIFRyYW5zbWl0dGVyIFVT
QiBzdXBwb3J0IgogCWRlcGVuZHMgb24gVVNCICYmIFZJREVPX1Y0TDIKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbWVkaWEvcmFkaW8vTWFrZWZpbGUgYi9kcml2ZXJzL21lZGlhL3JhZGlvL01ha2VmaWxl
CmluZGV4IDNiNjQ1NjAuLmViMWEzYTAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvcmFkaW8v
TWFrZWZpbGUKKysrIGIvZHJpdmVycy9tZWRpYS9yYWRpby9NYWtlZmlsZQpAQCAtMTcsMTIgKzE3
LDExIEBAIG9iai0kKENPTkZJR19SQURJT19SVFJBQ0spICs9IHJhZGlvLWFpbXNsYWIubwogb2Jq
LSQoQ09ORklHX1JBRElPX1pPTFRSSVgpICs9IHJhZGlvLXpvbHRyaXgubwogb2JqLSQoQ09ORklH
X1JBRElPX0dFTVRFSykgKz0gcmFkaW8tZ2VtdGVrLm8KIG9iai0kKENPTkZJR19SQURJT19UUlVT
VCkgKz0gcmFkaW8tdHJ1c3Qubwotb2JqLSQoQ09ORklHX0kyQ19TSTQ3MTMpICs9IHNpNDcxMy1p
MmMubwotb2JqLSQoQ09ORklHX1JBRElPX1NJNDcxMykgKz0gcmFkaW8tc2k0NzEzLm8KIG9iai0k
KENPTkZJR19SQURJT19TSTQ3NlgpICs9IHJhZGlvLXNpNDc2eC5vCiBvYmotJChDT05GSUdfUkFE
SU9fTUlST1BDTTIwKSArPSByYWRpby1taXJvcGNtMjAubwogb2JqLSQoQ09ORklHX1VTQl9EU0JS
KSArPSBkc2JyMTAwLm8KIG9iai0kKENPTkZJR19SQURJT19TSTQ3MFgpICs9IHNpNDcweC8KK29i
ai0kKENPTkZJR19SQURJT19TSTQ3MTMpICs9IHNpNDcxMy8KIG9iai0kKENPTkZJR19VU0JfTVI4
MDApICs9IHJhZGlvLW1yODAwLm8KIG9iai0kKENPTkZJR19VU0JfS0VFTkUpICs9IHJhZGlvLWtl
ZW5lLm8KIG9iai0kKENPTkZJR19VU0JfTUE5MDEpICs9IHJhZGlvLW1hOTAxLm8KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWVkaWEvcmFkaW8vc2k0NzEzL0tjb25maWcgYi9kcml2ZXJzL21lZGlhL3Jh
ZGlvL3NpNDcxMy9LY29uZmlnCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmVj
NjQwYjgKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL21lZGlhL3JhZGlvL3NpNDcxMy9LY29u
ZmlnCkBAIC0wLDAgKzEsMjUgQEAKK2NvbmZpZyBQTEFURk9STV9TSTQ3MTMKKwl0cmlzdGF0ZSAi
U2lsaWNvbiBMYWJzIFNpNDcxMyBGTSBSYWRpbyBUcmFuc21pdHRlciBzdXBwb3J0IHdpdGggSTJD
IgorCWRlcGVuZHMgb24gSTJDICYmIFJBRElPX1NJNDcxMworCXNlbGVjdCBTSTQ3MTMKKwktLS1o
ZWxwLS0tCisJICBUaGlzIGlzIGEgZHJpdmVyIGZvciBJMkMgZGV2aWNlcyB3aXRoIHRoZSBTaWxp
Y29uIExhYnMgU0k0NzEzCisJICBjaGlwLgorCisJICBTYXkgWSBoZXJlIGlmIHlvdSB3YW50IHRv
IGNvbm5lY3QgdGhpcyB0eXBlIG9mIHJhZGlvIHRvIHlvdXIKKwkgIGNvbXB1dGVyJ3MgSTJDIHBv
cnQuCisKKwkgIFRvIGNvbXBpbGUgdGhpcyBkcml2ZXIgYXMgYSBtb2R1bGUsIGNob29zZSBNIGhl
cmU6IHRoZQorCSAgbW9kdWxlIHdpbGwgYmUgY2FsbGVkIHJhZGlvLXBsYXRmb3JtLXNpNDcxMy4K
KworY29uZmlnIEkyQ19TSTQ3MTMKKwl0cmlzdGF0ZSAiU2lsaWNvbiBMYWJzIFNpNDcxMyBGTSBS
YWRpbyBUcmFuc21pdHRlciBzdXBwb3J0IgorCWRlcGVuZHMgb24gSTJDICYmIFJBRElPX1NJNDcx
MworCS0tLWhlbHAtLS0KKwkgIFNheSBZIGhlcmUgaWYgeW91IHdhbnQgc3VwcG9ydCB0byBTaTQ3
MTMgRk0gUmFkaW8gVHJhbnNtaXR0ZXIuCisJICBUaGlzIGRldmljZSBjYW4gdHJhbnNtaXQgYXVk
aW8gdGhyb3VnaCBGTS4gSXQgY2FuIHRyYW5zbWl0CisJICBSRFMgYW5kIFJCRFMgc2lnbmFscyBh
cyB3ZWxsLiBUaGlzIG1vZHVsZSBpcyB0aGUgdjRsMiByYWRpbworCSAgaW50ZXJmYWNlIGZvciB0
aGUgaTJjIGRyaXZlciBvZiB0aGlzIGRldmljZS4KKworCSAgVG8gY29tcGlsZSB0aGlzIGRyaXZl
ciBhcyBhIG1vZHVsZSwgY2hvb3NlIE0gaGVyZTogdGhlCisJICBtb2R1bGUgd2lsbCBiZSBjYWxs
ZWQgc2k0NzEzLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMvTWFrZWZp
bGUgYi9kcml2ZXJzL21lZGlhL3JhZGlvL3NpNDcxMy9NYWtlZmlsZQpuZXcgZmlsZSBtb2RlIDEw
MDY0NAppbmRleCAwMDAwMDAwLi45ZDBiZDBlCi0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVycy9t
ZWRpYS9yYWRpby9zaTQ3MTMvTWFrZWZpbGUKQEAgLTAsMCArMSw3IEBACisjCisjIE1ha2VmaWxl
IGZvciByYWRpb3Mgd2l0aCBTaWxpY29uIExhYnMgU2k0NzEzIEZNIFJhZGlvIFRyYW5zbWl0dGVy
cworIworCitvYmotJChDT05GSUdfSTJDX1NJNDcxMykgKz0gc2k0NzEzLm8KK29iai0kKENPTkZJ
R19QTEFURk9STV9TSTQ3MTMpICs9IHJhZGlvLXBsYXRmb3JtLXNpNDcxMy5vCisKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWVkaWEvcmFkaW8vcmFkaW8tc2k0NzEzLmMgYi9kcml2ZXJzL21lZGlhL3Jh
ZGlvL3NpNDcxMy9yYWRpby1wbGF0Zm9ybS1zaTQ3MTMuYwpzaW1pbGFyaXR5IGluZGV4IDk5JQpy
ZW5hbWUgZnJvbSBkcml2ZXJzL21lZGlhL3JhZGlvL3JhZGlvLXNpNDcxMy5jCnJlbmFtZSB0byBk
cml2ZXJzL21lZGlhL3JhZGlvL3NpNDcxMy9yYWRpby1wbGF0Zm9ybS1zaTQ3MTMuYwppbmRleCBi
YTRjZmM5Li5jZjBhYWQ0IDEwMDY0NAotLS0gYS9kcml2ZXJzL21lZGlhL3JhZGlvL3JhZGlvLXNp
NDcxMy5jCisrKyBiL2RyaXZlcnMvbWVkaWEvcmFkaW8vc2k0NzEzL3JhZGlvLXBsYXRmb3JtLXNp
NDcxMy5jCkBAIC0xLDUgKzEsNSBAQAogLyoKLSAqIGRyaXZlcnMvbWVkaWEvcmFkaW8vcmFkaW8t
c2k0NzEzLmMKKyAqIGRyaXZlcnMvbWVkaWEvcmFkaW8vcmFkaW8tcGxhdGZvcm0tc2k0NzEzLmMK
ICAqCiAgKiBQbGF0Zm9ybSBEcml2ZXIgZm9yIFNpbGljb24gTGFicyBTaTQ3MTMgRk0gUmFkaW8g
VHJhbnNtaXR0ZXI6CiAgKgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMt
aTJjLmMgYi9kcml2ZXJzL21lZGlhL3JhZGlvL3NpNDcxMy9zaTQ3MTMuYwpzaW1pbGFyaXR5IGlu
ZGV4IDk5JQpyZW5hbWUgZnJvbSBkcml2ZXJzL21lZGlhL3JhZGlvL3NpNDcxMy1pMmMuYwpyZW5h
bWUgdG8gZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMvc2k0NzEzLmMKaW5kZXggZmUxNjA4OC4u
YWM3MjdlMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMtaTJjLmMKKysr
IGIvZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMvc2k0NzEzLmMKQEAgLTEsNSArMSw1IEBACiAv
KgotICogZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMtaTJjLmMKKyAqIGRyaXZlcnMvbWVkaWEv
cmFkaW8vc2k0NzEzLmMKICAqCiAgKiBTaWxpY29uIExhYnMgU2k0NzEzIEZNIFJhZGlvIFRyYW5z
bWl0dGVyIEkyQyBjb21tYW5kcy4KICAqCkBAIC0zMyw3ICszMyw3IEBACiAjaW5jbHVkZSA8bWVk
aWEvdjRsMi1pb2N0bC5oPgogI2luY2x1ZGUgPG1lZGlhL3Y0bDItY29tbW9uLmg+CiAKLSNpbmNs
dWRlICJzaTQ3MTMtaTJjLmgiCisjaW5jbHVkZSAic2k0NzEzLmgiCiAKIC8qIG1vZHVsZSBwYXJh
bWV0ZXJzICovCiBzdGF0aWMgaW50IGRlYnVnOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZWRpYS9y
YWRpby9zaTQ3MTMtaTJjLmggYi9kcml2ZXJzL21lZGlhL3JhZGlvL3NpNDcxMy9zaTQ3MTMuaApz
aW1pbGFyaXR5IGluZGV4IDk5JQpyZW5hbWUgZnJvbSBkcml2ZXJzL21lZGlhL3JhZGlvL3NpNDcx
My1pMmMuaApyZW5hbWUgdG8gZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMvc2k0NzEzLmgKaW5k
ZXggMjVjZGVhMi4uYzI3NGUxZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3
MTMtaTJjLmgKKysrIGIvZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMvc2k0NzEzLmgKQEAgLTEs
NSArMSw1IEBACiAvKgotICogZHJpdmVycy9tZWRpYS9yYWRpby9zaTQ3MTMtaTJjLmgKKyAqIGRy
aXZlcnMvbWVkaWEvcmFkaW8vc2k0NzEzLmgKICAqCiAgKiBQcm9wZXJ0eSBhbmQgY29tbWFuZHMg
ZGVmaW5pdGlvbnMgZm9yIFNpNDcxMyByYWRpbyB0cmFuc21pdHRlciBjaGlwLgogICoKLS0gCjEu
Ny45LjUKCg==

--_002_C40DBE54484849439FC5081A05AEF5F5979F9B9EPLOXCHG24cernch_--
