Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43129 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1KFLRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 06:17:21 -0500
Received: by bke11 with SMTP id 11so2988797bke.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 03:17:19 -0800 (PST)
Message-ID: <4EB66CBE.6010107@gmail.com>
Date: Sun, 06 Nov 2011 12:17:18 +0100
From: Anders <aeriksson2@gmail.com>
MIME-Version: 1.0
To: lm <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Jarod Wilson <jarod@redhat.com>
Subject: EV_REP and imon
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've got an imon device (15c2:ffdc) on kernel 3.1.0-rc10 which, as far
as I can tell, is supposed to support ev_REP. However, irw shows a
steady flow of oneshot events when I press and hold  a button.

160 0 KEY_OK usb-15c2_ffdc-event-if00
160 0 KEY_OK usb-15c2_ffdc-event-if00
160 0 KEY_OK usb-15c2_ffdc-event-if00
160 0 KEY_OK usb-15c2_ffdc-event-if00
160 0 KEY_OK usb-15c2_ffdc-event-if00
160 0 KEY_OK usb-15c2_ffdc-event-if00
160 0 KEY_OK usb-15c2_ffdc-event-if00
160 0 KEY_OK usb-15c2_ffdc-event-if00
160 0 KEY_OK usb-15c2_ffdc-event-if00


I expect the 2nd column to show increasing ints. This causes lircmd's
ACCELERATOR config option not to kick in, which on large displays is a
must if you're to be able to move the mouse any significant distance.

Any ideas where to start to look?

-A
