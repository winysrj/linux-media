Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49658 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1FJWDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 18:03:23 -0400
Received: by wwa36 with SMTP id 36so3194779wwa.1
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 15:03:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=jxNS6mrqwQC3w2UUtZ+pO9AodBw@mail.gmail.com>
References: <BANLkTi=jxNS6mrqwQC3w2UUtZ+pO9AodBw@mail.gmail.com>
Date: Fri, 10 Jun 2011 15:03:22 -0700
Message-ID: <BANLkTikPsfwuESYz-h=Nmxze8Qk3Nzcjyg@mail.gmail.com>
Subject: Re: ov519 unknown sensor
From: Paul Thomas <pthomas8589@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?ISO-8859-1?Q?Jean=2DFran=E7ois_Moine?= <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

It's not an unknown sensor, please ignore that subject line. That was
before I tested it with the latest v4l tree.

2011/6/10 Paul Thomas <pthomas8589@gmail.com>:
> Hello,
>
> I just wanted to let you know the Orion StarShoot Solar System Color
> Imaging Camera works with the latest v4l git tree
> (http://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git).
> It needs the "case 0xb1:" for the OV9600 that's not in Linus's tree
> yet. I didn't know what sensor was in the camera or weather it would
> work when I got it, so maybe this will help someone else who is
> googling that camera.
>
> thanks,
> Paul
>
