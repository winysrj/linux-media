Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:36886 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab1ECP1C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 11:27:02 -0400
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Froe 1678f1f41284ad9665de8717b7b8be117ddf9596 Mon Sep 17 00:00:00 2001
Date: Tue,  3 May 2011 18:26:35 +0300
Message-Id: <1304436396-10501-1-git-send-email-ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

here is the fourth version of plugin support for libv4l2.

Changes in v4:

* Make close() callback void
* Move plugin clean up where the actual fd gets closed
* Use SYS_FOO in default device operations instead of syscall()


--------------------------------------------------------------------------
Changes in v3:

* Pass opened fd to the plugin instead of filename
* Plugin private data is returned by init call and is passed as argument
  in ioctl/read/close (remove libv4l2_set/get_plugindata functions)
* Plugin do not handle mmap/munmap



--------------------------------------------------------------------------
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



Yordan Kamenov (1):
  Add plugin support to libv4l

 lib/include/libv4l2-plugin.h                   |   36 ++++++
 lib/include/libv4lconvert.h                    |    5 +-
 lib/libv4l2/Makefile                           |    6 +-
 lib/libv4l2/libv4l2-priv.h                     |   10 ++
 lib/libv4l2/libv4l2.c                          |   88 ++++++++++----
 lib/libv4l2/v4l2-plugin.c                      |  158 ++++++++++++++++++++++++
 lib/libv4l2/v4l2convert.c                      |    9 --
 lib/libv4lconvert/control/libv4lcontrol-priv.h |    4 +
 lib/libv4lconvert/control/libv4lcontrol.c      |   35 ++++--
 lib/libv4lconvert/control/libv4lcontrol.h      |    5 +-
 lib/libv4lconvert/libv4lconvert-priv.h         |    2 +
 lib/libv4lconvert/libv4lconvert.c              |   34 ++++--
 utils/qv4l2/qv4l2.cpp                          |   17 +++-
 utils/qv4l2/qv4l2.h                            |    1 +
 14 files changed, 347 insertions(+), 63 deletions(-)
 create mode 100644 lib/include/libv4l2-plugin.h
 create mode 100644 lib/libv4l2/v4l2-plugin.c

-- 
1.7.3.1

