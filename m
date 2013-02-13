Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51410 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933821Ab3BMMOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 07:14:06 -0500
Received: by mail-wg0-f51.google.com with SMTP id 8so891973wgl.6
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 04:14:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJRKTVoKYyJqP1mE=HTmm2jq9uoSkX9kf0HcMxz7F9wZnD1Y5w@mail.gmail.com>
References: <CAJRKTVoKYyJqP1mE=HTmm2jq9uoSkX9kf0HcMxz7F9wZnD1Y5w@mail.gmail.com>
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Wed, 13 Feb 2013 10:13:42 -0200
Message-ID: <CAJRKTVrDdwG=Am6KV0F5d3_ncRO_VcEkkYrBh3sGLrHCZuUvYw@mail.gmail.com>
Subject: Fwd: omap3isp IRQs
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please, help me :-)

I trying capture frames from my new sensor, ov5640. I already capture
images from a mt9p031 camera, but I have some problems with ov5640.

Someone can explain me what are the CCDC_VD0_IRQ and CCDC_VD1_IRQ?

In the mt9p031 sensor, I get all interrupts (including HS_VS_IRQ) and
I can capture frames.

In other sensor, I can't capture any frame. I get many HS_VS_IRQ only,
then yavta app hangs and I need stop it. Then I get CCDC stop timeout!
Is it necessary get CCDC_VD0_IRQ and CCDC_VD1_IRQ ever to capture a frame?

I think all signal from ov5640 sensor are ok. A question about it:
vsync may be in high level until the frame is transmitted? On my case
I see just a pulse of vsync before hsync pulses. Is it correct?

Thanks

Regards
Adriano Martins
