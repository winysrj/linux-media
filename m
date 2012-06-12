Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44511 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2FLWTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 18:19:35 -0400
Received: by wibhn6 with SMTP id hn6so4632019wib.1
        for <linux-media@vger.kernel.org>; Tue, 12 Jun 2012 15:19:34 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Cc: sven.pilz@gmail.com, soeren.moch@ims.uni-hannover.de
Subject: [PATCH 0/3] em28xx: Improve compatiblity with the Terratec Cinergy HTC Stick HD
Date: Wed, 13 Jun 2012 00:19:25 +0200
Message-Id: <1339539568-7725-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this patch-set tries to improve compatibility with the Terratec Cinergy HTC Stick HD.
It includes a completely new GPIO and analog decoder setup, which is now
similar to what the driver on windows does.

I also disabled LNA by default as it's what the windows-driver seems to do.
This should also fix DVB-C.

Thanks to Antti Palosaari and Devin Heitmueller for their help!

@Soren, Sven: could you please try out this patch-set and give feedback?

The patches were written against the staging/for_v3.5 branch of media_tree.git.
They depend upon my previous patch-set (see [0] and [1]):
"em28xx: Remote control support for another board".

Patch 2 and 3 should also apply against linux 3.4.
On 3.4 an additional patch from Antti Palosaari is also required, see [2].
The drxk-firmware (required for DVB-T) can be downloaded from [3] (if patch
1 does not work on 3.4).

Regards,
Martin

[0] http://patchwork.linuxtv.org/patch/11544/
[1] http://patchwork.linuxtv.org/patch/11548/
[2] http://patchwork.linuxtv.org/patch/11310/
[3] http://filebin.ca/55M5bF38USL/dvb-usb-terratec-htc-stick-drxk.fw


