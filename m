Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:34652 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab1DSSUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 14:20:15 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 610BCD48169
	for <linux-media@vger.kernel.org>; Tue, 19 Apr 2011 20:20:06 +0200 (CEST)
Date: Tue, 19 Apr 2011 20:20:29 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.40] gspca for_v2.6.40
Message-ID: <20110419202029.7c9dfd14@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
d58307d6a1e2441ebaf2d924df4346309ff84c7d:

  [media] anysee: add more info about known board configs (2011-04-19 10:35:37 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v2.6.40

Antonio Ospite (2):
      Add Y10B, a 10 bpp bit-packed greyscale format.
      gspca - kinect: New subdriver for Microsoft Kinect

Jean-François Moine (1):
      gspca - zc3xx: Adjust the mc501cb exchanges

Patrice Chotard (5):
      gspca - jeilinj: suppress workqueue
      gspca - jeilinj: use gspca_dev->usb_err to forward error to upper layer
      gspca - jeilinj: add 640*480 resolution support
      gspca - jeilinj: Add SPORTSCAM_DV15 camera support
      gspca - jeilinj: add SPORTSCAM specific controls

 Documentation/DocBook/media-entities.tmpl |    1 +
 Documentation/DocBook/v4l/pixfmt-y10b.xml |   43 +++
 Documentation/DocBook/v4l/pixfmt.xml      |    1 +
 Documentation/DocBook/v4l/videodev2.h.xml |    3 +
 Documentation/video4linux/gspca.txt       |    1 +
 drivers/media/video/gspca/Kconfig         |    9 +
 drivers/media/video/gspca/Makefile        |    2 +
 drivers/media/video/gspca/jeilinj.c       |  581 ++++++++++++++++++++---------
 drivers/media/video/gspca/kinect.c        |  427 +++++++++++++++++++++
 drivers/media/video/gspca/zc3xx.c         |   42 +--
 include/linux/videodev2.h                 |    3 +
 11 files changed, 905 insertions(+), 208 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y10b.xml
 create mode 100644 drivers/media/video/gspca/kinect.c

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
