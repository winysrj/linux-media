Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39844 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0CHJVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Mar 2010 04:21:08 -0500
Received: by wwa36 with SMTP id 36so3135452wwa.19
        for <linux-media@vger.kernel.org>; Mon, 08 Mar 2010 01:21:05 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 8 Mar 2010 10:21:05 +0100
Message-ID: <eedb5541003080121t283d5549w3496573c8383703a@mail.gmail.com>
Subject: Question regarding soc-camera v4l subdev status.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I know that soc-camera has been recently added support for v4l subdev.
But, this does mean that now old encoder and sensor drivers like:
http://lxr.linux.no/#linux+v2.6.33/drivers/media/video/tvp5150.c
http://lxr.linux.no/#linux+v2.6.33/drivers/media/video/ov7670.c
are now compatible with host camera drivers?

Or, on the other hand, is the subdev support partially implemented right now?

Thank you.

--
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
