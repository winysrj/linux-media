Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm17-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.177]:27725 "EHLO
	nm17-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab3ERN5b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 May 2013 09:57:31 -0400
Message-ID: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com>
Date: Sat, 18 May 2013 06:57:30 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: 3.9.2 kernel - IR / em28xx_rc broken?
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi,

I have a PCTV 290e DVB2 adapter (em28xx, em28xx_dvb, em28xx_rc, cxd2820r), and I have just discovered that the IR remote control has stopped working with VDR when using a vanilla 3.9.2 kernel. Downgrading the kernel to 3.8.12 fixes things again. (Switching to my old DVB NOVA-T2 device fixes things too, although it cannot receive HDTV channels, of course).

Has anyone else noticed problems like this, please?

Thanks,
Chris

