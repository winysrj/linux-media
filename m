Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45975 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1LOHOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 02:14:25 -0500
Received: by wgbdr13 with SMTP id dr13so3474975wgb.1
        for <linux-media@vger.kernel.org>; Wed, 14 Dec 2011 23:14:24 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Dec 2011 15:14:24 +0800
Message-ID: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com>
Subject: Why is the Y12 support 12-bit grey formats at the CCDC input (Y12) is
 truncated to Y10 at the CCDC output?
From: James <angweiyang@gmail.com>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Jones <michael.jones@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm using an OMAP3530 board and a monochrome 12-bit grey sensor.

Can anyone enlighten me why is the 12-bit grey formats at the CCDC
input (Y12) is truncated to Y10 at the CCDC output?

I need to read the entire RAW 12-bit grey value from the CCDC to
memory and the data does not pass through other OMAP3ISP sub-devices.

I intend to use Laurent's yavta to capture the data to file to verify
its operation for the moment.

Can this 12-bit (Y12) raw capture be done?

Thank you in adv.

--
Regards,
James
