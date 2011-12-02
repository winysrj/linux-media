Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55237 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab1LBPDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2011 10:03:16 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC PATCH v1 0/7] media&omap4: introduce face detection(FD) driver
Date: Fri,  2 Dec 2011 23:02:45 +0800
Message-Id: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

These v1 patches(against -next tree) introduce v4l2 based face
detection(FD) device driver, and enable FD hardware[1] on omap4 SoC..
The idea of implementing it on v4l2 is from from Alan Cox, Sylwester
and Greg-Kh.

For verification purpose, I write one user space utility[2] to
test the module and driver, follows its basic functions:

	- detect faces in input grayscal picture(PGM raw, 320 by 240)
	- detect faces in input y8 format video stream
	- plot a rectangle to mark the detected faces, and save it as 
	another same type grayscal picture

Looks the performance of the module is not bad, see some detection
results on the link[3][4].

Face detection can be used to implement some interesting applications
(camera, face unlock, baby monitor, ...).

TODO:
	- implement FD setting interfaces with v4l2 controls or
	ext controls

thanks,
--
Ming Lei

[1], Ch9 of OMAP4 Technical Reference Manual
[2], http://kernel.ubuntu.com/git?p=ming/fdif.git;a=shortlog;h=refs/heads/v4l2-fdif
[3], http://kernel.ubuntu.com/~ming/dev/fdif/output
[4], All pictures are taken from http://www.google.com/imghp
and converted to pnm from jpeg format, only for test purpose.

