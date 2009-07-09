Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397AbZGINXi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2009 09:23:38 -0400
Message-ID: <4A55EFD8.8040201@hhs.nl>
Date: Thu, 09 Jul 2009 15:25:44 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l release: 0.6.0: the upside down release
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm very happy to announce the first release of the next
stable series: libv4l-0.6.0

This release features the following familiar features from
previous 0.5.9x test releases:
* Software whitebalancing
* Software automatic gain and exposure for cams which lack
   this in hardware
* Software gamma control
* Fake v4l2 controls to control all these
* Software flipping controls

And as a new feature it now has an extended list of laptops
whose camera modules (mostly uvc) are known to be mounted
upside down in the frame and it will automatically correct
the image for this.

And ofcourse the standard addition of support for a few new
camera output formats.

libv4l-0.6.0
-------------
* Recognize disabled controls and replace with fake equivalents where
   available
* Add support for decompressing ov511 and ov518 "JPEG", by piping data through
   an external helper as I've failed to contact Mark W. McClelland to get
   permission to relicense the code. If you know a working email address for
   Mark W. McClelland, please let me know.
* Add tons of laptop models to the upside down devices table
* Support for rgb565 source format by Mauro Carvalho Chehab
* Many bug fixes (see the mercurial tree for details)
* Improved pac207 decompression code to also support higher compression
   modes of the pac207, which enables us to use higher framerates.
   Many many thanks to Bertrik Sikken for figuring the decompression out!


Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.6.0.tar.gz

Regards,

Hans

