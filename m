Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:8062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab0H1O7Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Aug 2010 10:59:25 -0400
Message-ID: <4C7925A4.2020601@redhat.com>
Date: Sat, 28 Aug 2010 17:05:08 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.8.1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

I'm happy to announce the second stable release of v4l-utils, with
as highlight that libv4l1 no longer needs the kernel v4l1 compat
code, so that can be removed from the kernel (jay!).

New this release:

v4l-utils-0.8.1
---------------
* Utils changes:
   * Various v4l-keytable improvements (mchehab)
   * Various qv4l2 fixes (hverkuil)
   * v4l2-ctl: Added support for s/g_dv_timings (Mats Randgaard)
* libv4l changes (hdegoede):
   * Add many more laptop models to the upside down devices table
   * Detect short frames (and retry upto 3 times to get a non short frame)
   * Support (uvc) cameras with more then 16 framesizes properly (Balint Reczey)
   * libv4l1 no longer relies on the kernel v4l1 compat ioctl handling, many
     thanks to Huzaifa Sidhpurwala for his work on this!
   * Add support for Xirlink C-It YYVYUY
   * Add support for konica yuv420 format

Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.1.tar.bz2

You can always find the latest developments here:
http://git.linuxtv.org/v4l-utils.git

Regards,

Hans
