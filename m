Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:42075 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab0ANKcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 05:32:47 -0500
Received: by fxm25 with SMTP id 25so321140fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 02:32:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f74f98341001140219x2636eeai4f3986a5fb04ce27@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
	 <f74f98341001140219x2636eeai4f3986a5fb04ce27@mail.gmail.com>
Date: Thu, 14 Jan 2010 14:32:45 +0400
Message-ID: <1a297b361001140232w1c5fa384k481c9a50beb97c0a@mail.gmail.com>
Subject: Re: About driver architecture
From: Manu Abraham <abraham.manu@gmail.com>
To: Michael Qiu <fallwind@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 2:19 PM, Michael Qiu <fallwind@gmail.com> wrote:
> Thanks a lot for you advise.
>
> Before I read the source code you mentioned, I guess I should write a
> driver modules which provide /dev/dvb/adapter/audio, video, frontend,
> ca....,  and also provide a /dev/fbx for OSD layer. But in source
> level, all display HW relative functions would probably in a same
> module, because they are operation on same block of H/W.
> But I still don't know where to put my global display control
> interface, for instance, the function to control which layer open and
> close, the alpha values used for each layer...


Yes, in which case you will need a frame buffer to handle your global display.


> And I investigated DirectFB, it seems if I provide a /dev/fb0 device
> the DirectFB can play around it and it will the base for upper GUI
> system.
> I also found DirectFB support V4L as it's surface source. So it will
> need some kernel module to control layer blending. It seems the thing
> I am looking for which implement the global display control.


Direct FB has it's own drivers, at a userspace level,
http://directfb.org/index.php?path=Support%2FGraphics
http://directfb.org/index.php?path=Support%2FMedia

Directfb and linuxtv parted ways a long time back, where the original
goal was to make a x86 based DVB STB at the parent organization at
that time then Convergence.

Regards,
Manu
