Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39452 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754317AbdLTNep (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 08:34:45 -0500
Date: Wed, 20 Dec 2017 11:34:36 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] media: v4l2-ioctl.h: convert debug into an enum of
 bits
Message-ID: <20171220113436.6f1f40eb@vento.lan>
In-Reply-To: <2495011.azrSBV26NO@avalon>
References: <cover.1513625884.git.mchehab@s-opensource.com>
        <1829332.DyU8Vvd1sp@avalon>
        <20171219133446.3b42ad19@vento.lan>
        <2495011.azrSBV26NO@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Dec 2017 12:47:23 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Tuesday, 19 December 2017 17:34:46 EET Mauro Carvalho Chehab wrote:
> > Em Tue, 19 Dec 2017 16:05:46 +0200 Laurent Pinchart escreveu:  
> > > On Tuesday, 19 December 2017 16:02:02 EET Laurent Pinchart wrote:  
> > >> On Tuesday, 19 December 2017 13:39:27 EET Sakari Ailus wrote:  
> > >>> On Mon, Dec 18, 2017 at 05:53:56PM -0200, Mauro Carvalho Chehab wrote:  
> > >>>> The V4L2_DEV_DEBUG_IOCTL macros actually define a bitmask,
> > >>>> but without using Kernel's modern standards. Also,
> > >>>> documentation looks akward.
> > >>>> 
> > >>>> So, convert them into an enum with valid bits, adding
> > >>>> the correspoinding kernel-doc documentation for it.  
> > >>> 
> > >>> The pattern of using bits for flags is a well established one and I
> > >>> wouldn't deviate from that by requiring the use of the BIT() macro.
> > >>> There are no benefits that I can see from here but the approach brings
> > >>> additional risks: misuse of the flags and mimicing the same risky
> > >>> pattern.
> > >>> 
> > >>> I'd also like to echo Laurent's concern that code is being changed in
> > >>> odd ways and not for itself, but due to deficiencies in documentation
> > >>> tools.
> > >>> 
> > >>> I believe the tooling has to be improved to address this properly.
> > >>> That only needs to done once, compared to changing all flag
> > >>> definitions to enums.  
> > >> 
> > >> That's my main concern too. We really must not sacrifice code
> > >> readability or writing ease in order to work around limitations of the
> > >> documentation system. For this reason I'm strongly opposed to patches 2
> > >> and 5 in this series.  
> > > 
> > > And I forgot to mention patch 8/8. Let's drop those three and improve the
> > > documentation system instead.  
> > 
> > Are you volunteering yourself to write the kernel-doc patches? :-)  
> 
> I thought you were the expert in this field, given the number of documentation 
> patches that you have merged in the kernel ? :-)

c/c linux-doc, as this kind of discussion should be happening there.

Let me recap your proposal here, for the others from linux-doc to
understand this reply:

Em Mon, 18 Dec 2017 17:32:11 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Monday, 18 December 2017 17:13:26 EET Mauro Carvalho Chehab wrote:
> > Em Fri, 13 Oct 2017 15:38:11 +0300 Laurent Pinchart escreveu:  
> > > On Thursday, 28 September 2017 00:46:51 EEST Mauro Carvalho Chehab wrote:  
> > >> Currently, there's no way to document #define foo <value>
> > >> with kernel-doc. So, convert it to an enum, and document.  
> > > 
> > > The documentation seems fine to me (except for one comment below).
> > > However, converting macros to an enum just to work around a defect of the
> > > documentation system doesn't seem like a good idea to me. I'd rather find
> > > a way to document macros.  
> > 
> > I agree that this limitation should be fixed.
> > 
> > Yet, in this specific case where we have an "array" of defines, all
> > associated to the same field (even being a bitmask), and assuming that
> > we would add a way for kernel-doc to parse this kind of defines
> > (not sure how easy/doable would be), then, in order to respect the
> > way kernel-doc markup is, the documentation for those macros would be:
> > 
> > 
> > /**
> >  * define: Just log the ioctl name + error code
> >  */
> > #define V4L2_DEV_DEBUG_IOCTL		0x01
> > /**
> >  * define: Log the ioctl name arguments + error code
> >  */
> > #define V4L2_DEV_DEBUG_IOCTL_ARG	0x02
> > /**
> >  * define: Log the file operations open, release, mmap and get_unmapped_area
> > */
> > #define V4L2_DEV_DEBUG_FOP		0x04
> > /**
> >  * define: Log the read and write file operations and the VIDIOC_(D)QBUF
> > ioctls */
> > #define V4L2_DEV_DEBUG_STREAMING	0x08
> > 
> > IMHO, this is a way easier to read/understand by humans, and a way more
> > coincise:
> > 
> > /**
> >  * enum v4l2_debug_flags - Device debug flags to be used with the video
> >  *	device debug attribute
> >  *
> >  * @V4L2_DEV_DEBUG_IOCTL:	Just log the ioctl name + error code.
> >  * @V4L2_DEV_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
> >  * @V4L2_DEV_DEBUG_FOP:		Log the file operations and open, release,
> >  *				mmap and get_unmapped_area syscalls.
> >  * @V4L2_DEV_DEBUG_STREAMING:	Log the read and write syscalls and
> >  *				:c:ref:`VIDIOC_[Q|DQ]BUFF <VIDIOC_QBUF>` ioctls.
> >  */
> > 
> > It also underlines the aspect that those names are grouped altogether.
> > 
> > So, IMHO, the main reason to place them inside an enum and document
> > as such is that it looks a way better for humans to read.  
> 
> As we're talking about extending kerneldoc to document macros, we're free to 
> decide on a format that would make it easy and clear. Based on your above 
> example, we could write it
> 
> /**
>  * define v4l2_debug_flags - Device debug flags to be used with the video
>  *	device debug attribute
>  *
>  * @V4L2_DEV_DEBUG_IOCTL:	Just log the ioctl name + error code.
>  * @V4L2_DEV_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
>  * @V4L2_DEV_DEBUG_FOP:		Log the file operations and open, release,
>  *				mmap and get_unmapped_area syscalls.
>  * @V4L2_DEV_DEBUG_STREAMING:	Log the read and write syscalls and
>  *				:c:ref:`VIDIOC_[Q|DQ]BUFF <VIDIOC_QBUF>` ioctls.
>  */
> 
> That would be simple, clear, and wouldn't require a code change to workaround 
> a limitation of the documentation system.
> 

I could volunteer myself to write a patch that would just parse a single
define when I have some time for that, and after finishing to document
other things that don't depend on it.

However, I won't volunteer to add a patch that would artificially
group #defines on a single kernel-doc markup, because:

1) I don't believe that this is the right solution. When several
   name macros should be grouped altogether, C provides an specific
   syntax for it: enum;
2) the patch will likely be very complex;
3) the define "grouping" logic would be based on hints.

Let me explain (3) a little better. Right now, kernel-doc common
logic removes any comments and blank lines when processing a single
markup, like struct, enum, function, etc. It should very likely need
to do the same for #defines.

Using your proposed, syntax, please assume the following fictional
(but based on real code) example:

	/**
	 * define v4l2_debug_flags - Device debug flags to be used with the video
	 *	device debug attribute
	 *
	 * @V4L2_DEV_DEBUG_IOCTL:	Just log the ioctl name + error code.
	 * @V4L2_DEV_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
	 * @V4L2_DEV_DEBUG_FOP:		Log the file operations and open, release,
	 *				mmap and get_unmapped_area syscalls.
	 * @V4L2_DEV_DEBUG_STREAMING:	Log the read and write syscalls and
	 *				:c:ref:`VIDIOC_[Q|DQ]BUFF <VIDIOC_QBUF>` ioctls.
	 */

	/* ioctl debug macros */
	#define V4L2_DEV_DEBUG_IOCTL         0x01
	#define V4L2_DEV_DEBUG_IOCTL_ARG     0x02

	/* streaming debug macros */
	#define V4L2_DEV_DEBUG_FOP           0x04
	#define V4L2_DEV_DEBUG_STREAMING     0x08

	#define CEC_NUM_CORE_EVENTS 2
	#define CEC_NUM_EVENTS CEC_EVENT_PIN_CEC_HIGH

The V4L_DEV_DEBUG_* macros will be properly documented using your
notation.

However, how the kernel-doc logic will know when to stop grouping defines?

It should be reminded that, if later someone adds a new V4L_DEV_DEBUG_FOO
(either after V4L2_DEV_DEBUG_STREAMING or before it), we want a warning to
be generated, because something that belongs to this define "group"
was added without documentation.

It might be parsing by name, but that would break if someone ever adds a
macro like: V4L2_NODEV_DEBUG, it won't work (we do have some
"namespaces" like that). It would also fail if someone adds an unrelated
macro that would start with V4L2_DEV_DEBUG_.

Now, assume that, sometime in the future, we decide to also document
CEC_NUM_CORE_EVENTS, because it is now part of a kAPI, but we don't
want to document CEC_NUM_EVENTS, with is just an ancillary macro 
to be used internally.  The "group" define syntax won't fit.

In summary, trying to artificially group #defines for documentation is
a very dirty hack. We should really use enums on all kAPI cases where
we have different symbols that should be grouped altogether.

Regards,
Mauro
