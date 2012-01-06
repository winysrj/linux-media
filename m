Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54297 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883Ab2AFSYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 13:24:47 -0500
Received: by vcbfk14 with SMTP id fk14so1349684vcb.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:24:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201030214.22522.laurent.pinchart@ideasonboard.com>
References: <CAD6K1_OqO37F6omqDGHbn2D9pCBi9bmodQkmwNy_1WYyrksL6Q@mail.gmail.com>
	<201201030214.22522.laurent.pinchart@ideasonboard.com>
Date: Fri, 6 Jan 2012 23:54:46 +0530
Message-ID: <CAD6K1_N-88=1Dq1B8A_pXfB6T5ddXZR1tXr6oW+8waAdEsMj8A@mail.gmail.com>
Subject: Re: Multiple channel capture support in V4l2 layer
From: Dilip Mannil <mannil.dilip@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Laurent.Found similar type of discussion in this thread

http://www.mail-archive.com/linux-media@vger.kernel.org/msg38443.html


On Tue, Jan 3, 2012 at 6:44 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Dilip,
>
> On Friday 23 December 2011 19:57:22 Dilip Mannil wrote:
>> Hi,
>> I am trying to implement v4l2 slave driver for  ML86V76654  digital
>> video decoder that converts NTSC, PAL, SECAM analog video signals into
>> the YCbCr standard digital format. This codec takes 4 analog inputs(2
>> analog camera + 2 ext video in) and encodes in to digital(only one at
>> a time).
>>
>> The driver should be able to switch between capture channels upon
>> request from user space application.
>>
>> I couldn't find the support for multiple capture channels on a single
>> device in v4l2 layer. Please correct me if I am wrong.
>>
>> Ideally I want the v4l2 slave driver to have following feature.
>>
>> 1. ioctl that can be used to enumerate/get/set the  capture channels
>> on the video encoder.
>> 2. Able to capture video from the currently set capture channel and
>> pass to higher layers.
>>
>> Which is the best way to implement this support?
>
> VIDIOC_ENUMINPUT and VIDIOC_[GS]_INPUT seem to be what you're looking for.
>
> --
> Regards,
>
> Laurent Pinchart
