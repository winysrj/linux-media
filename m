Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:56518 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZAQMeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 07:34:09 -0500
Received: by mu-out-0910.google.com with SMTP id g7so1033034muf.1
        for <linux-media@vger.kernel.org>; Sat, 17 Jan 2009 04:34:05 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Jan 2009 07:34:05 -0500
Message-ID: <de8cad4d0901170434g62a3453by1e6970c0b6f60f66@mail.gmail.com>
Subject: Compile warning for CX18 / v4l2-common Ubuntu 8.10
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: linux-media@vger.kernel.org, Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A pull from v4l-dvb today:

Kernel build directory is /lib/modules/2.6.27-7-generic/build
make -C /lib/modules/2.6.27-7-generic/build
SUBDIRS=/root/drivers/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.27-7-generic'
...
/opt/drivers/v4l-dvb/v4l/cx18-driver.c: In function 'cx18_request_module':
/opt/drivers/v4l-dvb/v4l/cx18-driver.c:735: warning: format not a
string literal and no format arguments

  CC [M]  /root/drivers/v4l-dvb/v4l/v4l2-common.o
/root/drivers/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_ctrl_query_fill':
/root/drivers/v4l-dvb/v4l/v4l2-common.c:559: warning: format not a
string literal and no format arguments
/root/drivers/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_ctrl_query_menu':
/root/drivers/v4l-dvb/v4l/v4l2-common.c:724: warning: format not a
string literal and no format arguments
/root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
'v4l2_ctrl_query_menu_valid_items':
/root/drivers/v4l-dvb/v4l/v4l2-common.c:742: warning: format not a
string literal and no format arguments
/root/drivers/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_i2c_new_subdev':
/root/drivers/v4l-dvb/v4l/v4l2-common.c:947: warning: format not a
string literal and no format arguments
/root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
'v4l2_i2c_new_probed_subdev':
/root/drivers/v4l-dvb/v4l/v4l2-common.c:1008: warning: format not a
string literal and no format arguments

Thanks,

Brandon
