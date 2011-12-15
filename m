Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46844 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab1LOQCu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 11:02:50 -0500
Received: by wgbdr13 with SMTP id dr13so4294042wgb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 08:02:49 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Dec 2011 17:02:47 +0100
Message-ID: <CACKLOr1qSpJXjyptUF3OEWR2b7XNoRdMjiVWzZ9gtuanfgJZDQ@mail.gmail.com>
Subject: Trying to figure out reasons for lost pictures in UVC driver.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
we are testing a logitech Webcam M/N: V-U0012 in the UVC tree (commit
ef7728797039bb6a20f22cc2d96ef72d9338cba0).
It is configured at 25fps, VGA.

We've observed that the following debugging message appears sometimes
"Frame complete (FID bit toggled).". Whenever this happens a v4l2
frame is lost (i.e. one sequence number has been skipped).

Is this behavior expected? What could we do to avoid frame loss?

Thank you.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
