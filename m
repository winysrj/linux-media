Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64469 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab1CAO6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 09:58:25 -0500
Received: by iwn34 with SMTP id 34so4168655iwn.19
        for <linux-media@vger.kernel.org>; Tue, 01 Mar 2011 06:58:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTiktoL33cNPL8bF-p9iLSkFQmmCFJ1xK_1ydXyAD@mail.gmail.com>
References: <AANLkTincndvx154DXHgeNCnxe+KhtaH+tFUTfqXufFdp@mail.gmail.com>
	<AANLkTikVTgo48gfSUc9DyOhTCwSOuGS0gnjP6xTomor-@mail.gmail.com>
	<loom.20110224T142616-389@post.gmane.org>
	<AANLkTikFk73n87XHbfVVT37mDBd-3jMSBg1j=SKQJr8_@mail.gmail.com>
	<AANLkTiktoL33cNPL8bF-p9iLSkFQmmCFJ1xK_1ydXyAD@mail.gmail.com>
Date: Tue, 1 Mar 2011 15:58:24 +0100
Message-ID: <AANLkTi=sHnBPDAR5fSeq-EjG4nhe1ibnvfgUbWfeBVeD@mail.gmail.com>
Subject: Re: omap3-isp: can't register subdev for new sensor driver mt9t001
From: Bastian Hecht <hechtb@googlemail.com>
To: =?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

when you try to set a format in the pipeline, the sensor gets asked if
he can support this solution.

static int xxx_get_format(struct v4l2_subdev *subdev,
                              struct v4l2_subdev_fh *fh,
                              struct v4l2_subdev_format *fmt)
{

struct v4l2_mbus_framefmt format;

format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
format.width = MT9P031_MAX_WIDTH;
format.height = MT9P031_MAX_HEIGHT;
format.field = V4L2_FIELD_NONE;
format.colorspace = V4L2_COLORSPACE_SRGB;

fmt->format = format;
}


This is a simplified version of what you might need. Look the
mechanisms up in other code samples.
The function must be registered in
static struct v4l2_subdev_pad_ops framix_subdev_pad_ops = {
        .enum_mbus_code = mt9t001_enum_mbus_code,
        .enum_frame_size = mt9t001_enum_frame_size,
        .get_fmt = xxx_get_format,   <========================
        .set_fmt = mt9t001_set_format,
        .get_crop = mt9t001_get_crop,
        .set_crop = mt9t001_set_crop,
};


cheers,

 Bastian


2011/2/28 Loïc Akue <akue.loic@gmail.com>:
> Hi,
>
> Thank you for your reply,
>
> I finally solved my problem. My saa7113 driver code wasn't fully adapted to
> work with the new media framework.
> I tried to use the media-ctl and yavta programs for testing. Here are my
> logs :
>
> ************************************************************************************
> ./media-ctl -r -l '"saa7115 3-0024":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> Resetting all links to inactive
> Setting up link 16:0 -> 5:0 [1]
> Setting up link 5:1 -> 6:0 [1]
>
> root@cm-t35:~# ./media-ctl -f '"saa7115 3-0024":0[UYVY 720x480], "OMAP3 ISP
> CCDC":2[UYVY 720x480]'
> Setting up format UYVY 720x480 on pad saa7115 3-0024/0
> Unable to set format: Invalid argument (-22)
>
> ************************************************************************************
> Could it be due to a lack of information provided by my saa7113 driver, or
> is it due to a bad understanding of the media-ctl app.
>
> Regards
>
