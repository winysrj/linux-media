Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44488 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756870AbZKJQNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 11:13:17 -0500
Content-Type: text/plain; charset="iso-8859-1"
Date: Tue, 10 Nov 2009 17:13:18 +0100
From: "Philipp Wiesner" <p.wiesner@gmx.net>
Message-ID: <20091110161318.44980@gmx.net>
MIME-Version: 1.0
Subject: soc_camera, v4l2 api, gstreamer: setting errno ?
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm having some trouble using gstreamer with soc_camera and am a
modified tw9910 driver. I had difficulties compiling the latest sources
for my target so I'm using old kernel and gstreamer versions. But my
question may still be valid, because the problem doesn't seem to be fixed
and this may be interesting for driver programming in the future.

The part I'm suspecting is

  if (v4l2_ioctl (fd, VIDIOC_S_FMT, &format) < 0) {
    if (errno != EINVAL)
      goto set_fmt_failed;

[v4l2src_calls.c,1223]
According to V4L2 api documentation drivers should set errno, but all drivers I've seen in the soc_camera framework (including soc_camera.c)
only 'return -errno'. Should device drivers (like tw9910) set errno or
should soc_camera use return values and set errno? Is it correct that
none of them happens at the moment?
-- 
DSL-Preisknaller: DSL Komplettpakete von GMX schon für 
16,99 Euro mtl.!* Hier klicken: http://portal.gmx.net/de/go/dsl02
