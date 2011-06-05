Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42470 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1FEONQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2011 10:13:16 -0400
Received: by wya21 with SMTP id 21so2264881wya.19
        for <linux-media@vger.kernel.org>; Sun, 05 Jun 2011 07:13:15 -0700 (PDT)
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: linux-media@vger.kernel.org, davoremard@gmail.com
Subject: Compro VideoMate Vista T750F support
Date: Sun, 5 Jun 2011 15:13:12 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106051513.12237.carlos@strangeworlds.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

>From looking over the linux-media mailing list, it seems that a patch was 
submitted in October last year to add support for this card and the remote:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg22911.html

There was then a follow up to that, asking for some minor fixes (mostly style) 
and a signed-off-by:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg23347.html

After that, it seems to have fallen down the back of the proverbial sofa, as I 
don't see this applied to Linus' tree.

Since I'm looking at buying one of these cards, I'm obviously quite interested 
in getting this patch upstream.

The remote bits would need to be rebased as the files have moved, but 
everything else looks like it should apply as-is.

Davor -> I'm happy to help with cleaning up this patch and resubmitting it 
again on your behalf, if you don't have the time to do this, but I would still 
need your Signed-off-by, as you are the originator of the original patch 
above.

-Carlos

(Please keep me CC'd on any replies, as I'm not subscribed to the list).
