Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39999 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab1BPLQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 06:16:58 -0500
Received: by gxk9 with SMTP id 9so537014gxk.19
        for <linux-media@vger.kernel.org>; Wed, 16 Feb 2011 03:16:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinqsN0_q=Ln5A-7YW1bnUqX8=b2kU7tt_cNjk+d@mail.gmail.com>
References: <AANLkTinqsN0_q=Ln5A-7YW1bnUqX8=b2kU7tt_cNjk+d@mail.gmail.com>
Date: Wed, 16 Feb 2011 12:16:57 +0100
Message-ID: <AANLkTi=G2yS=OhS2fjfxcLETtfzh1PqQtMmPkTc2h+6c@mail.gmail.com>
Subject: Current soc-camera status.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
does currently soc-camera support using soc-camera host drivers with
non soc-camera sensors?
For instance, I would like to use soc-camera host driver
"mx2_camera.c" with non soc-camera sensor "tvp5150.c".

How much effort would it take to accomplish this goal?
Does it depends on conversion to v4l2-device API?
(http://www.open-technology.de/index.php?/pages/soc-camera.html)

Thank you.

--
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
