Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:35037 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932542AbeFPTaT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Jun 2018 15:30:19 -0400
MIME-Version: 1.0
Message-ID: <trinity-432fc36d-a67e-4ad0-907f-a0d43099c7b6-1529177417851@3c-app-gmx-bs45>
From: "Robert Schlabbach" <Robert.Schlabbach@gmx.net>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: em28xx: explicitly disable TS packet filter
Content-Type: text/plain; charset=UTF-8
Date: Sat, 16 Jun 2018 21:30:17 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, scrap that patch. I missed that the register is already explicitly set
in em28xx.h for the WinTV dualHD:

static const struct em28xx_reg_seq hauppauge_dualhd_dvb[] = {
	{EM2874_R80_GPIO_P0_CTRL,      0xff, 0xff,      0},
	{0x0d,                         0xff, 0xff,    200},
	{0x50,                         0x04, 0xff,    300},
	{EM2874_R80_GPIO_P0_CTRL,      0xbf, 0xff,    100}, /* demod 1 reset */
	{EM2874_R80_GPIO_P0_CTRL,      0xff, 0xff,    100},
	{EM2874_R80_GPIO_P0_CTRL,      0xdf, 0xff,    100}, /* demod 2 reset */
	{EM2874_R80_GPIO_P0_CTRL,      0xff, 0xff,    100},
	{EM2874_R5F_TS_ENABLE,         0x44, 0xff,     50},
	{EM2874_R5D_TS1_PKT_SIZE,      0x05, 0xff,     50},
	{EM2874_R5E_TS2_PKT_SIZE,      0x05, 0xff,     50},
	{-1,                             -1,   -1,     -1},
};

Is there a reason to enable discarding NULL packets? As I wrote before, my
application needs NULL packets, so I have to patch the driver to make it
work.

Should I submit a patch to change above initialization, or is there a better
solution, such as application control whether NULL packets are desired or not?

Best Regards,
-Robert Schlabbach
