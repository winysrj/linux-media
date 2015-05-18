Return-Path: <ricardo.ribalda@gmail.com>
MIME-version: 1.0
In-reply-to: <20150518162657.031a86fc@recife.lan>
References: <1430726852-11715-1-git-send-email-ricardo.ribalda@gmail.com>
 <20150518162657.031a86fc@recife.lan>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 18 May 2015 21:31:49 +0200
Message-id: <CAPybu_3GMM0oz7Qcr6Nyp9WKFTp7y+H02Qq7vTj+UFq390AgFQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add support for V4L2_PIX_FMT_Y16_BE
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
 linux-media <linux-media@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
Content-type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>

Hello Mauro


it is here https://patchwork.linuxtv.org/patch/29669/


Thanks!

On Mon, May 18, 2015 at 9:26 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Mon,  4 May 2015 10:07:28 +0200
> Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> escreveu:
>
>> New pixel format type Y16_BE (16 bits greyscale big-endian).
>>
>> Once I get the fist feedback on this patch I will send the patches for
>> v4lconvert and qv4l2.
>
> Hmm...
>
>         Error: no ID for constraint linkend: V4L2-PIX-FMT-Y16-BE.
>
> Where's the documentation for this new format?
>
> Regards,
> Mauro
>
>
>>
>>
>> Thanks
>>
>> Ricardo Ribalda Delgado (4):
>>   media/vivid: Add support for Y16 format
>>   media/v4l2-core: Add support for V4L2_PIX_FMT_Y16_BE
>>   media/vivid: Add support for Y16_BE format
>>   media/vivid: Code cleanout
>>
>>  drivers/media/platform/vivid/vivid-tpg.c        | 20 ++++++++++++++++----
>>  drivers/media/platform/vivid/vivid-vid-common.c | 16 ++++++++++++++++
>>  drivers/media/v4l2-core/v4l2-ioctl.c            |  1 +
>>  include/uapi/linux/videodev2.h                  |  1 +
>>  4 files changed, 34 insertions(+), 4 deletions(-)
>>



-- 
Ricardo Ribalda
