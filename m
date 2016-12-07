Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34559 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932215AbcLGRrC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2016 12:47:02 -0500
Received: by mail-oi0-f45.google.com with SMTP id y198so425943895oia.1
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2016 09:47:02 -0800 (PST)
MIME-Version: 1.0
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Wed, 7 Dec 2016 12:47:01 -0500
Message-ID: <CAGoCfiz28eu9dT5qXr-qyh6V_-Xm91MkjzE88wtUJsQfLMNCwA@mail.gmail.com>
Subject: Regression: tvp5150 refactoring breaks all em28xx devices
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Javier, Mauro, Laurent,

I hope all is well with you.  Mauro, Laurent:  you guys going to
ELC/Portland in February?

Looks like the refactoring done to tvp5150 in January 2016 for
s_stream() to support some embedded platform caused breakage in the
30+ em28xx products that also use the chip.

Problem confirmed on both the Startech SVIDUSB2 board Steve Preston
was nice enough to ship me (after adding a board profile), as well as
on my original HVR-950 which has worked fine since 2008.

The implementation tramples the TVP5150_MISC_CTL register, blowing
into it a hard-coded value based on one of two scenarios, neither of
which matches what is expected by em28xx devices.  At least in the
case of NTSC, this results in chroma cycling.  This was also reported
by Alexandre-Xavier Labont=C3=A9-Lamoureux back in August, although in the
video below he's also having some other issue related to progressive
video because he's using an old gaming console as the source (i.e. pay
attention to the chroma effects in the top half of the video rather
than the fact that only the first field is being rendered).

https://youtu.be/WLlqJ7T3y4g

The s_stream implementation writes 0x09 or 0x0d into TVP5150_MISC_CTL
(overriding whatever was written by tvp5150_init_default and
tvp5150_selmux().  In fact, just as a test I was able to start up
video, see the corruption, and write the correct value back into the
register via v4l2-dbg in order to get it working again:

sudo v4l2-dbg --chip=3Dsubdev0 --set-register=3D0x03 0x6f

There's no easy fix for this without extending the driver to support
proper configuration of the output pin muxing, which it isn't clear to
me what the right approach is and I don't have the embedded hardware
platform that prompted the refactoring in order to do regression
testing anyway.

Feel free to take it upon yourselves to fix the regression you introduced.

Thanks,

Devin

--=20
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
