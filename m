Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32844 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1EAB3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 21:29:05 -0400
Received: by gyd10 with SMTP id 10so1627398gyd.19
        for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 18:29:03 -0700 (PDT)
Message-ID: <4DBCB758.2000303@gmail.com>
Date: Sat, 30 Apr 2011 22:28:56 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Colin Minihan <colin.minihan@gmail.com>
CC: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Subject: Re: Build Failure
References: <BANLkTikBm0gmNd8oQ6CN+cAEbYhWEGvWPA@mail.gmail.com>	 <BANLkTim9vtBAE1dbOXAwW2Crh7aiMucD3w@mail.gmail.com> <1304179815.2434.10.camel@localhost>
In-Reply-To: <1304179815.2434.10.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-04-2011 13:10, Andy Walls escreveu:
> On Sat, 2011-04-30 at 10:31 -0400, Colin Minihan wrote:
>> On Ubuntu 10.04 attempting to run
>>
>> git clone git://linuxtv.org/media_build.git
>> cd media_build
>> ./check_needs.pl
>> make -C linux/ download
>> make -C linux/ untar
>> make stagingconfig
>> make
>>
>>  results in the following failure
>> ...
>>   CC [M]  /home/colm/media_build/v4l/lirc_zilog.o
>> /home/colm/media_build/v4l/lirc_zilog.c: In function 'destroy_rx_kthread':
>> /home/colm/media_build/v4l/lirc_zilog.c:238: error: implicit
>> declaration of function 'IS_ERR_OR_NULL'
> 
> Well, IS_ERR_OR_NULL() went into the kernel in December 2009:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=603c4ba96be998a8dd7a6f9b23681c49acdf4b64
> 
> so it should be in kernel version 2.6.33 and later.

This is defined at include/linux/err.h as:

#define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)

static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
{
	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
}

> 
> If you don't want to generate a patch for the media_build backward
> compatability build system, you can probably just patch your kernel
> header file or trivially hack the function it into 
> 
> 	drivers/staging/lirc/lirc_zilog.c
> 
> to get past your current build error.  But I suspect you'll run into
> more errors.  When I make changes to a module (like lirc_zilog.c), I
> tend to use the latest kernel interfaces at the time of the changes.
> 
> If you don't need lirc_zilog.ko built, then configure the build system
> to not build the module.

To make it work, it is probably as simple as adding this into v4l/compat.h:

#if NEED_IS_ERR_OR_NULL
#define IS_ERR_OR_NULL(ptr) (!(ptr) || IS_ERR_VALUE((unsigned long)(ptr)))
#endif


And:

check_file_for_func("include/linux/err.h", "IS_ERR_OR_NULL", "NEED_IS_ERR_OR_NULL");

at v4l/scripts/make_config_compat.pl,

as the enclosed (not tested) patch.

Please test it and, if it wors, ping us for its inclusion at media_tree.git. Otherwise,
feel free to fix it and submit us the fix.

Thanks!
Mauro

---

Add backward support for IS_ERR_OR_NULL

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/v4l/compat.h b/v4l/compat.h
index bc8d71f..9dbe54f 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -796,4 +796,8 @@ static inline int snd_ctl_enum_info(struct snd_ctl_elem_info *info, unsigned int
 #define usleep_range(min, max) msleep(min/1000)
 #endif
 
+#if NEED_IS_ERR_OR_NULL
+#define IS_ERR_OR_NULL(ptr) (!(ptr) || IS_ERR_VALUE((unsigned long)(ptr)))
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index a426134..01f6c30 100755
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -492,6 +492,7 @@ sub check_other_dependencies()
 	check_file_for_func("include/sound/control.h", "snd_ctl_enum_info", "NEED_SND_CTL_ENUM_INFO");
 	check_file_for_func("include/linux/sysfs.h", "sysfs_attr_init", "NEED_SYSFS_ATTR_INIT");
 	check_file_for_func("include/linux/delay.h", "usleep_range", "NEED_USLEEP_RANGE");
+	check_file_for_func("include/linux/err.h", "IS_ERR_OR_NULL", "NEED_IS_ERR_OR_NULL");
 }
 
 # Do the basic rules
