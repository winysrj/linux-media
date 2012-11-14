Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:55069 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab2KNUaZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 15:30:25 -0500
Message-ID: <50A3FF56.3070703@users.sourceforge.net>
Date: Wed, 14 Nov 2012 21:30:14 +0100
From: Philippe Valembois - Phil <lephilousophe@users.sourceforge.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: greg@kroah.com
Subject: Hauppauge WinTV HVR 900 (M/R 65018/B3C0) doesn't work anymore since
 linux 3.6.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I have posted a bug report here :
https://bugzilla.kernel.org/show_bug.cgi?id=50361 and I have been told
to send it to the ML too.

The commit causing the bug has been pushed to kernel between linux-3.5
and linux-3.6.

Here is my bug summary :

The WinTV HVR900 DVB-T usb stick has stopped working in Linux 3.6.6.
The tuner fails at tuning and no DVB channel can be watched.

Reverting the commit 3de9e9624b36263618470c6e134f22eabf8f2551 fixes the
problem
and the tuner can tune again. It still seems there is some delay between the
moment when the USB stick is plugged and when it can tune : running
dvbscan too
fast makes the first channels tuning fail but after several seconds it tunes
perfectly.

Don't hesitate to ask me for additional debug.

Regards,
Philippe Valembois
