Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2454 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbZAQOaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 09:30:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Subject: Re: Compile warning for CX18 / v4l2-common Ubuntu 8.10
Date: Sat, 17 Jan 2009 15:30:06 +0100
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@radix.net>
References: <de8cad4d0901170434g62a3453by1e6970c0b6f60f66@mail.gmail.com>
In-Reply-To: <de8cad4d0901170434g62a3453by1e6970c0b6f60f66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901171530.06887.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 17 January 2009 13:34:05 Brandon Jenkins wrote:
> A pull from v4l-dvb today:
>
> Kernel build directory is /lib/modules/2.6.27-7-generic/build
> make -C /lib/modules/2.6.27-7-generic/build
> SUBDIRS=/root/drivers/v4l-dvb/v4l  modules
> make[2]: Entering directory `/usr/src/linux-headers-2.6.27-7-generic'
> ...
> /opt/drivers/v4l-dvb/v4l/cx18-driver.c: In function
> 'cx18_request_module': /opt/drivers/v4l-dvb/v4l/cx18-driver.c:735:
> warning: format not a string literal and no format arguments
>
>   CC [M]  /root/drivers/v4l-dvb/v4l/v4l2-common.o
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
> 'v4l2_ctrl_query_fill': /root/drivers/v4l-dvb/v4l/v4l2-common.c:559:
> warning: format not a string literal and no format arguments
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
> 'v4l2_ctrl_query_menu': /root/drivers/v4l-dvb/v4l/v4l2-common.c:724:
> warning: format not a string literal and no format arguments
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
> 'v4l2_ctrl_query_menu_valid_items':
> /root/drivers/v4l-dvb/v4l/v4l2-common.c:742: warning: format not a
> string literal and no format arguments
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
> 'v4l2_i2c_new_subdev': /root/drivers/v4l-dvb/v4l/v4l2-common.c:947:
> warning: format not a string literal and no format arguments
> /root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
> 'v4l2_i2c_new_probed_subdev':
> /root/drivers/v4l-dvb/v4l/v4l2-common.c:1008: warning: format not a
> string literal and no format arguments

I've never seen these warnings, but they seem to be caused by 
snprintf(dst, size, src), without a proper format string. By itself 
harmless, but replacing it with strlcpy is better.

I did that for v4l2-common.c, but I don't see something similar in 
cx18_request_module.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
