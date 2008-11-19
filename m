Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJ9FYkx024142
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 04:15:34 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJ9FM3G002202
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 04:15:23 -0500
Received: by wf-out-1314.google.com with SMTP id 25so3440174wfc.6
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 01:15:22 -0800 (PST)
Message-ID: <62e5edd40811190115h5c5210a5l597ec0a0225e7cf0@mail.gmail.com>
Date: Wed, 19 Nov 2008 10:15:22 +0100
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Jonathan McDowell" <noodles@earth.li>
In-Reply-To: <20081119075203.GP3162@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <4923175A.10908@gmail.com> <20081118220827.GN3162@earth.li>
	<20081118223913.GO3162@earth.li> <20081119075203.GP3162@earth.li>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, qce-ga-devel@lists.sourceforge.net
Subject: Re: [gspca-stv06xx]First bits of the new stv0600/stv0610 pushed
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

2008/11/19 Jonathan McDowell <noodles@earth.li>:
> On Tue, Nov 18, 2008 at 10:39:13PM +0000, Jonathan McDowell wrote:
>> On Tue, Nov 18, 2008 at 10:08:27PM +0000, Jonathan McDowell wrote:
>> > On Tue, Nov 18, 2008 at 08:28:26PM +0100, Erik Andrén wrote:
>> >
>> > > As I've written in an earlier mail I've taken a stab at porting over
>> > > the old qc-usb driver to the gspca framework.  The driver is nowhere
>> > > complete but I've gotten it to work on my Quickcam Web using the
>> > > vv6410 sensor. There is some untested support for the HDCS sensors but
>> > > I need some testing on it (and probably some bug squashing).
>> >
>> > Er, yeah, I'll say. ;) I don't have time to dig deeper tonight, but
>> > compiling up against 2.6.28-rc5 on x86_64 and trying with my Quickcam
>> > Express (HDCS 1020) gives the following on doing a "modprobe
>> > gspca-stv06xx":
>> >
>> > Linux video capture interface: v2.00
>> > gspca: main v2.4.0 registered
>> > STV06xx: Probing for a stv06xx device
>> > gspca: probing 046d:0870
>> > STV06xx: Configuring camera
>> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>>
>> The below fixes that bit and I now get:
>>
>> gspca: main v2.4.0 registered
>> STV06xx: Probing for a stv06xx device
>> gspca: probing 046d:0870
>> STV06xx: Configuring camera
>> usbcore: registered new interface driver STV06xx
>> STV06xx: registered
>>
>> But no sign of a /dev/video0 and nothing in /sys/class/video4linux
>
> Patch below fixes a) the I2C address of the sensor and b) the fact that
> you can't compare the address of a struct that's defined in 2 separate
> places as static and get a useful result. It includes the previous
> read_sensor0 patch too.
>
> Successfully detects both a HDSC-1020 and a HDSC-1000/1100 and creates
> /dev/video0
>
> Signed-Off-By: Jonathan McDowell <noodles@earth.li>
>
> -----
> diff -r d037630bbca6 linux/drivers/media/video/gspca/stv06xx/stv06xx.c
> --- a/linux/drivers/media/video/gspca/stv06xx/stv06xx.c Tue Nov 18 18:50:20 2008 +0100
> +++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx.c Wed Nov 19 07:48:28 2008 +0000
> @@ -407,11 +407,11 @@
>        if (!sd->sensor->probe(sd))
>                return 0;
>
> -       sd->sensor = &hdcs1x00;
> +       sd->sensor = &stv06xx_sensor_hdcs1x00;
>        if (!sd->sensor->probe(sd))
>                return 0;
>
> -       sd->sensor = &hdcs1020;
> +       sd->sensor = &stv06xx_sensor_hdcs1020;
>        if (!sd->sensor->probe(sd))
>                return 0;
>
> diff -r d037630bbca6 linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
> --- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c    Tue Nov 18 18:50:20 2008 +0100
> +++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c    Wed Nov 19 07:48:28 2008 +0000
> @@ -29,28 +29,28 @@
>        u8 sensor;
>        int err;
>
> -       err = stv06xx_read_sensor(sd, HDCS_IDENT, &sensor, 1);
> +       err = stv06xx_read_sensor0(sd, HDCS_IDENT, &sensor);
>
>        if (err < 0)
>                return -ENODEV;
>
> -       if ((sensor == 0x08) && (sd->sensor == &hdcs1x00)) {
> +       if ((sensor == 0x08) && (sd->sensor == &stv06xx_sensor_hdcs1x00)) {
>                info("HDCS-1000/1100 sensor detected");
>
> -               sd->gspca_dev.cam.cam_mode = hdcs1x00.modes;
> -               sd->gspca_dev.cam.nmodes = hdcs1x00.nmodes;
> -               sd->desc->ctrls = hdcs1x00.ctrls;
> -               sd->desc->nctrls = hdcs1x00.nctrls;
> +               sd->gspca_dev.cam.cam_mode = sd->sensor->modes;
> +               sd->gspca_dev.cam.nmodes = sd->sensor->nmodes;
> +               sd->desc->ctrls = sd->sensor->ctrls;
> +               sd->desc->nctrls = sd->sensor->nctrls;
>                return 0;
>        }
>
> -       if ((sensor == 0x10) && (sd->sensor == &hdcs1020)) {
> +       if ((sensor == 0x10) && (sd->sensor == (&stv06xx_sensor_hdcs1020))) {
>                info("HDCS-1020 sensor detected");
>
> -               sd->gspca_dev.cam.cam_mode = hdcs1020.modes;
> -               sd->gspca_dev.cam.nmodes = hdcs1020.nmodes;
> -               sd->desc->ctrls = hdcs1020.ctrls;
> -               sd->desc->nctrls = hdcs1020.nctrls;
> +               sd->gspca_dev.cam.cam_mode = sd->sensor->modes;
> +               sd->gspca_dev.cam.nmodes = sd->sensor->nmodes;
> +               sd->desc->ctrls = sd->sensor->ctrls;
> +               sd->desc->nctrls = sd->sensor->nctrls;
>                return 0;
>        }
>
> @@ -181,3 +181,63 @@
>  {
>        return 0;
>  }
> +
> +struct stv06xx_sensor stv06xx_sensor_hdcs1x00 = {
> +       .name = "HDCS-1000/1100",
> +       .i2c_flush = 0,
> +       .i2c_addr = HDCS_ADDR,
> +
> +       .init = hdcs_init,
> +       .probe = hdcs_probe,
> +       .start = hdcs_start,
> +       .stop = hdcs_stop,
> +       .dump = hdcs_dump,
> +
> +       .nctrls = 0,
> +       .ctrls = {},
> +
> +       .nmodes = 1,
> +       .modes = {
> +       {
> +               HDCS_1X00_DEF_WIDTH,
> +               HDCS_1X00_DEF_HEIGHT,
> +               V4L2_PIX_FMT_SBGGR8,
> +               V4L2_FIELD_NONE,
> +               .sizeimage =
> +                       HDCS_1X00_DEF_WIDTH * HDCS_1X00_DEF_HEIGHT,
> +               .bytesperline = HDCS_1X00_DEF_WIDTH,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 1
> +       }
> +       }
> +};
> +
> +struct stv06xx_sensor stv06xx_sensor_hdcs1020 = {
> +       .name = "HDCS-1020",
> +       .i2c_flush = 0,
> +       .i2c_addr = HDCS_ADDR,
> +
> +       .nctrls = 0,
> +       .ctrls = {},
> +
> +       .init = hdcs_init,
> +       .probe = hdcs_probe,
> +       .start = hdcs_start,
> +       .stop = hdcs_stop,
> +       .dump = hdcs_dump,
> +
> +       .nmodes = 1,
> +       .modes = {
> +       {
> +               HDCS_1020_DEF_WIDTH,
> +               HDCS_1020_DEF_HEIGHT,
> +               V4L2_PIX_FMT_SBGGR8,
> +               V4L2_FIELD_NONE,
> +               .sizeimage =
> +                       HDCS_1020_DEF_WIDTH * HDCS_1020_DEF_HEIGHT,
> +               .bytesperline = HDCS_1020_DEF_WIDTH,
> +               .colorspace = V4L2_COLORSPACE_SRGB,
> +               .priv = 1
> +       }
> +       }
> +};
> diff -r d037630bbca6 linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
> --- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h    Tue Nov 18 18:50:20 2008 +0100
> +++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h    Wed Nov 19 07:48:28 2008 +0000
> @@ -28,7 +28,7 @@
>  #include "stv06xx_sensor.h"
>
>  /* I2C Address */
> -#define HDCS_ADDR              0x55
> +#define HDCS_ADDR              (0x55 << 1)
>
>  #define HDCS_1X00_DEF_WIDTH    360
>  #define HDCS_1X00_DEF_HEIGHT   296
> @@ -80,7 +80,7 @@
>  #define HDCS_SLEEP_MODE                (1 << 1)
>
>  #define IS_870(sd)             ((sd)->gspca_dev.dev->descriptor.idProduct == 0x870)
> -#define IS_1020(sd)            ((sd)->sensor == &hdcs1020)
> +#define IS_1020(sd)            ((sd)->sensor == &stv06xx_sensor_hdcs1020)
>  #define GET_CONTROL            (IS_1020(sd) ? HDCS20_CONTROL : HDCS00_CONTROL)
>
>  int hdcs_probe(struct sd *sd);
> @@ -89,64 +89,7 @@
>  int hdcs_stop(struct sd *sd);
>  int hdcs_dump(struct sd *sd);
>
> -static struct stv06xx_sensor hdcs1x00 = {
> -       .name = "HDCS-1000/1100",
> -       .i2c_flush = 0,
> -       .i2c_addr = HDCS_ADDR,
> -
> -       .init = hdcs_init,
> -       .probe = hdcs_probe,
> -       .start = hdcs_start,
> -       .stop = hdcs_stop,
> -       .dump = hdcs_dump,
> -
> -       .nctrls = 0,
> -       .ctrls = {},
> -
> -       .nmodes = 1,
> -       .modes = {
> -       {
> -               HDCS_1X00_DEF_WIDTH,
> -               HDCS_1X00_DEF_HEIGHT,
> -               V4L2_PIX_FMT_SBGGR8,
> -               V4L2_FIELD_NONE,
> -               .sizeimage =
> -                       HDCS_1X00_DEF_WIDTH * HDCS_1X00_DEF_HEIGHT,
> -               .bytesperline = HDCS_1X00_DEF_WIDTH,
> -               .colorspace = V4L2_COLORSPACE_SRGB,
> -               .priv = 1
> -       }
> -       }
> -};
> -
> -static struct stv06xx_sensor hdcs1020 = {
> -       .name = "HDCS-1020",
> -       .i2c_flush = 0,
> -       .i2c_addr = HDCS_ADDR,
> -
> -       .nctrls = 0,
> -       .ctrls = {},
> -
> -       .init = hdcs_init,
> -       .probe = hdcs_probe,
> -       .start = hdcs_start,
> -       .stop = hdcs_stop,
> -       .dump = hdcs_dump,
> -
> -       .nmodes = 1,
> -       .modes = {
> -       {
> -               HDCS_1020_DEF_WIDTH,
> -               HDCS_1020_DEF_HEIGHT,
> -               V4L2_PIX_FMT_SBGGR8,
> -               V4L2_FIELD_NONE,
> -               .sizeimage =
> -                       HDCS_1020_DEF_WIDTH * HDCS_1020_DEF_HEIGHT,
> -               .bytesperline = HDCS_1020_DEF_WIDTH,
> -               .colorspace = V4L2_COLORSPACE_SRGB,
> -               .priv = 1
> -       }
> -       }
> -};
> +extern struct stv06xx_sensor stv06xx_sensor_hdcs1x00;
> +extern struct stv06xx_sensor stv06xx_sensor_hdcs1020;
>
>  #endif

Thanks, I'll try to apply it tonight.
Do you any image when testing with ekiga?

Regards,
Erik

> -----
>
> J.
>
> --
> 101 things you can't have too much of : 48 - Pies.
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
>
> iQIVAwUBSSPFo/8WL8XPP7rRAQJZnw//Xq1N9MBjdLr5FJSa1l8zBM4n9i2yZ4V3
> LGGY9fdPZxBomJ1A3AdMukq0rO46wlCV8lZakTB8VRDbr6brNx52rvRuCIff8jAF
> oEvInHwrJcACKzI+5Q7vhO6esWnVnXmkCXsagw60gjFwV/I7ocYBh+jV88wf4E+U
> hs8AVksCEajJ6HKf3iqYBNEqNtAdIWhmQxeoizaGKoYfdUaUOU5RK2Yb2zbn9ZXR
> cMw9o3IR6q8A3LtombxWiAGMJjZB39vCKwEDRQCIGJenC+JmsnboEwayR8st9QGT
> YHAoicnDr5nZqkZ0WHKLGjOooeNySpPP5sN25Jvve04PDyH/RpYNMaANc3na/dCP
> JH7Hk2x1eb/mWk3k661V4Zx8iQZtvCvA021uyckK0KZ1tfVp7gSkg2gJeRaskV/R
> OI80zUAy0ZrUufP9onNHprVO2spxotDbXc3NVEtc84qnpDcqZb4jLgVV1d0IZfhC
> ld/duVDWVdPcOZH1kfFkp9gzNmb6I9gpDoHejCa3cMy+72p96v/de5vGzT7KGgPx
> xQmvp7hAnTYRpWx25DGm8IlS1PTJ3hA9gWTFeo8bx3dpD8xFLE78Q9fpwN83eh6w
> KbcxjTr+uasKOzz2Ih6rW+k4fs+ryC823Tp9ikN/sd4bW/8zzlN0OHp42lf11HvO
> 8d/9kNzjPuM=
> =NYq+
> -----END PGP SIGNATURE-----
>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
