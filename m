Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab1APOOH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 09:14:07 -0500
Message-ID: <4D32FF19.9050600@redhat.com>
Date: Sun, 16 Jan 2011 15:22:17 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Yordan Kamenov <ykamenov@mm-sol.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH 1/1 v2] Add plugin support to libv4l
References: <cover.1295024151.git.ykamenov@mm-sol.com> <db37feca5fecc23b024751467cac65039bac4cd6.1295024151.git.ykamenov@mm-sol.com>
In-Reply-To: <db37feca5fecc23b024751467cac65039bac4cd6.1295024151.git.ykamenov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Thanks for the new patch, it looks much better.

Unfortunately I found what I can only describe as a bug in the
plugin rfc (which as you probasbly know I wrote). The problem is
2 fold:
1) The existence of v4l2_fd_open (and its active use by multiple
    applications) means that we cannot let he plugin open the
    fd, since it may already be opened by the app. So the plugin
    function dev_open should be replaced by a dev_init taking an
    already open fd. Note we could probably change the API
    and remove v4l2_fd_open, but ...

The reason for actually passing the open call with a
file path (ie "/dev/video0") to the plugin was to allow
creating a fully fake device (which would be created by
a plugin when an open tries to open "fakevideo0" for example).
However I now realize that doing fake (or userspace originating)
device is best left to a loopback v4l2 kernel driver, because:

2) The fd needs to be a real file descriptor, which also really links
to the v4l2 buffer for the device, as the application may use poll or
select on the fd.

Note that 2 also means when working with subdevices that the
application actually needs to open the subdevice which will
be the exit node for the format which the apps want (raw bayer
for example has a different exit node then YUV data). This is part
of the unsolved enumeration problem which we discussed in Helsinki
last year.

So summarizing, I believe that:
1) dev_open should be replaced by a dev_init which gets passed in
an already open fd for the main / exit /dev/video node for the device
2) dev_close should be replaced by dev_cleanup, which frees allocated
resources but does not close the fd (for consistency)

This means this patch will need to be reworked a bit more, sorry
about this.

###

Looking at / thinking about the mmap / munmap code for plugins,
I'm wondering if we should allow plugins to intercept mmap
at all (given the above where we have given up on fully fake devices).

Intercepting mmap is only useful for creating fakebuffers, which
in turn is only necessary for format conversion which libv4l2 already
handles.

So I think it would be best to remove mmap interception, if we ever
get a use case scenario where plugins need to modify frame data, they
can create and manage their own mapping of the buffers and modify
the data inline (after a dqbuf), or we can add a separate plugin
mechanism to libv4lconvert for registering new format conversion
plugins.

Given that the main use case is for plugins which control
settings inside the "webcam bridge" part of soc's related to 3a
I don't think that dropping mmap interception will cause any problems
and it will significantly simplify the code, removing some nasty
corner cases. Which are hard to get right (and the current code
does not get right).

###

More detailed comments inline. Note quite a few remarks have to do
with mmap / munmap. If we decide to drop this, they can be ignored :)

On 01/14/2011 06:18 PM, Yordan Kamenov wrote:
> A libv4l2 plugin will sit in between libv4l2 itself and the
> actual /dev/video device node a fd refers to. It will be called each time
> libv4l2 wants to do an operation (read/write/ioctl/mmap/munmap) on the
> actual /dev/video node in question.
>
> Signed-off-by: Yordan Kamenov<ykamenov@mm-sol.com>
> ---
>   lib/include/libv4l2-plugin.h                   |   43 +++
>   lib/include/libv4l2.h                          |    4 +-
>   lib/include/libv4lconvert.h                    |    5 +-
>   lib/libv4l1/libv4l1.c                          |    2 +-
>   lib/libv4l2/Makefile                           |    4 +-
>   lib/libv4l2/libv4l2-priv.h                     |   24 ++
>   lib/libv4l2/libv4l2.c                          |  128 +++++++---
>   lib/libv4l2/v4l2-plugin.c                      |  344 ++++++++++++++++++++++++
>   lib/libv4l2/v4l2convert.c                      |   23 ++-
>   lib/libv4lconvert/control/libv4lcontrol-priv.h |    3 +
>   lib/libv4lconvert/control/libv4lcontrol.c      |   26 +-
>   lib/libv4lconvert/control/libv4lcontrol.h      |    5 +-
>   lib/libv4lconvert/libv4lconvert-priv.h         |    1 +
>   lib/libv4lconvert/libv4lconvert.c              |   25 +-
>   14 files changed, 573 insertions(+), 64 deletions(-)
>   create mode 100644 lib/include/libv4l2-plugin.h
>   create mode 100644 lib/libv4l2/v4l2-plugin.c
>
> diff --git a/lib/include/libv4l2-plugin.h b/lib/include/libv4l2-plugin.h
> new file mode 100644
> index 0000000..3971735
> --- /dev/null
> +++ b/lib/include/libv4l2-plugin.h
> @@ -0,0 +1,43 @@
> +/*
> +* Copyright (C) 2010 Nokia Corporation<multimedia@maemo.org>
> +
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU Lesser General Public License as published by
> +* the Free Software Foundation; either version 2.1 of the License, or
> +* (at your option) any later version.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +* Lesser General Public License for more details.
> +*
> +* You should have received a copy of the GNU Lesser General Public License
> +* along with this program; if not, write to the Free Software
> +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> +*/
> +
> +#ifndef __LIBV4L2_PLUGIN_H
> +#define __LIBV4L2_PLUGIN_H
> +
> +#include<sys/types.h>
> +
> +/* Structure libv4l2_dev_ops holds the calls from libv4ls to video nodes.
> +   They can be normal open/clode/ioctl etc. or any of them may be replaced
> +   with a callback by a loaded plugin.
> +*/
> +
> +struct libv4l2_dev_ops {
> +	int (*open)(const char *file, int oflag,  mode_t mode);
> +	int (*close)(int fd);
> +	int (*ioctl)(int fd, unsigned long int request, void *arg);
> +	ssize_t (*read)(int fd, void *buffer, size_t n);
> +	void *(*mmap)(void *start, size_t length, int prot, int flags,
> +			int fd, int64_t offset);
> +	int (*munmap)(void *_start, size_t length);
> +};
> +
> +/* Plugin utility functions */
> +void libv4l2_set_plugindata(int fd, void *plugin_data);
> +void *libv4l2_get_plugindata(int fd);

These should be marked as LIBV4L_PUBLIC so that plugins can link to them.

Also now that this is actually being implemented I'm not so sure that
this is a good idea. Actually I think it is not. With these 2 functions
we get:

1) app does a libv4l2_foo call
2) libv4l2_foo walks through devices to find index for fd
3) libv4l2 calls a plugin function from the plugin's dev_ops struct
4) plugin function needs its private data
5) plugin function calls libv4l2_get_plugindata
6) libv4l2_get_plugindata walks through devices to find index for fd
    again.

So I think it would be better to replace "int fd" with "void *priv"
in all the dev_ops functions. So that we directly call plugin functions
with their private data pointer, and then we no longer need
libv4l2_get_plugindata.

Like wise libv4l2_set_plugindata should go away too and
the open^W init dev_op should return the private data for
the plugin.

So libv4l2_dev_ops would become:

struct libv4l2_dev_ops {
	void * (*init)(int fd);
	int (*close)(void *dev_ops_priv);
	int (*ioctl)(void *dev_ops_priv, unsigned long int request, void *arg);
	ssize_t (*read)(void *dev_ops_priv, void *buffer, size_t n);
	void *(*mmap)(void *start, size_t length, int prot, int flags,
			void *dev_ops_priv, int64_t offset);
	int (*munmap)(void *dev_ops_priv, void *_start, size_t length);
};

Also notice how munmap now also gets dev_ops_priv, where as it would not get an
fd, making it impossible for a plugins munmap function to get to the
plugins private data. Which would be undesirable.


> +
> +#endif
> diff --git a/lib/include/libv4l2.h b/lib/include/libv4l2.h
> index cc0ab4a..5db000f 100644
> --- a/lib/include/libv4l2.h
> +++ b/lib/include/libv4l2.h
> @@ -22,6 +22,7 @@
>   #include<stdio.h>
>   #include<unistd.h>
>   #include<stdint.h>
> +#include "libv4l2-plugin.h"
>
>   #ifdef __cplusplus
>   extern "C" {
> @@ -106,7 +107,8 @@ LIBV4L_PUBLIC int v4l2_get_control(int fd, int cid);
>
>      Returns fd on success, -1 if the fd is not suitable for use through libv4l2
>      (note the fd is left open in this case). */
> -LIBV4L_PUBLIC int v4l2_fd_open(int fd, int v4l2_flags);
> +LIBV4L_PUBLIC int v4l2_fd_open(int fd, struct libv4l2_dev_ops *dev_ops,
> +		int v4l2_flags);
>

This function should not be changed, as doing so changes the libv4l2 API
(and ABI) which is not allowed.

>   #ifdef __cplusplus
>   }
> diff --git a/lib/include/libv4lconvert.h b/lib/include/libv4lconvert.h
> index 0264290..f210b2d 100644
> --- a/lib/include/libv4lconvert.h
> +++ b/lib/include/libv4lconvert.h
> @@ -38,6 +38,8 @@
>
>   #include<linux/videodev2.h>
>
> +#include "libv4l2-plugin.h"
> +
>   #ifdef __cplusplus
>   extern "C" {
>   #endif /* __cplusplus */
> @@ -50,7 +52,8 @@ extern "C" {
>
>   struct v4lconvert_data;
>
> -LIBV4L_PUBLIC struct v4lconvert_data *v4lconvert_create(int fd);
> +LIBV4L_PUBLIC struct v4lconvert_data *v4lconvert_create(int fd,
> +		struct libv4l2_dev_ops *dev_ops);
>   LIBV4L_PUBLIC void v4lconvert_destroy(struct v4lconvert_data *data);
>

This is an API change too, so we need to bump the soname for libv4lconvert.
In this case it is ok, since I know of only 2 programs which directly
use libv4l, one of which lives in the same git tree as libv4l. Note that
with the changes discussed above we should pass in dev_ops_priv too.

We also need to update the docs / comments for this saying that this is for
libv4l2 plugin use and that apps directly using libv4lconvert should pass in
libv4l2_default_ops and NULL, resp.


>   /* When doing flipping / rotating / video-processing, only supported
> diff --git a/lib/libv4l1/libv4l1.c b/lib/libv4l1/libv4l1.c
> index fee0fb7..180db0e 100644
> --- a/lib/libv4l1/libv4l1.c
> +++ b/lib/libv4l1/libv4l1.c
> @@ -342,7 +342,7 @@ int v4l1_open(const char *file, int oflag, ...)
>
>   	/* Register with libv4l2, as we use that todo format conversion and read()
>   	   emulation for us */
> -	if (v4l2_fd_open(fd, 0) == -1) {
> +	if (v4l2_fd_open(fd, NULL, 0) == -1) {
>   		int saved_err = errno;
>
>   		SYS_CLOSE(fd);
> diff --git a/lib/libv4l2/Makefile b/lib/libv4l2/Makefile
> index d78632f..eb1c019 100644
> --- a/lib/libv4l2/Makefile
> +++ b/lib/libv4l2/Makefile
> @@ -1,8 +1,8 @@
>   override CPPFLAGS += -I../include -fvisibility=hidden
>
> -LIBS_libv4l2  = -lpthread
> +LIBS_libv4l2  = -lpthread -ldl
>
> -V4L2_OBJS     = libv4l2.o log.o
> +V4L2_OBJS     = libv4l2.o v4l2-plugin.o log.o
>   V4L2CONVERT   = v4l2convert.so
>   V4L2CONVERT_O = v4l2convert.o libv4l2.so
>   TARGETS       = $(V4L2_LIB) libv4l2.pc
> diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
> index 46d6103..ac4ccd6 100644
> --- a/lib/libv4l2/libv4l2-priv.h
> +++ b/lib/libv4l2/libv4l2-priv.h
> @@ -85,8 +85,32 @@ struct v4l2_dev_info {
>   	/* buffer when doing conversion and using read() for read() */
>   	int readbuf_size;
>   	unsigned char *readbuf;
> +	struct libv4l2_dev_ops dev_ops;

please make this a pointer, no need to have a copy of the struct
(as far as I can see).

> +	/* plugin info */
> +	void *plugin_library;
> +	void *plugin_data;
>   };
>
> +int dev_open(const char *file, int oflag, mode_t mode);
> +int dev_close(int fd);
> +int dev_ioctl(int fd, unsigned long cmd, void *arg);
> +ssize_t dev_read(int fd, void *buf, size_t len);
> +void *dev_mmap(void *addr, size_t len, int prot, int flags, int fd, int64_t off);
> +int dev_munmap(void *addr, size_t len);
> +

Please remove these (see below).

> +
> +LIBV4L_PUBLIC int v4l2_plugin_open(int *plugin_used, const char *file,
> +					int oflag, ...);
> +LIBV4L_PUBLIC void *v4l2_plugin_mmap(int *plugin_used, void *start,
> +					size_t length, int prot, int flags,
> +					int fd, int64_t offset);
> +LIBV4L_PUBLIC int v4l2_plugin_munmap(int *plugin_used, void *_start,
> +					size_t length);
> +

Since these are only used internally they should *not* be marked as
LIBV4L_PUBLIC

> +extern struct v4l2_dev_info devices[V4L2_MAX_DEVICES];
> +extern pthread_mutex_t v4l2_open_mutex;
> +extern int devices_used;
> +
>   /* From log.c */
>   void v4l2_log_ioctl(unsigned long int request, void *arg, int result);
>
> diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> index ab85ea7..e066870 100644
> --- a/lib/libv4l2/libv4l2.c
> +++ b/lib/libv4l2/libv4l2.c
> @@ -67,6 +67,7 @@
>   #include<sys/stat.h>
>   #include "libv4l2.h"
>   #include "libv4l2-priv.h"
> +#include "libv4l2-plugin.h"
>
>   /* Note these flags are stored together with the flags passed to v4l2_fd_open()
>      in v4l2_dev_info's flags member, so care should be taken that the do not
> @@ -81,14 +82,23 @@
>
>   #define V4L2_MMAP_OFFSET_MAGIC      0xABCDEF00u
>
> -static pthread_mutex_t v4l2_open_mutex = PTHREAD_MUTEX_INITIALIZER;
> -static struct v4l2_dev_info devices[V4L2_MAX_DEVICES] = {
> +pthread_mutex_t v4l2_open_mutex = PTHREAD_MUTEX_INITIALIZER;
> +struct v4l2_dev_info devices[V4L2_MAX_DEVICES] = {
>   	{ .fd = -1 },
>   	{ .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 },
>   	{ .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 },
>   	{ .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }, { .fd = -1 }
>   };
> -static int devices_used;
> +int devices_used;
> +
> +struct libv4l2_dev_ops default_operations = {
> +	.open =&dev_open,
> +	.close =&dev_close,
> +	.ioctl =&dev_ioctl,
> +	.read =&dev_read,
> +	.mmap =&dev_mmap,
> +	.munmap =&dev_munmap
> +};
>

Please move this to libv4l2-plugin.c. You can then also make
all the dev_xxx default functions static.

>
>   static int v4l2_request_read_buffers(int index)
> @@ -102,7 +112,8 @@ static int v4l2_request_read_buffers(int index)
>   		devices[index].nreadbuffers;
>   	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>   	req.memory = V4L2_MEMORY_MMAP;
> -	result = SYS_IOCTL(devices[index].fd, VIDIOC_REQBUFS,&req);
> +	result = devices[index].dev_ops.ioctl(devices[index].fd,
> +			VIDIOC_REQBUFS,&req);
>   	if (result<  0) {
>   		int saved_err = errno;
>
> @@ -131,7 +142,7 @@ static void v4l2_unrequest_read_buffers(int index)
>   	req.count = 0;
>   	req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>   	req.memory = V4L2_MEMORY_MMAP;
> -	if (SYS_IOCTL(devices[index].fd, VIDIOC_REQBUFS,&req)<  0)
> +	if (devices[index].dev_ops.ioctl(devices[index].fd, VIDIOC_REQBUFS,&req)<  0)
>   		return;
>
>   	devices[index].no_frames = MIN(req.count, V4L2_MAX_NO_FRAMES);
> @@ -152,7 +163,8 @@ static int v4l2_map_buffers(int index)
>   		buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>   		buf.memory = V4L2_MEMORY_MMAP;
>   		buf.index = i;
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_QUERYBUF,&buf);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_QUERYBUF,&buf);
>   		if (result) {
>   			int saved_err = errno;
>
> @@ -202,7 +214,8 @@ static int v4l2_streamon(int index)
>   	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>
>   	if (!(devices[index].flags&  V4L2_STREAMON)) {
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_STREAMON,&type);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_STREAMON,&type);
>   		if (result) {
>   			int saved_err = errno;
>
> @@ -223,7 +236,8 @@ static int v4l2_streamoff(int index)
>   	enum v4l2_buf_type type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>
>   	if (devices[index].flags&  V4L2_STREAMON) {
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_STREAMOFF,&type);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_STREAMOFF,&type);
>   		if (result) {
>   			int saved_err = errno;
>
> @@ -252,7 +266,8 @@ static int v4l2_queue_read_buffer(int index, int buffer_index)
>   	buf.type   = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>   	buf.memory = V4L2_MEMORY_MMAP;
>   	buf.index  = buffer_index;
> -	result = SYS_IOCTL(devices[index].fd, VIDIOC_QBUF,&buf);
> +	result = devices[index].dev_ops.ioctl(devices[index].fd,
> +			VIDIOC_QBUF,&buf);
>   	if (result) {
>   		int saved_err = errno;
>
> @@ -277,7 +292,8 @@ static int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
>   		return result;
>
>   	do {
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_DQBUF, buf);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_DQBUF, buf);
>   		if (result) {
>   			if (errno != EAGAIN) {
>   				int saved_err = errno;
> @@ -356,7 +372,8 @@ static int v4l2_read_and_convert(int index, unsigned char *dest, int dest_size)
>   	}
>
>   	do {
> -		result = SYS_READ(devices[index].fd, devices[index].readbuf, buf_size);
> +		result = devices[index].dev_ops.read(devices[index].fd,
> +				devices[index].readbuf, buf_size);
>   		if (result<= 0) {
>   			if (result&&  errno != EAGAIN) {
>   				int saved_err = errno;
> @@ -496,7 +513,7 @@ static int v4l2_buffers_mapped(int index)
>   			buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>   			buf.memory = V4L2_MEMORY_MMAP;
>   			buf.index = i;
> -			if (SYS_IOCTL(devices[index].fd, VIDIOC_QUERYBUF,&buf)) {
> +			if (devices[index].dev_ops.ioctl(devices[index].fd, VIDIOC_QUERYBUF,&buf)) {
>   				int saved_err = errno;
>
>   				V4L2_LOG_ERR("querying buffer %u: %s\n", i, strerror(errno));
> @@ -522,7 +539,24 @@ static int v4l2_buffers_mapped(int index)
>
>   int v4l2_open(const char *file, int oflag, ...)
>   {
> -	int fd;
> +	int fd, plugin_used;
> +
> +	if (oflag&  O_CREAT) {
> +		va_list ap;
> +		mode_t mode;
> +
> +		va_start(ap, oflag);
> +		mode = va_arg(ap, mode_t);
> +
> +		fd = v4l2_plugin_open(&plugin_used, file, oflag, mode);
> +
> +		va_end(ap);
> +	} else {
> +		fd = v4l2_plugin_open(&plugin_used, file, oflag, 0);
> +	}
> +
> +	if (plugin_used)
> +		return fd;
>

Since the plugins will no longer be opening the fd, this can go way,
instead all the plugin init stuff will be done in v4l2_fd_open.


>   	/* original open code */
>   	if (oflag&  O_CREAT) {
> @@ -543,7 +577,7 @@ int v4l2_open(const char *file, int oflag, ...)
>   	if (fd == -1)
>   		return fd;
>
> -	if (v4l2_fd_open(fd, 0) == -1) {
> +	if (v4l2_fd_open(fd, NULL, 0) == -1) {
>   		int saved_err = errno;
>
>   		SYS_CLOSE(fd);
> @@ -554,7 +588,8 @@ int v4l2_open(const char *file, int oflag, ...)
>   	return fd;
>   }
>
> -int v4l2_fd_open(int fd, int v4l2_flags)
> +int v4l2_fd_open(int fd, struct libv4l2_dev_ops *dev_ops,
> +		int v4l2_flags)
>   {
>   	int i, index;
>   	char *lfname;
> @@ -562,6 +597,9 @@ int v4l2_fd_open(int fd, int v4l2_flags)
>   	struct v4l2_format fmt;
>   	struct v4lconvert_data *convert;
>
> +	if (dev_ops == NULL)
> +		dev_ops =&default_operations;
> +

This to can go away now, instead v4l2_plugin_init (the new name for
v4l2_plugin_open) should be called here. I suggest the following prototype
for v4l2_plugin_init:
void v4l2_plugin_init(int fd, void **plugin_lib_ret, void **plugin_priv_ret,
     struct libv4l2_dev_ops **dev_ops_ret);

In case a plugin is interested in handling the device (returns non NULL from
dev_init), this function will fill all pass by reference _ret pointers with
the relevant bits. Which v4l2_fd_open can then later store inside the devices
array. In case no plugin is interested this function will fill dev_ops_ret
with the address of default_ops, and the other 2 with NULL.

Note this also means that in the error paths in v4l_fd_open, v4l2_plugin_cleanup
(new name for v4l2_plugin_close) will needs to be called, to free up any plugin
allocated resources). Proposed prototype for v4l2_plugin_cleanup:
void v4l2_plugin_cleanup(void *plugin_priv, void *plugin_lib, struct libv4l2_dev_ops *dev_ops);

Note that this function does not get passed an index into devices to lookup
these 3 itself, because when it gets called in an error path in v4l2_fd_open
this info has not yet been registered into the devices array.

>   	/* If no log file was set by the app, see if one was specified through the
>   	   environment */
>   	if (!v4l2_log_file) {
> @@ -571,7 +609,7 @@ int v4l2_fd_open(int fd, int v4l2_flags)
>   	}
>
>   	/* check that this is an v4l2 device */
> -	if (SYS_IOCTL(fd, VIDIOC_QUERYCAP,&cap)) {
> +	if (dev_ops->ioctl(fd, VIDIOC_QUERYCAP,&cap)) {
>   		int saved_err = errno;
>
>   		V4L2_LOG_ERR("getting capabilities: %s\n", strerror(errno));
> @@ -586,7 +624,7 @@ int v4l2_fd_open(int fd, int v4l2_flags)
>
>   	/* Get current cam format */
>   	fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	if (SYS_IOCTL(fd, VIDIOC_G_FMT,&fmt)) {
> +	if (dev_ops->ioctl(fd, VIDIOC_G_FMT,&fmt)) {
>   		int saved_err = errno;
>
>   		V4L2_LOG_ERR("getting pixformat: %s\n", strerror(errno));
> @@ -595,15 +633,22 @@ int v4l2_fd_open(int fd, int v4l2_flags)
>   	}
>
>   	/* init libv4lconvert */
> -	convert = v4lconvert_create(fd);
> +	convert = v4lconvert_create(fd, dev_ops);
>   	if (!convert)
>   		return -1;
>
>   	/* So we have a v4l2 capture device, register it in our devices array */
>   	pthread_mutex_lock(&v4l2_open_mutex);
>   	for (index = 0; index<  V4L2_MAX_DEVICES; index++)
> -		if (devices[index].fd == -1) {
> +		if (devices[index].fd == fd || devices[index].fd == -1) {
>   			devices[index].fd = fd;

With the changes discussed so far this change won't be necessary.

> +
> +			devices[index].dev_ops.open = dev_ops->open;
> +			devices[index].dev_ops.close = dev_ops->close;
> +			devices[index].dev_ops.ioctl = dev_ops->ioctl;
> +			devices[index].dev_ops.read = dev_ops->read;
> +			devices[index].dev_ops.mmap = dev_ops->mmap;
> +			devices[index].dev_ops.munmap = dev_ops->munmap;

Here the 3 pointers returned by plugin_init should be stored. Also note
that if you want to copy over a struct like you're doing here, you could
write the following instead:
			devices[index].dev_ops = *dev_ops;

The compiler will then copy over all members of the struct.

>   			break;
>   		}
>   	pthread_mutex_unlock(&v4l2_open_mutex);
> @@ -723,7 +768,7 @@ int v4l2_close(int fd)
>   	/* Since we've marked the fd as no longer used, and freed the resources,
>   	   redo the close in case it was interrupted */
>   	do {
> -		result = SYS_CLOSE(fd);
> +		result = devices[index].dev_ops.close(fd);
>   	} while (result == -1&&  errno == EINTR);
>
>   	V4L2_LOG("close: %d\n", fd);

Note that v4l2_close should be modified to also clear all the framepointers /
framesizes. This means that memory mapped by the plugin which gets munmapped after
the fd is closed won't actually get munmapped. IOW it will be leaked, but that is
better then calling into potentially the wrong plugin for the munmap (if the
devices slot got re-used before the munmap happens).

libv4l2 already leaks (it will print a warning) its fake mmap buffer if it is still
mapped by the app when closing the fd. Plugging this hole in a thread safe manner
would require serializing almost all calls, which is too high a prize to pay IMHO.

In practice the libv4l2 warning about this happening is never seen as all apps
munmap their buffers before closing the fd.

> @@ -879,7 +924,7 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>   	}
>
>   	if (!is_capture_request) {
> -		result = SYS_IOCTL(fd, request, arg);
> +		result = devices[index].dev_ops.ioctl(fd, request, arg);
>   		saved_err = errno;
>   		v4l2_log_ioctl(request, arg, result);
>   		errno = saved_err;
> @@ -927,7 +972,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>   	case VIDIOC_QUERYCAP: {
>   		struct v4l2_capability *cap = arg;
>
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_QUERYCAP, cap);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_QUERYCAP, cap);
>   		if (result == 0)
>   			/* We always support read() as we fake it using mmap mode */
>   			cap->capabilities |= V4L2_CAP_READWRITE;
> @@ -977,8 +1023,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>   		}
>
>   		if (devices[index].flags&  V4L2_DISABLE_CONVERSION) {
> -			result = SYS_IOCTL(devices[index].fd, VIDIOC_TRY_FMT,
> -					dest_fmt);
> +			result = devices[index].dev_ops.ioctl(devices[index].fd,
> +					VIDIOC_TRY_FMT, dest_fmt);
>   			src_fmt = *dest_fmt;
>   		} else {
>   			result = v4lconvert_try_format(devices[index].convert, dest_fmt,
> @@ -1018,7 +1064,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>   			break;
>
>   		req_pix_fmt = src_fmt.fmt.pix;
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_S_FMT,&src_fmt);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_S_FMT,&src_fmt);
>   		if (result) {
>   			saved_err = errno;
>   			V4L2_LOG_ERR("setting pixformat: %s\n", strerror(errno));
> @@ -1067,7 +1114,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>   		if (req->count>  V4L2_MAX_NO_FRAMES)
>   			req->count = V4L2_MAX_NO_FRAMES;
>
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_REQBUFS, req);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_REQBUFS, req);
>   		if (result<  0)
>   			break;
>   		result = 0; /* some drivers return the number of buffers on success */
> @@ -1088,7 +1136,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>
>   		/* Do a real query even when converting to let the driver fill in
>   		   things like buf->field */
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_QUERYBUF, buf);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_QUERYBUF, buf);
>   		if (result || !v4l2_needs_conversion(index))
>   			break;
>
> @@ -1115,7 +1164,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>   				break;
>   		}
>
> -		result = SYS_IOCTL(devices[index].fd, VIDIOC_QBUF, arg);
> +		result = devices[index].dev_ops.ioctl(devices[index].fd,
> +				VIDIOC_QBUF, arg);
>   		break;
>
>   	case VIDIOC_DQBUF: {
> @@ -1128,7 +1178,8 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>   		}
>
>   		if (!v4l2_needs_conversion(index)) {
> -			result = SYS_IOCTL(devices[index].fd, VIDIOC_DQBUF, buf);
> +			result = devices[index].dev_ops.ioctl(devices[index].fd,
> +					VIDIOC_DQBUF, buf);
>   			if (result) {
>   				int saved_err = errno;
>
> @@ -1187,7 +1238,7 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>   		break;
>
>   	default:
> -		result = SYS_IOCTL(fd, request, arg);
> +		result = devices[index].dev_ops.ioctl(fd, request, arg);
>   		break;
>   	}
>
> @@ -1217,7 +1268,7 @@ ssize_t v4l2_read(int fd, void *dest, size_t n)
>   	   it */
>   	if ((devices[index].flags&  V4L2_SUPPORTS_READ)&&
>   			!v4l2_needs_conversion(index)) {
> -		result = SYS_READ(fd, dest, n);
> +		result = devices[index].dev_ops.read(fd, dest, n);
>   		goto leave;
>   	}
>
> @@ -1264,10 +1315,16 @@ leave:
>   void *v4l2_mmap(void *start, size_t length, int prot, int flags, int fd,
>   		int64_t offset)
>   {
> -	int index;
> +	int index, plugin_used;
>   	unsigned int buffer_index;
>   	void *result;
>
> +	result = v4l2_plugin_mmap(&plugin_used, start, length, prot,
> +							flags, fd, offset);
> +
> +	if (plugin_used)
> +		return result;
> +

This is wrong you're now passing all mmap calls to the device /
the plugin, including those for:
1) completely different fd's (remember libv4l2 can be made to intercept
all mmap calls to the compatibility shim which can be LD_PRELOAD-ed for
for example skype, see the comments at the top of libv4l2.c
2) the fake mmap buffer libv4l2 creates for the app when doing format
conversion. In the format conversion case, libv4l2 makes the app see
a fake mmap buffer, and maps the real buffers itself and then on each dqbuf
does a conversion from the real buf to the fake buf seen by the app.

One problem is that the different fd and not fake mmap buffer cases
are currently handled in 1 if in libv4l2:

         if (index == -1 ||
                         /* Check if the mmap data matches our answer to QUERY_B
                            let the kernel handle it (to allow for mmap based no
                         start || length != V4L2_FRAME_BUF_SIZE ||
                         ((unsigned int)offset & ~0xFFu) != V4L2_MMAP_OFFSET_MAG

This needs to be split, in the index == -1 case, the fd is not ours and SYS_MMAP
should called, in the other case. The stream lock should be taken and v4l2_plugin_mmap
should be called and passed in the found index (see below), followed by unlocking the
stream lock and returning the result. If none of the 2 cases match the fake mmap
buffer code which is below this if should execute.

Note libv4l2 also calls SYS_MMAP on the device in v4l2_map_buffers, this call
should be replaced by calling v4l2_plugin_mmap, in the case there is no need to
take the stream lock as it is already held.


>   	index = v4l2_get_index(fd);
>   	if (index == -1 ||
>   			/* Check if the mmap data matches our answer to QUERY_BUF, if it doesn't
> @@ -1329,10 +1386,15 @@ leave:
>
>   int v4l2_munmap(void *_start, size_t length)
>   {
> -	int index;
> +	int index, result, plugin_used;
>   	unsigned int buffer_index;
>   	unsigned char *start = _start;
>
> +	result = v4l2_plugin_munmap(&plugin_used, _start, length);
> +
> +	if (plugin_used)
> +		return result;
> +
>   	/* Is this memory ours? */
>   	if (start != MAP_FAILED&&  length == V4L2_FRAME_BUF_SIZE) {
>   		for (index = 0; index<  devices_used; index++)

Note that you should call v4l2_plugin_munmap in v4l2_unmap_buffers too.


> diff --git a/lib/libv4l2/v4l2-plugin.c b/lib/libv4l2/v4l2-plugin.c
> new file mode 100644
> index 0000000..22ea315
> --- /dev/null
> +++ b/lib/libv4l2/v4l2-plugin.c
> @@ -0,0 +1,344 @@
> +/*
> +* Copyright (C) 2010 Nokia Corporation<multimedia@maemo.org>
> +
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU Lesser General Public License as published by
> +* the Free Software Foundation; either version 2.1 of the License, or
> +* (at your option) any later version.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +* Lesser General Public License for more details.
> +*
> +* You should have received a copy of the GNU Lesser General Public License
> +* along with this program; if not, write to the Free Software
> +* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> +*/
> +
> +#include<stdarg.h>
> +#include<dlfcn.h>
> +#include<fcntl.h>
> +#include<glob.h>
> +#include<sys/stat.h>
> +#include<sys/mman.h>
> +#include "libv4l2.h"
> +#include "libv4l2-priv.h"
> +#include "libv4l2-plugin.h"
> +
> +/* libv4l plugin support:
> +   it is provided by functions v4l2_plugin_[open,close,etc].
> +
> +   When open() is called libv4l dlopens files in /usr/lib[64]/libv4l/plugins
> +   1 at a time and call open callback passing through the applications
> +   parameters unmodified.
> +
> +   If a plugin is relevant for the specified device node, it can indicate so
> +   by returning a value other then -1 (the actual file descriptor).
> +   As soon as a plugin returns another value then -1 plugin loading stops and
> +   information about it (fd and corresponding library handle) is stored. For
> +   each function v4l2_[ioctl,read,close,etc] is called corresponding
> +   v4l2_plugin_* function which looks if there is loaded plugin for that file
> +   and call it's callbacks.
> +
> +   v4l2_plugin_* function indicates by it's first argument if plugin was used,
> +   and if it was not then v4l2_* functions proceed with their usual behavior.
> +*/
> +
> +#define PLUGINS_PATTERN "/usr/lib/libv4l/plugins/*.so"
> +
> +int dev_open(const char *file, int oflag, mode_t mode)
> +{
> +	return syscall(SYS_open, (const char *)(file), (int)(oflag),
> +			(mode_t)(mode));
> +}
> +
> +int dev_close(int fd)
> +{
> +	return syscall(SYS_close, (int)(fd));
> +}
> +
> +int dev_ioctl(int fd, unsigned long cmd, void *arg)
> +{
> +	return syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd),
> +			(void *)(arg));
> +}
> +
> +ssize_t dev_read(int fd, void *buf, size_t len)
> +{
> +	return syscall(SYS_read, (int)(fd), (void *)(buf), (size_t)(len));
> +}
> +
> +void *dev_mmap(void *addr, size_t len, int prot, int flags, int fd,
> +		int64_t off)
> +{
> +	return (void *)syscall(SYS_mmap2, (void *)(addr), (size_t)(len),
> +			(int)(prot), (int)(flags), (int)(fd),
> +			(__off_t)((off)>>  MMAP2_PAGE_SHIFT));
> +}
> +
> +int dev_munmap(void *addr, size_t len)
> +{
> +	return syscall(SYS_munmap, (void *)(addr), (size_t)(len));
> +}
> +
> +int v4l2_plugin_open(int *plugin_used, const char *file, int oflag, ...)
> +{
> +	char *error;
> +	int index, fd = -1, glob_ret, plugin_num;
> +	void *plugin_library = NULL;
> +	struct libv4l2_dev_ops *libv4l2_plugin = NULL;
> +	glob_t globbuf;
> +
> +	pthread_mutex_lock(&v4l2_open_mutex);
> +	/* Check if there is empty slot for plugin */
> +	for (index = 0; index<  V4L2_MAX_DEVICES; index++)
> +		if (devices[index].fd == -1)
> +			break;
> +	pthread_mutex_unlock(&v4l2_open_mutex);
> +
> +	if (index == V4L2_MAX_DEVICES) {
> +		V4L2_LOG_ERR("attempting to open more than %d libv4l plugins\n",
> +			V4L2_MAX_DEVICES);
> +		*plugin_used = 0;
> +		return -1;
> +	}
> +

With the changes discussed before, libv4l2_fd_open will take
care of entering all information into the devices array, including
checking there is a free spot. So this can go away.

> +	glob_ret = glob(PLUGINS_PATTERN, 0, NULL,&globbuf);
> +
> +	if (glob_ret == GLOB_NOSPACE) {
> +		*plugin_used = 0;
> +		return -1;
> +	}
> +
> +	if (glob_ret == GLOB_ABORTED || glob_ret == GLOB_NOMATCH) {
> +		*plugin_used = 0;
> +		goto leave;
> +	}
> +
> +	for (plugin_num = 0; plugin_num<  globbuf.gl_pathc; plugin_num++) {
> +
> +		V4L2_LOG("PLUGIN: dlopen(%s);\n", globbuf.gl_pathv[plugin_num]);
> +
> +		plugin_library = dlopen(globbuf.gl_pathv[plugin_num],
> +							RTLD_LAZY);
> +
> +		if (!plugin_library)
> +			continue;
> +
> +		dlerror();    /* Clear any existing error */
> +		libv4l2_plugin = (struct libv4l2_dev_ops *)
> +					dlsym(plugin_library, "libv4l2_plugin");
> +
> +		error = dlerror();
> +		if (error != NULL)  {
> +			V4L2_LOG_ERR("PLUGIN: dlsym failed: %s\n", error);
> +			dlclose(plugin_library);
> +
> +			continue;
> +		}
> +
> +		if (libv4l2_plugin->open == NULL) {
> +			fd = -1;
> +		} else {
> +			if (oflag&  O_CREAT) {
> +				va_list ap;
> +				mode_t mode;
> +
> +				va_start(ap, oflag);
> +				mode = va_arg(ap, mode_t);
> +
> +				fd = libv4l2_plugin->open(file, oflag, mode);
> +
> +				va_end(ap);
> +			} else {
> +				fd = libv4l2_plugin->open(file, oflag, 0);
> +			}
> +		}
> +
> +		if (fd != -1) {
> +			V4L2_LOG("PLUGIN: plugin open() returned %d\n", fd);
> +
> +			if (libv4l2_plugin->open == NULL)
> +				libv4l2_plugin->open =&dev_open;
> +			if (libv4l2_plugin->close == NULL)
> +				libv4l2_plugin->close =&dev_close;
> +			if (libv4l2_plugin->ioctl == NULL)
> +				libv4l2_plugin->ioctl =&dev_ioctl;
> +			if (libv4l2_plugin->read == NULL)
> +				libv4l2_plugin->read =&dev_read;
> +			if (libv4l2_plugin->mmap == NULL)
> +				libv4l2_plugin->mmap =&dev_mmap;
> +			if (libv4l2_plugin->munmap == NULL)
> +				libv4l2_plugin->munmap =&dev_munmap;
> +

Begin block named "this block" below.

> +			v4l2_fd_open(fd, libv4l2_plugin, 0);
> +
> +			for (index = 0; index<  V4L2_MAX_DEVICES; index++)
> +				if (devices[index].fd == fd)
> +					break;
> +
> +			/* The fd was not stored in devices[] array */
> +			if (index == V4L2_MAX_DEVICES) {
> +				libv4l2_plugin->close(fd);
> +				dlclose(plugin_library);
> +				fd = -1;
> +				goto leave;
> +			}
> +
> +			pthread_mutex_lock(&v4l2_open_mutex);
> +			devices[index].plugin_library = plugin_library;
> +			pthread_mutex_unlock(&v4l2_open_mutex);
> +

Likewise, this block can be removed too, given the changes mentioned above.

> +			break;
> +		} else {
> +			V4L2_LOG("PLUGIN: plugin open() returned -1\n");
> +			dlclose(plugin_library);
> +			plugin_library = NULL;
> +		}
> +
> +	}
> +
> +leave:
> +	globfree(&globbuf);
> +
> +	if (fd == -1)
> +		*plugin_used = 0;
> +	else
> +		*plugin_used = 1;
> +
> +	return fd;
> +}
> +
> +void *v4l2_plugin_mmap(int *plugin_used, void *start, size_t length, int prot,
> +					int flags, int fd, int64_t offset)
> +{
> +	int index, i;
> +	void *result = NULL;
> +	void *plugin_library = NULL;
> +	struct libv4l2_dev_ops *libv4l2_plugin = NULL;
> +
> +	pthread_mutex_lock(&v4l2_open_mutex);
> +	for (index = 0; index<  V4L2_MAX_DEVICES; index++)
> +		if (devices[index].fd == fd) {
> +			plugin_library = devices[index].plugin_library;
> +			libv4l2_plugin =&(devices[index].dev_ops);
> +			break;
> +		}
> +

Please remove the walking of the devices array here, instead pass
int the index into the devices array as an additional argument.

Also I don't think it is necessary to take the open lock here, taking
the stream lock to avoid multiple mmap's on the same device using the
same frame_pointers slot should be enough. The taking of the stream
lock should be done by the caller, not this function (as some callers
will already have the lock).

Last I think that this function should increase devices[index].open_count
when it filling slot 0 of frame_pointers, so that the devices slot for
this fd does not get reused as long as there are

> +	if (fd == -1 || index == V4L2_MAX_DEVICES ||
> +				libv4l2_plugin == NULL ||
> +				libv4l2_plugin->mmap == NULL) {
> +		*plugin_used = 0;
> +	} else {
> +		for (i = 0; i<  V4L2_MAX_NO_FRAMES; i++)
> +			if (devices[index].frame_pointers[i] == MAP_FAILED)
> +				break;
> +
> +		if (i == V4L2_MAX_NO_FRAMES) {
> +			*plugin_used = 0;
> +			result = NULL;
> +			goto leave;
> +		}
> +
> +		result = libv4l2_plugin->mmap(start, length, prot,
> +						flags, fd, offset);
> +		if (result) {
> +			devices[index].frame_pointers[i] = result;
> +			devices[index].frame_sizes[i] = length;
> +			*plugin_used = 1;
> +		} else {
> +			*plugin_used = 0;
> +		}
> +	}
> +
> +leave:
> +	pthread_mutex_unlock(&v4l2_open_mutex);
> +
> +	return result;
> +}
> +
> +int v4l2_plugin_munmap(int *plugin_used, void *_start, size_t length)
> +{
> +	int index, map, result = 0;
> +	void *plugin_library = NULL;
> +	struct libv4l2_dev_ops *libv4l2_plugin = NULL;
> +
> +	pthread_mutex_lock(&v4l2_open_mutex);
> +	for (index = 0; index<  V4L2_MAX_DEVICES; index++) {
> +		for (map = 0; map<  V4L2_MAX_NO_FRAMES; map++) {
> +			if (devices[index].frame_pointers[map] == _start&&
> +				devices[index].frame_sizes[map] == length) {
> +
> +				plugin_library = devices[index].plugin_library;
> +				libv4l2_plugin =&(devices[index].dev_ops);
> +				devices[index].frame_pointers[map] = MAP_FAILED;
> +				devices[index].frame_sizes[map] = 0;
> +				break;
> +			}
> +		}
> +		if (plugin_library)
> +			break;
> +	}
> +
> +	if (plugin_library) {
> +		result = libv4l2_plugin->munmap(_start, length);
> +
> +		if (result)
> +			*plugin_used = 0;
> +		else
> +			*plugin_used = 1;
> +

I'm not sure why you are checking for result here, if the address came
from the plugin, it should be munmapped by the plugin. If for some reason the plugin
fails to munmap, we should just pass that failure on to the user and not try
a regular munmap instead. IOW I believe the *plugin_used = 1; should be done
unconditionally here.

> +	} else {
> +		*plugin_used = 0;
> +	}
> +
> +	pthread_mutex_unlock(&v4l2_open_mutex);
> +
> +	return result;
> +}
> +



> +LIBV4L_PUBLIC void libv4l2_set_plugindata(int fd, void *plugin_data)
> +{
> +	int index;
> +
> +	pthread_mutex_lock(&v4l2_open_mutex);
> +	for (index = 0; index<  V4L2_MAX_DEVICES; index++)
> +		if (devices[index].fd == fd)
> +			break;
> +
> +	/* We have no info about this fd - reserve an empty slot */
> +	if (index == V4L2_MAX_DEVICES) {
> +		for (index = 0; index<  V4L2_MAX_DEVICES; index++)
> +			if (devices[index].fd == -1)
> +				break;
> +	}
> +	pthread_mutex_unlock(&v4l2_open_mutex);
> +
> +	if (index == V4L2_MAX_DEVICES) {
> +		V4L2_LOG_ERR("store private data for more than %d plugins\n",
> +			V4L2_MAX_DEVICES);
> +		return;
> +	}
> +
> +	pthread_mutex_lock(&v4l2_open_mutex);
> +	devices[index].fd = fd;
> +	devices[index].plugin_data = plugin_data;
> +	pthread_mutex_unlock(&v4l2_open_mutex);
> +}
> +
> +LIBV4L_PUBLIC void *libv4l2_get_plugindata(int fd)
> +{
> +	int index;
> +	void *result = NULL;
> +
> +	pthread_mutex_lock(&v4l2_open_mutex);
> +	for (index = 0; index<  V4L2_MAX_DEVICES; index++)
> +		if (devices[index].fd == fd) {
> +			result = devices[index].plugin_data;
> +			break;
> +		}
> +	pthread_mutex_unlock(&v4l2_open_mutex);
> +
> +	return result;
> +}
> diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
> index e251085..820c8ae 100644
> --- a/lib/libv4l2/v4l2convert.c
> +++ b/lib/libv4l2/v4l2convert.c
> @@ -31,6 +31,8 @@
>   #include "../libv4lconvert/libv4lsyscall-priv.h"
>   #include<linux/videodev2.h>
>   #include<libv4l2.h>
> +#include "libv4l2-plugin.h"
> +#include "libv4l2-priv.h"
>
>   /* Check that open/read/mmap is not a define */
>   #if defined open || defined read || defined mmap
> @@ -45,10 +47,27 @@
>
>   LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
>   {
> -	int fd;
> +	int fd, plugin_used;
>   	struct v4l2_capability cap;
>   	int v4l_device = 0;
>
> +	if (oflag&  O_CREAT) {
> +		va_list ap;
> +		mode_t mode;
> +
> +		va_start(ap, oflag);
> +		mode = va_arg(ap, mode_t);
> +
> +		fd = v4l2_plugin_open(&plugin_used, file, oflag, mode);
> +
> +		va_end(ap);
> +	} else {
> +		fd = v4l2_plugin_open(&plugin_used, file, oflag, 0);
> +	}
> +
> +	if (plugin_used)
> +		return fd;
> +
>   	/* check if we're opening a video4linux2 device */
>   	if (!strncmp(file, "/dev/video", 10) || !strncmp(file, "/dev/v4l/", 9)) {
>   		/* Some apps open the device read only, but we need rw rights as the
> @@ -86,7 +105,7 @@ LIBV4L_PUBLIC int open(const char *file, int oflag, ...)
>
>   	/* Try to Register with libv4l2 (in case of failure pass the fd to the
>   	   application as is) */
> -	v4l2_fd_open(fd, 0);
> +	v4l2_fd_open(fd, NULL, 0);
>
>   	return fd;
>   }
> diff --git a/lib/libv4lconvert/control/libv4lcontrol-priv.h b/lib/libv4lconvert/control/libv4lcontrol-priv.h
> index 22cdf34..3a392e4 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol-priv.h
> +++ b/lib/libv4lconvert/control/libv4lcontrol-priv.h
> @@ -22,6 +22,8 @@
>   #ifndef __LIBV4LCONTROL_PRIV_H
>   #define __LIBV4LCONTROL_PRIV_H
>
> +#include "libv4l2-plugin.h"
> +
>   #define V4LCONTROL_SHM_SIZE 4096
>
>   #define V4LCONTROL_SUPPORTS_NEXT_CTRL 0x01
> @@ -37,6 +39,7 @@ struct v4lcontrol_data {
>   	unsigned int *shm_values; /* shared memory control value store */
>   	unsigned int old_values[V4LCONTROL_COUNT]; /* for controls_changed() */
>   	const struct v4lcontrol_flags_info *flags_info;
> +	struct libv4l2_dev_ops *dev_ops;
>   };
>
>   struct v4lcontrol_flags_info {
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
> index d91d8e6..6e12e59 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.c
> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
> @@ -679,7 +679,8 @@ static void v4lcontrol_get_flags_from_db(struct v4lcontrol_data *data,
>   		}
>   }
>
> -struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
> +struct v4lcontrol_data *v4lcontrol_create(int fd,
> +		struct libv4l2_dev_ops *dev_ops, int always_needs_conversion)
>   {
>   	int shm_fd;
>   	int i, rc, got_usb_ids, init = 0;
> @@ -699,10 +700,11 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
>   	}
>
>   	data->fd = fd;
> +	data->dev_ops = dev_ops;
>
>   	/* Check if the driver has indicated some form of flipping is needed */
> -	if ((SYS_IOCTL(data->fd, VIDIOC_G_INPUT,&input.index) == 0)&&
> -			(SYS_IOCTL(data->fd, VIDIOC_ENUMINPUT,&input) == 0)) {
> +	if ((data->dev_ops->ioctl(data->fd, VIDIOC_G_INPUT,&input.index) == 0)&&
> +			(data->dev_ops->ioctl(data->fd, VIDIOC_ENUMINPUT,&input) == 0)) {
>   		if (input.status&  V4L2_IN_ST_HFLIP)
>   			data->flags |= V4LCONTROL_HFLIPPED;
>   		if (input.status&  V4L2_IN_ST_VFLIP)
> @@ -719,7 +721,7 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
>   		data->flags = strtol(s, NULL, 0);
>
>   	ctrl.id = V4L2_CTRL_FLAG_NEXT_CTRL;
> -	if (SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL,&ctrl) == 0)
> +	if (data->dev_ops->ioctl(data->fd, VIDIOC_QUERYCTRL,&ctrl) == 0)
>   		data->priv_flags |= V4LCONTROL_SUPPORTS_NEXT_CTRL;
>
>   	/* If the device always needs conversion, we can add fake controls at no cost
> @@ -727,7 +729,7 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
>   	if (always_needs_conversion || v4lcontrol_needs_conversion(data)) {
>   		for (i = 0; i<  V4LCONTROL_AUTO_ENABLE_COUNT; i++) {
>   			ctrl.id = fake_controls[i].id;
> -			rc = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL,&ctrl);
> +			rc = data->dev_ops->ioctl(data->fd, VIDIOC_QUERYCTRL,&ctrl);
>   			if (rc == -1 || (rc == 0&&  (ctrl.flags&  V4L2_CTRL_FLAG_DISABLED)))
>   				data->controls |= 1<<  i;
>   		}
> @@ -739,17 +741,17 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
>   	   different sensors with / without autogain or the necessary controls. */
>   	while (data->flags&  V4LCONTROL_WANTS_AUTOGAIN) {
>   		ctrl.id = V4L2_CID_AUTOGAIN;
> -		rc = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL,&ctrl);
> +		rc = data->dev_ops->ioctl(data->fd, VIDIOC_QUERYCTRL,&ctrl);
>   		if (rc == 0&&  !(ctrl.flags&  V4L2_CTRL_FLAG_DISABLED))
>   			break;
>
>   		ctrl.id = V4L2_CID_EXPOSURE;
> -		rc = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL,&ctrl);
> +		rc = data->dev_ops->ioctl(data->fd, VIDIOC_QUERYCTRL,&ctrl);
>   		if (rc != 0 || (ctrl.flags&  V4L2_CTRL_FLAG_DISABLED))
>   			break;
>
>   		ctrl.id = V4L2_CID_GAIN;
> -		rc = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL,&ctrl);
> +		rc = data->dev_ops->ioctl(data->fd, VIDIOC_QUERYCTRL,&ctrl);
>   		if (rc != 0 || (ctrl.flags&  V4L2_CTRL_FLAG_DISABLED))
>   			break;
>
> @@ -766,7 +768,7 @@ struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion)
>   	if (data->controls == 0)
>   		return data; /* No need to create a shared memory segment */
>
> -	if (SYS_IOCTL(fd, VIDIOC_QUERYCAP,&cap)) {
> +	if (data->dev_ops->ioctl(fd, VIDIOC_QUERYCAP,&cap)) {
>   		perror("libv4lcontrol: error querying device capabilities");
>   		goto error;
>   	}
> @@ -952,7 +954,7 @@ int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data *data, void *arg)
>   		}
>
>   	/* find out what the kernel driver would respond. */
> -	retval = SYS_IOCTL(data->fd, VIDIOC_QUERYCTRL, arg);
> +	retval = data->dev_ops->ioctl(data->fd, VIDIOC_QUERYCTRL, arg);
>
>   	if ((data->priv_flags&  V4LCONTROL_SUPPORTS_NEXT_CTRL)&&
>   			(orig_id&  V4L2_CTRL_FLAG_NEXT_CTRL)) {
> @@ -989,7 +991,7 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *data, void *arg)
>   			return 0;
>   		}
>
> -	return SYS_IOCTL(data->fd, VIDIOC_G_CTRL, arg);
> +	return data->dev_ops->ioctl(data->fd, VIDIOC_G_CTRL, arg);
>   }
>
>   int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg)
> @@ -1010,7 +1012,7 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg)
>   			return 0;
>   		}
>
> -	return SYS_IOCTL(data->fd, VIDIOC_S_CTRL, arg);
> +	return data->dev_ops->ioctl(data->fd, VIDIOC_S_CTRL, arg);
>   }
>
>   int v4lcontrol_get_flags(struct v4lcontrol_data *data)
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.h b/lib/libv4lconvert/control/libv4lcontrol.h
> index 974e97a..770804a 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.h
> +++ b/lib/libv4lconvert/control/libv4lcontrol.h
> @@ -22,6 +22,8 @@
>   #ifndef __LIBV4LCONTROL_H
>   #define __LIBV4LCONTROL_H
>
> +#include "libv4l2-plugin.h"
> +
>   /* Flags */
>   #define V4LCONTROL_HFLIPPED              0x01
>   #define V4LCONTROL_VFLIPPED              0x02
> @@ -47,7 +49,8 @@ enum {
>
>   struct v4lcontrol_data;
>
> -struct v4lcontrol_data *v4lcontrol_create(int fd, int always_needs_conversion);
> +struct v4lcontrol_data *v4lcontrol_create(int fd,
> +		struct libv4l2_dev_ops *dev_ops, int always_needs_conversion);
>   void v4lcontrol_destroy(struct v4lcontrol_data *data);
>
>   /* Functions used by v4lprocessing to get the control state */
> diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
> index d8fe899..0b1e3e7 100644
> --- a/lib/libv4lconvert/libv4lconvert-priv.h
> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
> @@ -65,6 +65,7 @@ struct v4lconvert_data {
>   	unsigned char *convert_pixfmt_buf;
>   	struct v4lcontrol_data *control;
>   	struct v4lprocessing_data *processing;
> +	struct libv4l2_dev_ops *dev_ops;
>
>   	/* Data for external decompression helpers code */
>   	pid_t decompress_pid;
> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
> index 0d8b29f..c27401f 100644
> --- a/lib/libv4lconvert/libv4lconvert.c
> +++ b/lib/libv4lconvert/libv4lconvert.c
> @@ -91,7 +91,8 @@ static const int v4lconvert_crop_res[][2] = {
>   	{ 176, 144 },
>   };
>
> -struct v4lconvert_data *v4lconvert_create(int fd)
> +struct v4lconvert_data *v4lconvert_create(int fd,
> +		struct libv4l2_dev_ops *dev_ops)
>   {
>   	int i, j;
>   	struct v4lconvert_data *data = calloc(1, sizeof(struct v4lconvert_data));
> @@ -107,6 +108,7 @@ struct v4lconvert_data *v4lconvert_create(int fd)
>   	}
>
>   	data->fd = fd;
> +	data->dev_ops = dev_ops;
>   	data->decompress_pid = -1;
>
>   	/* Check supported formats */
> @@ -115,7 +117,7 @@ struct v4lconvert_data *v4lconvert_create(int fd)
>
>   		fmt.index = i;
>
> -		if (SYS_IOCTL(data->fd, VIDIOC_ENUM_FMT,&fmt))
> +		if (data->dev_ops->ioctl(data->fd, VIDIOC_ENUM_FMT,&fmt))
>   			break;
>
>   		for (j = 0; j<  ARRAY_SIZE(supported_src_pixfmts); j++)
> @@ -134,7 +136,7 @@ struct v4lconvert_data *v4lconvert_create(int fd)
>   	data->no_formats = i;
>
>   	/* Check if this cam has any special flags */
> -	if (SYS_IOCTL(data->fd, VIDIOC_QUERYCAP,&cap) == 0) {
> +	if (data->dev_ops->ioctl(data->fd, VIDIOC_QUERYCAP,&cap) == 0) {
>   		if (!strcmp((char *)cap.driver, "uvcvideo"))
>   			data->flags |= V4LCONVERT_IS_UVC;
>
> @@ -142,7 +144,7 @@ struct v4lconvert_data *v4lconvert_create(int fd)
>   			always_needs_conversion = 0;
>   	}
>
> -	data->control = v4lcontrol_create(fd, always_needs_conversion);
> +	data->control = v4lcontrol_create(fd, dev_ops, always_needs_conversion);
>   	if (!data->control) {
>   		free(data);
>   		return NULL;
> @@ -205,7 +207,7 @@ int v4lconvert_enum_fmt(struct v4lconvert_data *data, struct v4l2_fmtdesc *fmt)
>   	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
>   			(!v4lconvert_supported_dst_fmt_only(data)&&
>   			fmt->index<  data->no_formats))
> -		return SYS_IOCTL(data->fd, VIDIOC_ENUM_FMT, fmt);
> +		return data->dev_ops->ioctl(data->fd, VIDIOC_ENUM_FMT, fmt);
>
>   	for (i = 0; i<  ARRAY_SIZE(supported_dst_pixfmts); i++)
>   		if (v4lconvert_supported_dst_fmt_only(data) ||
> @@ -313,7 +315,7 @@ static int v4lconvert_do_try_format(struct v4lconvert_data *data,
>   		try_fmt = *dest_fmt;
>   		try_fmt.fmt.pix.pixelformat = supported_src_pixfmts[i].fmt;
>
> -		if (!SYS_IOCTL(data->fd, VIDIOC_TRY_FMT,&try_fmt)) {
> +		if (!data->dev_ops->ioctl(data->fd, VIDIOC_TRY_FMT,&try_fmt)) {
>   			if (try_fmt.fmt.pix.pixelformat == supported_src_pixfmts[i].fmt) {
>   				int size_x_diff = abs((int)try_fmt.fmt.pix.width -
>   						(int)dest_fmt->fmt.pix.width);
> @@ -381,7 +383,7 @@ int v4lconvert_try_format(struct v4lconvert_data *data,
>   	if (!v4lconvert_supported_dst_format(dest_fmt->fmt.pix.pixelformat) ||
>   			dest_fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
>   			v4lconvert_do_try_format(data,&try_dest,&try_src)) {
> -		result = SYS_IOCTL(data->fd, VIDIOC_TRY_FMT, dest_fmt);
> +		result = data->dev_ops->ioctl(data->fd, VIDIOC_TRY_FMT, dest_fmt);
>   		if (src_fmt)
>   			*src_fmt = *dest_fmt;
>   		return result;
> @@ -1236,7 +1238,7 @@ static void v4lconvert_get_framesizes(struct v4lconvert_data *data,
>
>   	for (i = 0; ; i++) {
>   		frmsize.index = i;
> -		if (SYS_IOCTL(data->fd, VIDIOC_ENUM_FRAMESIZES,&frmsize))
> +		if (data->dev_ops->ioctl(data->fd, VIDIOC_ENUM_FRAMESIZES,&frmsize))
>   			break;
>
>   		/* We got a framesize, check we don't have the same one already */
> @@ -1296,7 +1298,7 @@ int v4lconvert_enum_framesizes(struct v4lconvert_data *data,
>   			errno = EINVAL;
>   			return -1;
>   		}
> -		return SYS_IOCTL(data->fd, VIDIOC_ENUM_FRAMESIZES, frmsize);
> +		return data->dev_ops->ioctl(data->fd, VIDIOC_ENUM_FRAMESIZES, frmsize);
>   	}
>
>   	if (frmsize->index>= data->no_framesizes) {
> @@ -1332,7 +1334,8 @@ int v4lconvert_enum_frameintervals(struct v4lconvert_data *data,
>   			errno = EINVAL;
>   			return -1;
>   		}
> -		res = SYS_IOCTL(data->fd, VIDIOC_ENUM_FRAMEINTERVALS, frmival);
> +		res = data->dev_ops->ioctl(data->fd, VIDIOC_ENUM_FRAMEINTERVALS,
> +				frmival);
>   		if (res)
>   			V4LCONVERT_ERR("%s\n", strerror(errno));
>   		return res;
> @@ -1377,7 +1380,7 @@ int v4lconvert_enum_frameintervals(struct v4lconvert_data *data,
>   	frmival->pixel_format = src_fmt.fmt.pix.pixelformat;
>   	frmival->width = src_fmt.fmt.pix.width;
>   	frmival->height = src_fmt.fmt.pix.height;
> -	res = SYS_IOCTL(data->fd, VIDIOC_ENUM_FRAMEINTERVALS, frmival);
> +	res = data->dev_ops->ioctl(data->fd, VIDIOC_ENUM_FRAMEINTERVALS, frmival);
>   	if (res) {
>   		int dest_pixfmt = dest_fmt.fmt.pix.pixelformat;
>   		int src_pixfmt  = src_fmt.fmt.pix.pixelformat;

Thanks & Regards,

Hans
