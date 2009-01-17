Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58882 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779AbZAQOfo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 09:35:44 -0500
Subject: Re: Compile warning for CX18 / v4l2-common Ubuntu 8.10
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <de8cad4d0901170434g62a3453by1e6970c0b6f60f66@mail.gmail.com>
References: <de8cad4d0901170434g62a3453by1e6970c0b6f60f66@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 09:35:00 -0500
Message-Id: <1232202900.2951.26.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-01-17 at 07:34 -0500, Brandon Jenkins wrote:
> A pull from v4l-dvb today:
> 
> Kernel build directory is /lib/modules/2.6.27-7-generic/build
> make -C /lib/modules/2.6.27-7-generic/build
> SUBDIRS=/root/drivers/v4l-dvb/v4l  modules
> make[2]: Entering directory `/usr/src/linux-headers-2.6.27-7-generic'
> ...
> /opt/drivers/v4l-dvb/v4l/cx18-driver.c: In function 'cx18_request_module':
> /opt/drivers/v4l-dvb/v4l/cx18-driver.c:735: warning: format not a
> string literal and no format arguments
> 
>   CC [M]  /root/drivers/v4l-dvb/v4l/v4l2-common.o
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_ctrl_query_fill':
> /root/drivers/v4l-dvb/v4l/v4l2-common.c:559: warning: format not a
> string literal and no format arguments
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_ctrl_query_menu':
> /root/drivers/v4l-dvb/v4l/v4l2-common.c:724: warning: format not a
> string literal and no format arguments
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
> 'v4l2_ctrl_query_menu_valid_items':
> /root/drivers/v4l-dvb/v4l/v4l2-common.c:742: warning: format not a
> string literal and no format arguments
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_i2c_new_subdev':
> /root/drivers/v4l-dvb/v4l/v4l2-common.c:947: warning: format not a
> string literal and no format arguments
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
> 'v4l2_i2c_new_probed_subdev':
> /root/drivers/v4l-dvb/v4l/v4l2-common.c:1008: warning: format not a
> string literal and no format arguments

First, they are just warnings, so everything still builds right?

Second, yes these calls appear to be mildly abusing the format argument
of snprintf() and request_module().  These are declared as


extern int snprintf(char * buf, size_t size, const char * fmt, ...)
        __attribute__ ((format (printf, 3, 4)));

extern int request_module(const char * name, ...) __attribute__ ((format
(printf, 1, 2)));


Note the attribute flag that tells the compiler it may want to do some
extra checking of the arguments - they are like printf()'s arguments.
The "problem" is that we're not calling them like printf() should be
called.

With a "char *" variable "foo", we do something like

	printf(foo);

instead of 

	printf("%s", foo);

which is what the warnings are griping about.  The __attribute__ is
telling the compiler that the format argument should be string constant.

For the cx18 module, one should be able to make it go away with:

diff -r 262c623d8a28 linux/drivers/media/video/cx18/cx18-driver.c
--- a/linux/drivers/media/video/cx18/cx18-driver.c	Sat Jan 17 08:59:31 2009 -0500
+++ b/linux/drivers/media/video/cx18/cx18-driver.c	Sat Jan 17 09:30:28 2009 -0500
@@ -733,7 +733,7 @@
 {
 	if ((hw & id) == 0)
 		return hw;
-	if (request_module(name) != 0) {
+	if (request_module("%s", name) != 0) {
 		CX18_ERR("Failed to load module %s\n", name);
 		return hw & ~id;
 	}


Signed-off-by: Andy Walls <awalls@radix.net>

Please test as an SOB line doesn't mean that the patch compiles or
works. ;)   I don't normally get those warnings so my setup may be a
little different/lax.

Regards,
Andy


> Thanks,
> 
> Brandon


