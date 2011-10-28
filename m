Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1J1TL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 15:11:26 -0400
Received: by wyg36 with SMTP id 36so4220415wyg.19
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2011 12:11:25 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 28 Oct 2011 21:11:25 +0200
Message-ID: <CAL9G6WWQAQ4EM1TXmSfU+R+WcmD9Fhq1bu3LRmjO5vAKTXfv_Q@mail.gmail.com>
Subject: CONFIG_DVB_MAX_ADAPTERS
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello list, I want to increase the DVB adapter number, I make a little
search and I find this files:

# grep -r "CONFIG_DVB_MAX_ADAPTERS" .
./s2-liplianin-f5cd7d75370e/linux/drivers/media/dvb/dvb-core/dvbdev.h:#if
defined(CONFIG_DVB_MAX_ADAPTERS) && CONFIG_DVB_MAX_ADAPTERS > 0
./s2-liplianin-f5cd7d75370e/linux/drivers/media/dvb/dvb-core/dvbdev.h:
 #define DVB_MAX_ADAPTERS CONFIG_DVB_MAX_ADAPTERS
./s2-liplianin-f5cd7d75370e/v4l/dvbdev.h:#if
defined(CONFIG_DVB_MAX_ADAPTERS) && CONFIG_DVB_MAX_ADAPTERS > 0
./s2-liplianin-f5cd7d75370e/v4l/dvbdev.h:  #define DVB_MAX_ADAPTERS
CONFIG_DVB_MAX_ADAPTERS
./s2-liplianin-f5cd7d75370e/v4l/config-compat.h:#undef CONFIG_DVB_MAX_ADAPTERS
./s2-liplianin-f5cd7d75370e/v4l/config-compat.h:#undef
CONFIG_DVB_MAX_ADAPTERS_MODULE
./s2-liplianin-f5cd7d75370e/v4l/config-compat.h:#define
CONFIG_DVB_MAX_ADAPTERS 8
./s2-liplianin-f5cd7d75370e/v4l/.config:CONFIG_DVB_MAX_ADAPTERS=8
./s2-liplianin-f5cd7d75370e/v4l/.myconfig:CONFIG_DVB_MAX_ADAPTERS
                := 8
grep: warning: ./s2-liplianin-f5cd7d75370e/v4l/oss: recursive directory loop

Where is the best file to change it? I want to increase it to 16, is
it possible?

Thanks ans best regards.

-- 
Josu Lazkano
