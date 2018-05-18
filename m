Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:36974 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751413AbeERPhF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 11:37:05 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w4IFT0l9024998
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 16:37:03 +0100
Received: from mail-pf0-f197.google.com (mail-pf0-f197.google.com [209.85.192.197])
        by mx08-00252a01.pphosted.com with ESMTP id 2hwmrg38jm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 16:37:03 +0100
Received: by mail-pf0-f197.google.com with SMTP id c4-v6so4922917pfg.22
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 08:37:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180518120522.79b36f77@vento.lan>
References: <20180517160708.74811cfb@vento.lan> <1731086.UqanYK9fHS@avalon> <20180518120522.79b36f77@vento.lan>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 18 May 2018 16:37:01 +0100
Message-ID: <CAAoAYcN-9zrbLWZULZM9emF5G8=stssQy04QgrguSYi4g6dQxw@mail.gmail.com>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based cameras
 on generic apps
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18 May 2018 at 16:05, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> Em Fri, 18 May 2018 15:27:24 +0300
<snip>
>>
>> > There, instead of an USB camera, the hardware is equipped with a
>> > MC-based ISP, connected to its camera. Currently, despite having
>> > a Kernel driver for it, the camera doesn't work with any
>> > userspace application.
>> >
>> > I'm also aware of other projects that are considering the usage of
>> > mc-based devices for non-dedicated hardware.
>>
>> What are those projects ?
>
> Well, cheap ARM-based hardware like RPi3 already has this issue: they
> have an ISP (or some GPU firmware meant to emulate an ISP). While
> those hardware could have multiple sensors, typically they have just
> one.

Slight hijack, but a closely linked issue for the Pi.
The way I understand the issue of V4L2 / MC on Pi is a more
fundamental mismatch in architecture. Please correct me if I'm wrong
here.

The Pi CSI2 receiver peripheral always writes the incoming data to
SDRAM, and the ISP is then a memory to memory device.

V4L2 subdevices are not dma controllers and therefore have no buffers
allocated to them. So to support the full complexity of the pipeline
in V4L2 requires that something somewhere would have to be dequeuing
the buffers from the CSI receiver V4L2 device and queuing them to the
input of a (theoretical) ISP M2M V4L2 device, and returning them once
processed. The application only cares about the output of the ISP M2M
device.

So I guess my question is whether there is a sane mechanism to remove
that buffer allocation and handling from the app? Without it we are
pretty much forced to hide bigger blobs of functionality to even
vaguely fit in with V4L2.

I'm at the point where it shouldn't be a huge amount of work to create
at least a basic ISP V4L2 M2M device, but I'm not planning on doing it
if it pushes the above buffer handling onto the app because it simply
won't get used beyond demo apps. The likes of Cheese, Scratch, etc,
just won't do it.


To avoid ambiguity, the Pi has a hardware ISP block. There are other
SoCs that use either GPU code or a DSP to implement their ISP.

  Dave
