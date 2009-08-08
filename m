Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51190 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZHHRpc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 13:45:32 -0400
Received: by ewy10 with SMTP id 10so2174216ewy.37
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2009 10:45:32 -0700 (PDT)
Subject: [patch review 0/6] radio-mr800
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 08 Aug 2009 21:44:18 +0400
Message-Id: <1249753458.15160.234.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

Here are some radio-mr800 patches against hg v4l-dvb tree.
Patchset removes lock_kernel calls, fixes suspend/resume, cleanups,
introduces status variable and redesigns users counter in driver.

As usual comments, remarks, ideas are more than welcome :)

[1/6] radio-mr800: remove redundant lock/unlock_kernel
[2/6] radio-mr800: cleanup of usb_amradio_open/close
[3/6] radio-mr800: no need to pass curfreq value to amradio_setfreq()
[4/6] radio-mr800: make radio->status variable
[5/6] radio-mr800: update suspend/resume procedure
[6/6] radio-mr800: redesign radio->users counter


-- 
Best regards, Klimov Alexey

