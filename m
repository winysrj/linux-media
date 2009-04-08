Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:49834 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZDHXLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 19:11:50 -0400
Received: by fk-out-0910.google.com with SMTP id 18so163374fkq.5
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2009 16:11:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <61526.207.214.87.58.1239228654.squirrel@webmail.xs4all.nl>
References: <61526.207.214.87.58.1239228654.squirrel@webmail.xs4all.nl>
Date: Thu, 9 Apr 2009 03:11:48 +0400
Message-ID: <208cbae30904081611p604ec790kbbd2fac4daf358c3@mail.gmail.com>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,
	2.6.16-2.6.21: WARNINGS
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 9, 2009 at 2:10 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Can someone take a look at these warnings and errors? Looking at the log
> these seem to be pretty easy to fix (compat stuff for the most part).
>
> I don't have the time for this for several more days, so I'd appreciate it
> if someone could take a look at this for me.
>
> Thanks,
>
>        Hans

Well, i already posted about problems with compat.h and usb_endpoint_type.
The subject was "trouble with v4l-dvb compilation, compat.h:
redefinition of 'usb_endpoint_type". Here it is:
http://www.spinics.net/lists/linux-media/msg03965.html

I wish i know how to patch that thing right but i don't know that.
My cuurent workaroung for that is:

diff -r 77ebdc14cc24 v4l/compat.h
--- a/v4l/compat.h      Wed Apr 08 14:01:19 2009 -0300
+++ b/v4l/compat.h      Thu Apr 09 03:08:07 2009 +0400
@@ -392,11 +392,13 @@
 }
 #endif

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
 #ifdef NEED_USB_ENDPOINT_TYPE
 static inline int usb_endpoint_type(const struct usb_endpoint_descriptor *epd)
 {
        return epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
 }
+#endif
 #endif
 #endif /* __LINUX_USB_H */

but as i i understand it's bad. If someone can repair it correctly it
will be cool.

-- 
Best regards, Klimov Alexey
