Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44666 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaI3M4g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 08:56:36 -0400
Received: by mail-ig0-f177.google.com with SMTP id h3so5402985igd.16
        for <linux-media@vger.kernel.org>; Tue, 30 Sep 2014 05:56:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com>
References: <CAPueXH4puHLAPWpBS9gjGHd5AGb1gAxZqSggXDaGEJ3WYC_nMA@mail.gmail.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Tue, 30 Sep 2014 13:56:15 +0100
Message-ID: <CAPueXH73_yHoBhHKn+zroC6WViBmU1XH-B-FPVE2Q-V56bcBFQ@mail.gmail.com>
Subject: Re: uvcvideo fails on 3.16 and 3.17 kernels
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok,
so I've set a workaround in guvcview, it now uses the length filed if
bytesused is set to zero.
Anyway I think this violates the v4l2 api:
http://linuxtv.org/downloads/v4l-dvb-apis/buffer.html

bytesused - ..., Drivers must set this field when type refers to an
input stream, ...

without this value we have no way of knowing the exact frame size for
compressed formats.

And this was working in uvcvideo up until 3.16, I don't know how many
userspace apps rely on this value, but at least guvcview does, and
it's currently broken for uvcvideo devices in the latest kernels.

Regards,
Paulo

2014-09-30 9:50 GMT+01:00 Paulo Assis <pj.assis@gmail.com>:
> I referring to the following bug:
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1362358
>
> I've run some tests and after increasing verbosity for uvcvideo, I get:
> EOF on empty payload
>
> this seems consistent with the zero size frames returned by the driver.
> After VIDIOC_DQBUF | VIDIOC_QBUF, I get buf.bytesused=0
>
> Testing with an eye toy 2 (gspca), everything works fine, so this is
> definitly related to uvcvideo.
> This happens on all available formats (YUYV and MJPEG)
>
> Regards,
> Paulo
