Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:23482 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZFPLMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 07:12:23 -0400
Date: Tue, 16 Jun 2009 14:06:09 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Hans Verkuil <hverkuil@xs4all.nl>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv7 7/9] FMTx: si4713: Add files to handle si4713 i2c
	device
Message-ID: <20090616110609.GC16092@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com> <1244827840-886-7-git-send-email-eduardo.valentin@nokia.com> <1244827840-886-8-git-send-email-eduardo.valentin@nokia.com> <200906141431.55725.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906141431.55725.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 14, 2009 at 02:31:55PM +0200, ext Hans Verkuil wrote:
> On Friday 12 June 2009 19:30:38 Eduardo Valentin wrote:
> > This patch adds files to control si4713 devices.
> > Internal functions to control device properties
> > and initialization procedures are into these files.
> > Also, a v4l2 subdev interface is also exported.
> > This way other drivers can use this as v4l2 i2c subdevice.
> >
> > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > ---
> >  linux/drivers/media/radio/si4713-i2c.c | 2813 ++++++++++++++++++++++++++++++++
> >  linux/drivers/media/radio/si4713-i2c.h |  226 +++
> >  2 files changed, 3039 insertions(+), 0 deletions(-)
> >  create mode 100644 linux/drivers/media/radio/si4713-i2c.c
> >  create mode 100644 linux/drivers/media/radio/si4713-i2c.h
> >
> > diff --git a/linux/drivers/media/radio/si4713-i2c.c b/linux/drivers/media/radio/si4713-i2c.c
> > new file mode 100644
> > index 0000000..f640d33
> > --- /dev/null
> > +++ b/linux/drivers/media/radio/si4713-i2c.c
> > @@ -0,0 +1,2813 @@
> > +/*
> > + * drivers/media/radio/si4713-i2c.c
> > + *
> > + * Silicon Labs Si4713 FM Radio Transmitter I2C commands.
> > + *
> > + * Copyright (c) 2009 Nokia Corporation
> > + * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> > + */
> > +
> > +#include <linux/mutex.h>
> > +#include <linux/completion.h>
> > +#include <linux/delay.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/i2c.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +
> > +#include "si4713-i2c.h"
> > +
> > +#define DEFAULT_RDS_PI                       0x00
> > +#define DEFAULT_RDS_PTY                      0x00
> > +#define DEFAULT_RDS_PS_NAME          "Si4713  "
> > +#define DEFAULT_RDS_RADIO_TEXT               DEFAULT_RDS_PS_NAME
> > +#define DEFAULT_RDS_DEVIATION                0x00C8
> > +#define DEFAULT_RDS_PS_REPEAT_COUNT  0x0003
> > +#define DEFAULT_LIMITER_RTIME                0x1392
> > +#define DEFAULT_LIMITER_DEV          0x102CA
> > +#define DEFAULT_PILOT_FREQUENCY      0x4A38
> > +#define DEFAULT_PILOT_DEVIATION              0x1A5E
> > +#define DEFAULT_ACOMP_ATIME          0x0000
> > +#define DEFAULT_ACOMP_RTIME          0xF4240L
> > +#define DEFAULT_ACOMP_GAIN           0x0F
> > +#define DEFAULT_ACOMP_THRESHOLD      (-0x28)
> > +#define DEFAULT_MUTE                 0x01
> > +#define DEFAULT_POWER_LEVEL          88
> > +#define DEFAULT_FREQUENCY            8800
> > +#define DEFAULT_TUNE_RSSI            0xFF
> > +
> > +#define to_si4713_device(sd) container_of(sd, struct si4713_device, sd)
> > +
> > +/* frequency domain transformation (using times 10 to avoid floats) */
> > +#define FREQDEV_UNIT 100000
> > +#define FREQV4L2_MULTI       625
> > +#define si4713_to_v4l2(f)    ((f * FREQDEV_UNIT) / FREQV4L2_MULTI)
> > +#define v4l2_to_si4713(f)    ((f * FREQV4L2_MULTI) / FREQDEV_UNIT)
> > +
> > +#define MAX_ARGS 7
> > +
> > +#define RDS_BLOCK                    8
> > +#define RDS_BLOCK_CLEAR                      0x03
> > +#define RDS_BLOCK_LOAD                       0x04
> > +#define RDS_RADIOTEXT_2A             0x20
> > +#define RDS_RADIOTEXT_BLK_SIZE               4
> > +#define RDS_RADIOTEXT_INDEX_MAX              0x0F
> > +#define RDS_CARRIAGE_RETURN          0x0D
> > +
> > +#define rds_ps_nblocks(len)  ((len / RDS_BLOCK) + (len % RDS_BLOCK ? 1 : 0))
> > +#define enable_rds(p)                (p | (1 << 2))
> > +#define disable_rds(p)               (p & ~(1 << 2))
> > +#define get_rds_status(p)    ((p >> 2) & 0x01)
> > +
> > +#define enable_stereo(p)     (p | (1 << 1))
> > +#define disable_stereo(p)    (p & ~(1 << 1))
> > +#define get_stereo_status(p) ((p >> 1) & 0x01)
> > +
> > +#define enable_limiter(p)    (p | (1 << 1))
> > +#define disable_limiter(p)   (p & ~(1 << 1))
> > +#define get_limiter_status(p)        ((p >> 1) & 0x01)
> > +
> > +#define enable_pilot(p)              (p | (1 << 0))
> > +#define disable_pilot(p)     (p & ~(1 << 0))
> > +#define get_pilot_status(p)  ((p >> 0) & 0x01)
> > +
> > +#define enable_acomp(p)              (p | (1 << 0))
> > +#define disable_acomp(p)     (p & ~(1 << 0))
> > +#define get_acomp_status(p)  ((p >> 0) & 0x01)
> > +#define ATTACK_TIME_UNIT     500
> > +
> > +#define POWER_OFF                    0x00
> > +#define POWER_ON                     0x01
> > +
> > +#define msb(x)                  ((u8)((u16) x >> 8))
> > +#define lsb(x)                  ((u8)((u16) x &  0x00FF))
> > +#define compose_u16(msb, lsb)        (((u16)msb << 8) | lsb)
> > +#define check_command_failed(status) (!(status & SI4713_CTS) || \
> > +                                     (status & SI4713_ERR))
> > +/* mute definition */
> > +#define set_mute(p)  ((p & 1) | ((p & 1) << 1));
> > +#define get_mute(p)  (p & 0x01)
> > +#define set_pty(v, pty)      ((v & 0xFC1F) | (pty << 5))
> > +#define get_pty(v)   ((v >> 5) & 0x1F)
> > +
> > +#ifdef DEBUG
> > +#define DBG_BUFFER(device, message, buffer, size)                    \
> > +     {                                                               \
> > +             int i;                                                  \
> > +             char str[(size)*5];                                     \
> > +             for (i = 0; i < size; i++)                              \
> > +                     sprintf(str + i * 5, " 0x%02x", buffer[i]);     \
> > +             dev_dbg(device, "%s:%s\n", message, str);               \
> > +     }
> > +#else
> > +#define DBG_BUFFER(device, message, buffer, size)
> > +#endif
> > +
> > +
> > +/*
> > + * Values for limiter release time
> > + *   device  release
> > + *   value   time (us)
> > + */
> > +static unsigned long const limiter_times[] = {
> > +     2000,   250,
> > +     1000,   500,
> > +     510,    1000,
> > +     255,    2000,
> > +     170,    3000,
> > +     127,    4020,
> > +     102,    5010,
> > +     85,     6020,
> > +     73,     7010,
> > +     64,     7990,
> > +     57,     8970,
> > +     51,     10030,
> > +     25,     20470,
> > +     17,     30110,
> > +     13,     39380,
> > +     10,     51190,
> > +     8,      63690,
> > +     7,      73140,
> > +     6,      85330,
> > +     5,      102390,
> > +};
> > +
> > +/*
> > + * Values for audio compression release time
> > + *   device  release
> > + *   value   time (us)
> > + */
> > +static unsigned long const acomp_rtimes[] = {
> > +     0,      100000,
> > +     1,      200000,
> > +     2,      350000,
> > +     3,      525000,
> > +     4,      1000000,
> > +};
> > +
> > +static int usecs_to_dev(unsigned long usecs, unsigned long const array[],
> > +                     int size)
> > +{
> > +     int i;
> > +     int rval = -EINVAL;
> > +
> > +     for (i = 0; i < size / 2; i++)
> > +             if (array[(i * 2) + 1] >= usecs) {
> > +                     rval = array[i * 2];
> > +                     break;
> > +             }
> > +
> > +     return rval;
> > +}
> > +
> > +static unsigned long dev_to_usecs(int value, unsigned long const array[],
> > +                     int size)
> > +{
> > +     int i;
> > +     int rval = -EINVAL;
> > +
> > +     for (i = 0; i < size / 2; i++)
> > +             if (array[i * 2] == value) {
> > +                     rval = array[(i * 2) + 1];
> > +                     break;
> > +             }
> > +
> > +     return rval;
> > +}
> > +
> > +/* si4713_handler: IRQ handler, just complete work */
> > +static irqreturn_t si4713_handler(int irq, void *dev)
> > +{
> > +     struct si4713_device *sdev = dev;
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +
> > +     dev_dbg(&client->dev, "IRQ called, signaling completion work\n");
> > +     complete(&sdev->work);
> > +
> > +     return IRQ_HANDLED;
> > +}
> > +
> > +/*
> > + * si4713_send_command - sends a command to si4713 and waits its response
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @command: command id
> > + * @args: command arguments we are sending (up to 7)
> > + * @argn: actual size of @args
> > + * @response: buffer to place the expected response from the device (up to 15)
> > + * @respn: actual size of @response
> > + * @usecs: amount of time to wait before reading the response (in usecs)
> > + */
> > +static int si4713_send_command(struct si4713_device *sdev, const u8 command,
> > +                             const u8 args[], const int argn,
> > +                             u8 response[], const int respn, const int usecs)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     u8 data1[MAX_ARGS + 1];
> > +     int err;
> > +
> > +     if (!client->adapter)
> > +             return -ENODEV;
> > +
> > +     /* First send the command and its arguments */
> > +     data1[0] = command;
> > +     memcpy(data1 + 1, args, argn);
> > +     DBG_BUFFER(&client->dev, "Parameters", data1, argn + 1);
> > +
> > +     err = i2c_master_send(client, data1, argn + 1);
> > +     if (err != argn + 1) {
> > +             dev_err(&client->dev, "Error while sending command 0x%02x\n",
> > +                     command);
> > +             return (err > 0) ? -EIO : err;
> > +     }
> > +
> > +     /* Wait response from interrupt */
> > +     if (!wait_for_completion_timeout(&sdev->work,
> > +                             usecs_to_jiffies(usecs) + 1))
> > +             dev_dbg(&client->dev, "Device took too much time.\n");
> 
> Shouldn't this be a warning or error rather than a debug message?

yes, a warn.

> 
> > +
> > +     /* Then get the response */
> > +     err = i2c_master_recv(client, response, respn);
> > +     if (err != respn) {
> > +             dev_err(&client->dev,
> 
> For i2c drivers I recommend using v4l2_err and friends. These are used by all
> other v4l2 i2c drivers as well and they format the prefix a bit better than
> dev_err (these give a rather long prefix). It also ensures consistency over
> the various v4l2 i2c drivers.
> 
> The v4l2_dbg macro also is a bit more efficient when debugging is turned off.

Right, I'll rewrite the logging commands with v4l2_* family.

> 
> > +                     "Error while reading response for command 0x%02x\n",
> > +                     command);
> > +             return (err > 0) ? -EIO : err;
> > +     }
> > +
> > +     DBG_BUFFER(&client->dev, "Response", response, respn);
> > +     if (check_command_failed(response[0]))
> > +             return -EBUSY;
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * si4713_read_property - reads a si4713 property
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @prop: property identification number
> > + */
> > +static int si4713_read_property(struct si4713_device *sdev, u16 prop)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 val[SI4713_GET_PROP_NRESP];
> > +     /*
> > +      * REVISIT: From Programming Manual
> > +      *      .First byte = 0
> > +      *      .Second byte = property's MSB
> > +      *      .Third byte = property's LSB
> > +      */
> > +     const u8 args[SI4713_GET_PROP_NARGS] = {
> > +             0x00,
> > +             msb(prop),
> > +             lsb(prop),
> > +     };
> > +
> > +     err = si4713_send_command(sdev, SI4713_CMD_GET_PROPERTY,
> > +                               args, ARRAY_SIZE(args), val,
> > +                               ARRAY_SIZE(val), DEFAULT_TIMEOUT);
> > +
> > +     if (err < 0)
> > +             return err;
> > +
> > +     dev_dbg(&client->dev, "Status from read prop: 0x%02x\n", val[0]);
> > +
> > +     return compose_u16(val[2], val[3]);
> > +}
> > +
> > +/*
> > + * si4713_write_property - modifies a si4713 property
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @prop: property identification number
> > + * @val: new value for that property
> > + */
> > +static int si4713_write_property(struct si4713_device *sdev, u16 prop, u16 val)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int rval;
> > +     u8 resp[SI4713_SET_PROP_NRESP];
> > +     /*
> > +      * REVISIT: From Programming Manual
> > +      *      .First byte = 0
> > +      *      .Second byte = property's MSB
> > +      *      .Third byte = property's LSB
> > +      *      .Fourth byte = value's MSB
> > +      *      .Fifth byte = value's LSB
> > +      */
> > +     const u8 args[SI4713_SET_PROP_NARGS] = {
> > +             0x00,
> > +             msb(prop),
> > +             lsb(prop),
> > +             msb(val),
> > +             lsb(val),
> > +     };
> > +
> > +     rval = si4713_send_command(sdev, SI4713_CMD_SET_PROPERTY,
> > +                                     args, ARRAY_SIZE(args),
> > +                                     resp, ARRAY_SIZE(resp),
> > +                                     DEFAULT_TIMEOUT);
> > +
> > +     if (rval < 0)
> > +             return rval;
> > +
> > +     dev_dbg(&client->dev, "Status from write prop: 0x%02x\n",
> > +             resp[0]);
> > +
> > +     /*
> > +      * As there is no command response for SET_PROPERTY,
> > +      * wait Tcomp time to finish before proceed, in order
> > +      * to have property properly set.
> > +      */
> > +     msleep(TIMEOUT_SET_PROPERTY);
> > +
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_powerup - Powers the device up
> > + * @sdev: si4713_device structure for the device we are communicating
> > + */
> > +static int si4713_powerup(struct si4713_device *sdev)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 resp[SI4713_PWUP_NRESP];
> > +     /*
> > +      * REVISIT: From Programming Manual
> > +      *      .First byte = Enabled interrupts and boot function
> > +      *      .Second byte = Input operation mode
> > +      */
> > +     const u8 args[SI4713_PWUP_NARGS] = {
> > +             SI4713_PWUP_CTSIEN | SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
> > +             SI4713_PWUP_OPMOD_ANALOG,
> > +     };
> > +
> > +     if (sdev->power_state)
> > +             return 0;
> > +
> > +     sdev->platform_data->set_power(1);
> > +     err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
> > +                                     args, ARRAY_SIZE(args),
> > +                                     resp, ARRAY_SIZE(resp),
> > +                                     TIMEOUT_POWER_UP);
> > +
> > +     if (!err) {
> > +             dev_dbg(&client->dev, "Powerup response: 0x%02x\n",
> > +                     resp[0]);
> > +             dev_dbg(&client->dev, "Device in power up mode\n");
> > +             sdev->power_state = POWER_ON;
> > +
> > +             err = si4713_write_property(sdev, SI4713_GPO_IEN,
> > +                                             SI4713_STC_INT | SI4713_CTS);
> > +     } else {
> > +             sdev->platform_data->set_power(0);
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +/*
> > + * si4713_powerdown - Powers the device down
> > + * @sdev: si4713_device structure for the device we are communicating
> > + */
> > +static int si4713_powerdown(struct si4713_device *sdev)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 resp[SI4713_PWDN_NRESP];
> > +
> > +     if (!sdev->power_state)
> > +             return 0;
> > +
> > +     err = si4713_send_command(sdev, SI4713_CMD_POWER_DOWN,
> > +                                     NULL, 0,
> > +                                     resp, ARRAY_SIZE(resp),
> > +                                     DEFAULT_TIMEOUT);
> > +
> > +     if (!err) {
> > +             dev_dbg(&client->dev, "Power down response: 0x%02x\n",
> > +                     resp[0]);
> > +             dev_dbg(&client->dev, "Device in reset mode\n");
> > +             sdev->platform_data->set_power(0);
> > +             sdev->power_state = POWER_OFF;
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +/*
> > + * si4713_checkrev - Checks if we are treating a device with the correct rev.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + */
> > +#define pr_revision(devicep, buffer)                                 \
> > +     dev_info(devicep, "Detected %s (0x%02x) Firmware: %d.%d"        \
> > +                       " Patch ID: %02x:%02x Component: %d.%d"       \
> > +                       " Chip Rev.: %s\n",                           \
> > +                     buffer[1] == SI4713_PRODUCT_NUMBER ? "Si4713" : "",\
> > +                     buffer[1],                                      \
> > +                     buffer[2] & 0xF, buffer[3] & 0xF,               \
> > +                     buffer[4], buffer[5],                           \
> > +                     buffer[6] & 0xF, buffer[7] & 0xF,               \
> > +                     buffer[8] == 0x41 ? "revA" : "unknown")
> 
> Turn this into a static inline function.

This is just info to report when device is probed. I will replace
it with the standard v4l2 message (that one you pointed bellow)

> 
> > +static int si4713_checkrev(struct si4713_device *sdev)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int rval;
> > +     u8 resp[SI4713_GETREV_NRESP];
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     rval = si4713_send_command(sdev, SI4713_CMD_GET_REV,
> > +                                     NULL, 0,
> > +                                     resp, ARRAY_SIZE(resp),
> > +                                     DEFAULT_TIMEOUT);
> > +
> > +     if (rval < 0)
> > +             goto unlock;
> > +
> > +     if (resp[1] == SI4713_PRODUCT_NUMBER) {
> > +             pr_revision(&client->dev, resp);
> > +     } else {
> > +             dev_err(&client->dev, "Invalid product number\n");
> > +             rval = -EINVAL;
> > +     }
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_wait_stc - Waits STC interrupt and clears status bits. Usefull
> > + *                for TX_TUNE_POWER, TX_TUNE_FREQ and TX_TUNE_MEAS
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @usecs: timeout to wait for STC interrupt signal
> > + */
> > +static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 resp[SI4713_GET_STATUS_NRESP];
> > +
> > +     /* Wait response from STC interrupt */
> > +     if (!wait_for_completion_timeout(&sdev->work,
> > +                     usecs_to_jiffies(TIMEOUT_TX_TUNE) + 1))
> > +             dev_dbg(&client->dev, "Device took too much time.\n");
> > +
> > +     /* Clear status bits */
> > +     err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
> > +                                     NULL, 0,
> > +                                     resp, ARRAY_SIZE(resp),
> > +                                     DEFAULT_TIMEOUT);
> > +
> > +     if (err < 0)
> > +             goto exit;
> > +
> > +     dev_dbg(&client->dev, "Status bits: 0x%02x\n", resp[0]);
> > +
> > +     if (!(resp[0] & SI4713_STC_INT))
> > +             err = -EIO;
> > +
> > +exit:
> > +     return err;
> > +}
> > +
> > +/*
> > + * si4713_tx_tune_freq - Sets the state of the RF carrier and sets the tuning
> > + *                   frequency between 76 and 108 MHz in 10 kHz units and
> > + *                   steps of 50 kHz.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @frequency: desired frequency (76 - 108 MHz, unit 10 KHz, step 50 kHz)
> > + */
> > +static int si4713_tx_tune_freq(struct si4713_device *sdev, u16 frequency)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 val[SI4713_TXFREQ_NRESP];
> > +     /*
> > +      * REVISIT: From Programming Manual
> 
> Revisit what? I'm not sure what you mean with REVISIT. If this just recaps
> the manual, then I would suggest just removing the REVISIT: prefix.

Right. This is just a comment which was left behind since early stage
of driver development. I'll remove it.

> 
> > +      *      .First byte = 0
> > +      *      .Second byte = frequency's MSB
> > +      *      .Third byte = frequency's LSB
> > +      */
> > +     const u8 args[SI4713_TXFREQ_NARGS] = {
> > +             0x00,
> > +             msb(frequency),
> > +             lsb(frequency),
> > +     };
> > +
> > +     err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_FREQ,
> > +                               args, ARRAY_SIZE(args), val,
> > +                               ARRAY_SIZE(val), DEFAULT_TIMEOUT);
> > +
> > +     if (err < 0)
> > +             return err;
> > +
> > +     dev_dbg(&client->dev, "Status from tx tune freq: 0x%02x\n",
> > +             val[0]);
> > +
> > +     err = si4713_wait_stc(sdev, TIMEOUT_TX_TUNE);
> > +     if (err < 0)
> > +             return err;
> > +
> > +     return compose_u16(args[1], args[2]);
> > +}
> > +
> > +/*
> > + * si4713_tx_tune_power - Sets the RF voltage level between 88 and 115 dBuV in
> > + *                   1 dB units. A value of 0x00 indicates off. The command
> > + *                   also sets the antenna tuning capacitance. A value of 0
> > + *                   indicates autotuning, and a value of 1 - 191 indicates
> > + *                   a manual override, which results in a tuning
> > + *                   capacitance of 0.25 pF x @antcap.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @power: tuning power (88 - 115 dBuV, unit/step 1 dB)
> > + * @antcap: value of antenna tuning capacitor (0 - 191)
> > + */
> > +static int si4713_tx_tune_power(struct si4713_device *sdev, u8 power,
> > +                             u8 antcap)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 val[SI4713_TXPWR_NRESP];
> > +     /*
> > +      * REVISIT: From Programming Manual
> > +      *      .First byte = 0
> > +      *      .Second byte = 0
> > +      *      .Third byte = power
> > +      *      .Fourth byte = antcap
> > +      */
> > +     const u8 args[SI4713_TXPWR_NARGS] = {
> > +             0x00,
> > +             0x00,
> > +             power,
> > +             antcap,
> > +     };
> > +
> > +     if (((power > 0) && (power < SI4713_MIN_POWER)) ||
> > +             power > SI4713_MAX_POWER || antcap > SI4713_MAX_ANTCAP)
> > +             return -EDOM;
> > +
> > +     err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_POWER,
> > +                               args, ARRAY_SIZE(args), val,
> > +                               ARRAY_SIZE(val), DEFAULT_TIMEOUT);
> > +
> > +     if (err < 0)
> > +             return err;
> > +
> > +     dev_dbg(&client->dev, "Status from tx tune power: 0x%02x\n",
> > +             val[0]);
> > +
> > +     return si4713_wait_stc(sdev, TIMEOUT_TX_TUNE_POWER);
> > +}
> > +
> > +/*
> > + * si4713_tx_tune_measure - Enters receive mode and measures the received noise
> > + *                   level in units of dBuV on the selected frequency.
> > + *                   The Frequency must be between 76 and 108 MHz in 10 kHz
> > + *                   units and steps of 50 kHz. The command also sets the
> > + *                   antenna tuning capacitance. A value of 0 means
> > + *                   autotuning, and a value of 1 to 191 indicates manual
> > + *                   override.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @frequency: desired frequency (76 - 108 MHz, unit 10 KHz, step 50 kHz)
> > + * @antcap: value of antenna tuning capacitor (0 - 191)
> > + */
> > +static int si4713_tx_tune_measure(struct si4713_device *sdev, u16 frequency,
> > +                                     u8 antcap)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 val[SI4713_TXMEA_NRESP];
> > +     /*
> > +      * REVISIT: From Programming Manual
> > +      *      .First byte = 0
> > +      *      .Second byte = frequency's MSB
> > +      *      .Third byte = frequency's LSB
> > +      *      .Fourth byte = antcap
> > +      */
> > +     const u8 args[SI4713_TXMEA_NARGS] = {
> > +             0x00,
> > +             msb(frequency),
> > +             lsb(frequency),
> > +             antcap,
> > +     };
> > +
> > +     sdev->tune_rssi = DEFAULT_TUNE_RSSI;
> > +
> > +     if (antcap > SI4713_MAX_ANTCAP)
> > +             return -EDOM;
> > +
> > +     err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_MEASURE,
> > +                               args, ARRAY_SIZE(args), val,
> > +                               ARRAY_SIZE(val), DEFAULT_TIMEOUT);
> > +
> > +     if (err < 0)
> > +             return err;
> > +
> > +     dev_dbg(&client->dev, "Status from tx tune measure: 0x%02x\n",
> > +             val[0]);
> > +
> > +     return si4713_wait_stc(sdev, TIMEOUT_TX_TUNE);
> > +}
> > +
> > +/*
> > + * si4713_tx_tune_status- Returns the status of the tx_tune_freq, tx_tune_mea or
> > + *                   tx_tune_power commands. This command return the current
> > + *                   frequency, output voltage in dBuV, the antenna tunning
> > + *                   capacitance value and the received noise level. The
> > + *                   command also clears the stcint interrupt bit when the
> > + *                   first bit of its arguments is high.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @intack: 0x01 to clear the seek/tune complete interrupt status indicator.
> > + * @frequency: returned frequency
> > + * @power: returned power
> > + * @antcap: returned antenna capacitance
> > + * @noise: returned noise level
> > + */
> > +static int si4713_tx_tune_status(struct si4713_device *sdev, u8 intack,
> > +                                     u16 *frequency, u8 *power,
> > +                                     u8 *antcap, u8 *noise)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 val[SI4713_TXSTATUS_NRESP];
> > +     /*
> > +      * REVISIT: From Programming Manual
> > +      *      .First byte = intack bit
> > +      */
> > +     const u8 args[SI4713_TXSTATUS_NARGS] = {
> > +             intack & SI4713_INTACK_MASK,
> > +     };
> > +
> > +     err = si4713_send_command(sdev, SI4713_CMD_TX_TUNE_STATUS,
> > +                               args, ARRAY_SIZE(args), val,
> > +                               ARRAY_SIZE(val), DEFAULT_TIMEOUT);
> > +
> > +     if (!err) {
> > +             dev_dbg(&client->dev,
> > +                     "Status from tx tune status: 0x%02x\n", val[0]);
> > +             *frequency = compose_u16(val[2], val[3]);
> > +             sdev->frequency = *frequency;
> > +             *power = val[5];
> > +             *antcap = val[6];
> > +             *noise = val[7];
> > +             dev_dbg(&client->dev, "Tune status: %d x 10 kHz "
> > +                             "(power %d, antcap %d, rnl %d)\n",
> > +                             *frequency, *power, *antcap, *noise);
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +/*
> > + * si4713_tx_rds_buff - Loads the RDS group buffer FIFO or circular buffer.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @mode: the buffer operation mode.
> > + * @rdsb: RDS Block B
> > + * @rdsc: RDS Block C
> > + * @rdsd: RDS Block D
> > + * @intstatus: returns current interrupt status
> > + * @cbavail: returns the number of available circular buffer blocks.
> > + * @cbused: returns the number of used circular buffer blocks.
> > + * @fifoavail: returns the number of available fifo buffer blocks.
> > + * @fifoused: returns the number of used fifo buffer blocks.
> > + */
> > +static int si4713_tx_rds_buff(struct si4713_device *sdev, u8 mode, u16 rdsb,
> > +                             u16 rdsc, u16 rdsd, u8 *intstatus, u8 *cbavail,
> > +                             u8 *cbused, u8 *fifoavail, u8 *fifoused)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 val[SI4713_RDSBUFF_NRESP];
> > +
> > +     const u8 args[SI4713_RDSBUFF_NARGS] = {
> > +             mode & SI4713_RDSBUFF_MODE_MASK,
> > +             msb(rdsb),
> > +             lsb(rdsb),
> > +             msb(rdsc),
> > +             lsb(rdsc),
> > +             msb(rdsd),
> > +             lsb(rdsd),
> > +     };
> > +
> > +     err = si4713_send_command(sdev, SI4713_CMD_TX_RDS_BUFF,
> > +                               args, ARRAY_SIZE(args), val,
> > +                               ARRAY_SIZE(val), DEFAULT_TIMEOUT);
> > +
> > +     if (!err) {
> > +             dev_dbg(&client->dev,
> > +                     "Status from tx rds buff: 0x%02x\n", val[0]);
> > +             *intstatus = val[1];
> > +             *cbavail = val[2];
> > +             *cbused = val[3];
> > +             *fifoavail = val[4];
> > +             *fifoused = val[5];
> > +             dev_dbg(&client->dev, "rds buffer status: interrupts"
> > +                             " 0x%02x cb avail: %d cb used %d fifo avail"
> > +                             " %d fifo used %d\n", *intstatus, *cbavail,
> > +                             *cbused, *fifoavail, *fifoused);
> > +     }
> > +
> > +     return err;
> > +}
> > +
> > +/*
> > + * si4713_tx_rds_ps - Loads the program service buffer.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + * @psid: program service id to be loaded.
> > + * @pschar: assumed 4 size char array to be loaded into the program service
> > + */
> > +static int si4713_tx_rds_ps(struct si4713_device *sdev, u8 psid,
> > +                             unsigned char *pschar)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> > +     int err;
> > +     u8 val[SI4713_RDSPS_NRESP];
> > +
> > +     const u8 args[SI4713_RDSPS_NARGS] = {
> > +             psid & SI4713_RDSPS_PSID_MASK,
> > +             pschar[0],
> > +             pschar[1],
> > +             pschar[2],
> > +             pschar[3],
> > +     };
> > +
> > +     err = si4713_send_command(sdev, SI4713_CMD_TX_RDS_PS,
> > +                               args, ARRAY_SIZE(args), val,
> > +                               ARRAY_SIZE(val), DEFAULT_TIMEOUT);
> > +
> > +     if (err < 0)
> > +             return err;
> > +
> > +     dev_dbg(&client->dev, "Status from tx rds ps: 0x%02x\n",
> > +             val[0]);
> > +
> > +     return err;
> > +}
> > +
> > +/* TODO: Remove getters and setters functions and simplify driver code */
> > +
> > +/* getters */
> > +/* tx_tune_status */
> > +static int si4713_get_power_level(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +     u16 f = 0;
> > +     u8 p, a, n;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_tx_tune_status(sdev, 0x00, &f, &p, &a, &n);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->power_level = p;
> > +     }
> > +
> > +     rval = sdev->power_level;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_antenna_capacitor(struct si4713_device *sdev)
> > +{
> > +     int rval = 0;
> > +     u16 f = 0;
> > +     u8 p, a, n;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_tx_tune_status(sdev, 0x00, &f, &p, &a, &n);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->antenna_capacitor = a;
> > +     }
> > +
> > +     rval = sdev->antenna_capacitor;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_tune_measure(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +     u16 f = 0;
> > +     u8 p, a, n;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_tx_tune_status(sdev, 0x00, &f, &p, &a, &n);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->tune_rssi = n;
> > +     }
> > +
> > +     rval = sdev->tune_rssi;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_frequency(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +     u16 f = 0;
> > +     u8 p, a, n;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_tx_tune_status(sdev, 0x00, &f, &p, &a, &n);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->frequency = f;
> > +     }
> > +
> > +     rval = sdev->frequency;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +/* read_property */
> > +static int si4713_get_mute(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_LINE_INPUT_MUTE);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->mute = rval;
> > +     }
> > +
> > +     rval = get_mute(sdev->mute);
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_rds_pi(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_RDS_PI);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->rds_info.pi = rval;
> > +     }
> > +
> > +     rval = sdev->rds_info.pi;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_rds_pty(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_RDS_PS_MISC);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->rds_info.pty = get_pty(rval);
> > +     }
> > +
> > +     rval = sdev->rds_info.pty;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +
> > +static int si4713_get_rds_enabled(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->rds_info.enabled = get_rds_status(rval);
> > +     }
> > +
> > +     rval = sdev->rds_info.enabled;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_preemphasis(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_PREEMPHASIS);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             switch (rval) {
> > +             case FMPE_USA:
> > +                     sdev->preemphasis = V4L2_FM_TX_PREEMPHASIS_75_uS;
> > +                     break;
> > +             case FMPE_EU:
> > +                     sdev->preemphasis = V4L2_FM_TX_PREEMPHASIS_50_uS;
> > +                     break;
> > +             case FMPE_DISABLED:
> > +                     sdev->preemphasis = V4L2_FM_TX_PREEMPHASIS_DISABLED;
> > +                     break;
> > +             default:
> > +                     rval = -EINVAL;
> > +                     goto unlock;
> > +             }
> > +     }
> > +
> > +     rval = sdev->preemphasis;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_limiter_enabled(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_ACOMP_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->limiter_info.enabled = get_limiter_status(rval);
> > +     }
> > +
> > +     rval = sdev->limiter_info.enabled;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static long si4713_get_limiter_deviation(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_AUDIO_DEVIATION);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             /* Device returns in 10Hz units */
> > +             sdev->limiter_info.deviation = rval * 10;
> > +     }
> > +
> > +     rval = sdev->limiter_info.deviation;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static long si4713_get_limiter_release_time(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev,
> > +                             SI4713_TX_LIMITER_RELEASE_TIME);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->limiter_info.release_time = dev_to_usecs(rval,
> > +                                             limiter_times,
> > +                                             ARRAY_SIZE(limiter_times));
> > +     }
> > +
> > +     rval = sdev->limiter_info.release_time;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_stereo_enabled(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->stereo = get_stereo_status(rval);
> > +     }
> > +
> > +     rval = sdev->stereo;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_pilot_enabled(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->pilot_info.enabled = get_pilot_status(rval);
> > +     }
> > +
> > +     rval = sdev->pilot_info.enabled;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static long si4713_get_pilot_deviation(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_PILOT_DEVIATION);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             /* Device returns in 10Hz units */
> > +             sdev->pilot_info.deviation = rval * 10;
> > +     }
> > +
> > +     rval = sdev->pilot_info.deviation;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_pilot_frequency(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_PILOT_FREQUENCY);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->pilot_info.frequency = rval;
> > +     }
> > +
> > +     rval = sdev->pilot_info.frequency;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_acomp_enabled(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_ACOMP_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->acomp_info.enabled = get_acomp_status(rval);
> > +     }
> > +
> > +     rval = sdev->acomp_info.enabled;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_acomp_gain(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_ACOMP_GAIN);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->acomp_info.gain = rval;
> > +     }
> > +
> > +     rval = sdev->acomp_info.gain;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_get_acomp_threshold(struct si4713_device *sdev, s8 *threshold)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_ACOMP_THRESHOLD);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->acomp_info.threshold = rval;
> > +     }
> > +
> > +     *threshold = sdev->acomp_info.threshold;
> > +     rval = 0;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static long si4713_get_acomp_release_time(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev,
> > +                             SI4713_TX_ACOMP_RELEASE_TIME);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->acomp_info.release_time = dev_to_usecs(rval,
> > +                                             acomp_rtimes,
> > +                                             ARRAY_SIZE(acomp_rtimes));
> > +     }
> > +
> > +     rval = sdev->acomp_info.release_time;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +
> > +static int si4713_get_acomp_attack_time(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev,
> > +                             SI4713_TX_ACOMP_RELEASE_TIME);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             sdev->acomp_info.attack_time = rval * ATTACK_TIME_UNIT;
> > +     }
> > +
> > +     rval = sdev->acomp_info.attack_time;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +/* not read property */
> > +static int si4713_get_rds_ps_name(struct si4713_device *sdev, char *ps_name)
> > +{
> > +     mutex_lock(&sdev->mutex);
> > +     strncpy(ps_name, sdev->rds_info.ps_name, MAX_RDS_PS_NAME);
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return 0;
> > +}
> > +
> > +static int si4713_get_rds_radio_text(struct si4713_device *sdev,
> > +                                                     char *radio_text)
> > +{
> > +     mutex_lock(&sdev->mutex);
> > +     strncpy(radio_text, sdev->rds_info.radio_text, MAX_RDS_RADIO_TEXT);
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return 0;
> > +}
> > +
> > +/* setters */
> > +static int si4713_set_power_level(struct si4713_device *sdev, u8 power_level)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_tx_tune_power(sdev, power_level,
> > +                                             sdev->antenna_capacitor);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +     }
> > +
> > +     sdev->power_level = power_level;
> > +     rval = 0;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_antenna_capacitor(struct si4713_device *sdev, u8 value)
> > +{
> > +     int rval = 0;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_tx_tune_power(sdev, sdev->power_level, value);
> > +
> > +     if (!rval)
> > +             sdev->antenna_capacitor = value;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_power_state(struct si4713_device *sdev, u8 value)
> > +{
> > +     int rval;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (value)
> > +             rval = si4713_powerup(sdev);
> > +     else
> > +             rval = si4713_powerdown(sdev);
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_frequency(struct si4713_device *sdev, u16 frequency)
> > +{
> > +     int rval = 0;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_tx_tune_freq(sdev, frequency);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +             frequency = rval;
> > +     }
> > +     sdev->frequency = frequency;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_mute(struct si4713_device *sdev, u16 mute)
> > +{
> > +     int rval = 0;
> > +
> > +     mute = set_mute(mute);
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev,
> > +                             SI4713_TX_LINE_INPUT_MUTE, mute);
> > +
> > +     if (rval >= 0)
> > +             sdev->mute = get_mute(mute);
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_rds_pi(struct si4713_device *sdev, u16 pi)
> > +{
> > +     int rval = 0;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev, SI4713_TX_RDS_PI, pi);
> > +
> > +     if (rval >= 0)
> > +             sdev->rds_info.pi = pi;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_rds_pty(struct si4713_device *sdev, u8 pty)
> > +{
> > +     int rval = 0;
> > +     u16 p;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_RDS_PS_MISC);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             p = set_pty(rval, pty);
> > +
> > +             rval = si4713_write_property(sdev, SI4713_TX_RDS_PS_MISC, p);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +     }
> > +
> > +     sdev->rds_info.pty = pty;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_rds_ps_name(struct si4713_device *sdev, char *ps_name)
> > +{
> > +     int rval = 0, i;
> > +     u8 len = 0;
> > +     u8 *tmp;
> > +
> > +     if (!strlen(ps_name))
> > +             return -EINVAL;
> > +
> > +     tmp = kzalloc(MAX_RDS_PS_NAME + 1, GFP_KERNEL);
> > +     if (!tmp)
> > +             return -ENOMEM;
> > +
> > +     strncpy(tmp, ps_name, MAX_RDS_PS_NAME);
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             /* Write the new ps name and clear the padding */
> > +             for (i = 0; i < MAX_RDS_PS_NAME; i += (RDS_BLOCK / 2)) {
> > +                     rval = si4713_tx_rds_ps(sdev, (i / (RDS_BLOCK / 2)),
> > +                                             tmp + i);
> > +                     if (rval < 0)
> > +                             goto unlock;
> > +             }
> > +
> > +             /* Setup the size to be sent */
> > +             len = strlen(tmp) - 1;
> > +
> > +             rval = si4713_write_property(sdev,
> > +                             SI4713_TX_RDS_PS_MESSAGE_COUNT,
> > +                             rds_ps_nblocks(len));
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             rval = si4713_write_property(sdev,
> > +                             SI4713_TX_RDS_PS_REPEAT_COUNT,
> > +                             DEFAULT_RDS_PS_REPEAT_COUNT * 2);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +     }
> > +
> > +     strncpy(sdev->rds_info.ps_name, tmp, MAX_RDS_PS_NAME);
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     kfree(tmp);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_rds_radio_text(struct si4713_device *sdev,
> > +                                                     char *radio_text)
> > +{
> > +     int rval = 0, i;
> > +     u16 t_index = 0;
> > +     u8 s, a, u, fa, fu, b_index = 0, cr_inserted = 0;
> > +     u8 *tmp;
> > +
> > +     if (!strlen(radio_text))
> > +             return -EINVAL;
> > +
> > +     tmp = kzalloc(MAX_RDS_RADIO_TEXT + 1, GFP_KERNEL);
> > +     if (!tmp)
> > +             return -ENOMEM;
> > +
> > +     strncpy(tmp, radio_text, MAX_RDS_RADIO_TEXT);
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_tx_rds_buff(sdev, RDS_BLOCK_CLEAR, 0, 0, 0,
> > +                                             &s, &a, &u, &fa, &fu);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +             do {
> > +                     /* RDS spec says that if the last block isn't used,
> > +                      * then apply a carriage return
> > +                      */
> > +                     if (t_index < (RDS_RADIOTEXT_INDEX_MAX * \
> > +                             RDS_RADIOTEXT_BLK_SIZE)) {
> > +                             for (i = 0; i < RDS_RADIOTEXT_BLK_SIZE; i++) {
> > +                                     if (!tmp[t_index + i] ||
> > +                                             tmp[t_index + i] == \
> > +                                             RDS_CARRIAGE_RETURN) {
> > +                                             tmp[t_index + i] =
> > +                                                     RDS_CARRIAGE_RETURN;
> > +                                             cr_inserted = 1;
> > +                                             break;
> > +                                     }
> > +                             }
> > +                     }
> > +
> > +                     rval = si4713_tx_rds_buff(sdev, RDS_BLOCK_LOAD,
> > +                                     compose_u16(RDS_RADIOTEXT_2A,
> > +                                             b_index++),
> > +                                     compose_u16(tmp[t_index],
> > +                                             tmp[t_index + 1]),
> > +                                     compose_u16(tmp[t_index + 2],
> > +                                             tmp[t_index + 3]),
> > +                                     &s, &a, &u, &fa, &fu);
> > +                     if (rval < 0)
> > +                             goto unlock;
> > +
> > +                     t_index += RDS_RADIOTEXT_BLK_SIZE;
> > +
> > +                     if (cr_inserted)
> > +                             break;
> > +             } while (u < a);
> > +     }
> > +
> > +     strncpy(sdev->rds_info.radio_text, tmp, MAX_RDS_RADIO_TEXT);
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     kfree(tmp);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_rds_enabled(struct si4713_device *sdev, u8 enabled)
> > +{
> > +     int rval = 0;
> > +     u16 p;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             p = rval;
> > +             if (enabled)
> > +                     p = enable_rds(p);
> > +             else
> > +                     p = disable_rds(p);
> > +
> > +             rval = si4713_write_property(sdev, SI4713_TX_COMPONENT_ENABLE,
> > +                             p);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             if (enabled) {
> > +                     rval = si4713_write_property(sdev,
> > +                             SI4713_TX_RDS_DEVIATION,
> > +                             DEFAULT_RDS_DEVIATION);
> > +                     if (rval < 0)
> > +                             goto unlock;
> > +             }
> > +     }
> > +
> > +     sdev->rds_info.enabled = enabled & 0x01;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_preemphasis(struct si4713_device *sdev, u8 preemphasis)
> > +{
> > +     int rval = 0;
> > +     u8 val;
> > +
> > +     switch (preemphasis) {
> > +     case V4L2_FM_TX_PREEMPHASIS_75_uS:
> > +             val = FMPE_USA;
> > +             break;
> > +     case V4L2_FM_TX_PREEMPHASIS_50_uS:
> > +             val = FMPE_EU;
> > +             break;
> > +     case V4L2_FM_TX_PREEMPHASIS_DISABLED:
> > +             val = FMPE_DISABLED;
> > +             break;
> > +     default:
> > +             return -EINVAL;
> > +     }
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev, SI4713_TX_PREEMPHASIS, val);
> > +
> > +     if (rval >= 0)
> > +             sdev->preemphasis = preemphasis;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_limiter_enabled(struct si4713_device *sdev, u8 enabled)
> > +{
> > +     int rval = 0;
> > +     u16 p;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_ACOMP_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             p = rval;
> > +             if (enabled)
> > +                     p = enable_limiter(p);
> > +             else
> > +                     p = disable_limiter(p);
> > +
> > +             rval = si4713_write_property(sdev, SI4713_TX_ACOMP_ENABLE,
> > +                             p);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +     }
> > +
> > +     sdev->limiter_info.enabled = enabled & 0x01;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_limiter_deviation(struct si4713_device *sdev,
> > +                                     unsigned long deviation)
> > +{
> > +     int rval = 0;
> > +
> > +     /* Device receives in 10Hz units */
> > +     deviation /= 10;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev, SI4713_TX_AUDIO_DEVIATION,
> > +                                             deviation);
> > +
> > +     /* Device returns in 10Hz units */
> > +     if (rval >= 0)
> > +             sdev->limiter_info.deviation = deviation * 10;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_limiter_release_time(struct si4713_device *sdev,
> > +                                     unsigned long rtime)
> > +{
> > +     int rval;
> > +
> > +     rval = usecs_to_dev(rtime, limiter_times, ARRAY_SIZE(limiter_times));
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rtime = rval;
> > +     rval = 0;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev,
> > +                             SI4713_TX_LIMITER_RELEASE_TIME, rtime);
> > +
> > +     if (rval >= 0)
> > +             sdev->limiter_info.release_time = dev_to_usecs(rtime,
> > +                                             limiter_times,
> > +                                             ARRAY_SIZE(limiter_times));
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +exit:
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_stereo_enabled(struct si4713_device *sdev, u8 enabled)
> > +{
> > +     int rval = 0;
> > +     u16 p;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             p = rval;
> > +             if (enabled)
> > +                     p = enable_stereo(p);
> > +             else
> > +                     p = disable_stereo(p);
> > +
> > +             rval = si4713_write_property(sdev, SI4713_TX_COMPONENT_ENABLE,
> > +                             p);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +     }
> > +
> > +     sdev->stereo = enabled & 0x01;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_pilot_enabled(struct si4713_device *sdev, u8 enabled)
> > +{
> > +     int rval = 0;
> > +     u16 p;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_COMPONENT_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             p = rval;
> > +             if (enabled)
> > +                     p = enable_pilot(p);
> > +             else
> > +                     p = disable_pilot(p);
> > +
> > +             rval = si4713_write_property(sdev, SI4713_TX_COMPONENT_ENABLE,
> > +                             p);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +     }
> > +
> > +     sdev->pilot_info.enabled = enabled & 0x01;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_pilot_deviation(struct si4713_device *sdev,
> > +                                     unsigned long deviation)
> > +{
> > +     int rval = 0;
> > +
> > +     /* Device receives in 10Hz units */
> > +     deviation /= 10;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev, SI4713_TX_PILOT_DEVIATION,
> > +                                             deviation);
> > +
> > +     /* Device returns in 10Hz units */
> > +     if (rval >= 0)
> > +             sdev->pilot_info.deviation = deviation * 10;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_pilot_frequency(struct si4713_device *sdev, u16 freq)
> > +{
> > +     int rval = 0;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev, SI4713_TX_PILOT_FREQUENCY,
> > +                                             freq);
> > +
> > +     if (rval >= 0)
> > +             sdev->pilot_info.frequency = freq;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_acomp_enabled(struct si4713_device *sdev, u8 enabled)
> > +{
> > +     int rval = 0;
> > +     u16 p;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state) {
> > +             rval = si4713_read_property(sdev, SI4713_TX_ACOMP_ENABLE);
> > +             if (rval < 0)
> > +                     goto unlock;
> > +
> > +             p = rval;
> > +             if (enabled)
> > +                     p = enable_acomp(p);
> > +             else
> > +                     p = disable_acomp(p);
> > +
> > +             rval = si4713_write_property(sdev, SI4713_TX_ACOMP_ENABLE, p);
> > +
> > +             if (rval < 0)
> > +                     goto unlock;
> > +     }
> > +
> > +     sdev->acomp_info.enabled = enabled & 0x01;
> > +
> > +unlock:
> > +     mutex_unlock(&sdev->mutex);
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_acomp_gain(struct si4713_device *sdev, u8 gain)
> > +{
> > +     int rval = 0;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev, SI4713_TX_ACOMP_GAIN, gain);
> > +
> > +     if (rval >= 0)
> > +             sdev->acomp_info.gain = gain;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_acomp_threshold(struct si4713_device *sdev, s8 threshold)
> > +{
> > +     int rval = 0;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev, SI4713_TX_ACOMP_THRESHOLD,
> > +                                             threshold);
> > +
> > +     if (rval >= 0)
> > +             sdev->acomp_info.threshold = threshold;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_acomp_release_time(struct si4713_device *sdev,
> > +                                     unsigned long rtime)
> > +{
> > +     int rval;
> > +
> > +     rval = usecs_to_dev(rtime, acomp_rtimes, ARRAY_SIZE(acomp_rtimes));
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rtime = rval;
> > +     rval = 0;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev,
> > +                             SI4713_TX_ACOMP_RELEASE_TIME, rtime);
> > +
> > +     if (rval >= 0)
> > +             sdev->acomp_info.release_time = dev_to_usecs(rtime,
> > +                                             acomp_rtimes,
> > +                                             ARRAY_SIZE(acomp_rtimes));
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +exit:
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_acomp_attack_time(struct si4713_device *sdev, u16 atime)
> > +{
> > +     int rval = 0;
> > +
> > +     /* Device receives in 0.5 ms units */
> > +     atime /= ATTACK_TIME_UNIT;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +
> > +     if (sdev->power_state)
> > +             rval = si4713_write_property(sdev,
> > +                             SI4713_TX_ACOMP_ATTACK_TIME, atime);
> > +
> > +     if (rval >= 0)
> > +             sdev->acomp_info.attack_time = atime * ATTACK_TIME_UNIT;
> > +
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +static int si4713_set_tune_measure(struct si4713_device *sdev, u32 frequency)
> > +{
> > +     int rval = -ENODEV;
> > +
> > +     mutex_lock(&sdev->mutex);
> > +     if (sdev->power_state)
> > +             rval = si4713_tx_tune_measure(sdev, frequency / 10, 0);
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_init - Sets the device up with default configuration.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + */
> > +static int si4713_init(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     rval = si4713_set_rds_pi(sdev, DEFAULT_RDS_PI);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_rds_pty(sdev, DEFAULT_RDS_PTY);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_rds_ps_name(sdev, DEFAULT_RDS_PS_NAME);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_rds_radio_text(sdev, DEFAULT_RDS_RADIO_TEXT);
> 
> Just for my understanding: is RADIO_TEXT something that is always on? What do
> you do if you have no radio text? Just use the PS_NAME? An empty string?
> 
> This is something that needs to be explained in the v4l2 spec as well.
> 
> Currently DEFAULT_RDS_RADIO_TEXT is the same as DEFAULT_RDS_PS_NAME, but I
> wonder if it shouldn't be an empty string instead (if that's supported).


hmm need to double check. But I think we can disable it by clearing the
rds blocks which is configured into si4713.

> 
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_rds_enabled(sdev, 1);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_limiter_release_time(sdev, DEFAULT_LIMITER_RTIME);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_limiter_deviation(sdev, DEFAULT_LIMITER_DEV);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_limiter_enabled(sdev, 1);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_pilot_frequency(sdev, DEFAULT_PILOT_FREQUENCY);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_pilot_deviation(sdev, DEFAULT_PILOT_DEVIATION);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_pilot_enabled(sdev, 1);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_stereo_enabled(sdev, 1);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_attack_time(sdev, DEFAULT_ACOMP_ATIME);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_release_time(sdev, DEFAULT_ACOMP_RTIME);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_gain(sdev, DEFAULT_ACOMP_GAIN);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_threshold(sdev, DEFAULT_ACOMP_THRESHOLD);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_enabled(sdev, 1);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_mute(sdev, DEFAULT_MUTE);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_power_level(sdev, DEFAULT_POWER_LEVEL);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_preemphasis(sdev, V4L2_FM_TX_PREEMPHASIS_50_uS);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +exit:
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_setup - Sets the device up with current configuration.
> > + * @sdev: si4713_device structure for the device we are communicating
> > + */
> > +static int si4713_setup(struct si4713_device *sdev)
> > +{
> > +     struct si4713_device *tmp;
> > +     int rval;
> > +
> > +     tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
> > +     if (!tmp)
> > +             return -ENOMEM;
> > +
> > +     /* Get a local copy to avoid race */
> > +     mutex_lock(&sdev->mutex);
> > +     memcpy(tmp, sdev, sizeof(*sdev));
> > +     mutex_unlock(&sdev->mutex);
> > +
> > +     rval = si4713_set_rds_pi(sdev, tmp->rds_info.pi);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_rds_pty(sdev, tmp->rds_info.pty);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_rds_ps_name(sdev, tmp->rds_info.ps_name);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_rds_radio_text(sdev, tmp->rds_info.radio_text);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_rds_enabled(sdev, tmp->rds_info.enabled);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_limiter_release_time(sdev,
> > +                             tmp->limiter_info.release_time);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_limiter_deviation(sdev, tmp->limiter_info.deviation);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_limiter_enabled(sdev, tmp->limiter_info.enabled);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_pilot_frequency(sdev, tmp->pilot_info.frequency);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_pilot_deviation(sdev, tmp->pilot_info.deviation);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_pilot_enabled(sdev, tmp->pilot_info.enabled);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_stereo_enabled(sdev, tmp->stereo);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_attack_time(sdev, tmp->acomp_info.attack_time);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_release_time(sdev,
> > +                                             tmp->acomp_info.release_time);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_gain(sdev, tmp->acomp_info.gain);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_threshold(sdev, tmp->acomp_info.threshold);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_acomp_enabled(sdev, tmp->acomp_info.enabled);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_mute(sdev, tmp->mute);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_preemphasis(sdev, tmp->preemphasis);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_frequency(sdev, tmp->frequency ? tmp->frequency :
> > +                                     DEFAULT_FREQUENCY);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_power_level(sdev, tmp->power_level ?
> > +                                     tmp->power_level :
> > +                                     DEFAULT_POWER_LEVEL);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_antenna_capacitor(sdev, tmp->antenna_capacitor);
> > +
> > +exit:
> > +     kfree(tmp);
> > +     return rval;
> > +}
> > +
> > +static int si4713_probe(struct si4713_device *sdev)
> > +{
> > +     int rval;
> > +
> > +     rval = si4713_set_power_state(sdev, POWER_ON);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_checkrev(sdev);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_set_power_state(sdev, POWER_OFF);
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     rval = si4713_init(sdev);
> > +
> > +exit:
> > +     return rval;
> > +}
> > +
> > +static int si4713_write_econtrol(struct si4713_device *sdev,
> > +                                     struct v4l2_ext_control *control)
> > +{
> > +     char ps_name[MAX_RDS_PS_NAME + 1];
> > +     char radio_text[MAX_RDS_RADIO_TEXT + 1];
> > +     int size;
> > +     s32 rval = 0;
> > +
> > +     switch (control->id) {
> > +     /* User class controls */
> > +     case V4L2_CID_AUDIO_MUTE:
> > +             rval = si4713_set_mute(sdev, control->value);
> > +             break;
> > +     /* FM_TX class controls */
> > +     case V4L2_CID_RDS_ENABLED:
> > +             rval = si4713_set_rds_enabled(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_RDS_PI:
> > +             rval = si4713_set_rds_pi(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_RDS_PTY:
> > +             rval = si4713_set_rds_pty(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_RDS_PS_NAME:
> > +             size = control->length > MAX_RDS_PS_NAME ? MAX_RDS_PS_NAME :
> > +                                                             control->length;
> > +             rval = copy_from_user(ps_name, control->string, size + 1);
> > +             if (rval < 0)
> > +                     goto exit;
> > +             rval = si4713_set_rds_ps_name(sdev, ps_name);
> > +             goto exit;
> > +     case V4L2_CID_RDS_RADIO_TEXT:
> > +             size = control->length > MAX_RDS_RADIO_TEXT ?
> > +                                     MAX_RDS_RADIO_TEXT : control->length;
> > +             rval = copy_from_user(radio_text, control->string, size + 1);
> 
> No, control->length is the total size of the memory block so you should
> probably set size to 'control->length - 1' and check against
> 'control->length > MAX_RDS_RADIO_TEXT + 1'.
> 
> The same issue is true for the PS_NAME control above.

Yeah, I've messed thing here.

> 
> > +             if (rval < 0)
> > +                     goto exit;
> > +             rval = si4713_set_rds_radio_text(sdev, radio_text);
> > +             goto exit;
> > +
> > +     case V4L2_CID_AUDIO_LIMITER_ENABLED:
> > +             rval = si4713_set_limiter_enabled(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
> > +             rval = si4713_set_limiter_release_time(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_AUDIO_LIMITER_DEVIATION:
> > +             rval = si4713_set_limiter_deviation(sdev, control->value);
> > +             break;
> > +
> > +     case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
> > +             rval = si4713_set_acomp_enabled(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_GAIN:
> > +             rval = si4713_set_acomp_gain(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
> > +             rval = si4713_set_acomp_threshold(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
> > +             rval = si4713_set_acomp_attack_time(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
> > +             rval = si4713_set_acomp_release_time(sdev, control->value);
> > +             break;
> > +
> > +     case V4L2_CID_PILOT_TONE_ENABLED:
> > +             rval = si4713_set_pilot_enabled(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_PILOT_TONE_DEVIATION:
> > +             rval = si4713_set_pilot_deviation(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_PILOT_TONE_FREQUENCY:
> > +             rval = si4713_set_pilot_frequency(sdev, control->value);
> > +             break;
> > +
> > +     case V4L2_CID_PREEMPHASIS:
> > +             rval = si4713_set_preemphasis(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_TUNE_POWER_LEVEL:
> > +             rval = si4713_set_power_level(sdev, control->value);
> > +             break;
> > +     case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> > +             rval = si4713_set_antenna_capacitor(sdev, control->value);
> > +             break;
> > +     default:
> > +             rval = -EINVAL;
> > +             break;
> > +     };
> > +
> > +     /* FIXME: There are properties with negative values */
> > +     if (rval >= 0) {
> > +             control->value = rval;
> > +             rval = 0;
> > +     }
> > +
> > +exit:
> > +     return rval;
> > +}
> > +
> > +static int si4713_read_econtrol(struct si4713_device *sdev,
> > +                             struct v4l2_ext_control *control)
> > +{
> > +     s32 rval = 0;
> > +     s8 val = 0;
> > +     char ps_name[MAX_RDS_PS_NAME + 1];
> > +     char radio_text[MAX_RDS_RADIO_TEXT + 1];
> > +
> > +     switch (control->id) {
> > +     /* User class controls */
> > +     case V4L2_CID_AUDIO_MUTE:
> > +             rval = si4713_get_mute(sdev);
> > +             break;
> > +     /* FM_TX class controls */
> > +     case V4L2_CID_RDS_ENABLED:
> > +             rval = si4713_get_rds_enabled(sdev);
> > +             break;
> > +     case V4L2_CID_RDS_PI:
> > +             rval = si4713_get_rds_pi(sdev);
> > +             break;
> > +     case V4L2_CID_RDS_PTY:
> > +             rval = si4713_get_rds_pty(sdev);
> > +             break;
> > +
> > +     case V4L2_CID_AUDIO_LIMITER_ENABLED:
> > +             rval = si4713_get_limiter_enabled(sdev);
> > +             break;
> > +     case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
> > +             rval = si4713_get_limiter_release_time(sdev);
> > +             break;
> > +     case V4L2_CID_AUDIO_LIMITER_DEVIATION:
> > +             rval = si4713_get_limiter_deviation(sdev);
> > +             break;
> > +
> > +     case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
> > +             rval = si4713_get_acomp_enabled(sdev);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_GAIN:
> > +             rval = si4713_get_acomp_gain(sdev);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
> > +             rval = si4713_get_acomp_threshold(sdev, &val);
> > +             if (rval == 0)
> > +                     control->value = val;
> > +             /* We can have negative value, so return earlier */
> > +             goto exit;
> > +     case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
> > +             rval = si4713_get_acomp_attack_time(sdev);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
> > +             rval = si4713_get_acomp_release_time(sdev);
> > +             break;
> > +
> > +     case V4L2_CID_PILOT_TONE_ENABLED:
> > +             rval = si4713_get_pilot_enabled(sdev);
> > +             break;
> > +     case V4L2_CID_PILOT_TONE_DEVIATION:
> > +             rval = si4713_get_pilot_deviation(sdev);
> > +             break;
> > +     case V4L2_CID_PILOT_TONE_FREQUENCY:
> > +             rval = si4713_get_pilot_frequency(sdev);
> > +             break;
> > +
> > +     case V4L2_CID_PREEMPHASIS:
> > +             rval = si4713_get_preemphasis(sdev);
> > +             break;
> > +
> > +     /* here we do not use read property */
> > +     case V4L2_CID_RDS_PS_NAME:
> > +             rval = si4713_get_rds_ps_name(sdev, ps_name);
> > +             if (rval < 0)
> > +                     goto exit;
> > +             rval = copy_to_user(control->string, ps_name,
> > +                                                     strlen(ps_name) + 1);
> > +             control->length = strlen(ps_name);
> 
> No, this isn't right either. The caller allocates the memory and sets up the
> control->length. So you have to check whether the result fits in the available
> space and return an error if it doesn't. And control->length is the total size
> of the allocated memory, including terminating zeroes.
> 
> Currently my string control implementation doesn't say anything about how to
> detect the right length, that's something I need to think about. As I mentioned
> earlier the string control support was put together rather quickly and needs
> more time.

here too.

> 
> > +             goto exit;
> > +     case V4L2_CID_RDS_RADIO_TEXT:
> > +             rval = si4713_get_rds_radio_text(sdev, radio_text);
> > +             if (rval < 0)
> > +                     goto exit;
> > +             rval = copy_to_user(control->string, radio_text,
> > +                                                     strlen(radio_text) + 1);
> > +             control->length = strlen(radio_text);
> > +             goto exit;
> > +
> > +     /* here we use tx tune status */
> > +     case V4L2_CID_TUNE_POWER_LEVEL:
> > +             rval = si4713_get_power_level(sdev);
> > +             break;
> > +     case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> > +             rval = si4713_get_antenna_capacitor(sdev);
> > +             break;
> > +     default:
> > +             rval = -EINVAL;
> > +             break;
> > +     };
> > +
> > +     if (rval >= 0) {
> > +             control->value = rval;
> > +             rval = 0;
> > +     }
> > +
> > +exit:
> > +     return rval;
> > +}
> > +
> > +/*
> > + * Video4Linux Subdev Interface
> > + */
> > +/*
> > + * si4713_s_ext_ctrls - set extended controls value
> > + */
> > +static int si4713_s_ext_ctrls(struct v4l2_subdev *sd,
> > +                             struct v4l2_ext_controls *ctrls)
> > +{
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +     int i;
> > +
> > +     if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
> > +             return -EINVAL;
> > +
> > +     for (i = 0; i < ctrls->count; i++) {
> > +             int err = si4713_write_econtrol(sdev, ctrls->controls + i);
> > +
> > +             if (err < 0) {
> > +                     ctrls->error_idx = i;
> > +                     return err;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * si4713_g_ext_ctrls - get extended controls value
> > + */
> > +static int si4713_g_ext_ctrls(struct v4l2_subdev *sd,
> > +                             struct v4l2_ext_controls *ctrls)
> > +{
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +     int i;
> > +
> > +     if (ctrls->ctrl_class != V4L2_CTRL_CLASS_FM_TX)
> > +             return -EINVAL;
> > +
> > +     for (i = 0; i < ctrls->count; i++) {
> > +             int err = si4713_read_econtrol(sdev, ctrls->controls + i);
> > +
> > +             if (err < 0) {
> > +                     ctrls->error_idx = i;
> > +                     return err;
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * si4713_queryctrl - enumerate control items
> > + */
> > +static int si4713_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> > +{
> > +     int rval = 0;
> > +
> > +     switch (qc->id) {
> > +     /* User class controls */
> > +     case V4L2_CID_AUDIO_MUTE:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, DEFAULT_MUTE);
> > +             break;
> > +     /* FM_TX class controls */
> > +     case V4L2_CID_RDS_ENABLED:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> > +             break;
> > +     case V4L2_CID_RDS_PI:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 0xFFFF, 1, DEFAULT_RDS_PI);
> > +             break;
> > +     case V4L2_CID_RDS_PTY:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 31, 1, DEFAULT_RDS_PTY);
> > +             break;
> > +     /* TODO: String controls not implemented yet */
> > +     case V4L2_CID_RDS_PS_NAME:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 0, 0, 0);
> > +             break;
> > +     case V4L2_CID_RDS_RADIO_TEXT:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 0, 0, 0);
> > +             break;
> > +
> > +     case V4L2_CID_AUDIO_LIMITER_ENABLED:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> > +             break;
> > +     case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME:
> > +             rval = v4l2_ctrl_query_fill(qc, 250, MAX_LIMITER_RELEASE_TIME,
> > +                                             50, DEFAULT_LIMITER_RTIME);
> > +             break;
> > +     case V4L2_CID_AUDIO_LIMITER_DEVIATION:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, MAX_LIMITER_DEVIATION,
> > +                                             10, DEFAULT_LIMITER_DEV);
> > +             break;
> > +
> > +     case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_GAIN:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, MAX_ACOMP_GAIN, 1,
> > +                                             DEFAULT_ACOMP_GAIN);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD:
> > +             rval = v4l2_ctrl_query_fill(qc, MIN_ACOMP_THRESHOLD,
> > +                                             MAX_ACOMP_THRESHOLD, 1,
> > +                                             DEFAULT_ACOMP_THRESHOLD);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, MAX_ACOMP_ATTACK_TIME,
> > +                                             500, DEFAULT_ACOMP_ATIME);
> > +             break;
> > +     case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME:
> > +             rval = v4l2_ctrl_query_fill(qc, 100000, MAX_ACOMP_RELEASE_TIME,
> > +                                             100000, DEFAULT_ACOMP_RTIME);
> > +             break;
> > +
> > +     case V4L2_CID_PILOT_TONE_ENABLED:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> > +             break;
> > +     case V4L2_CID_PILOT_TONE_DEVIATION:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, MAX_PILOT_DEVIATION,
> > +                                             10, DEFAULT_PILOT_DEVIATION);
> > +             break;
> > +     case V4L2_CID_PILOT_TONE_FREQUENCY:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, MAX_PILOT_FREQUENCY,
> > +                                             1, DEFAULT_PILOT_FREQUENCY);
> > +             break;
> > +
> > +     case V4L2_CID_PREEMPHASIS:
> > +             rval = v4l2_ctrl_query_fill(qc, V4L2_FM_TX_PREEMPHASIS_DISABLED,
> > +                                             V4L2_FM_TX_PREEMPHASIS_75_uS, 1,
> > +                                             V4L2_FM_TX_PREEMPHASIS_50_uS);
> > +             break;
> > +     case V4L2_CID_TUNE_POWER_LEVEL:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 120, 1, DEFAULT_POWER_LEVEL);
> > +             break;
> > +     case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> > +             rval = v4l2_ctrl_query_fill(qc, 0, 191, 1, 0);
> > +             break;
> > +     default:
> > +             rval = -EINVAL;
> > +             break;
> > +     };
> > +
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_g_ctrl - get the value of a control
> > + */
> > +static int si4713_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> > +{
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +     int rval = 0;
> > +
> > +     if (!sdev)
> > +             return -ENODEV;
> > +
> > +     switch (ctrl->id) {
> > +     case V4L2_CID_AUDIO_MUTE:
> > +             rval = si4713_get_mute(sdev);
> > +             if (rval >= 0) {
> > +                     ctrl->value = rval;
> > +                     rval = 0;
> > +             }
> > +             break;
> > +     }
> > +
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_s_ctrl - set the value of a control
> > + */
> > +static int si4713_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> > +{
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +     int rval = 0;
> > +
> > +     if (!sdev)
> > +             return -ENODEV;
> > +
> > +     switch (ctrl->id) {
> > +     case V4L2_CID_AUDIO_MUTE:
> > +             if (ctrl->value) {
> > +                     rval = si4713_set_mute(sdev, ctrl->value);
> > +                     if (rval < 0)
> > +                             goto exit;
> > +
> > +                     rval = si4713_set_power_state(sdev, POWER_DOWN);
> > +             } else {
> > +                     rval = si4713_set_power_state(sdev, POWER_UP);
> > +                     if (rval < 0)
> > +                             goto exit;
> > +
> > +                     rval = si4713_setup(sdev);
> > +                     if (rval < 0)
> > +                             goto exit;
> > +
> > +                     rval = si4713_set_mute(sdev, ctrl->value);
> > +             }
> > +             break;
> > +     }
> > +
> > +exit:
> > +     return rval;
> > +}
> > +
> > +static const struct v4l2_subdev_core_ops si4713_subdev_core_ops = {
> > +     .queryctrl      = si4713_queryctrl,
> > +     .g_ext_ctrls    = si4713_g_ext_ctrls,
> > +     .s_ext_ctrls    = si4713_s_ext_ctrls,
> > +     .g_ctrl         = si4713_g_ctrl,
> > +     .s_ctrl         = si4713_s_ctrl,
> > +};
> > +
> > +/*
> > + * si4713_g_modulator - get modulator attributes
> > + */
> > +static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
> > +{
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +     int rval;
> > +
> > +     if (!sdev) {
> > +             rval = -ENODEV;
> > +             goto exit;
> > +     }
> > +
> > +     if (vm->index > 0) {
> > +             rval = -EINVAL;
> > +             goto exit;
> > +     }
> > +
> > +     strncpy(vm->name, "FM Modulator", 32);
> > +     vm->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW;
> > +
> > +     /* Report current frequency range limits */
> > +     vm->rangelow = si4713_to_v4l2(7600);
> > +     vm->rangehigh = si4713_to_v4l2(10800);
> > +
> > +     /* Report current audio mode: mono or stereo */
> > +     vm->txsubchans = V4L2_TUNER_SUB_MONO;
> > +     rval = si4713_get_stereo_enabled(sdev);
> > +     if (rval < 0)
> > +             goto exit;
> > +     if (rval)
> > +             vm->txsubchans |= V4L2_TUNER_SUB_STEREO;
> 
> This isn't right. It should be either SUB_MONO or SUB_STEREO. It tells the
> application the current modulation.

Ok. Will fix that.


> 
> > +
> > +     /* TODO: Report current signal length */
> > +
> > +     rval = 0;
> > +exit:
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_s_modulator - set modulator attributes
> > + */
> > +static int si4713_s_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
> > +{
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +     int rval;
> > +
> > +     if (!sdev) {
> > +             rval = -ENODEV;
> > +             goto exit;
> > +     }
> > +
> > +     if (vm->index > 0) {
> > +             rval = -EINVAL;
> > +             goto exit;
> > +     }
> > +
> > +     /* Set audio mode: mono or stereo */
> > +     rval = si4713_set_stereo_enabled(sdev,
> > +                             !!(vm->txsubchans & V4L2_TUNER_SUB_STEREO));
> 
> There are only two valid txsubchans values: SUB_MONO or SUB_STEREO. I suggest
> that you check explicitly for these values and return an -EINVAL error if
> you get something else.

yeah. wil fix it.

> 
> > +     if (rval < 0)
> > +             goto exit;
> > +
> > +     /* TODO: How to set frequency to measure current signal length */
> 
> Huh? I don't understand this TODO.

The todo is about the property this device had, to report signal length
of a freq. It used to work like: user echoes the freq on sysfs entry.
when reading the same entry, it reports the signal noise there.

This is something which I still don't know the proper place to put.

I thought in another ext control. But I don't know if this fix into
the fm tx controls. Maybe I should use a private one ?

> 
> > +
> > +exit:
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_g_frequency - get tuner or modulator radio frequency
> > + */
> > +static int si4713_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
> > +{
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +     int rval = 0;
> > +     int freq;
> > +
> > +     f->type = V4L2_TUNER_RADIO;
> > +     freq = si4713_get_frequency(sdev);
> > +
> > +     if (freq < 0)
> > +             rval = freq;
> > +     else
> > +             f->frequency = si4713_to_v4l2(freq);
> > +
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_s_frequency - set tuner or modulator radio frequency
> > + */
> > +static int si4713_s_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
> > +{
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +     int rval = 0;
> > +
> > +     rval = si4713_set_frequency(sdev, v4l2_to_si4713(f->frequency));
> > +     if (rval > 0) {
> > +             f->frequency = si4713_to_v4l2(rval);
> > +             rval = 0;
> > +     }
> > +
> > +     return rval;
> > +}
> > +
> > +static const struct v4l2_subdev_tuner_ops si4713_subdev_tuner_ops = {
> > +     .g_frequency    = si4713_g_frequency,
> > +     .s_frequency    = si4713_s_frequency,
> > +     .g_modulator    = si4713_g_modulator,
> > +     .s_modulator    = si4713_s_modulator,
> > +};
> > +
> > +static const struct v4l2_subdev_ops si4713_subdev_ops = {
> > +     .core           = &si4713_subdev_core_ops,
> > +     .tuner          = &si4713_subdev_tuner_ops,
> > +};
> > +
> > +/*
> > + * I2C driver interface
> > + */
> > +/*
> > + * si4713_i2c_driver_probe - probe for the device
> > + */
> > +static int si4713_i2c_driver_probe(struct i2c_client *client,
> > +                                     const struct i2c_device_id *id)
> 
> Misnomer: just call this si4713_probe. This isn't driver initialization,
> this probes for a si4713 on an i2c adapter.

right.

> 
> > +{
> > +     struct si4713_device *sdev;
> > +     int rval;
> > +
> > +     sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
> > +     if (!sdev) {
> > +             dev_dbg(&client->dev, "Failed to alloc video device.\n");
> > +             rval = -ENOMEM;
> > +             goto exit;
> > +     }
> > +
> > +     sdev->platform_data = client->dev.platform_data;
> > +     if (!sdev->platform_data) {
> > +             dev_err(&client->dev, "No platform data registered.\n");
> > +             rval = -ENODEV;
> > +             goto free_sdev;
> > +     }
> > +
> > +     v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
> 
> When the subdev was found, then the driver should print this message:
> 
>         v4l2_info(&sdev->sd, "chip found @ 0x%02x (%s)\n",
>                         client->addr << 1, client->adapter->name);
> 
> Since this shows up in the kernel log it is very useful for debugging as it
> tells you which i2c devices were found. All v4l i2c drivers do this.

yes, will use this.

> 
> > +
> > +     mutex_init(&sdev->mutex);
> > +     init_completion(&sdev->work);
> > +
> > +     if (client->irq) {
> > +             rval = request_irq(client->irq,
> > +                     si4713_handler, IRQF_TRIGGER_FALLING | IRQF_DISABLED,
> > +                     client->name, sdev);
> > +             if (rval < 0) {
> > +                     dev_err(&client->dev, "Could not request IRQ\n");
> > +                     goto free_sdev;
> > +             }
> > +             dev_dbg(&client->dev, "IRQ requested.\n");
> > +     } else {
> > +             dev_info(&client->dev, "IRQ not configure. Using timeouts.\n");
> 
> typo: configure -> configured

ok.

> 
> > +     }
> > +
> > +     rval = si4713_probe(sdev);
> > +     if (rval < 0) {
> > +             dev_err(&client->dev, "Failed to probe device information.\n");
> > +             goto free_irq;
> > +     }
> > +
> > +     return 0;
> > +
> > +free_irq:
> > +     if (client->irq)
> > +             free_irq(client->irq, sdev);
> > +free_sdev:
> > +     kfree(sdev);
> > +exit:
> > +     return rval;
> > +}
> > +
> > +/*
> > + * si4713_i2c_driver_remove - remove the device
> > + */
> > +static int __exit si4713_i2c_driver_remove(struct i2c_client *client)
> 
> Also a misnomer: si4713_remove is the correct name. You can't use __exit
> here since this doesn't exit the driver, it is just called when the adapter
> is removed.

yes.

> 
> > +{
> > +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +     struct si4713_device *sdev = to_si4713_device(sd);
> > +
> > +     /* our client isn't attached */
> > +     if (!client->adapter)
> > +             return -ENODEV;
> 
> This can never happen.
> 
> > +     if (sdev) {
> 
> sdev is never NULL.

true. removing.

> 
> > +             if (sdev->power_state)
> > +                     si4713_set_power_state(sdev, POWER_DOWN);
> > +
> > +             if (client->irq > 0)
> > +                     free_irq(client->irq, sdev);
> > +
> > +             v4l2_device_unregister_subdev(sd);
> > +
> > +             kfree(sdev);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * si4713_i2c_driver - i2c driver interface
> > + */
> > +static const struct i2c_device_id si4713_id[] = {
> > +     { "si4713" , 0 },
> > +     { },
> > +};
> > +MODULE_DEVICE_TABLE(i2c, si4713_id);
> > +
> > +static struct i2c_driver si4713_i2c_driver = {
> > +     .driver         = {
> > +             .name   = "si4713",
> > +     },
> > +     .probe          = si4713_i2c_driver_probe,
> > +     .remove         = __exit_p(si4713_i2c_driver_remove),
> 
> Remove __exit_p.

yup

> 
> > +     .id_table       = si4713_id,
> > +};
> > +
> > +/*
> > + * Module Interface
> > + */
> > +static int __init si4713_module_init(void)
> > +{
> > +     return i2c_add_driver(&si4713_i2c_driver);
> > +}
> > +
> > +static void __exit si4713_module_exit(void)
> > +{
> > +     i2c_del_driver(&si4713_i2c_driver);
> > +}
> > +
> > +module_init(si4713_module_init);
> > +module_exit(si4713_module_exit);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Eduardo Valentin <eduardo.valentin@nokia.com>");
> > +MODULE_DESCRIPTION("I2C driver for Si4713 FM Radio Transmitter");
> > +MODULE_VERSION("0.0.1");
> 
> I recommend moving these MODULE macros to the top of the source. This is
> top-level information so it is good to see this immediately when you open
> the source code for the first time.

Right. Will move this to top file. Will put on top the module parameter for
debug level as well.

> 
> > +
> > diff --git a/linux/drivers/media/radio/si4713-i2c.h b/linux/drivers/media/radio/si4713-i2c.h
> > new file mode 100644
> > index 0000000..d3c9259
> > --- /dev/null
> > +++ b/linux/drivers/media/radio/si4713-i2c.h
> > @@ -0,0 +1,226 @@
> > +/*
> > + * drivers/media/radio/si4713-i2c.h
> > + *
> > + * Property and commands definitions for Si4713 radio transmitter chip.
> > + *
> > + * Copyright (c) 2008 Instituto Nokia de Tecnologia - INdT
> > + * Contact: Eduardo Valentin <eduardo.valentin@nokia.com>
> > + *
> > + * This file is licensed under the terms of the GNU General Public License
> > + * version 2. This program is licensed "as is" without any warranty of any
> > + * kind, whether express or implied.
> > + *
> > + */
> > +
> > +#ifndef SI4713_I2C_H
> > +#define SI4713_I2C_H
> > +
> > +#include <media/v4l2-subdev.h>
> > +#include <media/si4713.h>
> > +
> > +#define SI4713_PRODUCT_NUMBER                0x0D
> > +
> > +/* Command Timeouts */
> > +#define DEFAULT_TIMEOUT                      500
> > +#define TIMEOUT_SET_PROPERTY         20
> > +#define TIMEOUT_TX_TUNE_POWER                30000
> > +#define TIMEOUT_TX_TUNE                      110000
> > +#define TIMEOUT_POWER_UP             200000
> > +
> > +/*
> > + * Command and its arguments definitions
> > + */
> > +#define SI4713_PWUP_CTSIEN           (1<<7)
> > +#define SI4713_PWUP_GPO2OEN          (1<<6)
> > +#define SI4713_PWUP_PATCH            (1<<5)
> > +#define SI4713_PWUP_XOSCEN           (1<<4)
> > +#define SI4713_PWUP_FUNC_TX          0x02
> > +#define SI4713_PWUP_FUNC_PATCH               0x0F
> > +#define SI4713_PWUP_OPMOD_ANALOG     0x50
> > +#define SI4713_PWUP_OPMOD_DIGITAL    0x0F
> > +#define SI4713_PWUP_NARGS            2
> > +#define SI4713_PWUP_NRESP            1
> > +#define SI4713_CMD_POWER_UP          0x01
> > +
> > +#define SI4713_GETREV_NRESP          9
> > +#define SI4713_CMD_GET_REV           0x10
> > +
> > +#define SI4713_PWDN_NRESP            1
> > +#define SI4713_CMD_POWER_DOWN                0x11
> > +
> > +#define SI4713_SET_PROP_NARGS                5
> > +#define SI4713_SET_PROP_NRESP                1
> > +#define SI4713_CMD_SET_PROPERTY              0x12
> > +
> > +#define SI4713_GET_PROP_NARGS                3
> > +#define SI4713_GET_PROP_NRESP                4
> > +#define SI4713_CMD_GET_PROPERTY              0x13
> > +
> > +#define SI4713_GET_STATUS_NRESP              1
> > +#define SI4713_CMD_GET_INT_STATUS    0x14
> > +
> > +#define SI4713_CMD_PATCH_ARGS                0x15
> > +#define SI4713_CMD_PATCH_DATA                0x16
> > +
> > +#define SI4713_MAX_FREQ                      10800
> > +#define SI4713_MIN_FREQ                      7600
> > +#define SI4713_TXFREQ_NARGS          3
> > +#define SI4713_TXFREQ_NRESP          1
> > +#define SI4713_CMD_TX_TUNE_FREQ              0x30
> > +
> > +#define SI4713_MAX_POWER             120
> > +#define SI4713_MIN_POWER             88
> > +#define SI4713_MAX_ANTCAP            191
> > +#define SI4713_MIN_ANTCAP            0
> > +#define SI4713_TXPWR_NARGS           4
> > +#define SI4713_TXPWR_NRESP           1
> > +#define SI4713_CMD_TX_TUNE_POWER     0x31
> > +
> > +#define SI4713_TXMEA_NARGS           4
> > +#define SI4713_TXMEA_NRESP           1
> > +#define SI4713_CMD_TX_TUNE_MEASURE   0x32
> > +
> > +#define SI4713_INTACK_MASK           0x01
> > +#define SI4713_TXSTATUS_NARGS                1
> > +#define SI4713_TXSTATUS_NRESP                8
> > +#define SI4713_CMD_TX_TUNE_STATUS    0x33
> > +
> > +#define SI4713_OVERMOD_BIT           (1 << 2)
> > +#define SI4713_IALH_BIT                      (1 << 1)
> > +#define SI4713_IALL_BIT                      (1 << 0)
> > +#define SI4713_ASQSTATUS_NARGS               1
> > +#define SI4713_ASQSTATUS_NRESP               5
> > +#define SI4713_CMD_TX_ASQ_STATUS     0x34
> > +
> > +#define SI4713_RDSBUFF_MODE_MASK     0x87
> > +#define SI4713_RDSBUFF_NARGS         7
> > +#define SI4713_RDSBUFF_NRESP         6
> > +#define SI4713_CMD_TX_RDS_BUFF               0x35
> > +
> > +#define SI4713_RDSPS_PSID_MASK               0x1F
> > +#define SI4713_RDSPS_NARGS           5
> > +#define SI4713_RDSPS_NRESP           1
> > +#define SI4713_CMD_TX_RDS_PS         0x36
> > +
> > +#define SI4713_CMD_GPO_CTL           0x80
> > +#define SI4713_CMD_GPO_SET           0x81
> > +
> > +/*
> > + * Bits from status response
> > + */
> > +#define SI4713_CTS                   (1<<7)
> > +#define SI4713_ERR                   (1<<6)
> > +#define SI4713_RDS_INT                       (1<<2)
> > +#define SI4713_ASQ_INT                       (1<<1)
> > +#define SI4713_STC_INT                       (1<<0)
> > +
> > +/*
> > + * Property definitions
> > + */
> > +#define SI4713_GPO_IEN                       0x0001
> > +#define SI4713_DIG_INPUT_FORMAT              0x0101
> > +#define SI4713_DIG_INPUT_SAMPLE_RATE 0x0103
> > +#define SI4713_REFCLK_FREQ           0x0201
> > +#define SI4713_REFCLK_PRESCALE               0x0202
> > +#define SI4713_TX_COMPONENT_ENABLE   0x2100
> > +#define SI4713_TX_AUDIO_DEVIATION    0x2101
> > +#define SI4713_TX_PILOT_DEVIATION    0x2102
> > +#define SI4713_TX_RDS_DEVIATION              0x2103
> > +#define SI4713_TX_LINE_INPUT_LEVEL   0x2104
> > +#define SI4713_TX_LINE_INPUT_MUTE    0x2105
> > +#define SI4713_TX_PREEMPHASIS                0x2106
> > +#define SI4713_TX_PILOT_FREQUENCY    0x2107
> > +#define SI4713_TX_ACOMP_ENABLE               0x2200
> > +#define SI4713_TX_ACOMP_THRESHOLD    0x2201
> > +#define SI4713_TX_ACOMP_ATTACK_TIME  0x2202
> > +#define SI4713_TX_ACOMP_RELEASE_TIME 0x2203
> > +#define SI4713_TX_ACOMP_GAIN         0x2204
> > +#define SI4713_TX_LIMITER_RELEASE_TIME       0x2205
> > +#define SI4713_TX_ASQ_INTERRUPT_SOURCE       0x2300
> > +#define SI4713_TX_ASQ_LEVEL_LOW              0x2301
> > +#define SI4713_TX_ASQ_DURATION_LOW   0x2302
> > +#define SI4713_TX_ASQ_LEVEL_HIGH     0x2303
> > +#define SI4713_TX_ASQ_DURATION_HIGH  0x2304
> > +#define SI4713_TX_RDS_INTERRUPT_SOURCE       0x2C00
> > +#define SI4713_TX_RDS_PI             0x2C01
> > +#define SI4713_TX_RDS_PS_MIX         0x2C02
> > +#define SI4713_TX_RDS_PS_MISC                0x2C03
> > +#define SI4713_TX_RDS_PS_REPEAT_COUNT        0x2C04
> > +#define SI4713_TX_RDS_PS_MESSAGE_COUNT       0x2C05
> > +#define SI4713_TX_RDS_PS_AF          0x2C06
> > +#define SI4713_TX_RDS_FIFO_SIZE              0x2C07
> > +
> > +#define PREEMPHASIS_USA                      75
> > +#define PREEMPHASIS_EU                       50
> > +#define PREEMPHASIS_DISABLED         0
> > +#define FMPE_USA                     0x00
> > +#define FMPE_EU                              0x01
> > +#define FMPE_DISABLED                        0x02
> > +
> > +#define POWER_UP                     0x01
> > +#define POWER_DOWN                   0x00
> > +
> > +struct rds_info {
> > +     u16 pi;
> > +#define MAX_RDS_PTY                  31
> > +     u8 pty;
> > +#define MAX_RDS_PS_NAME                      96
> > +     u8 ps_name[MAX_RDS_PS_NAME + 1];
> > +#define MAX_RDS_RADIO_TEXT           384
> > +     u8 radio_text[MAX_RDS_RADIO_TEXT + 1];
> > +     u8 enabled;
> > +};
> > +
> > +struct limiter_info {
> > +#define MAX_LIMITER_RELEASE_TIME     102390
> > +     unsigned long release_time;
> > +#define MAX_LIMITER_DEVIATION                90000
> > +     unsigned long deviation;
> > +     u8 enabled;
> > +};
> > +
> > +struct pilot_info {
> > +#define MAX_PILOT_DEVIATION          90000
> > +     unsigned long deviation;
> > +#define MAX_PILOT_FREQUENCY          19000
> > +     u16 frequency;
> > +     u8 enabled;
> > +};
> > +
> > +struct acomp_info {
> > +#define MAX_ACOMP_RELEASE_TIME               1000000
> > +     unsigned long release_time;
> > +#define MAX_ACOMP_ATTACK_TIME                5000
> > +     u16 attack_time;
> > +#define MAX_ACOMP_THRESHOLD          0
> > +#define MIN_ACOMP_THRESHOLD          (-40)
> > +     s8 threshold;
> > +#define MAX_ACOMP_GAIN                       20
> > +     u8 gain;
> > +     u8 enabled;
> > +};
> > +
> > +/*
> > + * si4713_device - private data
> > + */
> > +struct si4713_device {
> > +     /* v4l2_subdev and i2c reference (v4l2_subdev priv data) */
> > +     struct v4l2_subdev sd;
> > +     /* private data structures */
> > +     struct mutex mutex;
> > +     struct completion work;
> > +     struct si4713_platform_data *platform_data;
> > +     struct rds_info rds_info;
> > +     struct limiter_info limiter_info;
> > +     struct pilot_info pilot_info;
> > +     struct acomp_info acomp_info;
> > +     u16 frequency;
> > +     u8 preemphasis;
> > +     u8 mute;
> > +     u8 power_level;
> > +     u8 power_state;
> > +     u8 antenna_capacitor;
> > +     u8 stereo;
> > +     u8 tune_rssi;
> > +};
> > +#endif /* ifndef SI4713_I2C_H */
> 
> Regards,
> 
>         Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

-- 
Eduardo Valentin
