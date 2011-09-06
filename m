Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42188 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1IFPHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 11:07:54 -0400
Received: by yie30 with SMTP id 30so4068426yie.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 08:07:54 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 6 Sep 2011 17:07:54 +0200
Message-ID: <CACKLOr3GB-WO2p3+pQPdyXsipvTGFuj-wATgv=FSxtge=_Pq2g@mail.gmail.com>
Subject: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
we are planning to add support to H.264/MPEG4 encoder inside the
i.MX27 to v4l2. It is mainly a hardware module that has the following
features:

- It needs two input buffers (current frame and previous frame).
- It produces a third buffer as output, containing the encoded frame,
and generates an IRQ when that happens.
- Previous three buffers need contiguous physical memory addresses and
probably some alignment requirements.
- It needs an external firmware to be loaded in another contiguous
memory buffer.

I would like to know what is your opinion on this, what v4l2 framework
should we use to deal with it, etc... I guess Multi Format Codec 5.1
driver for s5pv210 and exynos4 SoC is the most similar piece of HW
I've found so far but it has not yet entered mainline [1]

Note that mx2_camera driver is still using soc-camera framework and
soc-camera doesn't seem to be ready for integration with pad level API
[2]. For that reason we think we could develop this VPU driver
separately.

[1] http://www.spinics.net/lists/linux-media/msg35040.html
[2] http://www.open-technology.de/index.php?/categories/2-SoC-camera

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
