Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61594 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1AVRWp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 12:22:45 -0500
Received: by wwa36 with SMTP id 36so2975864wwa.1
        for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 09:22:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=5JiLiD+jcB-6X48aNOEhwWVoM+_1fEEzE7WR+@mail.gmail.com>
References: <AANLkTi=5JiLiD+jcB-6X48aNOEhwWVoM+_1fEEzE7WR+@mail.gmail.com>
Date: Sat, 22 Jan 2011 15:22:43 -0200
Message-ID: <AANLkTimaP62dFjsT3MvCvTBk9nRh4kYUu--brsCzxqcL@mail.gmail.com>
Subject: Re: camera on Freescale i.MX51
From: Fabio Estevam <festevam@gmail.com>
To: Claudiu Covaci <claudiu.covaci@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Claudiu,

On Tue, Jan 18, 2011 at 11:37 AM, Claudiu Covaci
<claudiu.covaci@gmail.com> wrote:
> Hi,
>
> I'm have trouble receiving a video stream on the Freescale i.MX51
> processor. I've tried everything I could think, so I'm trying my luck
> here.
>
> I'm using a 2.6.31 kernel with some modifications: the camera capture
> driver [1] and the IPU (Image Processing Unit) driver [2] from the
> Freescale BSP 2010.11.
>
> I'm at a point where I can open the /dev/video0 device and can (at
> least try to) read frames, but it fails at dequeueing the video
> buffers (VIDIOC_DQBUF) with the message:
> <3>ERROR: v4l2 capture: mxc_v4l_dqueue timeout enc_counter 0
> Unable to dequeue buffer (62).
>
> - I've double-checked the IPU registers and they seem properly
> configured, but I don't get any interrupt (at end-of-frame).
> - The relevant IOMUX pins are also configured.
> - the video signal appears at the i.MX pins (so it gets there)
> - I've also tried activating the internal picture generator, but still
> nothing happens.
>
> Is there anything I overlooked? Is there a way to find out where the
> problem is? Any hints will be greatly appreciated.

These are the steps I do on a MX51EVK connected to the expansion board
with a OV3640 camera:

modprobe mxc_v4l2_capture

modprobe ov3640_camera

gst-launch mfw_v4lsrc ! mfw_v4lsink

Then I got the camera preview in the LCD/DVI output.

Regards,

Fabio Estevam
