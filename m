Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1BIWCx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Feb 2011 17:02:53 -0500
Message-ID: <4D5311A0.3010802@redhat.com>
Date: Wed, 09 Feb 2011 23:13:52 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.8.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm happy to announce the release of v4l-utils-0.8.3. The main
feature this release is that it will actually compile on a system
with the kernel headers version >= 2.6.38.

v4l-utils-0.8.3
---------------
* Utils changes:
   * Various ir-keytable improvements (mchehab)
   * Various cx231xx parser improvements (mchehab)
* libv4l changes
   * Add a few more laptop models to the upside down devices table (hdegoede)
   * Make libv4l1 compile with kernels >= 2.6.38, which no longer have the
     v4l1 linux/videodev.h header (hdegoede)

Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.3.tar.bz2

You can always find the latest developments here:
http://git.linuxtv.org/v4l-utils.git

Regards,

Hans
