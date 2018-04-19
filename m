Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59477 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbeDSP2I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 11:28:08 -0400
Date: Thu, 19 Apr 2018 12:27:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>
Subject: Re: [PATCH RESEND 6/6] media: v4l2-compat-ioctl32: simplify casts
Message-ID: <20180419122755.38c01e58@vento.lan>
In-Reply-To: <c1cce70e-1f4e-42c1-9206-4aaf5c791b9f@xs4all.nl>
References: <cover.1524136402.git.mchehab@s-opensource.com>
        <ded5e6117f2763919d0755d594ee0cb2e2d479a4.1524136402.git.mchehab@s-opensource.com>
        <c1cce70e-1f4e-42c1-9206-4aaf5c791b9f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Apr 2018 13:37:52 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 04/19/18 13:15, Mauro Carvalho Chehab wrote:
> > Making the cast right for get_user/put_user is not trivial, as
> > it needs to ensure that the types are the correct ones.
> > 
> > Improve it by using macros.
> > 
> > Tested with vivid with:
> > 	$ sudo modprobe vivid no_error_inj=1
> > 	$ v4l2-compliance-32bits -a -s10 >32bits && v4l2-compliance-64bits -a -s10 > 64bits && diff -U0 32bits 64bits
> > 	--- 32bits	2018-04-17 11:18:29.141240772 -0300
> > 	+++ 64bits	2018-04-17 11:18:40.635282341 -0300
> > 	@@ -1 +1 @@
> > 	-v4l2-compliance SHA   : bc71e4a67c6fbc5940062843bc41e7c8679634ce, 32 bits
> > 	+v4l2-compliance SHA   : bc71e4a67c6fbc5940062843bc41e7c8679634ce, 64 bits
> > 
> > Using the latest version of v4l-utils with this patch applied:
> > 	https://patchwork.linuxtv.org/patch/48746/
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 40 ++++++++++++++++++---------
> >  1 file changed, 27 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > index 8c05dd9660d3..d2f0268427c2 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > @@ -30,6 +30,24 @@
> >  	get_user(__assign_tmp, from) || put_user(__assign_tmp, to);	\
> >  })
> >  
> > +#define get_user_cast(__x, __ptr)					\
> > +({									\
> > +	get_user(__x, (typeof(*__ptr) __user *)(__ptr));		\
> > +})
> > +
> > +#define put_user_force(__x, __ptr)					\
> > +({									\
> > +	put_user((typeof(*__x) __force *)(__x), __ptr);			\
> > +})
> > +
> > +#define assign_in_user_cast(to, from)					\
> > +({									\
> > +	typeof(*from) __assign_tmp;					\
> > +									\
> > +	get_user_cast(__assign_tmp, from) || put_user(__assign_tmp, to);\
> > +})  
> 
> Please add comments for these macros. It's not trivially obvious what they
> do and why they are needed.

Ok. Would the comments below be acceptable?

I may eventually post it as a separate patch, adding documentation to some
other functions (maybe adding it to some .rst file).

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index d2f0268427c2..9530661d9b43 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -22,7 +22,18 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-ioctl.h>
 
-/* Use the same argument order as copy_in_user */
+/**
+ * assign_in_user() - Copy from one __user var to another one
+ *
+ * @to: __user var where data will be stored
+ * @from: __user var were data will be retrieved.
+ *
+ * As this code very often needs to allocate userspace memory, it is easier
+ * to have a macro that will do both get_user() and put_user() at once.
+ *
+ * This function complements the macros defined at asm-generic/uaccess.h.
+ * It uses the same argument order as copy_in_user()
+ */
 #define assign_in_user(to, from)					\
 ({									\
 	typeof(*from) __assign_tmp;					\
@@ -30,16 +41,57 @@
 	get_user(__assign_tmp, from) || put_user(__assign_tmp, to);	\
 })
 
+/**
+ * get_user_cast() - Stores at a kernelspace local var the contents from a
+ *		pointer with userspace data that is not tagged with __user.
+ *
+ * @__x: var where data will be stored
+ * @ptr: var were data will be retrieved.
+ *
+ * Sometimes, we need to declare a pointer without __user, because it
+ * comes from a pointer struct field that will be retrieved from userspace
+ * by the 64-bit native ioctl handler. This function ensures that the
+ * @ptr will be casted to __user before calling get_user(), in order to
+ * avoid warnings with static code analyzers like smatch.
+ */
 #define get_user_cast(__x, __ptr)					\
 ({									\
 	get_user(__x, (typeof(*__ptr) __user *)(__ptr));		\
 })
 
+/**
+ * put_user_force() - Stores at the contents of a kernelspace local var
+ *		      into an userspace pointer, removing any __user cast.
+ *
+ * @__x: var where data will be stored
+ * @ptr: var were data will be retrieved.
+ *
+ * As the compat32 code now handles with 32-bits and 64-bits __user
+ * structs, sometimes we need to remove the __user atributes from some data,
+ * by passing __force macro. This function ensures that the
+ * @ptr will be casted with __force before calling put_user(), in order to
+ * avoid warnings with static code analyzers like smatch.
+ */
 #define put_user_force(__x, __ptr)					\
 ({									\
 	put_user((typeof(*__x) __force *)(__x), __ptr);			\
 })
 
+/**
+ * assign_in_user_cast() - Copy from one __user var to another one
+ *
+ * @to: __user var where data will be stored
+ * @from: var were data will be retrieved that needs to be cast to __user.
+ *
+ * As this code very often needs to allocate userspace memory, it is easier
+ * to have a macro that will do both get_user_cast() and put_user() at once.
+ *
+ * This function should be used instead of assign_in_user() when the @from
+ * variable was not declared as __user. See get_user_cast() for more details.
+ *
+ * This function complements the macros defined at asm-generic/uaccess.h.
+ * It uses the same argument order as copy_in_user()
+ */
 #define assign_in_user_cast(to, from)					\
 ({									\
 	typeof(*from) __assign_tmp;					\


Thanks,
Mauro
