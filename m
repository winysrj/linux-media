Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:47662 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0ANJob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 04:44:31 -0500
Received: by fxm25 with SMTP id 25so283992fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 01:44:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3a11f97d6e44a5cd64c4378c51706ff4.squirrel@webmail.xs4all.nl>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
	 <3a11f97d6e44a5cd64c4378c51706ff4.squirrel@webmail.xs4all.nl>
Date: Thu, 14 Jan 2010 13:44:29 +0400
Message-ID: <1a297b361001140144s3518ed59o14b0784de9fd828@mail.gmail.com>
Subject: Re: About driver architecture
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Qiu <fallwind@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jan 14, 2010 at 1:25 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Hi,
>>
>>
>> On Thu, Jan 14, 2010 at 11:35 AM, Michael Qiu <fallwind@gmail.com> wrote:
>>> Hi guys,
>>>  I'm going to write drivers for a new soc which designed for dvb-s set
>>> top box.
>>> It will support these features:
>>> 1. Multi-layer display with alpha blending feature, including
>>> video(YUV), OSDs(2 same RGB layers), background(with fixed YUV color)
>>> and still picture(YUV color for still image)
>>> 2. DVB-S tuner and demod
>>> 3. HW MPEG2/4 decoder
>>> 4. HW accelerated JPEG decoder engine.
>>>
>>> My targets are:
>>> 1. Fit all the drivers in proper framework so they can be easily used
>>> by applications in open source community.
>>> 2. As flexible as I can to add new software features in the future.
>>>
>>> My questions are:
>>> How many drivers should I implement, and how should I divide all the
>>> features?
>>> As far as I know:
>>> A) a frame buffer driver for 2 OSDs, maybe also the control point for
>>> whole display module?
>>> B) video output device for video layer, which will output video program.
>>> C) drivers for tuner and demo (or just a driver which will export 2
>>> devices files for each?)
>>> D) driver for jpeg accelerate interface, or should it be a part of
>>> MPEG2/4 decoder driver?
>>> E) driver for MPEG2/4 decoder which will control the behave of H/W
>>> decoder.
>>>
>>> Actually I think all the display functions are relative, some
>>> functions i listed upper are operating one HW module, for instance:
>>> OSD and video layer are implemented by display module in H/W level.
>>> What's the right way to implement these functions in driver level,
>>> united or separated?
>>> And, I've read some documents for V4L2, but I still cannot figure out
>>> where should I implement my driver in the framework.
>>>
>>> In a word, I'm totally confused. Can you guys show me the right way or
>>> just kick me to a existing example with similar features?
>>>
>>
>> Currently, there are 2 drivers which have exactly the functionality
>> that you have mentioned. The first one is an AV7110 based device and
>> the other one is a STi7109 SOC based device.
>>
>> With regards to the AV7110 based hardware, you can have a look at
>> linux/drivers/media/dvb/ttpci/ *
>>
>> And with regards to the STi7109 SOC based, you can have a look at
>> http://jusst.de/hg/saa716x/
>> linux/drivers/media/common/saa716x/ *
>> specifically you will need to look at saa716x_ff.c/h for the STi7109
>> related stuff
>>
>>
>> Both the AV7110 and STi7109 SOC feature a OSD interface, in addition
>> to the audio and video layers. which you can see from the drivers,
>> themselves. Additionally the STi7109 SOC features HDMI outputs. The
>> AV7110 based cards, they incorporate DVB-S/C/T frontends for different
>> products. The STi7109 product that we have currently features only a
>> DVB-S/S2 system only, though that doesn't make any difference at all.
>
> The AV7110 OSD is not framebuffer based AFAIK. So probably not a good
> place to look.


It doesn't support OSD ?


static inline int DestroyOSDWindow(struct av7110 *av7110, u8 windownr)
{
	return av7110_fw_cmd(av7110, COMTYPE_OSD, WDestroy, 1, windownr);
}

static inline int CreateOSDWindow(struct av7110 *av7110, u8 windownr,
				  osd_raw_window_t disptype,
				  u16 width, u16 height)
{
	return av7110_fw_cmd(av7110, COMTYPE_OSD, WCreate, 4,
			     windownr, disptype, width, height);
}


static enum av7110_osd_palette_type bpp2pal[8] = {
	Pal1Bit, Pal2Bit, 0, Pal4Bit, 0, 0, 0, Pal8Bit
};
static osd_raw_window_t bpp2bit[8] = {
	OSD_BITMAP1, OSD_BITMAP2, 0, OSD_BITMAP4, 0, 0, 0, OSD_BITMAP8
};

static inline int WaitUntilBmpLoaded(struct av7110 *av7110)
{
	int ret = wait_event_timeout(av7110->bmpq,
				av7110->bmp_state != BMP_LOADING, 10*HZ);
	if (ret == 0) {
		printk("dvb-ttpci: warning: timeout waiting in LoadBitmap: %d, %d\n",
		       ret, av7110->bmp_state);
		av7110->bmp_state = BMP_NONE;
		return -ETIMEDOUT;
	}
	return 0;
}

static inline int LoadBitmap(struct av7110 *av7110,
			     u16 dx, u16 dy, int inc, u8 __user * data)
{
	u16 format;
	int bpp;
	int i;
	int d, delta;
	u8 c;
	int ret;

	dprintk(4, "%p\n", av7110);

	format = bpp2bit[av7110->osdbpp[av7110->osdwin]];

	av7110->bmp_state = BMP_LOADING;
	if	(format == OSD_BITMAP8) {
		bpp=8; delta = 1;
	} else if (format == OSD_BITMAP4) {
		bpp=4; delta = 2;
	} else if (format == OSD_BITMAP2) {
		bpp=2; delta = 4;
	} else if (format == OSD_BITMAP1) {
		bpp=1; delta = 8;
	} else {
		av7110->bmp_state = BMP_NONE;
		return -EINVAL;
	}
	av7110->bmplen = ((dx * dy * bpp + 7) & ~7) / 8;
	av7110->bmpp = 0;
	if (av7110->bmplen > 32768) {
		av7110->bmp_state = BMP_NONE;
		return -EINVAL;
	}
	for (i = 0; i < dy; i++) {
		if (copy_from_user(av7110->bmpbuf + 1024 + i * dx, data + i * inc, dx)) {
			av7110->bmp_state = BMP_NONE;
			return -EINVAL;
		}
	}
	if (format != OSD_BITMAP8) {
		for (i = 0; i < dx * dy / delta; i++) {
			c = ((u8 *)av7110->bmpbuf)[1024 + i * delta + delta - 1];
			for (d = delta - 2; d >= 0; d--) {
				c |= (((u8 *)av7110->bmpbuf)[1024 + i * delta + d]
				      << ((delta - d - 1) * bpp));
				((u8 *)av7110->bmpbuf)[1024 + i] = c;
			}
		}
	}
	av7110->bmplen += 1024;
	dprintk(4, "av7110_fw_cmd: LoadBmp size %d\n", av7110->bmplen);
	ret = av7110_fw_cmd(av7110, COMTYPE_OSD, LoadBmp, 3, format, dx, dy);
	if (!ret)
		ret = WaitUntilBmpLoaded(av7110);
	return ret;
}



I will be surprised if OSD doesn't work on the AV7110 based .....


> The saa716x driver doesn't have a framebuffer either. Manu, is this driver
> just passing the captured video to the OSD? Or does it use some custom OSD
> commands? Just curious.


Well, the SAA716x is only the PCI Express interface. There is no video
capture involved in there with the STi7109. It is a full fledged DVB
STB SOC.

OSD is handled by the STi7109 on that STB.
http://www.st.com/stonline/products/literature/bd/11660/sti7109.pdf

Though it is not complete, that driver, it still does handle it,
through the firmware interface. These are the kind of devices that you
find on a DVB STB, i must say.

On a DVB STB, what happens is that you load a vendor specific firmware
on the SOC. The SOC is just issued the firmware commands, that's how a
STB works in principle. A DVB STB can be considered to have 2 outputs,
ie if you use it as a PC card, you can output the whole thing to your
PC monitor, or output it to a TV set. But in the case of the STB, you
have a TV output alone.

Regards,
Manu
