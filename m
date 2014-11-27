Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:48292 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaK0Ryi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 12:54:38 -0500
Received: by mail-oi0-f50.google.com with SMTP id a141so3672196oig.37
        for <linux-media@vger.kernel.org>; Thu, 27 Nov 2014 09:54:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL8zT=hY8XeAb4j7-eBt3VJX-3Kzg6-BOajvSpxvgc+o3ZRuYQ@mail.gmail.com>
References: <CAL8zT=i+UZP7gpukW-cRe2M=xWW5Av9Mzd-FnnZAP5d+5J7Mzg@mail.gmail.com>
 <1417020934.3177.15.camel@pengutronix.de> <CAL8zT=hY8XeAb4j7-eBt3VJX-3Kzg6-BOajvSpxvgc+o3ZRuYQ@mail.gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Thu, 27 Nov 2014 18:54:22 +0100
Message-ID: <CAL8zT=gnkaD=9XbyBDcDh7D=w+rDSQPsi3dKfQ17ezvz6NZMCg@mail.gmail.com>
Subject: Re: i.MX6 CODA960 encoder
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Schwebel <r.schwebel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

2014-11-26 18:31 GMT+01:00 Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com>:
> Hi Philipp,
>
> Thanks for answering.
>
> 2014-11-26 17:55 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
>> Hi Jean-Michel,
>>
>> Am Mittwoch, den 26.11.2014, 14:33 +0100 schrieb Jean-Michel Hautbois:
>>> Hi,
>>>
>>> We are writing a gstreamer plugin to support CODA960 encoder on i.MX6,
>>> and it is not working so now trying to use v4l2-ctl for the moment.
>>> As I am asking about encoder, is there a way to make it support YUYV
>>> as input or is the firmware not able to do it ? I could not find a
>>> reference manual about that...
>>
>> The H.264 and MPEG-4 encoders support planar 4:2:0 subsampled formats
>> only: YU12, YV12, and chroma-interleaved NV12.
>> The JPEG encoder can also handle planar 4:2:2 subsampled frames, but
>> none of the interleaved (YUYV, UYVY, ...) variants.
>
> OK, just read this in TRM. This means that when the sensor is YUV
> 4:2:2 (say, a ADV76xx :)) it will have to be converted to NV12 in
> order to have it as input of the encoder...
>
>>> So back to the issue.
>>> $> cat /sys/class/video4linux/video0/name
>>> coda-encoder
>>> $> v4l2-ctl -d0 --list-formats
>>> ioctl: VIDIOC_ENUM_FMT
>>>     Index       : 0
>>>     Type        : Video Capture
>>>     Pixel Format: 'H264' (compressed)
>>>     Name        : H264 Encoded Stream
>>>
>>>     Index       : 1
>>>     Type        : Video Capture
>>>     Pixel Format: 'MPG4' (compressed)
>>>     Name        : MPEG4 Encoded Stream
>>>
>>> $> v4l2-ctl -d0 --list-formats-out
>>> ioctl: VIDIOC_ENUM_FMT
>>>     Index       : 0
>>>     Type        : Video Output
>>>     Pixel Format: 'YU12'
>>>     Name        : YUV 4:2:0 Planar, YCbCr
>>>
>>>     Index       : 1
>>>     Type        : Video Output
>>>     Pixel Format: 'YV12'
>>>     Name        : YUV 4:2:0 Planar, YCrCb
>>
>> Please apply all coda patches in the media-tree master branch first.
>> The output format list should include NV12 then.
>
> OK, applying right now.
>
>>> ==> First question, vid-cap should be related to the capture format,
>>> so YUV format in the encoder case, no ?
>>>
>>> $> v4l2-ctl -d0 --set-fmt-video-out=width=1280,height=720,pixelformat=YU12
>>> $> v4l2-ctl -d0 --stream-mmap --stream-out-mmap --stream-to x.raw
>>> unsupported pixelformat
>>> VIDIOC_STREAMON: failed: Invalid argument
>>
>> On v3.18-rc6 with the coda patches currently in the pipeline applied, I
>> get this:
>>
>> $ v4l2-ctl -d0 --set-fmt-video-out=width=1280,height=720,pixelformat=YU12
>> $ v4l2-ctl -d0 --stream-mmap --stream-out-mmap --stream-to x.raw
>> K>P>P>P>P>P>P>P>P>P>P>P>P>P>P>P>K>P>P>P>P>P>P>P>P>P>P>P>P>P>P>P>K>P>P>P>P>P>P 38 fps
>>> 38 fps

I don't have the same behaviour, but I may have missed a patch.
I have taken linux-next and rebased my work on it. I have some issues,
but nothing to be worried about, no link with coda.
I get the following :
$> v4l2-ctl -d0 --set-fmt-video-out=width=1280,height=720,pixelfor
$> v4l2-ctl -d0 --stream-mmap --stream-out-mmap --stream-to x.raw
[  173.705701] coda 2040000.vpu: CODA PIC_RUN timeout

JM
