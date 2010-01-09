Return-path: <linux-media-owner@vger.kernel.org>
Received: from web32702.mail.mud.yahoo.com ([68.142.207.246]:25736 "HELO
	web32702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751739Ab0AITaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2010 14:30:23 -0500
Message-ID: <430160.90047.qm@web32702.mail.mud.yahoo.com>
Date: Sat, 9 Jan 2010 11:30:21 -0800 (PST)
From: Franklin Meng <fmeng2002@yahoo.com>
Subject: Re: Kworld 315U and SAA7113?
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-192532993-1263065421=:90047"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0-192532993-1263065421=:90047
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I tweaked the GPIO's a bit more for the Kworld 315U and switching between a=
nalog and digital signals is more reliable now.  Attached is an updated dif=
f.  =0A=0Adiff -r b6b82258cf5e linux/drivers/media/video/em28xx/em28xx-card=
s.c=0A--- a/linux/drivers/media/video/em28xx/em28xx-cards.c   Thu Dec 31 19=
:14:54 2009 -0200=0A+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c  =
 Sat Jan 09 11:29:27 2010 -0800=0A@@ -122,13 +122,31 @@                    =
                                             =0A };                        =
                                                           =0A #endif      =
                                                                         =
=0A                                                                        =
              =0A+/* Kworld 315U                                           =
                            =0A+   GPIO0 - Enable digital power (lgdt3303) =
- low to enable                           =0A+   GPIO1 - Enable analog powe=
r (saa7113/emp202) - low to enable                      =0A+   GPIO7 - enab=
les something ?                                                       =0A+ =
  GOP2  - ?? some sort of reset ?                                          =
         =0A+   GOP3  - lgdt3303 reset                                     =
                       =0A+ */                                             =
                                     =0A /* Board - EM2882 Kworld 315U digi=
tal */                                             =0A static struct em28xx=
_reg_seq em2882_kworld_315u_digital[] =3D {                        =0A-    =
   {EM28XX_R08_GPIO,       0xff,   0xff,           10},                    =
      =0A-       {EM28XX_R08_GPIO,       0xfe,   0xff,           10},      =
                    =0A+       {EM28XX_R08_GPIO,       0x7e,   0xff,       =
    10},                          =0A        {EM2880_R04_GPO,        0x04, =
  0xff,           10},                          =0A        {EM2880_R04_GPO,=
        0x0c,   0xff,           10},                          =0A-       {E=
M28XX_R08_GPIO,       0x7e,   0xff,           10},                         =
 =0A+       {  -1,                  -1,     -1,             -1},           =
               =0A+};                                                      =
                             =0A+                                          =
                                           =0A+/* Board - EM2882 Kworld 315=
U analog1 analog tv */                                   =0A+static struct =
em28xx_reg_seq em2882_kworld_315u_analog1[] =3D {                        =
=0A+       {EM28XX_R08_GPIO,       0xfd,   0xff,           10},            =
              =0A+       {EM28XX_R08_GPIO,       0x7d,   0xff,           10=
},                          =0A+       {  -1,                  -1,     -1, =
            -1},                          =0A+};                           =
                                                        =0A+               =
                                                                      =0A+/=
* Board - EM2882 Kworld 315U analog2 component/svideo */                   =
         =0A+static struct em28xx_reg_seq em2882_kworld_315u_analog2[] =3D =
{                        =0A+       {EM28XX_R08_GPIO,       0xfd,   0xff,  =
         10},                          =0A        {  -1,                  -=
1,     -1,             -1},                          =0A };                =
                                                                   =0A     =
                                                                           =
      =0A@@ -140,6 +158,14 @@                                              =
                    =0A        {  -1,                  -1,     -1,         =
    -1},                          =0A };                                   =
                                                =0A                        =
                                                              =0A+/* Board =
- EM2882 Kworld 315U suspend */                                            =
 =0A+static struct em28xx_reg_seq em2882_kworld_315u_suspend[] =3D {       =
                 =0A+       {EM28XX_R08_GPIO,       0xff,   0xff,          =
 10},                          =0A+       {EM2880_R04_GPO,        0x08,   0=
xff,           10},                          =0A+       {EM2880_R04_GPO,   =
     0x0c,   0xff,           10},                          =0A+       {  -1=
,                  -1,     -1,             -1},                          =
=0A+};                                                                     =
              =0A+                                                         =
                            =0A static struct em28xx_reg_seq kworld_330u_an=
alog[] =3D {                                =0A        {EM28XX_R08_GPIO,   =
    0x6d,   ~EM_GPIO_4,     10},                          =0A        {EM288=
0_R04_GPO,        0x00,   0xff,           10},                          =0A=
@@ -1314,28 +1340,28 @@                                                    =
           =0A                .decoder        =3D EM28XX_SAA711X,          =
                           =0A                .has_dvb        =3D 1,       =
                                           =0A                .dvb_gpio    =
   =3D em2882_kworld_315u_digital,                         =0A+            =
   .suspend_gpio   =3D em2882_kworld_315u_suspend,                         =
=0A                .xclk           =3D EM28XX_XCLK_FREQUENCY_12MHZ,        =
                =0A                .i2c_speed      =3D EM28XX_I2C_CLK_WAIT_=
ENABLE,                         =0A-               /* Analog mode - still n=
ot ready */                                   =0A-               /*.input  =
      =3D { {                                                 =0A+         =
      .input        =3D { {                                                =
   =0A                        .type =3D EM28XX_VMUX_TELEVISION,            =
                   =0A                        .vmux =3D SAA7115_COMPOSITE2,=
                                   =0A                        .amux =3D EM2=
8XX_AMUX_VIDEO,                                    =0A-                    =
   .gpio =3D em2882_kworld_315u_analog,                            =0A+    =
                   .gpio =3D em2882_kworld_315u_analog1,                   =
        =0A                        .aout =3D EM28XX_AOUT_PCM_IN | EM28XX_AO=
UT_PCM_STEREO,          =0A                }, {                            =
                                      =0A                        .type =3D =
EM28XX_VMUX_COMPOSITE1,                               =0A                  =
      .vmux =3D SAA7115_COMPOSITE0,                                   =0A  =
                      .amux =3D EM28XX_AMUX_LINE_IN,                       =
           =0A-                       .gpio =3D em2882_kworld_315u_analog1,=
                           =0A+                       .gpio =3D em2882_kwor=
ld_315u_analog2,                           =0A                        .aout=
 =3D EM28XX_AOUT_PCM_IN | EM28XX_AOUT_PCM_STEREO,          =0A             =
   }, {                                                                  =
=0A                        .type =3D EM28XX_VMUX_SVIDEO,                   =
                =0A                        .vmux =3D SAA7115_SVIDEO3,      =
                                =0A                        .amux =3D EM28XX=
_AMUX_LINE_IN,                                  =0A-                       =
.gpio =3D em2882_kworld_315u_analog1,                           =0A+       =
                .gpio =3D em2882_kworld_315u_analog2,                      =
     =0A                        .aout =3D EM28XX_AOUT_PCM_IN | EM28XX_AOUT_=
PCM_STEREO,          =0A-               } }, */                            =
                                   =0A+               } },                 =
                                                 =0A        },             =
                                                               =0A        [=
EM2880_BOARD_EMPIRE_DUAL_TV] =3D {                                         =
    =0A                .name =3D "Empire dual TV",                         =
                    =0Adiff -r b6b82258cf5e linux/drivers/media/video/em28x=
x/em28xx-core.c                   =0A--- a/linux/drivers/media/video/em28xx=
/em28xx-core.c    Thu Dec 31 19:14:54 2009 -0200=0A+++ b/linux/drivers/medi=
a/video/em28xx/em28xx-core.c    Sat Jan 09 11:29:27 2010 -0800=0A@@ -1132,6=
 +1132,7 @@                                                                =
 =0A  */                                                                   =
               =0A void em28xx_wake_i2c(struct em28xx *dev)                =
                             =0A {                                         =
                                           =0A+       v4l2_device_call_all(=
&dev->v4l2_dev, 0, core,  s_power, 1);                   =0A        v4l2_de=
vice_call_all(&dev->v4l2_dev, 0, core,  reset, 0);                     =0A =
       v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,           =
          =0A                        INPUT(dev->ctl_input)->vmux, 0, 0);   =
                        =0Adiff -r b6b82258cf5e linux/drivers/media/video/s=
aa7115.c                              =0A--- a/linux/drivers/media/video/sa=
a7115.c       Thu Dec 31 19:14:54 2009 -0200        =0A+++ b/linux/drivers/=
media/video/saa7115.c       Sat Jan 09 11:29:27 2010 -0800        =0A@@ -13=
38,6 +1338,59 @@                                                           =
     =0A        return 0;                                                  =
                   =0A }                                                   =
                                 =0A                                       =
                                               =0A+static int saa711x_s_pow=
er(struct v4l2_subdev *sd, int val)                          =0A+{         =
                                                                           =
=0A+       struct saa711x_state *state =3D to_state(sd);                   =
                =0A+                                                       =
                              =0A+       if(val > 1 || val < 0)            =
                                            =0A+               return -EINV=
AL;                                                       =0A+             =
                                                                        =0A=
+       /* There really isn't a way to put the chip into power saving      =
           =0A+               other than by pulling CE to ground so all we =
do is return             =0A+               out of this function           =
                                       =0A+       */                       =
                                                     =0A+       if(val =3D=
=3D 0)                                                                  =0A=
+               return 0;                                                  =
           =0A+                                                            =
                         =0A+       /* When enabling the chip again we need=
 to reinitialize the                   =0A+               all the values   =
                                                     =0A+       */         =
                                                                   =0A+    =
   state->input =3D -1;                                                    =
        =0A+       state->output =3D SAA7115_IPORT_ON;                     =
                        =0A+       state->enable =3D 1;                    =
                                        =0A+       state->radio =3D 0;     =
                                                        =0A+       state->b=
right =3D 128;                                                          =0A=
+       state->contrast =3D 64;                                            =
             =0A+       state->hue =3D 0;                                  =
                             =0A+       state->sat =3D 64;                 =
                                             =0A+                          =
                                                           =0A+       state=
->audclk_freq =3D 48000;                                                   =
=0A+                                                                       =
              =0A+       v4l2_dbg(1, debug, sd, "writing init values s_powe=
r\n");                      =0A+                                           =
                                          =0A+       /* init to 60hz/48khz =
*/                                                      =0A+       state->c=
rystal_freq =3D SAA7115_FREQ_24_576_MHZ;                                =0A=
+       switch (state->ident) {                                            =
           =0A+       case V4L2_IDENT_SAA7111:                             =
                         =0A+               saa711x_writeregs(sd, saa7111_i=
nit);                                  =0A+               break;           =
                                                     =0A+       case V4L2_I=
DENT_SAA7113:                                                      =0A+    =
           saa711x_writeregs(sd, saa7113_init);=0A+               break;=0A=
+       default:=0A+               state->crystal_freq =3D SAA7115_FREQ_32_=
11_MHZ;=0A+               saa711x_writeregs(sd, saa7115_init_auto_input);=
=0A+       }=0A+       if (state->ident !=3D V4L2_IDENT_SAA7111)=0A+       =
        saa711x_writeregs(sd, saa7115_init_misc);=0A+       saa711x_set_v4l=
std(sd, V4L2_STD_NTSC);=0A+=0A+       v4l2_dbg(1, debug, sd, "status: (1E) =
0x%02x, (1F) 0x%02x\n",=0A+               saa711x_read(sd, R_1E_STATUS_BYTE=
_1_VD_DEC),=0A+               saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC));=
=0A+       return 0;=0A+}=0A+=0A static int saa711x_reset(struct v4l2_subde=
v *sd, u32 val)=0A {=0A        v4l2_dbg(1, debug, sd, "decoder RESET\n");=
=0A@@ -1513,6 +1566,7 @@=0A        .s_std =3D saa711x_s_std,=0A        .res=
et =3D saa711x_reset,=0A        .s_gpio =3D saa711x_s_gpio,=0A+       .s_po=
wer =3D saa711x_s_power,=0A #ifdef CONFIG_VIDEO_ADV_DEBUG=0A        .g_regi=
ster =3D saa711x_g_register,=0A        .s_register =3D saa711x_s_register,=
=0A=0A=0AThanks,=0AFranklin Meng=0A=0A--- On Thu, 1/7/10, Franklin Meng <fm=
eng2002@yahoo.com> wrote:=0A=0A> From: Franklin Meng <fmeng2002@yahoo.com>=
=0A> Subject: Kworld 315U and SAA7113?=0A> To: linux-media@vger.kernel.org=
=0A> Date: Thursday, January 7, 2010, 7:48 PM=0A> After some work I have fi=
nally gotten=0A> the analog inputs to work with the Kworld 315U device.=A0 =
I=0A> have attached the changes/updates to the em28xx driver.=0A> Note: I s=
till don't have analog sound working yet..=0A> =0A> I am hoping someone can=
 comment on the changes in=0A> saa7115.c.=A0 I added a s_power routine to r=
einitialize the=0A> device.=A0 The reason I am reinitializing this device i=
s=0A> because=0A> =0A> 1. I cannot keep both the LG demod and the SAA power=
ed on=0A> at the same time for my device=0A> =0A> 2. The SAA datasheet seem=
s to suggest that after a=0A> reset/power-on the chip needs to be reinitial=
ized.=A0 =0A> =0A> 3. Reinitializing causes the analog inputs to work=0A> c=
orrectly. =0A> =0A> Here's what is says in the SAA7113 datasheet.. =0A> ...=
.=0A> Status after power-on=0A> control sequence=0A> =0A> VPO7 to VPO0, RTC=
O, RTS0 and RTS1=0A> are held in high-impedance state=0A> =0A> after power-=
on (reset=0A> sequence) a complete=0A> I2C-bus transmission is=0A> required=
=0A> ...=0A> The above is really suppose to be arranged horizontally in=0A>=
 3 columns.=A0 Anyways, the last part describes that "a=0A> complete I2C bu=
s transmission is required"=A0 This is why=0A> I think the chip needs to be=
 reinitialized.=A0 =0A> =0A> =0A> Last thing is that the initialization rou=
ting uses these=0A> defaults:=0A> =0A> =A0 =A0 =A0=A0=A0state->bright =3D 1=
28;=0A> =A0 =A0 =A0=A0=A0state->contrast =3D 64;=0A> =A0 =A0 =A0=A0=A0state=
->hue =3D 0;=0A> =A0 =A0 =A0=A0=A0state->sat =3D 64;=0A> =0A> I was wonderi=
ng if we should just read the back the values=0A> that were initialized by =
the initialization routine and use=0A> those values instead.The reason is b=
ecause it seems like the=0A> different SAA's use slightly different values =
when=0A> initializing.=A0 =0A> =0A> Thanks,=0A> Franklin Meng=0A> =0A> =0A>=
 =A0 =A0 =A0=0A=0A=0A      
--0-192532993-1263065421=:90047
Content-Type: text/x-diff; name="curdiff1.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="curdiff1.diff"

ZGlmZiAtciBiNmI4MjI1OGNmNWUgbGludXgvZHJpdmVycy9tZWRpYS92aWRl
by9lbTI4eHgvZW0yOHh4LWNhcmRzLmMKLS0tIGEvbGludXgvZHJpdmVycy9t
ZWRpYS92aWRlby9lbTI4eHgvZW0yOHh4LWNhcmRzLmMJVGh1IERlYyAzMSAx
OToxNDo1NCAyMDA5IC0wMjAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vZW0yOHh4L2VtMjh4eC1jYXJkcy5jCVNhdCBKYW4gMDkgMTE6MjY6
MTMgMjAxMCAtMDgwMApAQCAtMTIyLDEzICsxMjIsMzEgQEAKIH07CiAjZW5k
aWYKIAorLyogS3dvcmxkIDMxNVUKKyAgIEdQSU8wIC0gRW5hYmxlIGRpZ2l0
YWwgcG93ZXIgKGxnZHQzMzAzKSAtIGxvdyB0byBlbmFibGUKKyAgIEdQSU8x
IC0gRW5hYmxlIGFuYWxvZyBwb3dlciAoc2FhNzExMy9lbXAyMDIpIC0gbG93
IHRvIGVuYWJsZQorICAgR1BJTzcgLSBlbmFibGVzIHNvbWV0aGluZyA/Cisg
ICBHT1AyICAtID8/IHNvbWUgc29ydCBvZiByZXNldCA/CisgICBHT1AzICAt
IGxnZHQzMzAzIHJlc2V0CisgKi8KIC8qIEJvYXJkIC0gRU0yODgyIEt3b3Js
ZCAzMTVVIGRpZ2l0YWwgKi8KIHN0YXRpYyBzdHJ1Y3QgZW0yOHh4X3JlZ19z
ZXEgZW0yODgyX2t3b3JsZF8zMTV1X2RpZ2l0YWxbXSA9IHsKLQl7RU0yOFhY
X1IwOF9HUElPLAkweGZmLAkweGZmLAkJMTB9LAotCXtFTTI4WFhfUjA4X0dQ
SU8sCTB4ZmUsCTB4ZmYsCQkxMH0sCisJe0VNMjhYWF9SMDhfR1BJTywJMHg3
ZSwJMHhmZiwJCTEwfSwKIAl7RU0yODgwX1IwNF9HUE8sCTB4MDQsCTB4ZmYs
CQkxMH0sCiAJe0VNMjg4MF9SMDRfR1BPLAkweDBjLAkweGZmLAkJMTB9LAot
CXtFTTI4WFhfUjA4X0dQSU8sCTB4N2UsCTB4ZmYsCQkxMH0sCisJeyAgLTEs
CQkJLTEsCS0xLAkJLTF9LAorfTsKKworLyogQm9hcmQgLSBFTTI4ODIgS3dv
cmxkIDMxNVUgYW5hbG9nMSBhbmFsb2cgdHYgKi8KK3N0YXRpYyBzdHJ1Y3Qg
ZW0yOHh4X3JlZ19zZXEgZW0yODgyX2t3b3JsZF8zMTV1X2FuYWxvZzFbXSA9
IHsKKwl7RU0yOFhYX1IwOF9HUElPLAkweGZkLAkweGZmLAkJMTB9LAorCXtF
TTI4WFhfUjA4X0dQSU8sCTB4N2QsCTB4ZmYsCQkxMH0sCisJeyAgLTEsCQkJ
LTEsCS0xLAkJLTF9LAorfTsKKworLyogQm9hcmQgLSBFTTI4ODIgS3dvcmxk
IDMxNVUgYW5hbG9nMiBjb21wb25lbnQvc3ZpZGVvICovCitzdGF0aWMgc3Ry
dWN0IGVtMjh4eF9yZWdfc2VxIGVtMjg4Ml9rd29ybGRfMzE1dV9hbmFsb2cy
W10gPSB7CisJe0VNMjhYWF9SMDhfR1BJTywJMHhmZCwJMHhmZiwJCTEwfSwK
IAl7ICAtMSwJCQktMSwJLTEsCQktMX0sCiB9OwogCkBAIC0xNDAsNiArMTU4
LDE0IEBACiAJeyAgLTEsCQkJLTEsCS0xLAkJLTF9LAogfTsKIAorLyogQm9h
cmQgLSBFTTI4ODIgS3dvcmxkIDMxNVUgc3VzcGVuZCAqLworc3RhdGljIHN0
cnVjdCBlbTI4eHhfcmVnX3NlcSBlbTI4ODJfa3dvcmxkXzMxNXVfc3VzcGVu
ZFtdID0geworCXtFTTI4WFhfUjA4X0dQSU8sCTB4ZmYsCTB4ZmYsCQkxMH0s
CisJe0VNMjg4MF9SMDRfR1BPLAkweDA4LAkweGZmLAkJMTB9LAorCXtFTTI4
ODBfUjA0X0dQTywJMHgwYywJMHhmZiwJCTEwfSwKKwl7ICAtMSwJCQktMSwJ
LTEsCQktMX0sCit9OworCiBzdGF0aWMgc3RydWN0IGVtMjh4eF9yZWdfc2Vx
IGt3b3JsZF8zMzB1X2FuYWxvZ1tdID0gewogCXtFTTI4WFhfUjA4X0dQSU8s
CTB4NmQsCX5FTV9HUElPXzQsCTEwfSwKIAl7RU0yODgwX1IwNF9HUE8sCTB4
MDAsCTB4ZmYsCQkxMH0sCkBAIC0xMzE0LDI4ICsxMzQwLDI4IEBACiAJCS5k
ZWNvZGVyCT0gRU0yOFhYX1NBQTcxMVgsCiAJCS5oYXNfZHZiCT0gMSwKIAkJ
LmR2Yl9ncGlvCT0gZW0yODgyX2t3b3JsZF8zMTV1X2RpZ2l0YWwsCisJCS5z
dXNwZW5kX2dwaW8JPSBlbTI4ODJfa3dvcmxkXzMxNXVfc3VzcGVuZCwKIAkJ
LnhjbGsJCT0gRU0yOFhYX1hDTEtfRlJFUVVFTkNZXzEyTUhaLAogCQkuaTJj
X3NwZWVkCT0gRU0yOFhYX0kyQ19DTEtfV0FJVF9FTkFCTEUsCi0JCS8qIEFu
YWxvZyBtb2RlIC0gc3RpbGwgbm90IHJlYWR5ICovCi0JCS8qLmlucHV0ICAg
ICAgICA9IHsgeworCQkuaW5wdXQgICAgICAgID0geyB7CiAJCQkudHlwZSA9
IEVNMjhYWF9WTVVYX1RFTEVWSVNJT04sCiAJCQkudm11eCA9IFNBQTcxMTVf
Q09NUE9TSVRFMiwKIAkJCS5hbXV4ID0gRU0yOFhYX0FNVVhfVklERU8sCi0J
CQkuZ3BpbyA9IGVtMjg4Ml9rd29ybGRfMzE1dV9hbmFsb2csCisJCQkuZ3Bp
byA9IGVtMjg4Ml9rd29ybGRfMzE1dV9hbmFsb2cxLAogCQkJLmFvdXQgPSBF
TTI4WFhfQU9VVF9QQ01fSU4gfCBFTTI4WFhfQU9VVF9QQ01fU1RFUkVPLAog
CQl9LCB7CiAJCQkudHlwZSA9IEVNMjhYWF9WTVVYX0NPTVBPU0lURTEsCiAJ
CQkudm11eCA9IFNBQTcxMTVfQ09NUE9TSVRFMCwKIAkJCS5hbXV4ID0gRU0y
OFhYX0FNVVhfTElORV9JTiwKLQkJCS5ncGlvID0gZW0yODgyX2t3b3JsZF8z
MTV1X2FuYWxvZzEsCisJCQkuZ3BpbyA9IGVtMjg4Ml9rd29ybGRfMzE1dV9h
bmFsb2cyLAogCQkJLmFvdXQgPSBFTTI4WFhfQU9VVF9QQ01fSU4gfCBFTTI4
WFhfQU9VVF9QQ01fU1RFUkVPLAogCQl9LCB7CiAJCQkudHlwZSA9IEVNMjhY
WF9WTVVYX1NWSURFTywKIAkJCS52bXV4ID0gU0FBNzExNV9TVklERU8zLAog
CQkJLmFtdXggPSBFTTI4WFhfQU1VWF9MSU5FX0lOLAotCQkJLmdwaW8gPSBl
bTI4ODJfa3dvcmxkXzMxNXVfYW5hbG9nMSwKKwkJCS5ncGlvID0gZW0yODgy
X2t3b3JsZF8zMTV1X2FuYWxvZzIsCiAJCQkuYW91dCA9IEVNMjhYWF9BT1VU
X1BDTV9JTiB8IEVNMjhYWF9BT1VUX1BDTV9TVEVSRU8sCi0JCX0gfSwgKi8K
KwkJfSB9LCAKIAl9LAogCVtFTTI4ODBfQk9BUkRfRU1QSVJFX0RVQUxfVFZd
ID0gewogCQkubmFtZSA9ICJFbXBpcmUgZHVhbCBUViIsCmRpZmYgLXIgYjZi
ODIyNThjZjVlIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2Vt
Mjh4eC1jb3JlLmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9l
bTI4eHgvZW0yOHh4LWNvcmUuYwlUaHUgRGVjIDMxIDE5OjE0OjU0IDIwMDkg
LTAyMDAKKysrIGIvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9lbTI4eHgv
ZW0yOHh4LWNvcmUuYwlTYXQgSmFuIDA5IDExOjI2OjEzIDIwMTAgLTA4MDAK
QEAgLTExMzIsNiArMTEzMiw3IEBACiAgKi8KIHZvaWQgZW0yOHh4X3dha2Vf
aTJjKHN0cnVjdCBlbTI4eHggKmRldikKIHsKKwl2NGwyX2RldmljZV9jYWxs
X2FsbCgmZGV2LT52NGwyX2RldiwgMCwgY29yZSwgIHNfcG93ZXIsIDEpOwog
CXY0bDJfZGV2aWNlX2NhbGxfYWxsKCZkZXYtPnY0bDJfZGV2LCAwLCBjb3Jl
LCAgcmVzZXQsIDApOwogCXY0bDJfZGV2aWNlX2NhbGxfYWxsKCZkZXYtPnY0
bDJfZGV2LCAwLCB2aWRlbywgc19yb3V0aW5nLAogCQkJSU5QVVQoZGV2LT5j
dGxfaW5wdXQpLT52bXV4LCAwLCAwKTsKZGlmZiAtciBiNmI4MjI1OGNmNWUg
bGludXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTE1LmMKLS0tIGEvbGlu
dXgvZHJpdmVycy9tZWRpYS92aWRlby9zYWE3MTE1LmMJVGh1IERlYyAzMSAx
OToxNDo1NCAyMDA5IC0wMjAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEv
dmlkZW8vc2FhNzExNS5jCVNhdCBKYW4gMDkgMTE6MjY6MTMgMjAxMCAtMDgw
MApAQCAtMTMzOCw2ICsxMzM4LDU5IEBACiAJcmV0dXJuIDA7CiB9CiAKK3N0
YXRpYyBpbnQgc2FhNzExeF9zX3Bvd2VyKHN0cnVjdCB2NGwyX3N1YmRldiAq
c2QsIGludCB2YWwpCit7CisJc3RydWN0IHNhYTcxMXhfc3RhdGUgKnN0YXRl
ID0gdG9fc3RhdGUoc2QpOworCisJaWYodmFsID4gMSB8fCB2YWwgPCAwKQor
CQlyZXR1cm4gLUVJTlZBTDsKKworCS8qIFRoZXJlIHJlYWxseSBpc24ndCBh
IHdheSB0byBwdXQgdGhlIGNoaXAgaW50byBwb3dlciBzYXZpbmcgCisJCW90
aGVyIHRoYW4gYnkgcHVsbGluZyBDRSB0byBncm91bmQgc28gYWxsIHdlIGRv
IGlzIHJldHVybgorCQlvdXQgb2YgdGhpcyBmdW5jdGlvbgorCSovCisJaWYo
dmFsID09IDApCisJCXJldHVybiAwOworCisJLyogV2hlbiBlbmFibGluZyB0
aGUgY2hpcCBhZ2FpbiB3ZSBuZWVkIHRvIHJlaW5pdGlhbGl6ZSB0aGUgCisJ
CWFsbCB0aGUgdmFsdWVzCisJKi8KKwlzdGF0ZS0+aW5wdXQgPSAtMTsKKwlz
dGF0ZS0+b3V0cHV0ID0gU0FBNzExNV9JUE9SVF9PTjsKKwlzdGF0ZS0+ZW5h
YmxlID0gMTsKKwlzdGF0ZS0+cmFkaW8gPSAwOworCXN0YXRlLT5icmlnaHQg
PSAxMjg7CisJc3RhdGUtPmNvbnRyYXN0ID0gNjQ7CisJc3RhdGUtPmh1ZSA9
IDA7CisJc3RhdGUtPnNhdCA9IDY0OworCisJc3RhdGUtPmF1ZGNsa19mcmVx
ID0gNDgwMDA7CisKKwl2NGwyX2RiZygxLCBkZWJ1Zywgc2QsICJ3cml0aW5n
IGluaXQgdmFsdWVzIHNfcG93ZXJcbiIpOworCisJLyogaW5pdCB0byA2MGh6
LzQ4a2h6ICovCisJc3RhdGUtPmNyeXN0YWxfZnJlcSA9IFNBQTcxMTVfRlJF
UV8yNF81NzZfTUhaOworCXN3aXRjaCAoc3RhdGUtPmlkZW50KSB7CisJY2Fz
ZSBWNEwyX0lERU5UX1NBQTcxMTE6CisJCXNhYTcxMXhfd3JpdGVyZWdzKHNk
LCBzYWE3MTExX2luaXQpOworCQlicmVhazsKKwljYXNlIFY0TDJfSURFTlRf
U0FBNzExMzoKKwkJc2FhNzExeF93cml0ZXJlZ3Moc2QsIHNhYTcxMTNfaW5p
dCk7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJCXN0YXRlLT5jcnlzdGFsX2Zy
ZXEgPSBTQUE3MTE1X0ZSRVFfMzJfMTFfTUhaOworCQlzYWE3MTF4X3dyaXRl
cmVncyhzZCwgc2FhNzExNV9pbml0X2F1dG9faW5wdXQpOworCX0KKwlpZiAo
c3RhdGUtPmlkZW50ICE9IFY0TDJfSURFTlRfU0FBNzExMSkKKwkJc2FhNzEx
eF93cml0ZXJlZ3Moc2QsIHNhYTcxMTVfaW5pdF9taXNjKTsKKwlzYWE3MTF4
X3NldF92NGxzdGQoc2QsIFY0TDJfU1REX05UU0MpOworCisJdjRsMl9kYmco
MSwgZGVidWcsIHNkLCAic3RhdHVzOiAoMUUpIDB4JTAyeCwgKDFGKSAweCUw
MnhcbiIsCisJCXNhYTcxMXhfcmVhZChzZCwgUl8xRV9TVEFUVVNfQllURV8x
X1ZEX0RFQyksCisJCXNhYTcxMXhfcmVhZChzZCwgUl8xRl9TVEFUVVNfQllU
RV8yX1ZEX0RFQykpOworCXJldHVybiAwOworfQorCiBzdGF0aWMgaW50IHNh
YTcxMXhfcmVzZXQoc3RydWN0IHY0bDJfc3ViZGV2ICpzZCwgdTMyIHZhbCkK
IHsKIAl2NGwyX2RiZygxLCBkZWJ1Zywgc2QsICJkZWNvZGVyIFJFU0VUXG4i
KTsKQEAgLTE1MTMsNiArMTU2Niw3IEBACiAJLnNfc3RkID0gc2FhNzExeF9z
X3N0ZCwKIAkucmVzZXQgPSBzYWE3MTF4X3Jlc2V0LAogCS5zX2dwaW8gPSBz
YWE3MTF4X3NfZ3BpbywKKwkuc19wb3dlciA9IHNhYTcxMXhfc19wb3dlciwK
ICNpZmRlZiBDT05GSUdfVklERU9fQURWX0RFQlVHCiAJLmdfcmVnaXN0ZXIg
PSBzYWE3MTF4X2dfcmVnaXN0ZXIsCiAJLnNfcmVnaXN0ZXIgPSBzYWE3MTF4
X3NfcmVnaXN0ZXIsCg==

--0-192532993-1263065421=:90047--
