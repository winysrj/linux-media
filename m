Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:45517 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZIMDWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:22:33 -0400
Received: by qw-out-2122.google.com with SMTP id 9so721299qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 20:22:36 -0700 (PDT)
Message-ID: <4AAC656D.2070709@gmail.com>
Date: Sat, 12 Sep 2009 23:22:21 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 0/14] radio-mr800 patch series
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What follow is a series of patches to clean up the radio-mr800 driver. I
do _not_ have access to this device so these patches need to be tested.
These patches should apply to Mauro's git tree and against the 2.6.31
release kernel. The patches in this series are as follows:

01. radio-mr800: implement proper locking
02. radio-mr800: simplify video_device allocation
03. radio-mr800: simplify error paths in usb probe callback
04. radio-mr800: remove an unnecessary local variable
05. radio-mr800: simplify access to amradio_device
06. radio-mr800: simplify locking in ioctl callbacks
07. radio-mr800: remove device-removed indicator
08. radio-mr800: fix potential use after free
09. radio-mr800: remove device initialization from open/close
10. radio-mr800: ensure the radio is initialized to a consistent state
11. radio-mr800: fix behavior of set_radio function
12. radio-mr800: preserve radio state during suspend/resume
13. radio-mr800: simplify device warnings
14. radio-mr800: set radio frequency only upon success

The first 7 in this series are the same as those submitted in my last 
series and will not be resent. The remaining 7 patches in this series 
will be sent separately for review.

Regards,

David Ellingsworth
