Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:54703 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0BHHGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 02:06:15 -0500
Received: by fg-out-1718.google.com with SMTP id 22so48596fge.1
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2010 23:06:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002062055.02032.lukas.karas@centrum.cz>
References: <201002062055.02032.lukas.karas@centrum.cz>
Date: Mon, 8 Feb 2010 08:06:13 +0100
Message-ID: <62e5edd41002072306k5e3e7711v85d7699d99c8a2d8@mail.gmail.com>
Subject: Re: New kernel failed suspend ro ram with m5602 camera
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Karas?= <lukas.karas@centrum.cz>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/2/6 Lukáš Karas <lukas.karas@centrum.cz>:
> Hi Erik and others.
>
> New kernel (2.6.33-rc*) failed suspend to ram with camera m5602 on my machine.
> At first, I thought that it's a kernel bug (see
> http://bugzilla.kernel.org/show_bug.cgi?id=15189) - suspend failed after
> unload gspca_m5602 module too. But it is more probably a hardware bug, that we
> can evade with simple udev rule
>
> ATTR{idVendor}=="0402", ATTR{idProduct}=="5602", ATTR{power/wakeup}="disabled"
>
> I sent this rule to linux-hotplug (udev) mailing list, but answer is
> (http://www.spinics.net/lists/hotplug/msg03353.html) that this quirk should be
> in camera driver or should be send to udev from v4l developers...
>
> What do you thing about it? It is a general m5602 chip problem or only my
> hardware combination problem?
Hi Lukas,

I haven't experienced it so far, but I haven't tried the latest kernel.
I'll see if I can manage to reproduce the problem later this week.

> How we can put rule into udev userspace library?
> What I know, in v4l repository isn't directory with general v4l rules. This
> problem can affect many users with this hardware...

We should definitely try to solve this in the camera driver if possible.
Would it be possible for you to bisect the kernel tree to see what
commit that caused this regression?

Best regards,
Erik

>
> Best regards,
> Lukas
>
