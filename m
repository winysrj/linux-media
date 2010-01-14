Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57581 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab0ANKyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 05:54:12 -0500
Received: by fxm25 with SMTP id 25so337626fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 02:54:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f74f98341001140219x2636eeai4f3986a5fb04ce27@mail.gmail.com>
References: <f74f98341001132335p562b189duda4478cb62a7549a@mail.gmail.com>
	 <1a297b361001140115l3dc56802r985b0fd9f8f83c16@mail.gmail.com>
	 <f74f98341001140219x2636eeai4f3986a5fb04ce27@mail.gmail.com>
Date: Thu, 14 Jan 2010 14:54:10 +0400
Message-ID: <1a297b361001140254r5578607dn45838d35df4f1358@mail.gmail.com>
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
>
> And I investigated DirectFB, it seems if I provide a /dev/fb0 device
> the DirectFB can play around it and it will the base for upper GUI
> system.
> I also found DirectFB support V4L as it's surface source. So it will
> need some kernel module to control layer blending. It seems the thing
> I am looking for which implement the global display control.

With regards to the 7109 framebuffer. There is a DirectFB driver for
it in the STLinux distribution. (If you use the SOC as a STB) DirectFB
acts as a whole application/framework on the STB.

http://www.stlinux.com/download/updates.php?r=2.3;u=stlinux23-target-directfb14-multi-1.4.3.STM2009.12.11-2.src.rpm

Regards,
Manu
