Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46093 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab2AOKzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 05:55:08 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RmNjv-0001gC-Gu
	for linux-media@vger.kernel.org; Sun, 15 Jan 2012 11:55:07 +0100
Received: from p54990898.dip0.t-ipconnect.de ([84.153.8.152])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 11:55:07 +0100
Received: from aurel by p54990898.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 11:55:07 +0100
To: linux-media@vger.kernel.org
From: Aurel <aurel@gmx.de>
Subject: White Balance Temperature
Date: Sun, 15 Jan 2012 10:16:30 +0000 (UTC)
Message-ID: <loom.20120115T110626-849@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there

my "Live! Cam Socialize HD VF0610", Device ID: 041e:4080, Driver: uvcvideo is
running perfectly on Fedora 16 Linux, except one thing:
When I try to switch on "White Balance Temperature, Auto" or just try to change
"White Balance Temperature" slider I get a failure message and it won't work.
All other controls, like contrast, gamma, etc. are working.
"v4l2-ctl -d 1 --set-ctrl=white_balance_temperature_auto=1" produces an error
message:
"VIDIOC_S_CTRL: failed: Input/output error
white_balance_temperature_auto: Input/output error"

As soon as I boot Windows (inside Linux out of a Virtual Box), start the camera
there and go back to Linux, I am able to adjust and switch on the White Balance
things in Linux.
"v4l2-ctl -d 1 --set-ctrl=white_balance_temperature_auto=1" working fine after
running the camera in Windows.

Everytime I switch off my computer or disconnect the camera, I have to run the
camera in Windows again, bevor I can adjust White Balance in Linux.

What can I do to get White Balance controls working in Linux, without having to
run the camera in Windows every time?
Is there a special command I have to send to the camera for initializing or so?

Best regards
Aurel

