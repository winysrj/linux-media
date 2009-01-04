Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <b24e53350901032231l6630addbx17af1fb089327bd4@mail.gmail.com>
Date: Sun, 4 Jan 2009 01:31:29 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
In-Reply-To: <b24e53350901032155n6b438cd2xaefe496f51c15447@mail.gmail.com>
MIME-Version: 1.0
References: <b24e53350901032021t2fdc4e54saec05f223d430f35@mail.gmail.com>
	<412bdbff0901032118y9dda1c2uaeb451c0874a65cd@mail.gmail.com>
	<b24e53350901032155n6b438cd2xaefe496f51c15447@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: Jerry Geis <geisj@messagenetsystems.com>, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: KWorld 330U Employs Samsung S5H1409X01 Demodulator
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

On Sun, Jan 4, 2009 at 12:55 AM, Robert Krakora <
rob.krakora@messagenetsystems.com> wrote:

>
>
> On Sun, Jan 4, 2009 at 12:18 AM, Devin Heitmueller <
> devin.heitmueller@gmail.com> wrote:
>
>> On Sat, Jan 3, 2009 at 11:21 PM, Robert Krakora
>> <rob.krakora@messagenetsystems.com> wrote:
>> > Mauro:
>> >
>> > The KWorld 330U employs the Samsung S5H1409X01 demodulator, not the
>> > LGDT330X.  Hence the error initializing the LGDT330X in the current
>> source
>> > in em28xx-dvb.c.
>> >
>> > Best Regards,
>>
>> Hello Robert,
>>
>> Well, that's good to know.  I don't think anyone has done any work on
>> that device recently, so I don't know why the code has it as an
>> lgdt3303.
>>
>> Do you know which tuner chip the device has?  The reason I ask is
>> because I'm working on another device that also has the s5h1409, and
>> it's got an xc3028L (the low power version of the xc3028).  If the
>> 330U also has the xc3028L, then we need to make sure to indicate that
>> in the device profile so it doesn't burn out the chip.
>>
>> We're probably also going to need to get a Windows trace, so we know
>> how to setup the s5h1409 configuration.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>>
>>
> Devin:
>
> I believe that it has the 3028 and not the 3028L as the part gets a little
> toasty even on Windows,  I will get the magnifying glass out and look again
> though (I am over 40 and becoming near-sighted).  I can get the Windows
> trace using USBTrace on Windows XP or with my Elisys USB Analyzer.
>
>
> Best Regards,
>
> --
> Rob Krakora
> Software Engineer
> MessageNet Systems
> 101 East Carmel Dr. Suite 105
> Carmel, IN 46032
> (317)566-1677 Ext. 206
> (317)663-0808 Fax
>

Devin:

I took a stab at attaching the Samsung demod to the em28xx and got the
following error.  My guess is that the demod address is wrong.  How does one
go about dissecting vendor requests in a USB trace to obtain setup
information for this part?  I was going to put an I2C analyzer on the I2C
line while running Windows to capture I2C traffic.  I will get a Windows USB
trace tomorrow and e-mail it out.  Sure would be easier with the specs or a
little help from KWorld.  ;-)

s5h1409_readreg: readreg error (ret == -19)
em28xx #0/2: dvb frontend not attached. Can't attach xc3028
Em28xx: Initialized (Em28xx dvb Extension) extension


[root@am2mm v4l-dvb]# hg diff
diff -r 211ae674f601 linux/drivers/media/video/em28xx/em28xx-audio.c
--- a/linux/drivers/media/video/em28xx/em28xx-audio.c   Fri Jan 02 18:34:28
2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-audio.c   Sun Jan 04 01:24:39
2009 -0500
@@ -63,9 +63,11 @@

        dprintk("Stopping isoc\n");
        for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
-               usb_unlink_urb(dev->adev.urb[i]);
+               usb_kill_urb(dev->adev.urb[i]);
                usb_free_urb(dev->adev.urb[i]);
                dev->adev.urb[i] = NULL;
+               kfree(dev->adev.transfer_buffer[i]);
+               dev->adev.transfer_buffer[i] = NULL;
        }

        return 0;
diff -r 211ae674f601 linux/drivers/media/video/em28xx/em28xx-cards.c
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c   Fri Jan 02 18:34:28
2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c   Sun Jan 04 01:24:39
2009 -0500
@@ -1242,31 +1242,31 @@
                        .gpio     = hauppauge_wintv_hvr_900_analog,
                } },
        },
-       [EM2883_BOARD_KWORLD_HYBRID_A316] = {
-               .name         = "Kworld PlusTV HD Hybrid 330",
-               .tuner_type   = TUNER_XC2028,
-               .tuner_gpio   = default_tuner_gpio,
-               .decoder      = EM28XX_TVP5150,
-               .mts_firmware = 1,
-               .has_dvb      = 1,
-               .dvb_gpio     = default_digital,
-               .input        = { {
-                       .type     = EM28XX_VMUX_TELEVISION,
-                       .vmux     = TVP5150_COMPOSITE0,
-                       .amux     = EM28XX_AMUX_VIDEO,
-                       .gpio     = default_analog,
-               }, {
-                       .type     = EM28XX_VMUX_COMPOSITE1,
-                       .vmux     = TVP5150_COMPOSITE1,
-                       .amux     = EM28XX_AMUX_LINE_IN,
-                       .gpio     = hauppauge_wintv_hvr_900_analog,
-               }, {
-                       .type     = EM28XX_VMUX_SVIDEO,
-                       .vmux     = TVP5150_SVIDEO,
-                       .amux     = EM28XX_AMUX_LINE_IN,
-                       .gpio     = hauppauge_wintv_hvr_900_analog,
-               } },
-       },
+        [EM2883_BOARD_KWORLD_HYBRID_A316] = {
+                .name         = "Kworld PlusTV HD Hybrid 330",
+                .tuner_type   = TUNER_XC2028,
+                .tuner_gpio   = default_tuner_gpio,
+                .has_dvb      = 1,
+                .dvb_gpio     = default_digital,
+                .mts_firmware = 1,
+                .decoder      = EM28XX_TVP5150,
+                .input        = { {
+                        .type     = EM28XX_VMUX_TELEVISION,
+                        .vmux     = TVP5150_COMPOSITE0,
+                        .amux     = EM28XX_AMUX_VIDEO,
+                        .gpio     = default_analog,
+                }, {
+                        .type     = EM28XX_VMUX_COMPOSITE1,
+                        .vmux     = TVP5150_COMPOSITE1,
+                        .amux     = EM28XX_AMUX_LINE_IN,
+                        .gpio     = default_analog,
+                }, {
+                        .type     = EM28XX_VMUX_SVIDEO,
+                        .vmux     = TVP5150_SVIDEO,
+                        .amux     = EM28XX_AMUX_LINE_IN,
+                        .gpio     = default_analog,
+                } },
+        },
        [EM2820_BOARD_COMPRO_VIDEOMATE_FORYOU] = {
                .name         = "Compro VideoMate ForYou/Stereo",
                .tuner_type   = TUNER_LG_PAL_NEW_TAPC,
diff -r 211ae674f601 linux/drivers/media/video/em28xx/em28xx-dvb.c
--- a/linux/drivers/media/video/em28xx/em28xx-dvb.c     Fri Jan 02 18:34:28
2009 -0200
+++ b/linux/drivers/media/video/em28xx/em28xx-dvb.c     Sun Jan 04 01:24:39
2009 -0500
@@ -29,6 +29,7 @@

 #include "lgdt330x.h"
 #include "zl10353.h"
+#include "s5h1409.h"
 #ifdef EM28XX_DRX397XD_SUPPORT
 #include "drx397xD.h"
 #endif
@@ -231,6 +232,17 @@
        .no_tuner = 1,
        .parallel_ts = 1,
        .if2 = 45600,
+};
+
+static struct s5h1409_config em28xx_s5h1409_with_xc3028 = {
+       .demod_address = 0x32 >> 1,
+       .output_mode   = S5H1409_SERIAL_OUTPUT,
+       .gpio          = S5H1409_GPIO_ON,
+       .qam_if        = 44000,
+       .inversion     = S5H1409_INVERSION_OFF,
+       .status_mode   = S5H1409_DEMODLOCKING,
+       .mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK
+
 };

 #ifdef EM28XX_DRX397XD_SUPPORT
@@ -413,7 +425,6 @@
        case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850:
        case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
        case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:
-       case EM2883_BOARD_KWORLD_HYBRID_A316:
        case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
                dvb->frontend = dvb_attach(lgdt330x_attach,
                                           &em2880_lgdt3303_dev,
@@ -447,6 +458,15 @@
                }
                break;
 #endif
+       case EM2883_BOARD_KWORLD_HYBRID_A316:
+               dvb->frontend = dvb_attach(s5h1409_attach,
+                                          &em28xx_s5h1409_with_xc3028,
+                                          &dev->i2c_adap);
+               if (attach_xc3028(0x61, dev) < 0) {
+                       result = -EINVAL;
+                       goto out_free;
+               }
+               break;
        default:
                printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card"
                                " isn't supported yet\n",
@@ -514,3 +534,4 @@

 module_init(em28xx_dvb_register);
 module_exit(em28xx_dvb_unregister);
+
[root@am2mm v4l-dvb]#

Best Regards,

-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
