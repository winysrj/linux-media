Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2087 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZILK52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 06:57:28 -0400
Received: from tschai.lan (cm-84.208.105.24.getinternet.no [84.208.105.24])
	(authenticated bits=0)
	by smtp-vbr13.xs4all.nl (8.13.8/8.13.8) with ESMTP id n8CAvTrv028840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 12:57:30 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Initial media controller implementation
Date: Sat, 12 Sep 2009 12:57:28 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909121257.28522.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rather than writing long mails on what a media controller is and what it can
do, I thought that I could just as well implement it.

So in 4 hours I implemented pretty much all of the media controller
functionality. The main missing features are the ability to register non-v4l
device nodes so that they can be enumerated and setting controls private to
a sub-device. For that I should first finish the control handling framework.

The datastructures and naming conventions needs to be cleaned up, and it
needs some tweaking, but I'd say this is pretty much the way I want it.

The code is available here:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-mc/

It includes a v4l2-mc utility in v4l2-apps/util that has the
--show-topology option that enumerates all nodes and subdev. Currently any
registered subdevs and v4l device nodes are already automatically added.
Obviously, there are no links setup between them, that would require work
in the drivers.

Total diffstat:

 b/linux/include/media/v4l2-mc.h         |   54 +++++
 b/v4l2-apps/util/v4l2-mc.cpp            |  325 ++++++++++++++++++++++++++++++++
 linux/drivers/media/video/v4l2-dev.c    |   15 +
 linux/drivers/media/video/v4l2-device.c |  265 +++++++++++++++++++++++++-
 linux/include/linux/videodev2.h         |   74 +++++++
 linux/include/media/v4l2-dev.h          |    6
 linux/include/media/v4l2-device.h       |   23 +-
 linux/include/media/v4l2-subdev.h       |   11 -
 v4l2-apps/util/Makefile                 |    2
 9 files changed, 762 insertions(+), 13 deletions(-)

Ignoring the new utility that's just 435 lines of core code.

Now try this with sysfs. Brrr.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
