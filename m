Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:46841 "EHLO butterbrot.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750869AbdJASZC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Oct 2017 14:25:02 -0400
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by butterbrot.org (Postfix) with ESMTPS id 129B04AE030A
        for <linux-media@vger.kernel.org>; Sun,  1 Oct 2017 20:15:05 +0200 (CEST)
Date: Sun, 1 Oct 2017 20:15:04 +0200 (CEST)
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org
Subject: Regression on 4.10 with Logitech Quickcam Sphere
Message-ID: <alpine.DEB.2.10.1710012003100.18874@butterbrot>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,

I recently upgraded from a 4.4 kernel to 4.10, and found that my Logitech 
Quickcam Sphere now behaves differently.

More specifically, the pan/tilt controls do not work anymore - in fact, 
they are completely gone from "v4l2-ctl -L".

In dmesg, I'm getting these messages:

[   10.129984] uvcvideo: Found UVC 1.00 device <unnamed> (046d:0994)
[   10.162212] uvcvideo 1-5:1.0: Entity type for entity Extension 4 was 
not initialized!
[   10.162215] uvcvideo 1-5:1.0: Entity type for entity Extension 10 was 
not initialized!
[   10.162216] uvcvideo 1-5:1.0: Entity type for entity Extension 12 was 
not initialized!
[   10.162217] uvcvideo 1-5:1.0: Entity type for entity Extension 8 was 
not initialized!
[   10.162218] uvcvideo 1-5:1.0: Entity type for entity Extension 11 was 
not initialized!
[   10.162220] uvcvideo 1-5:1.0: Entity type for entity Extension 9 was 
not initialized!
[   10.162221] uvcvideo 1-5:1.0: Entity type for entity Processing 2 was 
not initialized!
[   10.162222] uvcvideo 1-5:1.0: Entity type for entity Extension 13 was 
not initialized!
[   10.162223] uvcvideo 1-5:1.0: Entity type for entity Camera 1 was not 
initialized!
[   10.162360] usbcore: registered new interface driver uvcvideo

I suspect that https://bugzilla.kernel.org/show_bug.cgi?id=111291#c10 may 
be related, and the new extension handling causes the pan/tilt controls to 
disappear.

Question now is, how to get them back?

Best, Florian
-- 
"_Nothing_ brightens up my morning. Coffee simply provides a shade of
grey just above the pitch-black of the infinite depths of the _abyss_."
