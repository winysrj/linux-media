Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:18900 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaENXCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 19:02:35 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5L00IK16O8FR90@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 May 2014 19:02:32 -0400 (EDT)
Date: Wed, 14 May 2014 20:02:23 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANN] Report on the San Jose V4L/DVB mini-summit
Message-id: <20140514200223.6438f2cc.m.chehab@samsung.com>
In-reply-to: <536763A6.8010602@xs4all.nl>
References: <536763A6.8010602@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for summarizing it, and for the ones that took the Etherpad notes.

A few comments:

Em Mon, 05 May 2014 12:10:46 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Note: please reply with corrections if I made a mistake or missed something. In
> particular the DVB sections might contain inaccuracies since I am not a DVB expert.
> 
> ================================================================================
> 
> Report of the V4L/DVB mini-summit in San Jose, May 3rd 2014
> 
> Attendees:
> 
> Mauro Carvalho Chehab
> Kamil Debski
> Tomasz Figa
> Devin Heitmueller
> Shuah Khan
> Mike Krufky
> Laurent Pinchart
> Steve Toth
> Hans Verkuil
> 
> Sakari Ailus was not present but was reading and commenting on the etherpad notes.
> 
> 
> 1) V4L2 Ambiguities
> 
> 1.1) VIDIOC_ENUM_FMT & Multi-planar
> 
> Currently there is no way to know if a format is a multi-planar format.
> 
> This is an issue when using a single-planar application with a multi-planar driver:
> the libv4l plugin will convert from the single planar API to the multi-planar API, but
> that only works for single planar formats, multi-planar formats should be skipped.
> 
> It is not possible to deduce whether a fourcc format is multi or single planar.
> 
> Proposed solution:
> 
> Add an MPLANE flag reported during format enumeration (similar to the compressed flag).
> 
> Actions:
>     
> - Post an RFC (Hans).
> 
> 1.2) Rename mem2mem_testdev to vim2m
> 
> Actions:
> 
> - Do this, but add a module alias with the old name to ensure backward compatibility. (Hans)
> 
> 1.3) Drop 2.6.31 support in media_build
> 
> We need to support at least the distro LTS kernels. This means keeping 2.6.32 support until
> the end of the year (projected EOL as LTS by mid 2014)
> 
> Actions:
>     
> - Drop 2.6.31 next time it breaks (Hans)
> 
> 1.4) Extending struct v4l2_pix_format
> 
> The v4l2_pix_format struct has no more free space. We need to extend it today to add flags
> (for pre-multiplied alpha) and data_offset for single planar. However the structure is used
> in v4l2_framebuffer, whose size would then change, breaking the ioctl ABI.
> 
> The risk of breakage when embedding v4l2_pix_format inside v4l2_framebuffer is unknown but
> not expected to be too high. The Xorg V4L plugin shouldn't break at first sight.
> 
> Mauro mentioned that the fmt field is the very last in v4l2_framebuffer, so we could keep
> the ABI by hardcoding the size in the ioctl number without embedding v4l2_pix_format in
> v4l2_framebuffer. However the risk of bugs sneaking in in the kernel could be high as the
> size would need to be hardcoded in video_usercopy as well.
> 
> Mauro proposed first deprecating v4l2_framebuffer in favour of dmabuf. We don't really know
> how widely the related ioctls are used.
> 
> Actions:
>     
> - Embed the structure (anyone who needs to extend v4l2_pix_format)
> - Mark the framebuffer API as deprecated (Hans)
> - Would be nice: Convert the Xorg V4L driver to DMABUF
> 
> Extending struct v4l2_pix_format:
> 
> - Use the priv field as a magic value to indicate that extensions are available.
> - Alias the priv field using a union to name it 'version'.
> 
> Actions:
>     
> - Post an RFC (Hans)
> 
> 1.5) Height vs Field
> 
> When calling S/TRY_FMT with incompatible height and field values, which one of the
> two should be changed by the driver? Proposal: field should change.
> 
> Actions:
>     
> - Post an RFC (Hans)
> 
> 1.6) Crop, Compose, Scale
> 
> All 8 combinations of crop, compose and scaling were described.
> 
> Do we want to increase the format automatically when requesting a compose rectangle
> that is partially outside of the S_FMT buffer, or constrain the compose rectangle to
> that of the S_FMT buffer? If the format is locked (vb2_is_busy() returns true), then
> the compose rectangle has to be constrained. But should this also happen if the format
> is not locked?
> 
> In the "crop, no compose, scale" case, do we adjust the format and keep the crop
> rectangle fixed when the set crop rectangle + scaler limitations require it, or do we
> adjust the crop rectangle and keep the format fixed? Effectively the same question as
> in the case above.
> 
> The problem is complicated, documentation should do more than just listing the cases
> with text only. Graphics and/or tables should be used to make the behavior clearer
> for applications.
> 
> To simplify drivers the addition of V4L2 core helper functions are certainly needed
> to coordinate the crop/compose/scale dependencies.
> 
> To detect scaler presence, mandate drivers to implement ENUM_FRAMESIZES with
> stepwise/continuous framesize ranges *and* forbid drivers for devices without a scaler
> to report stepwise/continuous framesizes.
> 
> Actions:
>     
> - Check what happens when we allow or disallow partly out of bounds compose rectangles
>   (as opposed to increasing the format automatically). (Hans)
> - Add ENUM_FRAMESIZES support to those drivers that can scale (Hans)
> 
> Separate issue: changing the input, output, STD, DV_TIMINGS or discrete webcam framesize
> will typically reset the crop/compose/fmt.
> 
> However, when setting the same input, output, std, etc. this does not happen. E.g.
> S_STD(G_STD()) will normally be a nop.
> 
> We should look into creating a reset ioctl that can be used to explicitly reset the
> pipeline.
> 
> In addition (a bit unrelated to the topic) we should look into an ioctl that can be
> used to have some control over power usage. E.g., if the last user of the /dev/radioX
> device goes away, should the power be turn off or not, or perhaps only after X seconds.

Actually, It was mentioned that a reset ioctl could also be used to free a radio device
that was previous set to be tuned, for applications like "radio" where it is possible to
open the device, tune it and close, keeping listening to the audio station.

> 
> Actions:
> 
> - Look in a reset and power control ioctl (Hans)
> 
> 
> 2) Extend the control framework with Compound Types.
> 
> Drop units from the compound types proposal for now, will be added back later as no
> agreement has been reached on unit numerical vs. string IDs (and neither is that required
> for the first version).
> 
> Laurent: Whether a control should be hidden from users isn't really something the kernel
> should decide. A new HIDDEN flag might not be a good  solution. A NEXT_COMPOUND flag could
> be used instead of NEXT_HIDDEN to solve the enumeration problem (hiding compound controls
> from older applications) for compound controls only, but is it even really needed?
> 
> Do we need more than two dimensions? Hans: Can be done, but 99% of the cases will be 1 or 2
> dimensions, so that's what we should optimize for. Adding support for more than 2 dimensions
> would require passing an arbitrary number of sizes (one per dimension) to the query control
> API. That would require adding a pointer to struct v4l2_query_ext_ctrl. Hans: possible to do,
> but a PITA. Laurent has hardware that needs 3 dimensions.
> 
> Proposed implementation: Simplify 1D and 2D, allows >2D.
>     
>     __u32 dimensions;
>     union {
>         struct {
>             __u32 cols;
>             __u32 rows;
>         };
>         __u32 *sizes;
>     };
> 
> Just using a pointer might not be too difficult though. Hans would like to play with it, if
> it turns out to be not too complex to implement for applications we might just use that.
> 
> Laurent: What about supporting querying multiple controls in one ioctl call? The ext get/set
> API allows it, it might be nice for consistency. Hans didn't see a need for it since you
> typically enumerate controls only once.
> 
> Actions Hans:
> 
> - Drop unit string
> - Drop HIDDEN flag, replace NEXT_HIDDEN by NEXT_COMPOUND
> - Investigate multi-dimensional data structs
> 
> 
> 3) Patch Merging Process
> 
> Some proposals:
>     
> - Merge to "devel" branch rather than master branch during critical development
>   periods (merge windows, etc)
>     
> - Encourage earlier pull request submission to that review can happen before
>   the last opportunity, allowing time to make changes if needed according to
>   feedback from review
>     
> - Add 'ATTN' inside pull request subject line tp indicate that Mauro's (or some
>   other maintainer's) attention is required. Should be limited to api changes,
>   dependencies.
>     
> - Push for the creation of a DT submaintainer for v4l, to review & aid in the
>   process of getting DT changes merged - possible proposal for upcoming LKS.
>     
> - Patches that modify DT bindings should include the term, "DT" or "Devicetree"
>   in the patch subject.
> 
> Changes merged in the fixes branch are only applied to master when the next kernel
> version is released and merged in master. This causes potential conflicts in the
> master branch. Merged -rc back in master automatically won't be done, but when
> needed developers can contact Mauro to request merging of specific fixes back in
> master on a case-by-case basis.
> 
> Submaintainers need to send regular pull requests (around once per week) instead
> of waiting for the end of the merge window.
> 
> 
> 4) Linux media power management
> 
> One driver, the attach point, loads extensions. The main driver has to make sure that
> all functions are suspended and resumed properly.
> 
> After resume, multiple extensions might access the tuner at the same time, causing
> many problems: i2c gates, i2c bus speed setup, etc.
> 
> What to do if a platform v4l/dvb device depends on a completely separate other device
> (e.g. i2c bus)? There is currently no way of describing dependencies across subsystems.
> 
> early_resume() could be used to setup buses etc. before the rest of the resume
> process will continue.
> 
> High-level PM code for the DVB case is probably needed.
> 
> The proposal was to add token support to drivers/base to coordinate who has a 'token'
> (i.e. resource ownership). However, concerns were raised that putting this in drivers/base
> would making upstreaming more difficult and it was not clear whether making this a
> generic mechanism was actually the right thing to do. Too early to tell, let's make
> it work for two or more hybrid devices first to get more experience.
> 
> i2c_mux_adapter can be used to implement i2c gates, thus simplifying driver code.
> 
> There is one special case where a i2c device has a mux that selects between two i2c
> buses (one slow, one fast), and which bus is used is selected by the driver.
> 
> It's not clear whether i2c_mux_adapter can be used to model that as well.
> 
> Actions (Shuah):
> 
> - Make it work first for two or more hybrid devices, and go from there.
> 
> 
> 5) Configuration stores
> 
> Use cases:
> 
>     - The Renesas VSP1 supports configuring the device automatically from a "command"
>       buffer that describes a complete configuration, instead of writing to registers individually.
>     - Switch between hardware shadow registers (register banks available in camera sensors)
>     - MFC hardware codec (Exynos SoC) has configuration options that can be changed on
>       a per frame basis (e.g. forcing a particular QP for a frame, forcing a particular frame type).
>     - Android libcamera 3 (under development, not used yet) mandates per-frame configurations
>       (and per-frame status)
> 
> Sakari: To be the most useful for the user space in the context of cameras in embedded systems,
> we should provide complete functionality, including sensor and ISP configuration. Syncing the
> two is a problem on its own. As the hardware doesn't support this there's room for errors
> if timing goes wrong.
> 
> How do we solve this problem without impacting drivers and applications?
> 
> Possible implementation: use the control framework with configuration stores. We will need to
> define the exact semantics of many small details (e.g. how does this interact with control events?).
> 
> The main questions are:
> 
> - Is the proposed implementation (using the control framework for configuration stores)
>   acceptable?
> 
>   The consensus was that leveraging the control framework makes a lot of sense since it already

It should be, instead:

"The consensus was that leveraging the control framework inside the Kernelspace makes a lot of sense 
since it already"

>   provides 90% of what is needed to support this. Doing it outside of the control framework
>   would duplicate what is already there.
> - Most of the per-frame configuration settings are controls, but not all. E.g. some are ioctls
>   like S_INPUT. Should controls be made for these and should applications actually have to use those
>   controls to set the input in a config store, or should a more transaction-like concept be used:
> 
> 	start configuration store
> 	ioctl calls to set config store
> 	apply changes to config store
> 
>   Sakari: how about configuration passed using private IOCTLs? Much of this may be something that
>   could change on per-frame basis.
> 
>   No real conclusion was reached, but Hans will look into experimenting with a transaction-based
>   approach.
> 
> - How should the number of configuration stores be determined? By the kernel or should userspace
>   be able to set it?
> 
>   Maximum number of configuration stores could be equal to the maximum number of buffers. This is
>   32, which easily maps to a bitmap. Stores should be allocated explicitly, either in one go
>   (similar to REQBUFS) or on demand (similar to CREATE_BUFS). Use cases are not clear at the moment.

I probably missed that part of the discussion, but Kernel bitmap implementation is not limited
to 32 bits. Kernel uses an array for that, so it could (theoretically) have any size.

>   Sakari: the maximum number of buffers isn't part of the user space API and hopefully won't be. At
>   the very least it mustn't be kept as low as 32.
> 
>   Allowing userspace to set this someone seemed to be the preferred approach.

The above paragraph is confusing. Would it mean, instead:
	"Someone seemed to believe that allowing userspace to set would be the preferred approach".

If this is the case, I think we should identify who authored this idea, as
this was not a consensus.

> 
> - (Somewhat unrelated) Adding crop/compose selection controls to allow for atomic setting
>   of crop and compose rectangles and to allow for multi-selection (multiple crop and compose
>   rectangles). Currently the selection API does not allow for this, and attempts to extend
>   the API made it very messy and where never accepted. The compound type additions to the
>   control framework would make this quite easy to do.
> 
>   After some discussion selection controls are grumpily accepted.
> 
> For testing/reference hardware Laurent proposed the vsp1 driver where these features
> are needed.
> 
> If you have multiple video nodes feeding video to a hardware block (e.g. a composer), then
> the format for each video can be different depending on the configuration store. This
> means that those formats and the config store have to be validated together: either by
> adding support for that in vb2 or requiring that all buffers provide the same config store ID.
> 
> The media controller API will need to be extended to support configuration stores
> for links. This would be an opportunity to support setting up multiple links in one go.
> The configuration store creation/deletion API could also be implemented at the MC level
> instead of in a specific V4L2 node.
> 
> 
> 6) DVB Demux Improvements
> 
> - must add mmapped stream & dmabuf support, currently DVB only supports read() - bad!
> - propose to wrap packets within a structure containing timestamps before mmap
>   delivery - read() remains the same, this will aid in seeking encrypted streams
> - currently the kernel demux only allows us to filter one section per pid per
>   file descriptor - we would like to remove this limit
> - in the case of a hardware demux, we would like to be able to service multiple

>   frontends in a single demux - currently this is not possible.

Please change to:

	"frontends in a single shared physical demux filters - current
implementation doesn't allow to properly control it".

> - we'd like to extend it such that the same file descriptor can handle more
>   than one section / pid filter
> - use videobuf2 post-demux for delivery?
> - ultimately, we should use the media controller to aid in pipeline connections
> 
> The consensus was that all these proposed additions were useful. For the mmap and
> dmabuf support vb2 should be used internally, this might need some work to make
> vb2 less v4l2 specific.
> 
> 
> 7) of-graph helpers
> 
> - of-graph; generalized v4l2 DT bindings (valid for v4l2/drm)
> - Currently both A -> B and B -> A are supplied: not everyone likes that
>   (slight duplication of information)
> - What is correct to do for new devices? Ongoing discussion.
> 
> Russell King's framework: component fw (similar to v4l2-async), currently in mainline.
> The current implementation is complex to use, but patches exist to clean that up, all
> good stuff.
> 
> However, it has no partial binding support (no callbacks when each module appears).
> This is used in several drivers today (soc-camera, davinci, exynos4-is).
> 
> Need a solution for this if we want to use Russell's work.
> 
> Yet another implementation: [RFC PATCH 0/4] drivers/base: Generic framework for
> tracking internal interfaces
> 
> Actions:
> 
> - Figure out if the drivers that implement partial binding support really need it?
> - If so, then a solution needs to be found if we want to use Russell's framework.
> - Check out the 'tracking internal interfaces' patch series.
> 
> 
> 8) vivi rewrite demo
> 
> Very well received. Hans wanted to know if the rewritten vivi driver could just replace
> the current one, or if incremental patches were needed. There were no objections to just
> replacing it.
> 
> One comment was made that instead of having a TV channel every 10 MHz one of the frequency
> tables should be used instead as being more realistic. Hans will look into this.
> 
> =================================================================================
> 
> All in all it was a very productive mini-summit. I would like to thank all attendees
> and the Linux Foundation for providing a room for us to use.
> 
> Regards,
> 
> 	Hans Verkuil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
