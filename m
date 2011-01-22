Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41402 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1AVK2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 05:28:34 -0500
Received: by yxt3 with SMTP id 3so785762yxt.19
        for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 02:28:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=5JiLiD+jcB-6X48aNOEhwWVoM+_1fEEzE7WR+@mail.gmail.com>
References: <AANLkTi=5JiLiD+jcB-6X48aNOEhwWVoM+_1fEEzE7WR+@mail.gmail.com>
Date: Sat, 22 Jan 2011 12:28:33 +0200
Message-ID: <AANLkTikE3cNBu5QjdAxXhV9v7HhHziyyYBgfq-ZPohCj@mail.gmail.com>
Subject: Re: camera on Freescale i.MX51
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Claudiu Covaci <claudiu.covaci@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jan 18, 2011 at 3:37 PM, Claudiu Covaci
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
>
> Thanks!
> Claudiu
>
> [1] http://opensource.freescale.com/git?p=imx/linux-2.6-imx.git;a=blob;f=drivers/media/video/mxc/capture/mxc_v4l2_capture.c;h=8133d202304eea22e94bbd8eaaa215002b2dc675;hb=0fae922f451a5bde63595a2e0c2cd7079f083440
>
> [2] http://opensource.freescale.com/git?p=imx/linux-2.6-imx.git;a=tree;f=drivers/mxc/ipu3;h=288c21f88aa650d16d843dccec2b04ba9f1462f7;hb=0fae922f451a5bde63595a2e0c2cd7079f083440
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Hans, Jean, Mauro:
No ideea to help Claudiu ?
