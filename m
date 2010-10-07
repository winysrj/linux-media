Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46720 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab0JGJmD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 05:42:03 -0400
Received: by iwn9 with SMTP id 9so617545iwn.19
        for <linux-media@vger.kernel.org>; Thu, 07 Oct 2010 02:42:03 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Oct 2010 11:42:01 +0200
Message-ID: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
Subject: OMAP 3530 camera ISP forks and new media framework
From: Bastian Hecht <hechtb@googlemail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: sakari.ailus@maxwell.research.nokia.com,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello media team,

I want to write a sensor driver for the mt9p031 (not mt9t031) camera
chip and start getting confused about the different kernel forks and
architectural changes that happen in V4L2.
A similar problem was discussed in this mailing list at
http://www.mail-archive.com/linux-media@vger.kernel.org/msg19084.html.

Currently I don't know which branch to follow. Either
http://gitorious.org/omap3camera from Sakari Ailus or the branch
media-0004-omap3isp at http://git.linuxtv.org/pinchartl/media.git from
Laurent Pinchart. Both have an folder drivers/media/video/isp and are
written for the new media controller architecture if I am right.

I see in http://gitorious.org/omap3camera/camera-firmware that there
is already an empty placeholder for the mt9t031.
The README of the camera-firmware repository states: "makemodes.pl is
a perl script which converts sensor register lists from FIXME into C
code. dcc-pulautin is a Makefile (mostly) that converts sensor
register lists as C code into binaries understandable to sensor
drivers. The end result is a binary with sensor driver name, sensor
version and bin suffix, for example et8ek8-0002.bin."

So I think the goal is to provide a script framework for camera
systems. You just script some register tables and it creates a binary
that can be read by a sensor driver made for that framework. If the a
camera bridge driver for your chip exists, you are done. Am I right?
Are drivers/media/video/et8ek8.c and
drivers/staging/dream/camera/mt9p012_* such drivers?

So do you think it is the right way to go to use your ISP driver,
adapt drivers/staging/dream/camera/mt9p012_* to suit my mt9p031 and
write a register list and create a camera firmware for that sensor
driver with makemodes?

I am still quite confused... if I get something wrong, please give me
some hints.

Thanks a lot!

Bastian Hecht
