Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42767 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJWCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 18:02:05 -0400
Received: by wya21 with SMTP id 21so2154064wya.19
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 15:02:04 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Jun 2011 15:02:03 -0700
Message-ID: <BANLkTi=jxNS6mrqwQC3w2UUtZ+pO9AodBw@mail.gmail.com>
Subject: ov519 unknown sensor
From: Paul Thomas <pthomas8589@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?ISO-8859-1?Q?Jean=2DFran=E7ois_Moine?= <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I just wanted to let you know the Orion StarShoot Solar System Color
Imaging Camera works with the latest v4l git tree
(http://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git).
It needs the "case 0xb1:" for the OV9600 that's not in Linus's tree
yet. I didn't know what sensor was in the camera or weather it would
work when I got it, so maybe this will help someone else who is
googling that camera.

thanks,
Paul
