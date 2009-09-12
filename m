Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:20584 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbZILOsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:48:52 -0400
Received: by qw-out-2122.google.com with SMTP id 9so632867qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:48:56 -0700 (PDT)
Message-ID: <4AABB4C5.5020507@gmail.com>
Date: Sat, 12 Sep 2009 10:48:37 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 0/10] radio-mr800 patch series
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What follow is a series of patches to clean up the radio-mr800 driver. I 
do _not_ have access to this device so these patches need to be tested. 
These patches should apply to Mauro's git tree and against the 2.6.31 
release kernel. The patches in this series are as follows:

1. radio-mr800: implement proper locking
2. radio-mr800: simplify video_device allocation
3. radio-mr800: simplify error paths in usb probe callback
4. radio-mr800: remove an unnecessary local variable
5. radio-mr800: simplify access to amradio_device
6. radio-mr800: simplify locking in ioctl callbacks
7. radio-mr800: remove device-removed indicator
8. radio-mr800: turn radio on during first open and off during last close
9. radio-mr800: preserve radio-state during suspend/resume
10. radio-mr800: fix potential use after free

Each individual patch will follow in a separate email.

Regards,

David Ellingsworth
