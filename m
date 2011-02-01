Return-path: <mchehab@pedra>
Received: from mailmxout5.mailmx.agnat.pl ([193.239.44.251]:39160 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751640Ab1BANSR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Feb 2011 08:18:17 -0500
Message-ID: <8026191608244DB98F002E983C866149@laptop2>
From: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <g.daniluk@elproma.com.pl>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
References: <1E539FC23CF84B8A91428720570395E0@laptop2> <Pine.LNX.4.64.1101241720001.17567@axis700.grange> <AD14536027B946D6B4504D4F43E352A5@laptop2> <Pine.LNX.4.64.1101262045550.3989@axis700.grange> <F95361ABAE1D4A70A10790A798004482@laptop2> <Pine.LNX.4.64.1101271809030.8916@axis700.grange>
Subject: Re: SoC Camera driver and TV decoder
Date: Tue, 1 Feb 2011 14:17:57 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

include/linux/errno.h:#define ENOIOCTLCMD       515     /* No ioctl command 
*/

What did I forget below?
static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
        .s_routing = tvp5150_s_routing,

        /* SoC camera: */
        .s_stream       = tvp5150_s_stream,
        .g_mbus_fmt     = tvp5150_g_fmt,
        .s_mbus_fmt     = tvp5150_s_fmt,
        .try_mbus_fmt   = tvp5150_try_fmt,
        .enum_mbus_fmt  = tvp5150_enum_fmt,
/*      .cropcap        = tw9910_cropcap,
        .g_crop         = tw9910_g_crop,
        .s_crop         = tw9910_s_crop,*/
};

cropcap/g_crop/s_cros are necessary? why and when?

thanks
Janusz


> On Thu, 27 Jan 2011, Janusz Uzycki wrote:
>
>> Hello Guennadi again.
>>
>> I patched tvp5150.c according to tw9910 driver (without real cropping
>> support yet).
>> Unfortunately I got the messages:
>> camera 0-0: Probing 0-0
>> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to 
>> camera 0
>> tvp5150 0-005d: chip found @ 0xba (i2c-sh_mobile)
>> tvp5150 0-005d: tvp5150am1 detected.
>
> This looks good - i2c to the chip works!
>
>> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from 
>> camera 0
>> camera: probe of 0-0 failed with error -515
>
> This is strange, however - error code 515... Can you try to find out where
> it is coming from?
>
> Thanks
> Guennadi
>

