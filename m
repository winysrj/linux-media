Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50467 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab1ILOun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 10:50:43 -0400
Received: by ywb5 with SMTP id 5so825210ywb.19
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2011 07:50:42 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Sep 2011 16:50:42 +0200
Message-ID: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
Subject: omap3isp as a wakeup source
From: Enrico <ebutera@users.berlios.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

While testing omap3isp+tvp5150 with latest Deepthy bt656 patches
(kernel 3.1rc4) i noticed that yavta hangs very often when grabbing
or, if not hanged, it grabs at max ~10fps.

Then i noticed that tapping on the (serial) console made it "unblock"
for some frames, so i thought it doesn't prevent the cpu to go
idle/sleep. Using the boot arg "nohlt" the problem disappear and it
grabs at a steady 25fps.

In the code i found a comment that says the camera can't be a wakeup
source but the camera powerdomain is instead used to decide to not go
idle, so at this point i think the camera powerdomain is not enabled
but i don't know how/where to enable it. Any ideas?

Thanks,

Enrico
