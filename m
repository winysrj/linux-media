Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34147 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749Ab1KBPtn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 11:49:43 -0400
Received: by faao14 with SMTP id o14so539541faa.19
        for <linux-media@vger.kernel.org>; Wed, 02 Nov 2011 08:49:42 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Nov 2011 16:49:42 +0100
Message-ID: <CACKLOr2CvPofCcveh6ReYuEbAzsq+z4hu12nza_pTwSceYtRkQ@mail.gmail.com>
Subject: UVC with continuous video buffers.
From: javier Martin <javier.martin@vista-silicon.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
we have a system with a UVC camera connected to USB to acquire video
images and a hardware processor which needs continuous memory buffers
to process them.

I've been looking at the current version of UVC drivers and it seems
it allocates buffers using vmalloc_32() call:
http://lxr.linux.no/#linux+v3.1/drivers/media/video/uvc/uvc_queue.c#L135

I am interested to extend the driver to support contiguous memory
buffers and send it to mainline. What is the right way to achieve
this? Can anyone please point me to a video driver example where
continuous memory allocation is used?

Thank you.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
