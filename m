Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45137 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2KEKtC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 05:49:02 -0500
Message-ID: <50979998.8090809@gmail.com>
Date: Mon, 05 Nov 2012 11:48:56 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Andrey Gusakov <dron0gus@gmail.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
	In-Bae Jeong <kukyakya@gmail.com>,
	=?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: S3C244X/S3C64XX SoC camera host interface driver questions
References: <CAA11ShCpH7Z8eLok=MEh4bcSb6XjtVFfLQEYh2icUtYc-j5hEQ@mail.gmail.com> <5096C561.5000108@gmail.com> <CAA11ShCKFfdmd_ydxxCYo9Sv0VhgZW9kCk_F7LAQDg3mr5prrw@mail.gmail.com> <5096E8D7.4070304@gmail.com> <CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com>
In-Reply-To: <CAA11ShDinm7oU4azQYPMrNDsqWPqw+vJNFPpBDNzV=dTeUdZzw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/05/2012 10:44 AM, Andrey Gusakov wrote:
>>> But documentation on ov9650 is too conflicting and did not cover all
>>> registers used in driver.
>> Do you mean the OV9650 datasheet, version 1.3, from September 24, 2004 ?
> Yes. Also I have datasheet version 1.91 from January 28, 2005 and
> Application note 1.1 from 7 December 2004
> All can be found here [1].
> It seems there is different versions of sensor exist. With VER=0x50
> and 0x52. I have second one.

Hmm, in my case VER was 0x50. PID, VER = 0x96, 0x50. And this a default 
value
after reset according to the datasheet, ver. 1.3. For ver. 1.91 it is
PID, VER = 0x96, 0x52. Perhaps it just indicates ov9652 sensor ov9652.
Obviously I didn't test the driver with this one. Possibly the differences
can be resolved by comparing the documentation. Not sure if those are
significant and how much it makes sense to have single driver for both
sensor versions. I'll try to have a look at that.

...
>>>> Are you using media-ctl to configure resolution on the camif and sensor
>>>> subdev ?
>>>
>>> I'm using GStreamer:
>>> gst-launch -v v4l2src device=/dev/video0 \
>>>           ! video/x-raw-yuv, width=320, height=240 \
>>>           ! ffmpegcolorspace \
>>>           ! fbdevsink
>>
>>
>> AFAIR, in the s3c-camif-v3.5 branch there was a bug that the CAMIF input
>> resolution was not being properly set to what was reported by the sensor
>> driver (default s3c-camif resolution is 640 x 480). The s3c-camif driver
>> is supposed to get format from a sensor subdev and set it on the S3C-CAMIF
>> subdev, upon image sensor subdev registration. Please see function
>> camif_register_sensor() for details.
>>
>> The above issue should be fixed in this branch:
>> [1] http://git.linuxtv.org/snawrocki/media.git/shortlog/refs/heads/s3c-camif
>>
>> Also, it could be verified by setting the formats with media-ctl manually,
>> before running gst-launch, i.e.
>>
>> media-ctl --set-v4l2 '"OV9650":0 [fmt: YUYV2X8/320x240]'
>> media-ctl --set-v4l2 '"S3C-CAMIF":0 [fmt: YUYV2X8/320x240]'
>>
>> with your current kernel and the s3c-camif driver.
>> media-ctl was integrated in the OSELAS mini2440 BSP and probably is also
>> in the mini6440 version.
> Thanks. I'll try it. media-ctl from OpenEmbedded for some reason don't
> like this params.

As you might know the development version can be found here:
http://git.ideasonboard.org/?p=media-ctl.git;a=summary

There has been some change in the command line semantics recently.
...
>> I suggest you to update to the s3c-camif branch as above, it includes some
>> bug fixes. Sorry, I don't have exact patch for your issue handy right now.
> I just try this branch. No luck. Now it fails on __ov965x_set_params
> while writing some registers:
> ...
> OV9650: i2c_write: 0x40 : 0xc1. ret: 2
> OV9650: i2c_write: 0x29 : 0x3f. ret: 2
> OV9650: i2c_write: 0x0F : 0x43. ret: -6
> ...
> If I comment out exits on this errors, following writes in sensors
> give -6 (ENXIO) or -111 (ECONNREFUSED) erros. Seems sensors hung after
> write to some registers.

Hmm, that looks bad. The driver wasn't tested with VER=0x52 and there
must be some differences that need to get sorted out.

> [1] http://roboforum.ru/forum36/topic7835.html

--

Regards,
Sylwester
