Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39924 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750844AbdLSTUc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 14:20:32 -0500
Date: Tue, 19 Dec 2017 17:20:24 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] media: v4l2-ioctl.h: convert debug into an enum of
 bits
Message-ID: <20171219172024.695148f2@vento.lan>
In-Reply-To: <2448808.QM7caob540@avalon>
References: <cover.1513625884.git.mchehab@s-opensource.com>
        <20171219141235.mgiyoeeiyfn2z4zh@paasikivi.fi.intel.com>
        <20171219133758.6cf22460@vento.lan>
        <2448808.QM7caob540@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Dec 2017 19:17:12 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Tuesday, 19 December 2017 17:37:58 EET Mauro Carvalho Chehab wrote:
> > Em Tue, 19 Dec 2017 16:12:35 +0200 Sakari Ailus escreveu:  
> > > On Tue, Dec 19, 2017 at 04:02:02PM +0200, Laurent Pinchart wrote:  
> > >> And furthermore using enum types in the uAPI is a bad idea as the enum
> > >> size is architecture-dependent. That's why we use integer types in
> > >> structures used as ioctl arguments.  
> > > 
> > > I guess we have an argeement on that, enums are a no-go for uAPI, for
> > > reasons not related to the topic at hand.  
> > 
> > Huh? We're not talking about uAPI. This is kAPI. Using enums there is OK.  
> 
> Sure, there's no disagreement about that. 

> The point was that, as both uAPI and  kAPI should be documented,

No disagreement here...

> and we can't use enums for uAPI, 

Err... we actually do use enums on uAPI... videodev2.h is full of it.
What we can't do is to use enums on ioctls. So, all such enums are
replaced by u32 at the ioctl calls.

Ok, this is not elegant (and it happened for historic reasons - we're
now avoiding it at all costs), but that's the way it is.

The fact is - for uAPI - we have enums and defines, and both are
documented.

> we need a way to document non-enum types,

We have already a way to document all uAPI data structures, including
enums and defines.

> which we could then use to document the kAPI the same way.

Let's not mix subjects. This patch series is all about kAPI.

Specifically, we're talking about this change:

-/* Just log the ioctl name + error code */
-#define V4L2_DEV_DEBUG_IOCTL		0x01
-/* Log the ioctl name arguments + error code */
-#define V4L2_DEV_DEBUG_IOCTL_ARG	0x02
-/* Log the file operations open, release, mmap and get_unmapped_area */
-#define V4L2_DEV_DEBUG_FOP		0x04
-/* Log the read and write file operations and the VIDIOC_(D)QBUF ioctls */
-#define V4L2_DEV_DEBUG_STREAMING	0x08
+/**
+ * enum v4l2_debug_bits - Device debug bits to be used with the video
+ *	device debug attribute
+ *
+ * @V4L2_DEBUG_IOCTL:		Just log the ioctl name + error code.
+ * @V4L2_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
+ * @V4L2_DEBUG_FOP:		Log the file operations and open, release,
+ *				mmap and get_unmapped_area syscalls.
+ * @V4L2_DEBUG_STREAMING:	Log the read and write syscalls and
+ *				:c:ref:`VIDIOC_[Q|DQ]BUF <VIDIOC_QBUF>` ioctls.
+ * @V4L2_DEBUG_POLL:		Log poll syscalls.
+ */
+enum v4l2_debug_bits {
+	V4L2_DEBUG_IOCTL	= 0,
+	V4L2_DEBUG_IOCTL_ARG	= 1,
+	V4L2_DEBUG_FOP		= 2,
+	V4L2_DEBUG_STREAMING	= 3,
+	V4L2_DEBUG_POLL		= 4,
+};

I agree with the principle of having a way to document #defines and
static data that belongs to kAPI and drivers. So, from my side, if
someone pops up and propose a way to document #defines to linux-doc,
manages to get such proposal accepted and submit patches implementing it, 
I'm fine.

There are things like:

include/media/cec.h:#define CEC_NUM_CORE_EVENTS 2
include/media/cec.h:#define CEC_MAX_MSG_RX_QUEUE_SZ             (18 * 3)
include/media/cec.h:#define CEC_MAX_MSG_TX_QUEUE_SZ             (18 * 1)
include/media/rc-core.h:#define IR_DEFAULT_TIMEOUT      MS_TO_NS(125)
include/media/rc-core.h:#define IR_MAX_DURATION         500000000       /* 500 ms */
include/media/v4l2-clk.h:#define V4L2_CLK_NAME_SIZE 64
...

that currently can't be documented, and do belong to "#define" namespace,
as those are true macros that create an alias for a magic number.

Those should *never* be converted to enums. The fact that they can't right
now be documented shouldn't be used as an excuse to conver to enums: they're
just magic numbers that can be used on a countless number of random places
that may or may not be related.

However, I do believe that, grouping namespace for values with the
same meaning do belong to enums. After all, those values are bound
together for life, as they're meant to be used at the same places.
A define is a very poor and lazy way to define, and sometimes induce
to mistakes, as, from time to time, I see values on defines that belongs
to an specific field being used on some other one.

>From documentation PoV, they also play nicer when grouped together,
as a common comment that applies to all such values are grouped
together.

In the specific case of this patch, all those V4L2_DEV_DEBUG_* bits
(or V4L2_DEV_DEBUG_* values - before this patchset) are meant to be
used only when enabling or disabling V4L2 core debug messages.

Grouping them into the same "enum" namespace makes all sense.
They should have grouped together since the beginning. That's all
my fault, as, when I added this logic[1], I just took the lazy way.

[1] Back on 2006, where there were just 2 debug values

	commit 401998fa96fe18b057af3f906527196522dd2d9d
	Author: Mauro Carvalho Chehab <mchehab@infradead.org>
	Date:   Sun Jun 4 10:06:18 2006 -0300

	    V4L/DVB (4065): Several improvements at videodev.c
    
	    Videodev now is capable of better handling V4L2 api, by
	    processing V4L2 ioctls and using callbacks to the driver.
	    The drivers should be migrated to the newer way and the older
	    one will be obsoleted soon.


Thanks,
Mauro
