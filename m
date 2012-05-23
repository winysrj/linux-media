Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35347 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab2EWHd0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 03:33:26 -0400
Received: by yhmm54 with SMTP id m54so6241583yhm.19
        for <linux-media@vger.kernel.org>; Wed, 23 May 2012 00:33:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205221918150.11851@axis700.grange>
References: <E1SUH8r-0005cc-3k@www.linuxtv.org>
	<Pine.LNX.4.64.1205160050270.25352@axis700.grange>
	<Pine.LNX.4.64.1205221918150.11851@axis700.grange>
Date: Wed, 23 May 2012 09:33:25 +0200
Message-ID: <CACKLOr0e7_UXSnq9GwRQx35eaGbZ1mwQMQ7-L8Riprz3rerzcw@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.5] [media] media: mx2_camera: Fix mbus format handling
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi, Mauro,

>> Looks like I have missed this patch, unfortunately, it hasn't been cc'ed
>> to me. It would have been better to merge it via my soc-camera tree, also
>> because with this merge window there are a couple more changes, that
>> affect the generic soc-camera API and the mx2-camera driver in particular.
>> So far I don't see anything, what could break here, but if something does
>> - we know who will have to fix it;-)

Sorry about that. I usually send patches for mx2-camera to you as well
but this time I missed it. The fact that your name does not appear
when executing 'get_mantainer' doesn't help me to remember either.

>
> I'm afraid, I get an impression, that your patch breaks support for the
> pass-through mode in the mx2-camera driver. Where previously not natively
> supported formats would be just read in by the camera interface without
> any conversion (see the first entry in the mx27_emma_prp_table[] array),
> you now return an error in mx2_camera_set_bus_param().

I think you are right. It seems I should provide a default for other
mbus formats instead of returning an error. It's good you noticed
because I haven't got any device to test this pass-through mode, so I
try my best to add new functionallity without breaking it.

>If I'm write, I'll ask Mauro to revert your patch. Please correct me if I'm mistaken.

Is this the way to proceed or should I send a fix on top of it? This
patch is merged in 'for_v3.5', if Mauro reverts it and I send a new
version,  would it be also merged 'for_v3.5' or should it wait for
version 3.6?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
