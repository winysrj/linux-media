Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41622 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2EWHzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 03:55:32 -0400
Received: by yenm10 with SMTP id m10so6190512yen.19
        for <linux-media@vger.kernel.org>; Wed, 23 May 2012 00:55:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205230938470.21980@axis700.grange>
References: <E1SUH8r-0005cc-3k@www.linuxtv.org>
	<Pine.LNX.4.64.1205160050270.25352@axis700.grange>
	<Pine.LNX.4.64.1205221918150.11851@axis700.grange>
	<CACKLOr0e7_UXSnq9GwRQx35eaGbZ1mwQMQ7-L8Riprz3rerzcw@mail.gmail.com>
	<Pine.LNX.4.64.1205230938470.21980@axis700.grange>
Date: Wed, 23 May 2012 09:55:31 +0200
Message-ID: <CACKLOr0vp5WM-ow2UETbXUcMOzKyBPJrbhX3b=RapS-VOoRT5w@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.5] [media] media: mx2_camera: Fix mbus format handling
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Is this the way to proceed or should I send a fix on top of it? This
>> patch is merged in 'for_v3.5', if Mauro reverts it and I send a new
>> version,  would it be also merged 'for_v3.5' or should it wait for
>> version 3.6?
>
> I think, it would be better to revert and re-do it for the following
> reason: since neither you nor me can test those pass-through cases, I
> think, it is easier to review patches and try to avoid regressions by
> looking at patches, that take you from a (presumably working) state A step
> by step to a state B, where each patch is seemingly correct, than by
> looking at a patch "a" that introduces a breakage and "b" that hopefully
> should fix it back.

All right. Then Mauro can revert this patch and I'll get my hands on a
new version whenever I have some spare time.
Sorry for the inconvenience.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
