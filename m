Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:56892 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZHaFvb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 01:51:31 -0400
Message-ID: <4A9B64E0.9040003@freemail.hu>
Date: Mon, 31 Aug 2009 07:51:28 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] libv4l: add NULL pointer check
References: <4A9A3EB0.8060304@freemail.hu> <200908302333.20933.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200908302333.20933.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> On Sunday 30 August 2009 10:56:16 Németh Márton wrote:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> Add NULL pointer check before the pointers are dereferenced.
> 
> Applications are not supposed to pass NULL pointers to those functions. It 
> would be an API violation. Instead of silently failing a segfault is better.

Actually we cannot speak about API violation because the behaviour when
passing NULL pointer as ioctl() argument is not defined as of V4L2 API
revision 0.29 available from http://linuxtv.org/hg/v4l-dvb/ . The current
implemention in Linux in kernel space is to return -EACCESS.

I don't really agree with the segfault behaviour, because:

 - currently there is a different behaviour when just using the V4L2
   interface and using the libv4l2 0.6.0. When using the kernel interface
   it is an error in kernelspace if a NULL pointer is dereferenced, thus
   kernel will return -EACCESS. When the libv4l2 0.6.0 is used then the
   behaviour changes: currently there is a segfault instead of getting
   a return value -1 and errno=EACCESS.

 - the segfault normally results that the whole calling process is
   killed. If there is a complex software like a browser, it is not
   very user friendly that the whole software crashes just because an
   implementation error in the V4L2 handling code.

 - currently a lot of V4L2 API ioctls() return -EINVAL or -EFAULT when
   passing NULL pointer as a parameter depending on whether the given
   ioctl is not supported at all or it is supported but there is a problem
   with the passed pointer, respectively. The use case for this would be
   that an application could easily scan for the supported and not supported
   V4L2 ioctls.

 - dereferencing a NULL pointer is not always result segfault, see [1] and
   [2]. So dereferencing a NULL pointer can be treated also as a security
   risk.

 - the patch I sent is only checking the pointer just before it is
   dereferenced. When the libv4l just passes the pointer value to the
   ioctl() then there is no additional check: this situation will be
   handled in kernel space.

These are my arguments. I am open to listen to your arguments.

I think that the final solution could be that the V4L2 API specification
defines what shall happen when NULL pointer is passed as an ioctl() argument.

References:
[1] Jonathan Corbet: Fun with NULL pointers, part 1 (July 20, 2009)
    http://lwn.net/Articles/342330/

[2] Jonathan Corbet: Fun with NULL pointers, part 2
    http://lwn.net/Articles/342420/

Regards,

	Márton Németh

