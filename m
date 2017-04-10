Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:39391 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753206AbdDJKgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 06:36:08 -0400
Subject: Re: [PATCH] dev-capture.rst/dev-output.rst: video standards ioctls
 are optional
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <8e21fc74-64a8-8767-8bcf-4b954d4e22c1@xs4all.nl>
 <20170410070940.7f55c1b1@vento.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <19667636-a0a2-1793-4638-af0a25a9198a@xs4all.nl>
Date: Mon, 10 Apr 2017 12:36:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170410070940.7f55c1b1@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2017 12:21 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 29 Mar 2017 09:56:47 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> The documentation for video capture and output devices claims that the video standard
>> ioctls are required. This is not the case, they are only required for PAL/NTSC/SECAM
>> type inputs and outputs. Sensors do not implement this at all and e.g. HDMI inputs
>> implement the DV Timings ioctls.
>>
>> Just drop the mention of 'video standard' ioctls.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This is an API change that has the potential of breaking userspace.
> 
> In the past, several applications were failing if VIDIOC_ENUMSTD ioctl is
> not implemented. So, I remember we had this discussion before, but I don't
> remember the dirty details anymore.
> 
> Yet, looking at the code, it seems that we ended by making VIDIOC_ENUMSTD
> mandatory and implemented at the core. So, V4L2 core will make this
> ioctl available for all drivers. The core implementattion will, however, 
> return -ENODATA  if the driver doesn't set video_device.tvnorms, indicating
> that standard video timings are not supported.
> 
> So, instead of the enclosed patch, the documentation should mention the
> standard ioctls, saying that G_STD/S_STD are optional, and ENUMSTD is
> mandatory. 

I don't think so. In v4l2-dev.c ENUMSTD is only enabled if the driver supports
the s_std ioctl:

        if (is_vid || is_vbi || is_tch) {
                /* ioctls valid for video or vbi */
                if (ops->vidioc_s_std)
                        set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);

And in case you are wondering: if you have two inputs, one SDTV and one HDTV, then
you have both s_std and s_dv_timings ioctls and if you switch to the HDTV input,
then tvnorms is set to 0, causing ENUMSTD to return -ENODATA. If you switch back,
then the driver will fill in tvnorms to something non-0.

Regards,

	Hans

> 
> We could include a note about it may return -ENODATA, although the ENUMSTD
> documentation already states that it returns -ENODATA:
> 	https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/vidioc-enumstd.html
> 
> Regards,
> Mauro
> 
>> ---
>> diff --git a/Documentation/media/uapi/v4l/dev-capture.rst b/Documentation/media/uapi/v4l/dev-capture.rst
>> index 32b32055d070..4218742ab5d9 100644
>> --- a/Documentation/media/uapi/v4l/dev-capture.rst
>> +++ b/Documentation/media/uapi/v4l/dev-capture.rst
>> @@ -42,8 +42,8 @@ Video capture devices shall support :ref:`audio input <audio>`,
>>  :ref:`tuner`, :ref:`controls <control>`,
>>  :ref:`cropping and scaling <crop>` and
>>  :ref:`streaming parameter <streaming-par>` ioctls as needed. The
>> -:ref:`video input <video>` and :ref:`video standard <standard>`
>> -ioctls must be supported by all video capture devices.
>> +:ref:`video input <video>` ioctls must be supported by all video
>> +capture devices.
>>
>>
>>  Image Format Negotiation
>> diff --git a/Documentation/media/uapi/v4l/dev-output.rst b/Documentation/media/uapi/v4l/dev-output.rst
>> index 25ae8ec96fdf..342eb4931f5c 100644
>> --- a/Documentation/media/uapi/v4l/dev-output.rst
>> +++ b/Documentation/media/uapi/v4l/dev-output.rst
>> @@ -40,8 +40,8 @@ Video output devices shall support :ref:`audio output <audio>`,
>>  :ref:`modulator <tuner>`, :ref:`controls <control>`,
>>  :ref:`cropping and scaling <crop>` and
>>  :ref:`streaming parameter <streaming-par>` ioctls as needed. The
>> -:ref:`video output <video>` and :ref:`video standard <standard>`
>> -ioctls must be supported by all video output devices.
>> +:ref:`video output <video>` ioctls must be supported by all video
>> +output devices.
>>
>>
>>  Image Format Negotiation
> 
> 
> 
> Thanks,
> Mauro
> 
