Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:52980 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZBRMln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 07:41:43 -0500
Received: by rv-out-0506.google.com with SMTP id g37so2504273rvb.1
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2009 04:41:41 -0800 (PST)
To: linux-media@vger.kernel.org
Subject: Re: PVR x50 corrupts ATSC 115 streams
Content-Disposition: inline
From: Andreas <linuxdreas@dslextreme.com>
Date: Wed, 18 Feb 2009 04:41:40 -0800
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200902180441.40316.linuxdreas@dslextreme.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, 17. Februar 2009 21:19:45 schrieben Sie:
[...]
> So what does all of this indicate?  My original hunch was that it's a
> problem with the x50 hardware or driver (at least in combination with
> my motherboard).  I think I'm back to that conclusion.
>
> BTW, in my testing last night, I tried changing the PCI latency timer
> on the x50 cards.  I thought maybe it was holding off access to the
> 115 cards.  Changing that had no effect.

Just to let you know that you're not alone:
I had a simiilar problem with the combination of an AverMedia A180 and 
two Asus Falcon (they use the ivtv drivers and firmware). Whenever one 
of the Falcons was recording, I got blips and dropouts on the 
AverMedia. I chalked it off to a flaky mainboard and seperated the 
Falcons and the Avermedia in two different computers. A while later I 
got a new mainboard and additional ATSC tuner cards. As long as I had 
two of the ATSC tuner cards installed, the recordings were ok, except 
for an occasional dropout. But when I put a third ATSC tuner in, the 
recordings were barely watchable. After I put two ATSC tuners (2x 
Avermedia A180) in a different computer, they *all* are recording 
almost perfectly. Even a HVR-1600 card that I had dismissed as broken, 
delivers very good recordings in the other computer.

-- 
Gruﬂ
Andreas
