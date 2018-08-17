Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:59030 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726376AbeHQMgz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Aug 2018 08:36:55 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?Q?B=c3=a5rd_Eirik_Winther?= <bwinther@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [ANN] qvidcap: Qt/OpenGL video capture testing utility
Message-ID: <f69c82ae-b40c-d78c-1218-62c74944daaf@xs4all.nl>
Date: Fri, 17 Aug 2018 11:34:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have just added qvidcap to v4l-utils. It is a utility that I've been working on
for a long time. For the past 2 years or so I was stuck on Qt/OpenGL issues and
without time to dig into it. I want to thank my colleague Bård Eirik for fixing
those issues.

The core purpose is to display uncompressed video using OpenGL/OpenGL ES.

It can read from V4L2 video nodes, from a network socket, from a file or using
the built-in test pattern generator.

To use the network functionality you start qvidcap with the -p option. And on
the device elsewhere on the network you run:

v4l2-ctl --stream-mmap --stream-to-host <hostname>

It will now stream video (run-length-encoded, so poor compression unless you
are streaming a test pattern) to the host that is running qvidcap and you can
see what the video looks like.

Very useful when dealing with embedded systems that do not yet have working
video output.

When qvidcap reads from a file you can also dynamically change the resolution
and pixelformat (i.e. how it interprets the data). Again, very useful for
debugging.

Changing colorspace, transfer functions, etc. is always possible (right-click to
see a menu appear).

There are two display modes: either the video is scaled to the window, or the
video is never scaled and you get scrollbars if the video is larger than the
window.

By default qvidcap uses OpenGL, but with the --opengles option you can select
OpenGL ES.

Future planned work:

1) Allow changing resolution/pixelformat for streaming over the network as well.
2) Re-use the opengl(es) code for qv4l2 as it is much cleaner code.
3) Use the vicodec codec for the network streaming code as a second option
   besides the run-length encoding.

qvidcap has been tested on nvidia (both the nvidia and nouveau drivers), amd
(amdgpu driver), intel i915 and vmware GPU drivers. I expect virtualbox to
work fine as well.

Enjoy!

	Hans
