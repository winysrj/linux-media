Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2783 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1HILbs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 07:31:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1 PATCH for v3.1] v4l2-ioctl: fix ENOTTY handling.
Date: Tue, 9 Aug 2011 13:31:40 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201107291410.53552.hverkuil@xs4all.nl> <201108091210.25974.hverkuil@xs4all.nl> <4E41188F.6060600@redhat.com>
In-Reply-To: <4E41188F.6060600@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108091331.40300.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, August 09, 2011 13:22:55 Mauro Carvalho Chehab wrote:
> Em 09-08-2011 07:10, Hans Verkuil escreveu:
> > On Sunday, July 31, 2011 14:43:44 Mauro Carvalho Chehab wrote:
> >> Em 29-07-2011 09:10, Hans Verkuil escreveu:
> >>> Hi all,
> >>>
> >>> While converting v4l2-compliance to correctly handle ENOTTY errors I found
> >>> several regressions in v4l2-ioctl.c:
> >>>
> >>> 1) VIDIOC_ENUM/G/S/TRY_FMT would return -ENOTTY if the op for the particular
> >>>    format type was not set, even though the op for other types might have been
> >>>    present. In such a case -EINVAL should have been returned.
> >>> 2) The priority check could cause -EBUSY or -EINVAL to be returned instead of
> >>>    -ENOTTY if the corresponding ioctl was unsupported.
> >>> 3) Certain ioctls that have an internal implementation (ENUMSTD, G_STD, S_STD,
> >>>    G_PARM and the extended control ioctls) could return -EINVAL when -ENOTTY
> >>>    should have been returned or vice versa.
> >>>
> >>> I first tried to fix this by adding extra code for each affected ioctl, but
> >>> that made the code rather ugly.
> >>>
> >>> So I ended up with this code that first checks whether a certain ioctl is
> >>> supported or not and returns -ENOTTY if not.
> >>>
> >>> Comments?
> >>
> >> This patch adds an extra cost of double-parsing the ioctl just because the
> >> errors. The proper way is to check at the error path.
> >>
> >> See the enclosed patch.
> > 
> > Your patch fixes some but not all of the problems that my patch fixes.
> 
> What was left?

A number of things: the priority check has to be done after the 'ENOTTY' check,
the no_ioctl_err() macros had copy and paste errors ('g' was used for both set
and try), and was incomplete (enum_fmt has a subset of the possible ops compared
to get/set/try).

Several error paths were also not handled correctly (returning ENOTTY instead of
EINVAL).

> > I'm trying to create a new patch on top of yours that actually fixes all the
> > issues, but I'm having a hard time with that.
> > 
> > It is getting very difficult to follow the error path, which is exactly why
> > I didn't want to do that in the first place. I've never understood the fixation
> > on performance *without doing any measurements*. As the old saying goes:
> > "Premature optimization is the root of all evil."
> > 
> > Code such as the likely/unlikely macros just obfuscate the code and should not
> > be added IMHO unless you can prove that it makes a difference. See for example
> > the discussion whether prefetch is useful or not: http://lwn.net/Articles/444336
> 
> I politely disagree that likely/unlikely macros obfuscate the code. 
> 
> If it actually make some difference or not would require a study using several 
> different processors with different types of CPU pipelines, and/or checking the 
> generated assembler for the supported processor families.
> 
> If someone comes to a conclusion that it doesn't make any difference, we can
> simply discard them.

That's the wrong way around IMHO. Code must serve a purpose. I have no problem
with likely/unlikely in tight loops or often executed code. Neither of which is
the case here.

> 
> > 
> > Code complexity is by far the biggest problem with all V4L code. I am tempted
> > to completely reorganize v4l2-ioctl.c, but I can't do that for v3.1.
> 
> A single code block like:
> 
> switch (ioctl) {
> case VIDIOC_foo:
> 	/* handle foo */
> 	break;
> ...
> }
> 
> Has less complexity than two blocks:
> 
> switch (ioctl) {
> case VIDIOC_foo:
> 	/* Check for errors on foo */
> 	break;
> ...
> }
> 
> switch (ioctl) {
> case VIDIOC_foo:
> 	/* handle foo */
> 	break;
> ...
> }
> 
> Also, it allows optimizing the error handling logic to only run when there's
> an error, and not before.
> 
> In the past, the ioctl handling were a big mess, as there were several switch
> loops to handle ioctl's, internally to each V4L driver. This is harder to
> review, and may lead into mistakes. A single switch improved a lot code
> readability, as now everything is there together.
> 
> The priority patches messed it somehow, by adding an extra switch. Let's not
> add more complexity to it.
> 
> > I'll try to come up with another approach instead.
> 
> What do you have in mind?

I'll post a new patch today. The vivi and ivtv drivers now pass the v4l2-compliance
test again.

Regards,

	Hans

> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> >>
> >>
> >> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> >> Date: Sun, 31 Jul 2011 09:37:56 -0300
> >> [PATCH] v4l2-ioctl: properly return -EINVAL when parameters are wrong
> >>
> >> When an ioctl is implemented, but the parameters are invalid,
> >> the error code should be -EINVAL. However, if the ioctl is
> >> not defined, it should return -ENOTTY instead.
> >>
> >> While here, adds a gcc hint that having the ioctl enabled is more
> >> likely, as userspace should know what the driver supports due to QUERYCAP
> >> call.
> >>
> >> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> >> index 002ce13..9f80e9d 100644
> >> --- a/drivers/media/video/v4l2-ioctl.c
> >> +++ b/drivers/media/video/v4l2-ioctl.c
> >> @@ -55,6 +55,14 @@
> >>  	memset((u8 *)(p) + offsetof(typeof(*(p)), field) + sizeof((p)->field), \
> >>  	0, sizeof(*(p)) - offsetof(typeof(*(p)), field) - sizeof((p)->field))
> >>  
> >> +#define no_ioctl_err(foo) ( (						\
> >> +	ops->vidioc_##foo##_fmt_vid_cap ||				\
> >> +	ops->vidioc_##foo##_fmt_vid_out ||				\
> >> +	ops->vidioc_##foo##_fmt_vid_cap_mplane ||			\
> >> +	ops->vidioc_##foo##_fmt_vid_out_mplane ||			\
> >> +	ops->vidioc_##foo##_fmt_vid_overlay ||				\
> >> +	ops->vidioc_##foo##_fmt_type_private) ? -EINVAL : -ENOTTY)
> >> +
> >>  struct std_descr {
> >>  	v4l2_std_id std;
> >>  	const char *descr;
> >> @@ -591,7 +599,7 @@ static long __video_do_ioctl(struct file *file,
> >>  			ret = v4l2_prio_check(vfd->prio, vfh->prio);
> >>  			if (ret)
> >>  				goto exit_prio;
> >> -			ret = -EINVAL;
> >> +			ret = -ENOTTY;
> >>  			break;
> >>  		}
> >>  	}
> >> @@ -638,7 +646,7 @@ static long __video_do_ioctl(struct file *file,
> >>  		enum v4l2_priority *p = arg;
> >>  
> >>  		if (!ops->vidioc_s_priority && !use_fh_prio)
> >> -				break;
> >> +			break;
> >>  		dbgarg(cmd, "setting priority to %d\n", *p);
> >>  		if (ops->vidioc_s_priority)
> >>  			ret = ops->vidioc_s_priority(file, fh, *p);
> >> @@ -654,37 +662,37 @@ static long __video_do_ioctl(struct file *file,
> >>  
> >>  		switch (f->type) {
> >>  		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> >> -			if (ops->vidioc_enum_fmt_vid_cap)
> >> +			if (likely(ops->vidioc_enum_fmt_vid_cap))
> >>  				ret = ops->vidioc_enum_fmt_vid_cap(file, fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> >> -			if (ops->vidioc_enum_fmt_vid_cap_mplane)
> >> +			if (likely(ops->vidioc_enum_fmt_vid_cap_mplane))
> >>  				ret = ops->vidioc_enum_fmt_vid_cap_mplane(file,
> >>  									fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> >> -			if (ops->vidioc_enum_fmt_vid_overlay)
> >> +			if (likely(ops->vidioc_enum_fmt_vid_overlay))
> >>  				ret = ops->vidioc_enum_fmt_vid_overlay(file,
> >>  					fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >> -			if (ops->vidioc_enum_fmt_vid_out)
> >> +			if (likely(ops->vidioc_enum_fmt_vid_out))
> >>  				ret = ops->vidioc_enum_fmt_vid_out(file, fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> >> -			if (ops->vidioc_enum_fmt_vid_out_mplane)
> >> +			if (likely(ops->vidioc_enum_fmt_vid_out_mplane))
> >>  				ret = ops->vidioc_enum_fmt_vid_out_mplane(file,
> >>  									fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_PRIVATE:
> >> -			if (ops->vidioc_enum_fmt_type_private)
> >> +			if (likely(ops->vidioc_enum_fmt_type_private))
> >>  				ret = ops->vidioc_enum_fmt_type_private(file,
> >>  								fh, f);
> >>  			break;
> >>  		default:
> >>  			break;
> >>  		}
> >> -		if (!ret)
> >> +		if (likely (!ret))
> >>  			dbgarg(cmd, "index=%d, type=%d, flags=%d, "
> >>  				"pixelformat=%c%c%c%c, description='%s'\n",
> >>  				f->index, f->type, f->flags,
> >> @@ -693,6 +701,8 @@ static long __video_do_ioctl(struct file *file,
> >>  				(f->pixelformat >> 16) & 0xff,
> >>  				(f->pixelformat >> 24) & 0xff,
> >>  				f->description);
> >> +		else if (ret == -ENOTTY)
> >> +			ret = no_ioctl_err(enum);
> >>  		break;
> >>  	}
> >>  	case VIDIOC_G_FMT:
> >> @@ -744,7 +754,7 @@ static long __video_do_ioctl(struct file *file,
> >>  				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> >> -			if (ops->vidioc_g_fmt_vid_overlay)
> >> +			if (likely(ops->vidioc_g_fmt_vid_overlay))
> >>  				ret = ops->vidioc_g_fmt_vid_overlay(file,
> >>  								    fh, f);
> >>  			break;
> >> @@ -789,34 +799,36 @@ static long __video_do_ioctl(struct file *file,
> >>  				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
> >> -			if (ops->vidioc_g_fmt_vid_out_overlay)
> >> +			if (likely(ops->vidioc_g_fmt_vid_out_overlay))
> >>  				ret = ops->vidioc_g_fmt_vid_out_overlay(file,
> >>  				       fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VBI_CAPTURE:
> >> -			if (ops->vidioc_g_fmt_vbi_cap)
> >> +			if (likely(ops->vidioc_g_fmt_vbi_cap))
> >>  				ret = ops->vidioc_g_fmt_vbi_cap(file, fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VBI_OUTPUT:
> >> -			if (ops->vidioc_g_fmt_vbi_out)
> >> +			if (likely(ops->vidioc_g_fmt_vbi_out))
> >>  				ret = ops->vidioc_g_fmt_vbi_out(file, fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
> >> -			if (ops->vidioc_g_fmt_sliced_vbi_cap)
> >> +			if (likely(ops->vidioc_g_fmt_sliced_vbi_cap))
> >>  				ret = ops->vidioc_g_fmt_sliced_vbi_cap(file,
> >>  									fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> >> -			if (ops->vidioc_g_fmt_sliced_vbi_out)
> >> +			if (likely(ops->vidioc_g_fmt_sliced_vbi_out))
> >>  				ret = ops->vidioc_g_fmt_sliced_vbi_out(file,
> >>  									fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_PRIVATE:
> >> -			if (ops->vidioc_g_fmt_type_private)
> >> +			if (likely(ops->vidioc_g_fmt_type_private))
> >>  				ret = ops->vidioc_g_fmt_type_private(file,
> >>  								fh, f);
> >>  			break;
> >>  		}
> >> +		if (unlikely(ret == -ENOTTY))
> >> +			ret = no_ioctl_err(g);
> >>  
> >>  		break;
> >>  	}
> >> @@ -926,33 +938,36 @@ static long __video_do_ioctl(struct file *file,
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VBI_CAPTURE:
> >>  			CLEAR_AFTER_FIELD(f, fmt.vbi);
> >> -			if (ops->vidioc_s_fmt_vbi_cap)
> >> +			if (likely(ops->vidioc_s_fmt_vbi_cap))
> >>  				ret = ops->vidioc_s_fmt_vbi_cap(file, fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VBI_OUTPUT:
> >>  			CLEAR_AFTER_FIELD(f, fmt.vbi);
> >> -			if (ops->vidioc_s_fmt_vbi_out)
> >> +			if (likely(ops->vidioc_s_fmt_vbi_out))
> >>  				ret = ops->vidioc_s_fmt_vbi_out(file, fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
> >>  			CLEAR_AFTER_FIELD(f, fmt.sliced);
> >> -			if (ops->vidioc_s_fmt_sliced_vbi_cap)
> >> +			if (likely(ops->vidioc_s_fmt_sliced_vbi_cap))
> >>  				ret = ops->vidioc_s_fmt_sliced_vbi_cap(file,
> >>  									fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> >>  			CLEAR_AFTER_FIELD(f, fmt.sliced);
> >> -			if (ops->vidioc_s_fmt_sliced_vbi_out)
> >> +			if (likely(ops->vidioc_s_fmt_sliced_vbi_out))
> >>  				ret = ops->vidioc_s_fmt_sliced_vbi_out(file,
> >>  									fh, f);
> >> +
> >>  			break;
> >>  		case V4L2_BUF_TYPE_PRIVATE:
> >>  			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
> >> -			if (ops->vidioc_s_fmt_type_private)
> >> +			if (likely(ops->vidioc_s_fmt_type_private))
> >>  				ret = ops->vidioc_s_fmt_type_private(file,
> >>  								fh, f);
> >>  			break;
> >>  		}
> >> +		if (unlikely(ret == -ENOTTY))
> >> +			ret = no_ioctl_err(g);
> >>  		break;
> >>  	}
> >>  	case VIDIOC_TRY_FMT:
> >> @@ -1008,7 +1023,7 @@ static long __video_do_ioctl(struct file *file,
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> >>  			CLEAR_AFTER_FIELD(f, fmt.win);
> >> -			if (ops->vidioc_try_fmt_vid_overlay)
> >> +			if (likely(ops->vidioc_try_fmt_vid_overlay))
> >>  				ret = ops->vidioc_try_fmt_vid_overlay(file,
> >>  					fh, f);
> >>  			break;
> >> @@ -1057,40 +1072,43 @@ static long __video_do_ioctl(struct file *file,
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
> >>  			CLEAR_AFTER_FIELD(f, fmt.win);
> >> -			if (ops->vidioc_try_fmt_vid_out_overlay)
> >> +			if (likely(ops->vidioc_try_fmt_vid_out_overlay))
> >>  				ret = ops->vidioc_try_fmt_vid_out_overlay(file,
> >>  				       fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VBI_CAPTURE:
> >>  			CLEAR_AFTER_FIELD(f, fmt.vbi);
> >> -			if (ops->vidioc_try_fmt_vbi_cap)
> >> +			if (likely(ops->vidioc_try_fmt_vbi_cap))
> >>  				ret = ops->vidioc_try_fmt_vbi_cap(file, fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_VBI_OUTPUT:
> >>  			CLEAR_AFTER_FIELD(f, fmt.vbi);
> >> -			if (ops->vidioc_try_fmt_vbi_out)
> >> +			if (likely(ops->vidioc_try_fmt_vbi_out))
> >>  				ret = ops->vidioc_try_fmt_vbi_out(file, fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
> >>  			CLEAR_AFTER_FIELD(f, fmt.sliced);
> >> -			if (ops->vidioc_try_fmt_sliced_vbi_cap)
> >> +			if (likely(ops->vidioc_try_fmt_sliced_vbi_cap))
> >>  				ret = ops->vidioc_try_fmt_sliced_vbi_cap(file,
> >>  								fh, f);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> >>  			CLEAR_AFTER_FIELD(f, fmt.sliced);
> >> -			if (ops->vidioc_try_fmt_sliced_vbi_out)
> >> +			if (likely(ops->vidioc_try_fmt_sliced_vbi_out))
> >>  				ret = ops->vidioc_try_fmt_sliced_vbi_out(file,
> >>  								fh, f);
> >> +			else
> >> +				ret = no_ioctl_err(try);
> >>  			break;
> >>  		case V4L2_BUF_TYPE_PRIVATE:
> >>  			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
> >> -			if (ops->vidioc_try_fmt_type_private)
> >> +			if (likely(ops->vidioc_try_fmt_type_private))
> >>  				ret = ops->vidioc_try_fmt_type_private(file,
> >>  								fh, f);
> >>  			break;
> >>  		}
> >> -
> >> +		if (unlikely(ret == -ENOTTY))
> >> +			ret = no_ioctl_err(g);
> >>  		break;
> >>  	}
> >>  	/* FIXME: Those buf reqs could be handled here,
> >> @@ -1262,16 +1280,15 @@ static long __video_do_ioctl(struct file *file,
> >>  	{
> >>  		v4l2_std_id *id = arg;
> >>  
> >> -		ret = 0;
> >>  		/* Calls the specific handler */
> >>  		if (ops->vidioc_g_std)
> >>  			ret = ops->vidioc_g_std(file, fh, id);
> >> -		else if (vfd->current_norm)
> >> +		else if (vfd->current_norm) {
> >> +			ret = 0;
> >>  			*id = vfd->current_norm;
> >> -		else
> >> -			ret = -EINVAL;
> >> +		}
> >>  
> >> -		if (!ret)
> >> +		if (likely(!ret))
> >>  			dbgarg(cmd, "std=0x%08Lx\n", (long long unsigned)*id);
> >>  		break;
> >>  	}
> >> @@ -1288,8 +1305,6 @@ static long __video_do_ioctl(struct file *file,
> >>  		/* Calls the specific handler */
> >>  		if (ops->vidioc_s_std)
> >>  			ret = ops->vidioc_s_std(file, fh, &norm);
> >> -		else
> >> -			ret = -EINVAL;
> >>  
> >>  		/* Updates standard information */
> >>  		if (ret >= 0)
> >> @@ -1812,7 +1827,7 @@ static long __video_do_ioctl(struct file *file,
> >>  			if (ops->vidioc_g_std)
> >>  				ret = ops->vidioc_g_std(file, fh, &std);
> >>  			else if (std == 0)
> >> -				ret = -EINVAL;
> >> +				ret = -ENOTTY;
> >>  			if (ret == 0)
> >>  				v4l2_video_std_frame_period(std,
> >>  						    &p->parm.capture.timeperframe);
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
