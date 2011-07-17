Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab1GQQME (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 12:12:04 -0400
Message-ID: <4E230A27.5020708@redhat.com>
Date: Sun, 17 Jul 2011 18:13:27 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Announcing v4l-utils-0.8.5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm happy to announce the release of v4l-utils-0.8.5. We're back to
our regular boring releases again :) Still this release contains
some fixes / things which are good to get out there, hence a new
release.

Full changelog:

v4l-utils-0.8.5
---------------
* Utils changes
   * parse_em28xx_drxk.pl: New parser for dumps of em28xx with drxk frontend
     (mchehab)
   * qv4l2: Add support for bitmap controls (hverkuil)
   * v4l2-ctl: add support for the new bitmask control type (hverkuil)
   * v4l2-ctl: add support for the control event (hverkuil)
   * v4l2-ctl: small bugfixes (hverkuil)
   * v4l2-compliance: various new tests (hverkuil)
   * lib_media_dev: various fixes / cleanups (hdegoede)
* libv4l changes
   * Add some more laptop models to the upside down devices table (hdegoede)
   * Add support for SE401 pixelformat (hdegoede)
   * Software autogain tweaks (hdegoede)

Go get it here:
http://linuxtv.org/downloads/v4l-utils/v4l-utils-0.8.5.tar.bz2

You can always find the latest developments here:
http://git.linuxtv.org/v4l-utils.git

Regards,

Hans
