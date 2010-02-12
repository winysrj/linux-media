Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1071 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab0BLPmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 10:42:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: saa7134 and =?utf-8?q?=C3=83=C2=8E=C3=82=C2=BCPD61151_MPEG2?= coder
Date: Fri, 12 Feb 2010 16:44:15 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <20091007101142.3b83dbf2@glory.loctelecom.ru> <20100129161202.2ecb510a@glory.loctelecom.ru> <20100209144150.17fafc52@glory.loctelecom.ru>
In-Reply-To: <20100209144150.17fafc52@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002121644.15896.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 09 February 2010 06:41:50 Dmitri Belimov wrote:
> Hi Hans
> 
> This is my last state for review.
> After small time I'll finish process of initialize the encoder.
> Configure some register, upload two firmware for video and for audio.
> Configure the frontends.
> 
> I have the questions.
> For configuring audio frontend need know samplerate of audio.
> saa7134 can only 32kHz
> saa7131/3/5 on I2S 32кГц from SIF source and 32/44.1/48 from external i.e.
> RCA stereo audio input. 
> 
> Hardcode 32kHz or need a function for determine mode of audio??

See struct v4l2_subdev_audio_ops: it has a s_clock_freq op for precisely that
purpose. The saa7134 should call that whenever it sets a new samplerate.

> 
> Other question. For configure VideoFrontend need know 50 or 60Hz
> Now I use videomode from h structure. I think more correct detect it
> on saa7134.

Whether it is 50 or 60 Hz depends on the video standard that you receive via
the s_std core op. Just implement that and when you get a new standard you
can use something like this: is_60hz = (std & V4L2_STD_525_60) ? 1 : 0;

Some more review comments:

linux/drivers/media/video/saa7134/saa7134.h:

@@ -355,6 +377,10 @@
        unsigned char           empress_addr;
        unsigned char           rds_addr;
 
+       /* SPI info */
+       struct saa7134_software_spi     spi;
+       struct spi_board_info   spi_conf;

Make this a struct spi_board_info *. This struct is too large: it is only used
in one board but all elements of the board array will suddenly get this whole
struct increasing the memory footprint substantially. In this case you can just
make it a pointer, that will work just as well.

+
        unsigned int            tda9887_conf;
        unsigned int            tuner_config;

linux/drivers/media/video/v4l2-common.c, in v4l2_spi_subdev_init():

+       /* initialize name */
+       snprintf(sd->name, sizeof(sd->name), "%s",
+               spi->dev.driver->name);

Use strlcpy here.

saa7134-spi.c:


static inline u32 getmiso(struct spi_device *dev)
{
        struct saa7134_spi_gpio *sb = to_sb(dev);
        unsigned long status;

        status = saa7134_get_gpio(sb->controller_data);
        if ( status & (1 << sb->controller_data->spi.miso))
                return 1;
        else
                return 0;
}

Simplify to:

static inline u32 getmiso(struct spi_device *dev)
{
        struct saa7134_spi_gpio *sb = to_sb(dev);
        u32 status;

        status = saa7134_get_gpio(sb->controller_data);
        return !!(status & (1 << sb->controller_data->spi.miso));
}

Also note that saa7134_get_gpio should return an u32 since unsigned long is
64 bits when compiled on a 64-bit kernel, which is probably not what you want.

saa7134_spi_unregister can be a void function as the result code is always 0.

There seems to be some old stuff in upd61151.h. Please remove what is not
needed.

In upd61151.c I highly recommend that all functions will use struct v4l2_subdev *sd
as argument. Only at the lowest level should you go from sd to spi. Among
others this allows you to use the standard v4l2_info/dbg etc. logging functions.

Don't use RESULT_SUCCESS. Just return 0.

Remove upd61151_init. The init op is rarely needed and should in general not
be used.

Remove those emacs editor comments at the end of the files. That's bad practice.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
