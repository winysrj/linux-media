Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61902 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab3AULU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 06:20:27 -0500
Received: by mail-wg0-f51.google.com with SMTP id 8so1886655wgl.6
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2013 03:20:23 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Jan 2013 12:20:23 +0100
Message-ID: <CACKLOr2t84A8OVXBd1AEcK2U7bg0ufKZ7gZQZemX8uznz3_bgg@mail.gmail.com>
Subject: [Q] Querying Y/Gb Average Level in a sensor.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
ov7670 and ov7675 sensors have the possibility of querying the average
value of the Y/Cb components of the image reading a register. This
could be useful for applications such as calise [1]. This program
grabs frames from a video camera, calculates the average brightness
and then adjusts screen's backlight accordingly.

If the user could query the value of this register t in cameras that
support it we could save a lot of processing effort.

The first idea that came into my mind was to define a new v4l2-ctrl
for this but I'm not sure if it is a common feature in other sensors.
Is it worth it to define a new v4l2-ctrl for this or should I use a
private ctrl instead?

Regards.

[1] http://calise.sourceforge.net/wordpress/

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
