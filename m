Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35003 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932082AbdCFOen (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 09:34:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2.2] v4l: Clearly document interactions between formats, controls and buffers
Date: Mon, 06 Mar 2017 15:38:48 +0200
Message-ID: <2492396.nhRjhP263E@avalon>
In-Reply-To: <84bfd635-e58e-ba23-98c1-c2b957458bd7@xs4all.nl>
References: <20170305143936.11257-1-laurent.pinchart+renesas@ideasonboard.com> <2151087.6KcNijWoxt@avalon> <84bfd635-e58e-ba23-98c1-c2b957458bd7@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 06 Mar 2017 11:46:28 Hans Verkuil wrote:
> On 06/03/17 11:35, Laurent Pinchart wrote:
> > On Monday 06 Mar 2017 11:04:50 Hans Verkuil wrote:
> >> On 05/03/17 22:36, Laurent Pinchart wrote:
> >>> V4L2 exposes parameters that influence buffers sizes through the format
> >>> ioctls (VIDIOC_G_FMT, VIDIOC_TRY_FMT, VIDIOC_S_FMT, and possibly
> >>> VIDIOC_G_SELECTION and VIDIOC_S_SELECTION). Other parameters not part of
> >>> the format structure may also influence buffer sizes or buffer layout in
> >>> general. One existing such parameter is rotation, which is implemented
> >>> by the V4L2_CID_ROTATE control and thus exposed through the V4L2 control
> >>> ioctls.
> >>> 
> >>> The interaction between those parameters and buffers is currently only
> >>> partially specified by the V4L2 API. In particular interactions between
> >>> controls and buffers isn't specified at all. The behaviour of the
> >>> VIDIOC_S_FMT and VIDIOC_S_SELECTION ioctls when buffers are allocated is
> >>> also not fully specified.
> >>> 
> >>> This patch clearly defines and documents the interactions between
> >>> formats, selections, controls and buffers.
> >>> 
> >>> The preparatory discussions for the documentation change considered
> >>> completely disallowing controls that change the buffer size or layout,
> >>> in favour of extending the format API with a new ioctl that would bundle
> >>> those controls with format information. The idea has been rejected, as
> >>> this would essentially be a restricted version of the upcoming request
> >>> API that wouldn't bring any additional value.
> >>> 
> >>> Another option we have considered was to mandate the use of the request
> >>> API to modify controls that influence buffer size or layout. This has
> >>> also been rejected on the grounds that requiring the request API to
> >>> change rotation even when streaming is stopped would significantly
> >>> complicate implementation of drivers and usage of the V4L2 API for
> >>> applications.
> >>> 
> >>> Applications will however be required to use the upcoming request API to
> >>> change at runtime formats or controls that influence the buffer size or
> >>> layout, because of the need to synchronize buffers with the formats and
> >>> controls. Otherwise there would be no way to interpret the content of a
> >>> buffer correctly.
> >>> 
> >>> Signed-off-by: Laurent Pinchart
> >>> <laurent.pinchart+renesas@ideasonboard.com>
> >>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>> ---
> >>> Changes since v2.1:
> >>> 
> >>> - Fixed small issues in commit message
> >>> - Simplified wording of one sentence in the documentation
> >>> 
> >>> Changes since v2:
> >>> 
> >>> - Document the interaction with ioctls that can affect formats
> >>>   (VIDIOC_S_SELECTION, VIDIOC_S_INPUT, VIDIOC_S_OUTPUT, VIDIOC_S_STD and
> >>>   VIDIOC_S_DV_TIMINGS)
> >>> - Clarify the format/control change order
> >>> ---
> >>> 
> >>>  Documentation/media/uapi/v4l/buffer.rst | 108 ++++++++++++++++++++++++
> >>>  1 file changed, 108 insertions(+)
> >>> 
> >>> diff --git a/Documentation/media/uapi/v4l/buffer.rst
> >>> b/Documentation/media/uapi/v4l/buffer.rst index
> >>> ac58966ccb9b..60d62a5824f8 100644
> >>> --- a/Documentation/media/uapi/v4l/buffer.rst
> >>> +++ b/Documentation/media/uapi/v4l/buffer.rst
> >>> @@ -34,6 +34,114 @@ flags are copied from the OUTPUT video buffer to the
> >>> CAPTURE video>
> >>> 
> >>>  buffer.
> >>> 
> >>> +Interactions between formats, controls and buffers
> >>> +==================================================
> >>> +
> >>> +V4L2 exposes parameters that influence the buffer size, or the way data
> >>> is +laid out in the buffer. Those parameters are exposed through both
> >>> formats and +controls. One example of such a control is the
> >>> ``V4L2_CID_ROTATE`` control +that modifies the direction in which pixels
> >>> are stored in the buffer, as well +as the buffer size when the selected
> >>> format includes padding at the end of +lines.
> >>> +
> >>> +The set of information needed to interpret the content of a buffer
> >>> (e.g. the +pixel format, the line stride, the tiling orientation or the
> >>> rotation) is +collectively referred to in the rest of this section as
> >>> the buffer layout.
> >>> +
> >>> +Modifying formats or controls that influence the buffer size or layout
> >>> require +the stream to be stopped. Any attempt at such a modification
> >>> while the stream +is active shall cause the ioctl setting the format or
> >>> the control to return +the ``EBUSY`` error code.
> >> 
> >> This is my problem with putting the more complex case first: if you are
> >> reading this for the first time then the preceding paragraph is simply
> >> *wrong*.
> >> 
> >> You cannot modify the buffer size when the stream is stopped. You need to
> >> free all buffers first before you can do that.
> > 
> > That's driver-dependent. If I reverse the order to start with the more
> > restricted case, it will also be wrong for drivers that implement the
> > other case.
> 
> It's not about wrong or right, it's about which case is the most common.

Note that you were the one saying the current order was "*wrong*" ;-) I'll 
change it anyway.

> > I'm running out of time so I'll change this though. We can always
> > reorder the paragraphs later when we will have more drivers implementing
> > the more powerful case.
> > 
> >> Unless the driver has been especially written to allow that. And I am not
> >> aware of any.
> >> 
> >>> +
> >>> +Controls that only influence the buffer layout can be modified at any
> >>> time +when the stream is stopped. As they don't influence the buffer
> >>> size, no +special handling is needed to synchronize those controls with
> >>> buffer +allocation.
> >>> +
> >>> +Formats and controls that influence the buffer size interact with
> >>> buffer +allocation. As buffer allocation is an expensive operation,
> >>> drivers should +allow format or controls that influence the buffer size
> >>> to be changed with +buffers allocated. A typical ioctl sequence to
> >>> modify format and controls is
> >>> +
> >>> + #. VIDIOC_STREAMOFF
> >>> + #. VIDIOC_S_EXT_CTRLS
> >>> + #. VIDIOC_S_FMT
> >>> + #. VIDIOC_QBUF
> >>> + #. VIDIOC_STREAMON
> >>> +
> >>> +.. note::
> >>> +
> >>> +   The API doesn't mandate the above order for control (2.) and format
> >>> (3.) +   changes. Format and controls can be set in a different order,
> >>> or even +   interleaved, depending on the device and use case. For
> >>> instance some +   controls might behave differently for different pixel
> >>> formats, in which +   case the format might need to be set first.
> >>> +
> >>> +Queued buffers must be large enough for the new format or controls.
> >>> +
> >>> +Drivers shall return a ``ENOSPC`` error in response to format change
> >>> +(:c:func:`VIDIOC_S_FMT`) or control changes (:c:func:`VIDIOC_S_CTRL` or
> >>> +:c:func:`VIDIOC_S_EXT_CTRLS`) if buffers too small for the new format
> >>> are +currently queued. As a simplification, drivers are allowed to
> >>> return an error
> >> 
> >> s/an error/``EBUSY``/
> >> 
> >>> +from these ioctls if any buffer is currently queued, without checking
> >>> the +queued buffers sizes.
> >> 
> >> Again, swap the order: simple case first, more complex case next.
> >> 
> >>> +
> >>> +.. note::
> >>> +
> >>> +   The :c:func:`VIDIOC_S_SELECTION` ioctl can, depending on the
> >>> hardware (for +   instance if the device doesn't include a scaler),
> >>> modify the format in +   addition to the selection rectangle. Similarly,
> >>> the +   :c:func:`VIDIOC_S_INPUT`, :c:func:`VIDIOC_S_OUTPUT`,
> >>> 
> >>> :c:func:`VIDIOC_S_STD` +   and :c:func:`VIDIOC_S_DV_TIMINGS` ioctls can
> >>> 
> >>> also modify the format and +   selection rectangles. Driver shall return
> >>> the same ``ENOSPC`` error from +   all ioctls that would result in
> >>> formats too large for queued buffers.
> >> 
> >> This will return EBUSY for the 'simple' drivers, and ENOSPC for the
> >> complex ones. Should be mentioned clearly to avoid confusion.
> >> 
> >>> +
> >>> +Drivers shall also return a ``ENOSPC`` error from the
> >>> :c:func:`VIDIOC_QBUF` +ioctl if the buffer being queued is too small for
> >>> the current format or +controls. Together, these requirements ensure
> >>> that queued buffers will always +be large enough for the configured
> >>> format and controls.
> >> 
> >> NACK: it's EINVAL as returned by the buf_prepare() callbacks. Yes, I
> >> agree that ENOSPC would have been more appropriate, but I do not believe
> >> we can change this without breaking ABI. I also do not think this is all
> >> that important. Feel free to blame this on lack for foresight :-)
> > 
> > That's driver-dependent though, but I agree that due to cargo-cult
> > programming most probably return -EINVAL today. Most, because I'm pretty
> > sure we have drivers that don't check that condition, resulting in
> > potential DMA buffer overflows. It might make sense to move the check to
> > videobuf2-v4l2.c (but that's unrelated to this patch).
> 
> videobuf2-v4l2.c doesn't have the format information, so it can't do that
> check. I agree that there are likely some drivers that do not check this,
> which is definitely a bug. I think v4l2-compliance tries to check for this,
> but I am not sure it is able to do so today for the DMABUF case, which is
> the most relevant one.

This is getting out of scope for this patch, but I'll mention it for 
reference: While I agree that vb2 should not be format-aware, I believe it 
should grow to be size-aware. We could expose a new vb2 function that allows 
drivers to set the minimum size for each plane, and move all size checks 
within vb2. That would greatly simplify the implementation of the vb2 queue 
callbacks that are currently implemented in many different (and slightly or 
completely incompatible ways) by different drivers.

> > We should have used -ENOSPC, and I believe that switching to -ENOSPC now
> > wouldn't result in any breakage. Can you think of any application that
> > would queue a too small buffer, match the error code against -EINVAL, and
> > have a strategy to recover ? Queuing a too small buffer is an application
> > but in the first place, I don't think application developers will have
> > gone through the trouble of implementing a way to recover from their own
> > bug instead of fixing them :-)
> > 
> > Would it be OK with you to document that -ENOSPC is the recommended error
> > code, but that some drivers currently return -EINVAL ?
> 
> I really don't think it is worth changing this. Changing it to ENOSPC would
> make drivers do inconsistent things. And the important thing is that it DOES
> return an error.
> 
> Just stick to -EINVAL. The world won't end :-)

It will, but hopefully not because of that :-)

> >>> +Userspace applications can query the buffer size required for a given
> >>> format +and controls by first setting the desired control values and
> >>> then trying the +desired format. The :c:func:`VIDIOC_TRY_FMT` ioctl will
> >>> return the required +buffer size.
> >>> +
> >>> + #. VIDIOC_S_EXT_CTRLS(x)
> >>> + #. VIDIOC_TRY_FMT()
> >>> + #. VIDIOC_S_EXT_CTRLS(y)
> >>> + #. VIDIOC_TRY_FMT()
> >>> +
> >>> +The :c:func:`VIDIOC_CREATE_BUFS` ioctl can then be used to allocate
> >>> buffers +based on the queried sizes (for instance by allocating a set of
> >>> buffers large +enough for all the desired formats and controls, or by
> >>> allocating separate set +of appropriately sized buffers for each use
> >>> case).
> >>> +
> >>> +To simplify their implementation, drivers may also require buffers to
> >>> be +reallocated in order to change formats or controls that influence
> >>> the buffer +size. In that case, to perform such changes, userspace
> >>> applications shall +first stop the video stream with the
> >>> :c:func:`VIDIOC_STREAMOFF` ioctl if it +is running and free all buffers
> >>> with the :c:func:`VIDIOC_REQBUFS` ioctl if +they are allocated. The
> >>> format or controls can then be modified, and buffers +shall then be
> >>> reallocated and the stream restarted. A typical ioctl sequence +is
> >>> +
> >>> + #. VIDIOC_STREAMOFF
> >>> + #. VIDIOC_REQBUFS(0)
> >>> + #. VIDIOC_S_EXT_CTRLS
> >>> + #. VIDIOC_S_FMT
> >>> + #. VIDIOC_REQBUFS(n)
> >>> + #. VIDIOC_QBUF
> >>> + #. VIDIOC_STREAMON
> >>> +
> >>> +The second :c:func:`VIDIOC_REQBUFS` call will take the new format and
> >>> control +value into account to compute the buffer size to allocate.
> >>> Applications can +also retrieve the size by calling the
> >>> :c:func:`VIDIOC_G_FMT` ioctl if needed.
> >>> +
> >>> +When reallocation is required, any attempt to modify format or controls
> >>> that +influences the buffer size while buffers are allocated shall cause
> >>> the format +or control set ioctl to return the ``EBUSY`` error code.
> >>> +
> >>> +
> >>>  .. c:type:: v4l2_buffer
> >>>  
> >>>  struct v4l2_buffer
> >> 
> >> The order really has to be changed: first explain the 99%, then continue
> >> with the more complex case. It's not the text itself, it's the order in
> >> which this is presented. I won't accept it in this order as it will be
> >> terminally confusing for most readers. Sorry.

-- 
Regards,

Laurent Pinchart
