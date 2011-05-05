Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59317 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab1EEK02 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 06:26:28 -0400
Received: by iyb14 with SMTP id 14so1686350iyb.19
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 03:26:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1105051215340.29735@axis700.grange>
References: <BANLkTinRqcFj5doua4r6d-vwPAym=JGvDw@mail.gmail.com>
	<Pine.LNX.4.64.1105051215340.29735@axis700.grange>
Date: Thu, 5 May 2011 12:26:27 +0200
Message-ID: <BANLkTintFLcWMN460H7xZiadZax5EO7-YA@mail.gmail.com>
Subject: Re: omap3isp clock problems on Beagleboard xM.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thank you two guys for your answer.

> I don't remember exactly, but it didn't work without this patch. I know it
> is not clean and shouldn't be needed, so, if now it works also without it
> - perfect! You can start, stop, and restart streaming without this patch
> and it all works? Then certainly it should be dropped.

No, sorry, what I meant is although, according to my debugging results
the patch shouldn't be needed, it still does not work without it.

I'll try to track down the issue and I'll work on a fix myself.



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
