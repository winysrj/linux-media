Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:59532 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751053Ab2GFM1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 08:27:54 -0400
From: Federico Fuga <fuga@studiofuga.com>
To: linux-media@vger.kernel.org
Cc: Federico Fuga <fuga@studiofuga.com>
Subject: [v4l-utils] [PATCH] Cross compilation corrections and script
Date: Fri,  6 Jul 2012 14:27:40 +0200
Message-Id: <1341577661-12415-1-git-send-email-fuga@studiofuga.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello, I saw that in the current stable branch of 0.8 (at least in tag 0.8.8) no configure script is provided.
Cross compiling with it could be difficult.
This patch deals with this problem. It corrects some Makefile and adds a script (./cross-compile.sh) that
cross compiles the utils with some different parameters, like:
- cross tool selection
- Static linking (very useful for testing!)
- Stripping
- jpeg library path selection.

Tested on ARM with arm-linux-gnueabi toolchain, static linking and no staging jpeg libraries (only statically linked 
libraries outside the root build tree)

Regards

Federico Fuga

