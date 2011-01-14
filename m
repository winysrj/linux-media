Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:51885 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab1ANRUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 12:20:37 -0500
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: [PATCH 0/1 v2] libv4l: Add plugin support
Date: Fri, 14 Jan 2011 19:18:51 +0200
Message-Id: <cover.1295024151.git.ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

here is second version of plugin support for libv4l2.

Changes in v2:
* Remove calls of v4l2_plugin_foo functions in the beginning of coresponding
  v4l2_foo functions and instead replace SYS_FOO calls.
* Add to v4l2_dev_info device operation structure which can hold plugin
  callbacks or dyrect syscall(SYS_foo, ...) calls.
* Under libv4lconvert also replace SYS_FOO cals with device operations. This
  required also to add dev_ops field to v4lconvert_data and v4lcontrol_data.



---------------------------------------------------------------------------
v1:

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

 lib/include/libv4l2-plugin.h                   |   43 +++
 lib/include/libv4l2.h                          |    4 +-
 lib/include/libv4lconvert.h                    |    5 +-
 lib/libv4l1/libv4l1.c                          |    2 +-
 lib/libv4l2/Makefile                           |    4 +-
 lib/libv4l2/libv4l2-priv.h                     |   24 ++
 lib/libv4l2/libv4l2.c                          |  128 +++++++---
 lib/libv4l2/v4l2-plugin.c                      |  344 ++++++++++++++++++++++++
 lib/libv4l2/v4l2convert.c                      |   23 ++-
 lib/libv4lconvert/control/libv4lcontrol-priv.h |    3 +
 lib/libv4lconvert/control/libv4lcontrol.c      |   26 +-
 lib/libv4lconvert/control/libv4lcontrol.h      |    5 +-
 lib/libv4lconvert/libv4lconvert-priv.h         |    1 +
 lib/libv4lconvert/libv4lconvert.c              |   25 +-
 14 files changed, 573 insertions(+), 64 deletions(-)
 create mode 100644 lib/include/libv4l2-plugin.h
 create mode 100644 lib/libv4l2/v4l2-plugin.c

-- 
1.7.3.1

