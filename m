Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:35351 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab1AGRBh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 12:01:37 -0500
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: [PATCH 0/1] libv4l: Add plugin support
Date: Fri,  7 Jan 2011 18:59:34 +0200
Message-Id: <cover.1294418213.git.ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Here is initial version of plugin support for libv4l, based on your RFC.

It is provided by functions v4l2_plugin_[open,close,etc]. When open() is
called libv4l dlopens files in /usr/lib/libv4l/plugins 1 at a time and call
open() callback passing through the applications parameters unmodified.
If a plugin is relevant for the specified device node, it can indicate so by
returning a value other then -1 (the actual file descriptor).

As soon as a plugin returns another value then -1 plugin loading stops and
information about it (fd and corresponding library handle) is stored.
For each function v4l2_[ioctl,read,close,etc] is called corresponding 
v4l2_plugin_* function which looks if there is loaded plugin for that file
and call it's callbacks. v4l2_plugin_* functions indicate by their first 
argument if plugin was used, and if it was not then v4l2_* functions proceed 
with their usual behavior.

Yordan Kamenov (1):
  Add plugin support to libv4l

 lib/include/libv4l2-plugin.h |   74 ++++++++
 lib/include/libv4l2.h        |   15 ++
 lib/libv4l2/Makefile         |    4 +-
 lib/libv4l2/libv4l2-priv.h   |    9 +
 lib/libv4l2/libv4l2.c        |   56 ++++++-
 lib/libv4l2/v4l2-plugin.c    |  399 ++++++++++++++++++++++++++++++++++++++++++
 lib/libv4l2/v4l2convert.c    |   20 ++-
 7 files changed, 568 insertions(+), 9 deletions(-)
 create mode 100644 lib/include/libv4l2-plugin.h
 create mode 100644 lib/libv4l2/v4l2-plugin.c

-- 
1.7.3.1

