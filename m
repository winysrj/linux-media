Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52143 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2DZUd0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 16:33:26 -0400
Received: by ghrr11 with SMTP id r11so16473ghr.19
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2012 13:33:25 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 17:33:25 -0300
Message-ID: <CALF0-+WaMObsjmpqF8akQwaizETsS2zg05yT5fcOTA5CT=wLJA@mail.gmail.com>
Subject: video capture driver interlacing question (easycap)
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

As you may know I'm re-writing from scratch the staging/easycap driver.

Finally, after digging through the labyrinthic staging/easycap code,
I've reached a point where I'm able to understand isoc packets.
Despite not having any documentation (I asked several times) from chip vendor,
I can separate packets in odd and even.

So, instead of receiving frames the device is sending me fields, right?

My doubt now is this:
* Do I have to *merge* this pair of fields for each frame, or can I
give it to v4l?
If affirmative: how should I *merge* them?
* Is this related to multiplanar buffers (should I use vb2_plane_addr)?

Currently, staging/easycap does some strange and complex conversion,
from the pair of fields buffers, to get a "frame" buffer (!) but I'm
not sure if it's the correct way to do it?

I guess I can keep staring at em28xx (together with vivi/uvc/pwc) driver,
but if someone cares to give me a small hint or point me at a small portion
of code I'll be grateful.

Thanks,
Ezequiel.
