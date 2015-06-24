Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49599 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933823AbbFXDFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 23:05:37 -0400
Message-ID: <558A1E79.8050902@osg.samsung.com>
Date: Tue, 23 Jun 2015 21:05:29 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: "Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: =?UTF-8?B?Q29tcGlsZXIgd2FybmluZyBmcm9tIGRyaXZlcnMvbWVkaWEvdXNiL2E=?=
 =?UTF-8?B?dTA4MjgvYXUwODI4LXZpZGVvLmM6IEluIGZ1bmN0aW9uIOKAmHF1ZXVlX3NldHU=?=
 =?UTF-8?B?cOKAmQ==?=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I am seeing the following warning from au0828 - linux_media
media_controller branch:

drivers/media/usb/au0828/au0828-video.c: In function ‘queue_setup’:
drivers/media/usb/au0828/au0828-video.c:679:6: warning: ‘entity’ may be
used uninitialized in this function [-Wmaybe-uninitialized]
   if (sink == entity)
      ^
drivers/media/usb/au0828/au0828-video.c:644:24: note: ‘entity’ was
declared here
  struct media_entity  *entity, *source;
                        ^

This looks real to me, but don't know what entity should have been
initialized to.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
