Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64698 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3AVLkJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 06:40:09 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so4300667wgb.0
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 03:40:08 -0800 (PST)
MIME-Version: 1.0
From: Adriano Martins <adrianomatosmartins@gmail.com>
Date: Tue, 22 Jan 2013 09:39:47 -0200
Message-ID: <CAJRKTVq02L-aXCFzFMOU4V_MFTs=5r=CHOwP5ZnUZDxpVroGaw@mail.gmail.com>
Subject: yavta - Broken pipe
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent and all.

Can you explain me what means the message in yavta output:

"Unable to start streaming: Broken pipe (32)."

I'm using omap3isp driver on DM3730 processor and a ov5640 sensor. I
configured it as parallel mode, but I can't get data from /dev/video6
(OMAP3 ISP resizer output)

Thanks

Regards
Adriano Martins
