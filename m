Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:47366 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941Ab2EGTxI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:53:08 -0400
Received: by qabj40 with SMTP id j40so4249046qab.1
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 12:53:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH9_wRP4+hzFpCdcZWmyyTZpTTFi+9wyTJxX2vPd+3r0QNhLkA@mail.gmail.com>
References: <CAH9_wRP4+hzFpCdcZWmyyTZpTTFi+9wyTJxX2vPd+3r0QNhLkA@mail.gmail.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 7 May 2012 14:52:47 -0500
Message-ID: <CAKnK67Qdte8qJ9L18OL2ft=YaF4YEAD-5rTP_bk7+_nQAn4u+A@mail.gmail.com>
Subject: Re: Android Support for camera?
To: Sriram V <vshrirama@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sriram,

On Mon, May 7, 2012 at 10:33 AM, Sriram V <vshrirama@gmail.com> wrote:
> Hi Sergio,
>  I understand that you are working on providing Android HAL Support
> for camera on omap4.

That's right. Not an active task at the moment, due to some other
stuff going on,
but yes, I have that task pending to do.

>  Were you able to capture and record?

Well, I'm trying to take these patches as a reference:

http://review.omapzoom.org/#/q/project:platform/hardware/ti/omap4xxx+topic:usbcamera,n,z

Which are implementing V4L2 camera support for the CameraHAL,
currently tested with
the UVC camera driver only.

So, I need to set the IOCTLs to program the omap4iss media controller
device, to set a
usecase, and start preview.

I'll keep you posted.

Regards,
Sergio

>
>  --
> Regards,
> Sriram
