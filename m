Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64085 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0DENV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 09:21:29 -0400
Received: by bwz1 with SMTP id 1so2782374bwz.21
        for <linux-media@vger.kernel.org>; Mon, 05 Apr 2010 06:21:28 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: STV6110 vs STV6110x
Date: Mon, 5 Apr 2010 15:21:25 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004051521.25997.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Igor,
hi Manu,

I'm currently adding support for a device based on STV0903+STV6110 frontend 
combination.

Early investigation have shown that for both devices there is a driver - now 
looking in more detail because I'm doing the actual coding, I'm finding out 
that there is actually 2 drivers for STV6110.

Which one I need to/can use for my hardware?

>From a first glance the actual code is identical (not the coding itself, but 
the things done). 

Please advise me what to do?

In any case thanks for your initial work on the stv090x-driver (+ stv6110x), 
Manu - it saves me a lot of time now for my project. Thanks to Igor for the 
stv6110. I'm sure one of those two is the right for me.

-- 
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
