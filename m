Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZIAILT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2009 04:11:19 -0400
Message-ID: <4A9CD798.2040205@hhs.nl>
Date: Tue, 01 Sep 2009 10:13:12 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: libv4l release: 0.6.1: the 2nd upside down release
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I'm very happy to announce the release of libv4l-0.6.1

The main changes this release is tons of new laptops in the list of laptops
whose camera modules (mostly uvc) are known to be mounted upside down in
the frame and it will automatically correct the image for this.

libv4l-0.6.1
-------------
* Add more laptop models to the upside down devices table
* Makefile changes to make life easier for the Debian package (Gregor Jasny)
* Bugfix: fixup 320x240 output for pac7302 cameras
* README improvements / clarifications (Bifferos)
* Bugfix: fix reqbuf Device or Resource busy error when using v4l2_read()
* Some applications want to use jpg format if possible, so do not hide
   it from the apps (do not assume it always needs conversion)
* Change controls shm segment name to include the username, as it is only
   writable by the user (this means libv4l controls are per user) (Gregor Jasny)
* Add support for decompressing sn9c2028 compressed bayer (Theodore Kilgore)
* Report V4L2_FMT_FLAG_EMULATED in v4l2_fmtdesc flags for emulated formats


Get it here:
http://people.atrpms.net/~hdegoede/libv4l-0.6.1.tar.gz

Regards,

Hans

