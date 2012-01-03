Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50784 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2ACMZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 07:25:22 -0500
Received: by qadc12 with SMTP id c12so9815675qad.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 04:25:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F02BEC5.2080204@redhat.com>
References: <1325535901-15251-1-git-send-email-anarsoul@gmail.com> <4F02BEC5.2080204@redhat.com>
From: Vasily <anarsoul@gmail.com>
Date: Tue, 3 Jan 2012 15:25:01 +0300
Message-ID: <CA+E=qVcAtQbMeS4PjZ=h279ELjtFTowXSwL_VPq2xL296kvC2A@mail.gmail.com>
Subject: Re: [PATCH] libv4l: add hflip quirk for dealextreme cam sku #44507
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/1/3 Hans de Goede <hdegoede@redhat.com>:
> Hi,
>
>
> Thanks for the patch.
>
> I'm sorry, but a quick google shows that your cam has a usb id used by
> various generic
> cameras, including some microscopes, see:
> http://blog.littleimpact.de/index.php/2011/10/16/using-biolux-nv-on-ubuntu-linux/
>
> Enabling flipping on all these models because one has the sensor mounted
> upside down
> is the wrong thing to do.
>
> Instead you could add the following to your /etc/profile
> export LIBV4LCONTROL_FLAGS=3
>
> Note this will flip the image from all cameras you plug into your computer,
> or you
> can keep a patched libv4l around for yourself.

Thanks, I'm OK with it :)

> Regards,
>
> Hans
