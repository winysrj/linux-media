Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44306 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1H3QgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 12:36:23 -0400
Received: by ywf7 with SMTP id 7so5727790ywf.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 09:36:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5D0E69.6020909@mlbassoc.com>
References: <4E56734A.3080001@mlbassoc.com>
	<4E5CEECC.6040804@mlbassoc.com>
	<4E5CF118.3050903@mlbassoc.com>
	<201108301620.09365.laurent.pinchart@ideasonboard.com>
	<4E5CFA0B.3010207@mlbassoc.com>
	<CA+2YH7sfhWz_ubLExnGKmyLKOVKGOXYOmH6a1Hoy8ssJeMQnWQ@mail.gmail.com>
	<4E5D0E69.6020909@mlbassoc.com>
Date: Tue, 30 Aug 2011 18:36:22 +0200
Message-ID: <CA+2YH7t1SFoJvYYxVCmZrgo-mpvQMMnEnvG5Ocdioe4T8d29Cw@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 6:23 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> Thanks, I'll give it a look.
>
> Your note says that /dev/video* is properly registered.  Does this
> mean that udev created them for you on boot as well?  If so, what
> version of udev are you using?  What's your root file system setup?
> n.b. I'm using an OpenEmbedded variant, Poky

They are not created on boot but when i modprobe omap3-isp (and
tvp5150 gets automatically loaded).

Udev is version 173 and i'm using Angstrom, an OpenEmbedded (core) variant too.

Anyway when developing the patch it happened to me too that i had
those subdev open errors, but if i remember correctly only for tvp5150
so it was something wrong in my code.

And if i continue to remember correctly it was because you had to set
the V4L2_SUBDEV_FL_HAS_DEVNODE after calling v4l2_i2c_subdev_init.
Seems nonsense but this is what i remember, actually this is what the
mt9v032 driver does.

Enrico
