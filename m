Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57796 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab2KWRBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 12:01:16 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so3967435bkw.19
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2012 09:01:14 -0800 (PST)
Message-ID: <50AFABDA.9050309@googlemail.com>
Date: Fri, 23 Nov 2012 18:01:14 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Mysterious USB device ID change on Hauppauge HVR-900 (em28xx)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've got a Hauppauge HVR-900 (65008/A1C0) today. First,  the device
showed up as USB device 7640:edc1 (even after several unplug - replug
cycles), so I decided to add this VID:PID to the em28xx driver to see
what happens.
That worked fine, em2882/em2883, tuner xc2028/3028 etc. were detected
properly.
Later I noticed, that the device now shows up as 2040:6500, which is the
expected ID for this device.
Since then, the device maintains this ID. I also checked if Windows is
involved, but it shows up with the same ID there.

Does anyone have an idea what could have happened ???
I wonder if we should add this ID to the em28xx driver...

Regards,
Frank

