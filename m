Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab0GAOAP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jul 2010 10:00:15 -0400
Received: from int-mx04.intmail.prod.int.phx2.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o61E0EYJ008258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 10:00:14 -0400
Received: from localhost.localdomain (vpn2-11-88.ams2.redhat.com [10.36.11.88])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o61E0AoC030383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 1 Jul 2010 10:00:13 -0400
Message-ID: <4C2CA010.70907@redhat.com>
Date: Thu, 01 Jul 2010 16:02:56 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFCl libv4l2 plugin API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

RFC: a plugin API for libv4l2
=============================

During the Plumbers conference in 2009 various parties expresse interest
in adding a plugin API to libv4l2. Some hardware can do some
processing steps in hardware, but this needs to be setup from userspace
and sometimes still need some regulation from userspace as streaming
happens, hardware specific libv4l2 plugins could be a solution here.

During the v4l summit in Helsinki this was discussed further and a
simple and very generic plugin API was pitched. This is a first draft
specification for this API.


Basic libv4l2 principles
------------------------

The basic unit libv4l2's API deals with is a /dev/video node represented
by a fd. A libv4l2 plugin will sit in between libv4l2 itself and the
actual /dev/video device node a fd refers to. It will be called each time
libv4l2 wants to do an operation (read/write/ioctl/mmap/munmap) on the
actual /dev/video node in question. When called the plugin can then choose
to do one of the following:
1. Pass the call unmodified to the fd, and return the return value unmodifed
    (iow do nothing)
2. Modify some arguments in the call and pass it through
3. Modify the return(ed) value(s) of a passed through call
4. Not do any operation on the fd at all but instead completely fake it
    (which opens the possibility for "fake" v4l devices)

Note that:
1. A plugin may decide between 1. - 4. on a per call basis depending on the
operations arguments and / or state. This esp. is important with the ioctl
operation where a plugin may want to intercept some ioctls but not all
2. If a plugin always wants to pass all calls through for a certain
operation, it is allowed to simply not define a callback function for that
operation
3. As libv4l2 does some "faking" itself esp. when it comes to format
conversion a single libv4l2 call may result in multiple calls to the plugin,
or to none at all.

So to summarize the above: Anything goes :)


libv4l2 plugin loading
----------------------

A libv4l2 plugin is a .so file which lives under /usr/lib[64]/libv4l/plugins.
This .so file defines a single symbol: libv4l2_plugin. This symbol is a
(constant) libv4l_plugin_data struct, which contains pointers to all the
callbacks the plugin wants to install.

libv4l2 plugin loading begins with the application using libv4l2 doing a
v4l2_open() for example v4l2_open("foobar", O_RDWR); When this happens
libv4l2 will dlopen all files found under /usr/lib[64]/libv4l/plugins 1 at a
time and call open callback passing through the applications parameters
unmodified. If a plugin is relevant for the specified device node, it can
indicate so by returning a value other then -1 from the open callback
(usually the result of an actual open call on the device node). If it
is not relevant for this specific video node it should return -1.

As soon as a plugin returns another value then -1 plugin loading stops
and that plugins callbacks are called for all operations on the /dev/video#
node in question. This means that plugins cannot be stacked!

Note that a plugin is bound to a specific fd, this way if there is for
example a system with a SOC connected camera and an external usb camera, the
SOC specific plugin will only be involved when an application is talking to
the SOC connected camera and not when the app talks to the USB webcam.

Note that a plugin is bound to a specific fd not to a device node! IOW it is
possible for a plugin to return not -1 from its open callback when called
on /dev/video0 with O_RDWR, and to return -1 when called on /dev/video0 with
O_RDONLY. Then its callbacks will only get called when operations are done
on the video node though the RW fd, and not when operations are done on the
same node through the RD_ONLY fd. This is not a good idea! It is only meant
to emphasize the binding of a plugin to the fd, rather then to a specific
device node.


libv4l2 plugins and private data
--------------------------------

libv4l2 plugins should *never* use any global variables. All data should be
bound to the specific fd to which the plugin is bound. This ensures that for
example a plugin for a specific type of usb webcam will also work when 2
identical cameras are plugged into a system (and both are used from the same
process).

A libv4l2 plugin can register plugin private data using:
void libv4l2_set_plugindata(int fd, void *plugin_data);

And can get this data out of libv4l2 again inside a callback using:
void *libv4l2_get_plugindata(int fd);

Note that a plugin should call libv4l2_set_plugindata only once per fd !
Calling it a second time will overwrite the previous value. The logical
place to use libv4l2_set_plugindata is from the plugin's open callback.


libv4l2-plugin.h
----------------

/* Plugin callback function struct */
struct libv4l2_plugin_data {
	int (*open)(const char *file, int oflag, ...);
	int (*close)(int fd);
	int (*ioctl)(int fd, unsigned long int request, ...);
	ssize_t (*read)(int fd, void *buffer, size_t n);
	void *(*mmap)(void *start, size_t length, int prot, int flags,
			int fd, int64_t offset);
	/* Note as munmap has no fd argument, defining a callback for munmap
	   will result in it getting called for *any* call to v4l2_munmap. So
	   if a plugin defines a callback for munmap (because for example it
	   returns fake mmap buffers from its mmap callback). Then it must
	   keep track of the addresses at which these buffers live and their
	   size and check the munmap arguments to see if the munmap call was
	   meant for it. */
	int (*munmap)(void *_start, size_t length);
};

/* Plugin utility functions */
void libv4l2_set_plugindata(int fd, void *plugin_data);
void *libv4l2_get_plugindata(int fd);

Regards,

Hans
