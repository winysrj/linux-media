Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64323 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab1BOCk0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 21:40:26 -0500
Received: by vxb37 with SMTP id 37so3126991vxb.19
        for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 18:40:26 -0800 (PST)
Subject: tm6010 based tv tuner uses the correct firmware? or the audio part
 problem
From: hendry zhang <hendry002@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 10:40:00 +0800
Message-ID: <1297737600.2272.11.camel@levono3000>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

hi,
My tm6010 based tv tuner is WINTV-HVR-900H, Model number is 66009, and
USB id is 2040:6600. According to the guide, I use the firmware
xc3028L-v36.fw from http://www.stefanringel.de/pub/xc3028L-v36.fw.
I'm sure this firmware is for Xceive products and is also suitable for
this product?
I'm able to get video but without audio. Is it the problem of the
firmware or the audio part of the module tm6000-alsa code ?

BTW, I have hcw66xxx.sys and hcwCP.ax from tuner installation cd-rom,
and how can I extract the firmware from the .sys file ?

