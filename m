Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:28664 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZE1Uo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 16:44:29 -0400
Received: by fg-out-1718.google.com with SMTP id 16so2096501fgg.17
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 13:44:30 -0700 (PDT)
Subject: [patch 0/4] Patches for dsbr100 radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 00:44:22 +0400
Message-Id: <1243543463.6713.40.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was discussion on maillist about lock/unlock_kernel, about
open/close functions and about radio->users counter. So, there are
patches arised from that discussion.

There is suspend/resume procedure fix in patch 4/4.

Here is description of patches:

[1/4] dsbr100: remove radio->users counter
Patch removes radio->users counter because it is not in use.

[2/4] dsbr100: remove usb_dsbr100_open/close calls
Patch removes usb_dsbr100_open and usb_dsbr100_close calls.
1. No need to start, set frequency, adjust parameters in open call.
2. This patch tackles issue with lock/unlock_kernel() in open call.
3. With this patch feature "Mute on exit?" in gnomeradio works.

[3/4] dsbr100: no need to pass curfreq value to dsbr100_setfreq()
Small cleanup of dsbr100_setfreq(). No need to pass radio->curfreq value
to this function.

[4/4] dsbr100: change radio->muted to radio->status, update
suspend/resume
Patch renames radio->muted to radio->status, add defines for that
variable, and fixes suspend/resume procedure. Radio->status set to
STOPPED in usb_dsbr100_probe because of removing open call.
Also, patch increases driver version.

Tested on i686 and x86_64 machines with gnomeradio, mplayer and kradio
under 2.6.30-rc7 kernel.

-- 
Best regards, Klimov Alexey

