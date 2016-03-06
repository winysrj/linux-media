Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36204 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbcCFNux (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:50:53 -0500
Received: by mail-wm0-f67.google.com with SMTP id l68so6409306wml.3
        for <linux-media@vger.kernel.org>; Sun, 06 Mar 2016 05:50:53 -0800 (PST)
Date: Sun, 6 Mar 2016 15:50:39 +0200
From: Ulrik de Muelenaere <ulrikdem@gmail.com>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>, Antonio Ospite <ao2@ao2.it>
Subject: [PATCH 0/2] [media] gspca_kinect: enable both video and depth streams
Message-ID: <cover.1457262292.git.ulrikdem@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The Kinect produces both a video and depth stream, but the current implementation of the
gspca_kinect subdriver requires a depth_mode parameter at probe time to select one of
the streams which will be exposed as a v4l device. This patchset allows both streams to
be accessed as separate video nodes.

A possible solution which has been discussed in the past is to call gspca_dev_probe()
multiple times in order to create multiple video nodes. See the following mails:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/26194/focus=26213
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/76715/focus=78344

In the second mail linked above, it was mentioned that gspca_dev_probe() cannot be
called multiple times for the same USB interface, since gspca_dev_probe2() stores a
pointer to the new gspca_dev as the interface's private data. This is required for
gspca_disconnect(), gspca_suspend() and gspca_resume(). As far as I can tell, this is
the only reason gspca_dev_probe() cannot be called multiple times.

The first patch fixes this by storing other devices linked to the same interface as a
linked list. The second patch then calls gspca_dev_probe() twice in the gspca_kinect
subdriver, to create a video node for each stream.

Some notes on error handling, which I think should be reviewed:

* I could not test the gspca_suspend() and gspca_resume() functions. From my evaluation
  of the code, it seems that the only effect of returning an error code from
  gspca_resume() is that a message is logged. Therefore I decided to attempt to resume
  each gspca_dev when the interface is resumed, even if one fails. Bitwise OR seems
  like the best way to combine potentially multiple error codes.

* In the gspca_kinect subdriver, if the second call to gspca_dev_probe() fails, the
  first video node will still be available. I handle this case by calling
  gspca_disconnect(), which worked when I was testing, but I am not sure if this is the
  correct way to handle it.

Regards,
Ulrik

Ulrik de Muelenaere (2):
  [media] gspca: allow multiple probes per USB interface
  [media] gspca_kinect: enable both video and depth streams

 drivers/media/usb/gspca/gspca.c  | 129 +++++++++++++++++++++++----------------
 drivers/media/usb/gspca/gspca.h  |   1 +
 drivers/media/usb/gspca/kinect.c |  28 +++++----
 3 files changed, 91 insertions(+), 67 deletions(-)

-- 
2.7.0

