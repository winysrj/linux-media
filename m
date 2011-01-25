Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab1AYPwa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 10:52:30 -0500
Message-ID: <4D3EF3EF.6000100@redhat.com>
Date: Tue, 25 Jan 2011 17:01:51 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.8.2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm happy to announce the release of v4l-utils-0.8.2
This release features many small fixes, esp. to the ir-keytable
util (which now comes with udev rules and a manpage), qv4l2,
v4l2-ctl and v4l2-compliance.

v4l-utils-0.8.2
---------------
* Utils changes:
   * Various ir-keytable improvements (mchehab)
   * Various qv4l2 fixes (hverkuil, hdegoede)
   * Various v4l2-ctl fixes (hverkuil)
   * Add parsers for cx231xx i2c, saa7134 pci, sn9c201 usb and generic usb
     logs (mchehab)
   * v4l2-compliance: lots of new tests (hverkuil)
* libv4l changes
   * Add many more laptop models to the upside down devices table (hdegoede)
   * Add support for 8-bits grey format (V4L2_PIX_FMT_GREY) (mchehab)


Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.2.tar.bz2

You can always find the latest developments here:
http://git.linuxtv.org/v4l-utils.git

Regards,

Hans
