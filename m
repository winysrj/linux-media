Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:64792 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaIFIFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Sep 2014 04:05:48 -0400
Received: by mail-lb0-f171.google.com with SMTP id 10so5618133lbg.2
        for <linux-media@vger.kernel.org>; Sat, 06 Sep 2014 01:05:46 -0700 (PDT)
MIME-Version: 1.0
From: Isaac Nickaein <nickaein.i@gmail.com>
Date: Sat, 6 Sep 2014 12:35:25 +0430
Message-ID: <CA+NJmkdrRWHvSwHQ248qHqaaGBu8N=4aY7XaPQ4WUeD3QrhjMA@mail.gmail.com>
Subject: Framerate is consistently divided by 2.5
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After patching the kernel, the rate that images are captured from the
camera reduce by a factor of 2.5. Here are a list of frame rates I
have tried followed by the resulted frame-rate:

10 fps --> 4 fps
15 fps --> 6 fps
25 fps --> 10 fps
30 fps --> 12 fps

Note that all of the rates are consistently divided by 2.5. This seems
to be a clocking issue to me. Is there any multipliers in V4L2 (or
UVC?) code in framerate calculation which depends on the hardware and
be cause of this?

Bests,
Isaac
