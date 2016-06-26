Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36155 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbcFZU3Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2016 16:29:25 -0400
Received: by mail-wm0-f65.google.com with SMTP id c82so19577806wme.3
        for <linux-media@vger.kernel.org>; Sun, 26 Jun 2016 13:29:25 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: b.galvani@gmail.com, linux-media@vger.kernel.org,
	linux-amlogic@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
	carlo@caione.org, mchehab@kernel.org, tobetter@gmail.com
Subject: media: rc: fix Meson IR decoder
Date: Sun, 26 Jun 2016 22:29:04 +0200
Message-Id: <20160626202905.21817-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The meson-ir driver uses the wrong offset (at least according to
Amlogic's reference driver as well as the datasheets of the
Meson8b/S805 and GXBB/S905).
This means that we are getting incorrect durations (REG1_TIME_IV)
reported from the hardware.

This problem was also noticed by some people trying to use this on an
ODROID-C1 and ODROID-C2 - the workaround there (probably because the
datasheets were not publicy available yet at that time) was to switch
to ir_raw_event_store_edge (which leaves it up to the kernel to measure
the duration of a pulse). See [0] and [1] for the corresponding
patches.

Please note that I was only able to test this on an GXBB/S905 based
device (due to lack of other hardware).


[0] https://github.com/erdoukki/linux-amlogic-1/commit/969b2e2242fb14a13cb651f9a1cf771b599c958b
[1] http://forum.odroid.com/viewtopic.php?f=135&t=20504

