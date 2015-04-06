Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35320 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbDFTCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2015 15:02:44 -0400
Received: by iggg4 with SMTP id g4so9205397igg.0
        for <linux-media@vger.kernel.org>; Mon, 06 Apr 2015 12:02:44 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Apr 2015 20:02:44 +0100
Message-ID: <CACWMfZ+cQE_SJVRRZResfX913HK4yNapxzxmM2YawSq__WO+0g@mail.gmail.com>
Subject: DVBSky S952 and PCTV 290e DVB-T2 Together
From: Adam Wisher <adamwisher792@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I wasn't sure if this was the right place for this query, but I just
wondered if anyone could help.

I'm trying to use both a dual tuner DVB-S2 DVBSky S952 card and a PCTV
290e DVB-T2 card on one machine running Ubuntu 14.04.

I heard that the DVBSky card is now supported in the main media_build
drivers, so when I did a fresh install of my computer a few days ago,
I tried this. The DVBSky card was recognised but TVHeadend was unable
to tune in any channels, reporting problems with setting DiSEqC and
LNB voltage.

This has led me back to using DVBSky's own release of V4L media_build
drivers from their site - http://www.dvbsky.net/Support_linux.html -
media_build-bst-14-141106. However, with the DVBSky drivers, I cannot
use my PCTV 290e DVB-T2 USB stick (it works fine under the regular
media_build). I get the following messages on dmesg:

[    2.074294] em28xx: disagrees about version of symbol
v4l2_i2c_new_subdev_board
[    2.074296] em28xx: Unknown symbol v4l2_i2c_new_subdev_board (err -22)
[    2.074351] em28xx: disagrees about version of symbol
tveeprom_hauppauge_analog
[    2.074352] em28xx: Unknown symbol tveeprom_hauppauge_analog (err -22)

The device does not show in DVB devices.

Does anybody know what this error is and how to fix it? I don't mind
using either regular drivers or the DVBSky ones as long as I can get
both my devices working.

Many thanks!
