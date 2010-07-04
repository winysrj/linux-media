Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0GDL0u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Jul 2010 07:26:50 -0400
Message-ID: <4C3070A4.6040702@redhat.com>
Date: Sun, 04 Jul 2010 13:29:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Patryk Biela <patryk.biela@gmail.com>
Subject: ibmcam (xrilink_cit) and konica webcam driver porting to gspca update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've finished porting the usbvideo v4l1 ibmcam and
konicawc drivers to gspcav2.

The ibmcam driver is replaced by gspca_xirlink_cit, which also
adds support for 2 new models (it turned out my testing cams
where not supported by the old driver). This one could use
more testing.

The konicawc driver is replaced by gspca_konica which is
pretty much finished.

You can get them both here:
http://linuxtv.org/hg/~hgoede/ibmcam

Once Douglas updates the hg v4l-dvb tree to be up2date with
the latest and greatest from Mauro, then I'll rebase my
tree (the ibmcam driver needs a very recent gspca core patch),
and send a pull request.

Regards,

Hans


p.s.

1) Many thanks to Patryk Biela for providing me a konica
    driver using camera.
2) Still to do the se401 driver.
3) I'll be on vacation the coming week and not reading email.
