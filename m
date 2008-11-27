Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARBq6FN031240
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 06:52:06 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARBptBt019103
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 06:51:55 -0500
Received: by wf-out-1314.google.com with SMTP id 25so928046wfc.6
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 03:51:54 -0800 (PST)
Message-ID: <62e5edd40811270351o7ae92605ra2e46ec5e9ee94fa@mail.gmail.com>
Date: Thu, 27 Nov 2008 12:51:54 +0100
From: "=?ISO-8859-1?Q?Erik_Andr=E9n?=" <erik.andren@gmail.com>
To: "Hans de Goede" <hdegoede@redhat.com>
In-Reply-To: <492E7906.905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <492B15E1.2080207@gmail.com> <20081125082002.GC18787@m500.domain>
	<492E7906.905@redhat.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, noodles@earth.li,
	qce-ga-devel@lists.sourceforge.net
Subject: Re: Please test the gspca-stv06xx branch
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

2008/11/27 Hans de Goede <hdegoede@redhat.com>:
> Erik,
>
> While looking at the pb0100 code I noticed several issues. Attached is a
> patch fixing these. So far I've not gotten further then looking I'm afraid.
>
> The issues are:
>
> stv06xx_write_sensor_w() was calling stv06xx_write_sensor() with a count of
> 2, but that is not correct, there only is one address being passed and
> buf[0x21] should be set to 0, not to 1. Both indicate a count of 1, but
> there are 2 bytes of data being passed!
>
Thanks,
the stv06xx_write_sensor_w() and _b() were added on top as much of the
init is performed with separate function calls for each i2c write.
Later when all sensors are working I'm thinking of moving the data to
a table, this allows multiple i2c writes in the same packet.

> I've solved this be creating 2 separate stv06xx_write_sensor functions:
> typedef u8 u8_pair[2];
> typedef u16 u16_pair[2];
>
> int stv06xx_write_sensor_bytes(struct sd *sd, const u8_pair *data, int len);
> int stv06xx_write_sensor_words(struct sd *sd, const u16_pair *data, int
> len);
>
> These functions get passed one or more u8 / u16  pairs where pair[0] is an
> register-address and pair[1] is the value to write to that register, note
> that for stv06xx_write_sensor_words() the addresses are in reality still 8
> bits, they are gettings stored in an u16 for easier coding.

This is an alternate way of solving the same problem. I think this
approach is more convoluted without any real gain.
First you must multiplex the data and addresses by putting them
together and then demultiplex them in the function.
Not ideal but also not a big deal.

>
> The functions now also take care of putting multiple i2c register writes in
> one
> usb transaction and splitting over multiple if necessary, IMHO this belongs
> here and not in the sensor drivers.

Indeed.

>
> The other fix is that stv06xx_read_sensor_w was being passed an u8 pointer
> and then stored 2 bytes there, where as it was being called from pb0100.c
> with a buffer of only one u8. I've fixed this by making it take a pointer to
> an u16, which seems the right thing todo to me.

Whoops.

>
> While modifying stv06xx_vv6410.c to use the new methods I think I found a
> bug, both set flip functions are modifying VV6410_DATAFORMAT, but they are
> not doing read modify writes, so only the last one will stick, also they are
> masking a boolean, where they should set / clear the bit depending on the
> boolean being true or not.

Thanks for the catch.
>
> Note this patch is only compile tested.
>
> Chia-I Wu, I'm afraid this might conflict with your HDCS work, as it is
> against Erik's latest hg tree, so without your patches. I noticed you were
> defining your own read/write register functions which really seems the wrong
> thing todo, hopefully with my new functions you can use those directly, or ?
>
> Regards,
>
> Hans

Thanks for testing and the patch.
I'll review and commit ASAP.

Regards,
Erik

>
>
>
>
>
> Chia-I Wu wrote:
>>
>> Hi Erik,
>>
>> On Mon, Nov 24, 2008 at 10:00:17PM +0100, Erik Andrén wrote:
>>>
>>> I've reworked the driver somewhat and added initial support for th
>>> pb0100.
>>> Please test with the latest version of the gspca-stv06xx tree and
>>> see if you can get an image. Ekiga works best for me at the moment.
>>
>> I am trying to make gspca-stv06xx work with my QuickCam Express
>> (046d:0840).  It comes with the HDCS 1000 sensor.  So far, I am able to
>> receive frames using gstreamer (with libv4l).  The colors are wrong
>> though.
>>
>> While working on it, I encounter two minor issues:
>>
>> * stv06xx_write_sensor sends an extra packet unconditionally.  It causes
>>  the function call return error.
>> * Turning LED on/off kills the device.  I have to re-plug the device to
>>  make it work again.
>>
>> I could put those functions inside an if clause:
>>
>>        if (udev->descriptor.idProduct != 0x840)
>>                do_something;
>>
>> and things work.  But as I do not have other cameras to test, I am not
>> sure if this is the right way.  Do you have any suggestion?
>>
>> I will keep working on it.  But you can find a primitive patch and a
>> sample image in the attachments.
>>
>>
>>
>> ------------------------------------------------------------------------
>>
>
> diff -r 8b1b8968a794 linux/drivers/media/video/gspca/stv06xx/stv06xx.c
> --- a/linux/drivers/media/video/gspca/stv06xx/stv06xx.c Tue Nov 25 22:19:48
> 2008 +0100
> +++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx.c Thu Nov 27 11:30:56
> 2008 +0100
> @@ -74,67 +74,94 @@
>
>  /* Wraps the normal write sensor function for those cases
>    when you just want to write a byte to a single register */
> -int stv06xx_write_sensor_b(struct sd *sd, u8 address, u8 i2c_data)
> +int stv06xx_write_sensor_b(struct sd *sd, u8 address, u8 value)
>  {
> -       return stv06xx_write_sensor(sd, &address, &i2c_data, 1);
> +       const u8 data[2] = { address, value };
> +       return stv06xx_write_sensor_bytes(sd, &data, 1);
>  }
>
>  /* Wraps the normal write sensor function with a 16 bit word */
> -int stv06xx_write_sensor_w(struct sd *sd, u8 address, u16 i2c_data)
> +int stv06xx_write_sensor_w(struct sd *sd, u8 address, u16 value)
>  {
> -       int err;
> -       u8 data[2];
> -
> -       data[0] = i2c_data & 0xff;
> -       data[1] = i2c_data >> 8;
> -
> -       err = stv06xx_write_sensor(sd, &address, data, 2);
> -
> -       return (err < 0) ? err : 0;
> +       const u16 data[2] = { address, value };
> +       return stv06xx_write_sensor_words(sd, &data, 1);
>  }
>
> -int stv06xx_write_sensor(struct sd *sd, u8 *address,
> -                        u8 *i2c_data, const u8 len)
> +static int stv06xx_write_sensor_finish(struct sd *sd)
>  {
> -       int err, i;
> +       int err = 0;
>        struct usb_device *udev = sd->gspca_dev.dev;
>        __u8 *buf = sd->gspca_dev.usb_buf;
>
> -       if (!len || len > I2C_MAX_COMMANDS)
> -               return -EINVAL;
> -
> -       PDEBUG(D_USBO, "I2C: Command buffer contains %d entries", len);
> -
> -       /* Build the command buffer */
> -       for (i = 0; i < len; i++) {
> -               buf[i] = address[i];
> -               buf[i + 0x10] = i2c_data[i];
> -               PDEBUG(D_USBO, "I2C: Writing 0x%x to address 0x%x",
> -                      buf[i + 0x10], buf[i]);
> -       }
> -
> -       buf[0x20] = sd->sensor->i2c_addr;
> -
> -       /* Number of commands to send - 1 */
> -       buf[0x21] = len - 1;
> -
> -       /* Write cmd */
> -       buf[0x22] = I2C_WRITE_CMD;
> -
> -       err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> -                             0x04, 0x40, 0x0400, 0, buf,
> -                             I2C_BUFFER_LENGTH,
> -                             STV06XX_URB_MSG_TIMEOUT);
> -
>        if (IS_850(sd)) {
>                /* Quickam Web needs an extra packet */
> -               buf[0] = 0;
> +               buf[0] = 0; /* Note original qc-usb had 1 here */
>                err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
>                                      0x04, 0x40, 0x1704, 0, buf, 1,
>                                      STV06XX_URB_MSG_TIMEOUT);
>        }
> +       return err;
> +}
>
> -       return (err < 0) ? err : 0;
> +int stv06xx_write_sensor_bytes(struct sd *sd, const u8_pair *data, int len)
> +{
> +       int err, i, j;
> +       struct usb_device *udev = sd->gspca_dev.dev;
> +       __u8 *buf = sd->gspca_dev.usb_buf;
> +
> +       PDEBUG(D_USBO, "I2C: Command buffer contains %d entries", len);
> +
> +       for (i = 0; i < len; ) {
> +               /* Build the command buffer */
> +               memset(buf, 0, I2C_BUFFER_LENGTH);
> +               for (j = 0; j < I2C_MAX_BYTES && i < len; j++, i++) {
> +                       buf[j] = data[i][0];
> +                       buf[0x10 + j] = data[i][1];
> +                       PDEBUG(D_USBO, "I2C: Writing 0x%02x to reg 0x%02x",
> +                               data[i][1], data[i][0]);
> +               }
> +               buf[0x20] = sd->sensor->i2c_addr;
> +               buf[0x21] = j - 1; /* Number of commands to send - 1 */
> +               buf[0x22] = I2C_WRITE_CMD;
> +               err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> +                             0x04, 0x40, 0x0400, 0, buf,
> +                             I2C_BUFFER_LENGTH,
> +                             STV06XX_URB_MSG_TIMEOUT);
> +               if (err < 0)
> +                       return err;
> +       }
> +       return stv06xx_write_sensor_finish(sd);
> +}
> +
> +int stv06xx_write_sensor_words(struct sd *sd, const u16_pair *data, int
> len)
> +{
> +       int err, i, j;
> +       struct usb_device *udev = sd->gspca_dev.dev;
> +       __u8 *buf = sd->gspca_dev.usb_buf;
> +
> +       PDEBUG(D_USBO, "I2C: Command buffer contains %d entries", len);
> +
> +       for (i = 0; i < len; ) {
> +               /* Build the command buffer */
> +               memset(buf, 0, I2C_BUFFER_LENGTH);
> +               for (j = 0; j < I2C_MAX_WORDS && i < len; j++, i++) {
> +                       buf[j] = data[i][0];
> +                       buf[0x10 + j * 2] = data[i][1];
> +                       buf[0x10 + j * 2 + 1] = data[i][1] >> 8;
> +                       PDEBUG(D_USBO, "I2C: Writing 0x%04x to reg 0x%02x",
> +                               data[i][1], data[i][0]);
> +               }
> +               buf[0x20] = sd->sensor->i2c_addr;
> +               buf[0x21] = j - 1; /* Number of commands to send - 1 */
> +               buf[0x22] = I2C_WRITE_CMD;
> +               err = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
> +                             0x04, 0x40, 0x0400, 0, buf,
> +                             I2C_BUFFER_LENGTH,
> +                             STV06XX_URB_MSG_TIMEOUT);
> +               if (err < 0)
> +                       return err;
> +       }
> +       return stv06xx_write_sensor_finish(sd);
>  }
>
>  /* Wraps the normal read sensor function for those cases
> @@ -145,9 +172,15 @@
>  }
>
>  /* Wraps the normal read sensor function and returns a two byte data array
> */
> -int stv06xx_read_sensor_w(struct sd *sd, u8 address, u8 *data)
> +int stv06xx_read_sensor_w(struct sd *sd, u8 address, u16 *value)
>  {
> -       return stv06xx_read_sensor(sd, &address, data, 2);
> +       u8 data[2];
> +       int err;
> +
> +       err = stv06xx_read_sensor(sd, &address, data, 2);
> +       *value = data[0] | (data[1] << 8);
> +
> +       return err;
>  }
>
>  int stv06xx_read_sensor(struct sd *sd, const u8 *address,
> @@ -157,7 +190,7 @@
>        struct usb_device *udev = sd->gspca_dev.dev;
>        __u8 *buf = sd->gspca_dev.usb_buf;
>
> -       if (!len || len > I2C_MAX_COMMANDS)
> +       if (!len || len > I2C_MAX_BYTES)
>                return -EINVAL;
>
>        err = stv06xx_write_bridge(sd, STV_I2C_FLUSH, sd->sensor->i2c_flush);
> @@ -200,7 +233,7 @@
>        return (err < 0) ? err : 0;
>  }
>
> -/* Dumps all sensor registers */
> +/* Dumps all bridge registers */
>  static void stv06xx_dump_bridge(struct sd *sd)
>  {
>        int i;
> diff -r 8b1b8968a794 linux/drivers/media/video/gspca/stv06xx/stv06xx.h
> --- a/linux/drivers/media/video/gspca/stv06xx/stv06xx.h Tue Nov 25 22:19:48
> 2008 +0100
> +++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx.h Thu Nov 27 11:30:56
> 2008 +0100
> @@ -71,7 +71,8 @@
>
>  #define STV06XX_URB_MSG_TIMEOUT                5000
>
> -#define I2C_MAX_COMMANDS               16
> +#define I2C_MAX_BYTES                  16
> +#define I2C_MAX_WORDS                  8
>
>  #define I2C_BUFFER_LENGTH              0x23
>  #define I2C_READ_CMD                   3
> @@ -91,16 +92,19 @@
>        struct sd_desc *desc;
>  };
>
> +typedef u8 u8_pair[2];
> +typedef u16 u16_pair[2];
> +
>  int stv06xx_write_bridge(struct sd *sd, u16 address, u16 i2c_data);
>  int stv06xx_read_bridge(struct sd *sd, u16 address, u8 *i2c_data);
>
> -int stv06xx_write_sensor_b(struct sd *sd, u8 address, u8 i2c_data);
> -int stv06xx_write_sensor_w(struct sd *sd, u8 address, u16 i2c_data);
> -int stv06xx_write_sensor(struct sd *sd, u8 *address,
> -                        u8 *i2c_data, const u8 len);
> +int stv06xx_write_sensor_b(struct sd *sd, u8 address, u8 value);
> +int stv06xx_write_sensor_w(struct sd *sd, u8 address, u16 value);
> +int stv06xx_write_sensor_bytes(struct sd *sd, const u8_pair *data, int
> len);
> +int stv06xx_write_sensor_words(struct sd *sd, const u16_pair *data, int
> len);
>
>  int stv06xx_read_sensor_b(struct sd *sd, u8 address, u8 *data);
> -int stv06xx_read_sensor_w(struct sd *sd, u8 address, u8 *data);
> +int stv06xx_read_sensor_w(struct sd *sd, u8 address, u16 *value);
>  int stv06xx_read_sensor(struct sd *sd, const u8 *address,
>                        u8 *i2c_data, const u8 len);
>
> diff -r 8b1b8968a794
> linux/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
> --- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c  Tue Nov 25
> 22:19:48 2008 +0100
> +++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c  Thu Nov 27
> 11:30:56 2008 +0100
> @@ -31,7 +31,7 @@
>
>  int pb0100_probe(struct sd *sd)
>  {
> -       u8 sensor;
> +       u16 sensor;
>        int err;
>
>        err = stv06xx_read_sensor_w(sd, PB_IDENT, &sensor);
> @@ -39,7 +39,7 @@
>        if (err < 0)
>                return -ENODEV;
>
> -       if (sensor == 0x64) {
> +       if ((sensor & 0xff) == 0x64) {
>                info("Photobit pb0100 sensor detected");
>
>                sd->gspca_dev.cam.cam_mode = stv06xx_sensor_pb0100.modes;
> diff -r 8b1b8968a794
> linux/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
> --- a/linux/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c  Tue Nov 25
> 22:19:48 2008 +0100
> +++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c  Thu Nov 27
> 11:30:56 2008 +0100
> @@ -55,8 +55,7 @@
>
>  int vv6410_init(struct sd *sd)
>  {
> -       int err = 0, i, no_cmds = ARRAY_SIZE(vv6410_sensor_init);
> -       u8 buf_p = 0;
> +       int err = 0, i;
>
>        for (i = 0; i < ARRAY_SIZE(stv_bridge_init); i++) {
>                /* if NULL then len contains single value */
> @@ -74,34 +73,11 @@
>        }
>
>        if (err < 0)
> -               goto out;
> +               return err;
>
> -       PDEBUG(D_USBO, "%d commands to send", no_cmds);
> -       while (no_cmds) {
> -               u8 add_buf[I2C_MAX_COMMANDS], dat_buf[I2C_MAX_COMMANDS];
> -               int len = min(no_cmds, I2C_MAX_COMMANDS);
> -               PDEBUG(D_USBO, "Batch contains %d entries", len);
> +       err = stv06xx_write_sensor_bytes(sd, vv6410_sensor_init,
> +                                        ARRAY_SIZE(vv6410_sensor_init));
>
> -               /* Prepare the buffer */
> -               for (i = 0; i < len; i++) {
> -                       add_buf[i] = vv6410_sensor_init[buf_p + i][0];
> -                       dat_buf[i] = vv6410_sensor_init[buf_p + i][1];
> -                       PDEBUG(D_USBO, "I2C: Adding 0x%x to address 0x%x on"
> -                                      "buffer slot %d",
> -                                       dat_buf[i], add_buf[i], i);
> -               }
> -
> -               /* Write out the buffer */
> -               err = stv06xx_write_sensor(sd, add_buf, dat_buf, len);
> -
> -               if (err < 0)
> -                       goto out;
> -
> -               buf_p += len;
> -               no_cmds -= len;
> -       }
> -
> -out:
>        return (err < 0) ? err : 0;
>  }
>
> @@ -174,12 +150,10 @@
>  int vv6410_set_hflip(struct gspca_dev *gspca_dev, __s32 val)
>  {
>        int err;
> -       u8 i2c_data = val & VV6410_HFLIP;
> -       u8 address = VV6410_DATAFORMAT;
>        struct sd *sd = (struct sd *) gspca_dev;
>
>        PDEBUG(D_V4L2, "Set horizontal flip to %d", val);
> -       err = stv06xx_write_sensor(sd, &address, &i2c_data, 1);
> +       err = stv06xx_write_sensor_b(sd, VV6410_DATAFORMAT, val &
> VV6410_HFLIP);
>
>        return (err < 0) ? err : 0;
>  }
> @@ -202,12 +176,10 @@
>  int vv6410_set_vflip(struct gspca_dev *gspca_dev, __s32 val)
>  {
>        int err;
> -       u8 i2c_data = val & VV6410_VFLIP;
> -       u8 address = VV6410_DATAFORMAT;
>        struct sd *sd = (struct sd *) gspca_dev;
>
> -       PDEBUG(D_V4L2, "Set vertical flip to %d", i2c_data);
> -       err = stv06xx_write_sensor(sd, &address, &i2c_data, 1);
> +       PDEBUG(D_V4L2, "Set vertical flip to %d", val);
> +       err = stv06xx_write_sensor_b(sd, VV6410_DATAFORMAT, val &
> VV6410_VFLIP);
>
>        return (err < 0) ? err : 0;
>  }
> @@ -230,12 +202,10 @@
>  int vv6410_set_analog_gain(struct gspca_dev *gspca_dev, __s32 val)
>  {
>        int err;
> -       u8 i2c_data = 0xf0 | (val & 0xf);
> -       u8 address = VV6410_ANALOGGAIN;
>        struct sd *sd = (struct sd *) gspca_dev;
>
> -       PDEBUG(D_V4L2, "Set analog gain to %d", i2c_data);
> -       err = stv06xx_write_sensor(sd, &address, &i2c_data, 1);
> +       PDEBUG(D_V4L2, "Set analog gain to %d", val);
> +       err = stv06xx_write_sensor_b(sd, VV6410_ANALOGGAIN, 0xf0 | (val &
> 0xf));
>
>        return (err < 0) ? err : 0;
>  }
>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
