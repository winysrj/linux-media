Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3407 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbZFINEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 09:04:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address lists on the fly
Date: Tue, 9 Jun 2009 15:04:36 +0200
Cc: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
References: <200906061500.49338.hverkuil@xs4all.nl> <20090608143932.36cd1b4f@hyperion.delvare>
In-Reply-To: <20090608143932.36cd1b4f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906091504.37330.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 08 June 2009 14:39:32 Jean Delvare wrote:
> Hi Hans,
>
> On Sat, 6 Jun 2009 15:00:48 +0200, Hans Verkuil wrote:
> > For video4linux we sometimes need to probe for a single i2c address.
> > Normally you would do it like this:
> >
> > static const unsigned short addrs[] = {
> > 	addr, I2C_CLIENT_END
> > };
> >
> > client = i2c_new_probed_device(adapter, &info, addrs);
> >
> > This is a bit awkward and I came up with this macro:
> >
> > #define V4L2_I2C_ADDRS(addr, addrs...) \
> >         ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
> >
> > This can construct a list of one or more i2c addresses on the fly. But
> > this is something that really belongs in i2c.h, renamed to I2C_ADDRS.
> >
> > With this macro we can just do:
> >
> > client = i2c_new_probed_device(adapter, &info, I2C_ADDRS(addr));
> >
> > Comments?
>
> I'm not a big fan of macros which hide how things work, but if this
> makes your life easier, why not. Just send a patch and I'll queue it up
> for 2.6.31.

Hi Jean,

Here it is:

--- linux-git/include/linux/i2c.h.orig	2009-06-09 14:53:32.000000000 +0200
+++ linux-git/include/linux/i2c.h	2009-06-09 15:03:24.000000000 +0200
@@ -412,6 +412,10 @@
 /* The numbers to use to set I2C bus address */
 #define ANY_I2C_BUS		0xffff
 
+/* Construct an I2C_CLIENT_END-terminated array of i2c addresses */
+#define I2C_ADDRS(addr, addrs...) \
+	((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
+
 
 /* ----- functions exported by i2c.o */
 

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Note that this can also be used to initialize an array:

static const unsigned short addrs[] = I2C_ADDRS(0x2a, 0x2c);

Whether you want to is another matter, but it works. This functionality is 
also available in the oldest supported gcc (3.2).

Thanks,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
