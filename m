Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44928 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbbHMOIr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 10:08:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hans.verkuil@cisco.com, s.nawrocki@samsung.com
Subject: Re: [PATCH] [media] v4l2-subdev: return -EPIPE instead of -EINVAL in link validate default
Date: Thu, 13 Aug 2015 17:09:42 +0300
Message-ID: <1451994.H4NDI6ktJg@avalon>
In-Reply-To: <20150813122326.GB19840@valkosipuli.retiisi.org.uk>
References: <1435538742-32447-1-git-send-email-helen.fornazier@gmail.com> <55C8B022.6010107@xs4all.nl> <20150813122326.GB19840@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 13 August 2015 15:23:26 Sakari Ailus wrote:
> On Mon, Aug 10, 2015 at 04:07:30PM +0200, Hans Verkuil wrote:
> > On 07/14/2015 04:32 PM, Laurent Pinchart wrote:
> >> On Tuesday 14 July 2015 16:19:50 Hans Verkuil wrote:
> >>> On 07/13/15 10:03, Sakari Ailus wrote:
> >>>> Helen Fornazier wrote:
> >>>>> On Tue, Jun 30, 2015 at 4:26 PM, Helen Fornazier wrote:
> >>>>>> On Tue, Jun 30, 2015 at 6:19 AM, Sakari Ailus wrote:
> >>>>>>> Laurent Pinchart wrote:
> >>>>>>>> On Monday 29 June 2015 10:23:34 Sakari Ailus wrote:
> >>>>>>>>> Helen Fornazier wrote:
> >>>>>>>>>> According to the V4L2 API, the VIDIOC_STREAMON ioctl should
> >>>>>>>>>> return EPIPE when the pipeline configuration is invalid.
> >>>>>>>>>> 
> >>>>>>>>>> As the .vidioc_streamon in the v4l2_ioctl_ops usually forwards
> >>>>>>>>>> the error caused by the v4l2_subdev_link_validate_default (if it
> >>>>>>>>>> is in use), it should return -EPIPE if it detects a format
> >>>>>>>>>> mismatch in the pipeline configuration
> >>>>>>>>> 
> >>>>>>>>> Only link configuration errors have yielded -EPIPE so far,
> >>>>>>>>> sub-device format configuration error has returned -INVAL instead
> >>>>>>>>> as you noticed.
> >>>>>>>> 
> >>>>>>>> It should also be noted that while v4l2_subdev_link_validate()
> >>>>>>>> will return -EINVAL in case of error, the only driver that
> >>>>>>>> performs custom link validation (omap3isp/ispccdc.c) will return -
> >>>>>>>> EPIPE.
> >>>>>>> 
> >>>>>>> Good point. That has escaped me until now.
> >>>>>>> 
> >>>>>>>>> There are not many sources of -EINVAL while enabling streaming
> >>>>>>>>> and all others are directly caused by the application; I lean
> >>>>>>>>> towards thinking the code is good as it was. The documentation
> >>>>>>>>> could be improved though. It may not be clear which error codes
> >>>>>>>>> could be caused by different conditions.
> >>>>>>>>> 
> >>>>>>>>> The debug level messages from media module
> >>>>>>>>> (drivers/media/media-entity.c) do provide more information if
> >>>>>>>>> needed, albeit this certainly is not an application interface.
> >>>>>>>>> 
> >>>>>>>>> I wonder what others think.
> >>>>>>>> 
> >>>>>>>> There's a discrepancy between the implementation and the
> >>>>>>>> documentation, so at least one of them need to be fixed. -EPIPE
> >>>>>>>> would be coherent with the documentation and seems appropriately
> >>>>>>>> named, but another error code would allow userspace to tell link
> >>>>>>>> configuration and format configuration problems apart.
> >>>>>>> 
> >>>>>>> That was the original intent, I think.
> >>>>>>> 
> >>>>>>>> Do you think -EINVAL is the most appropriate error code for format
> >>>>>>>> configuration ? It's already used to indicate that the stream type
> >>>>>>>> is invalid or that not enough buffers have been allocated, and is
> >>>>>>>> also used by drivers directly for various purposes.
> >>>>>>> 
> >>>>>>> That's true, it's been used also for that purpose. At the time this
> >>>>>>> certainly was not the primary concern. If you can think of a better
> >>>>>>> error code for the purpose (than EINVAL) I'm certainly fine with
> >>>>>>> using one. I still think that -EPIPE is worse for telling about
> >>>>>>> incorrect format configuration than -EINVAL since it's relatively
> >>>>>>> easy to avoid -EINVAL for the documented reasons.
> >>>>>> 
> >>>>>> I'd like just to point out where in the docs EPIPE for format
> >>>>>> mismatch is specified, as it is not described in the streamon page
> >>>>>> as I thought it would, but it is in the subdev page in case anyone
> >>>>>> is looking for it (as I took some time to find it too):
> >>>>>> 
> >>>>>> http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html
> >>>>>> "Applications are responsible for configuring coherent parameters on
> >>>>>> the whole pipeline and making sure that connected pads have
> >>>>>> compatible formats. The pipeline is checked for formats mismatch at
> >>>>>> VIDIOC_STREAMON time, and an EPIPE error code is then returned if
> >>>>>> the configuration is invalid"
> >>>>>> 
> >>>>>> So maybe the doc should be improved as you already stated.
> >>>>> 
> >>>>> I would like to revive this subject.
> >>>>> 
> >>>>> Should we change the docs? Change the -EINVAL to -EPIPE, or create
> >>>>> another error code? What are your opinion?
> >>>>> 
> >>>>> I read in the docs of dev-kmsg that EPIPE is returned when messages
> >>>>> get overwritten, and in other parts of the code EPIPE is returned
> >>>>> when there is an error in the pipeline communication level while
> >>>>> trying to send information through the pipe or a pipe broken error.
> >>>>> 
> >>>>> But in the error-codes.txt files, the EPIPE error is defined as:
> >>>>> *EPIPE "The pipe type specified in the URB doesn't match the
> >>>>> endpoint's actual type"*
> >>>> 
> >>>> This exact definition sound USB specific to me.
> >>>> 
> >>>>> Then, if EPIPE is used when types don't match between two endpoints,
> >>>>> it seems reasonable to me to use EPIPE when formats don't match
> >>>>> either. Or do "types" in this context have a specific definition? I
> >>>>> don't know much about URB, you may be able to judge this better.
> >>>> 
> >>>> A short recap of the current situation as far as I understand it:
> >>>> 
> >>>> - MC link validation failure yields EPIPE to the user space,
> >>>> 
> >>>> - V4L2 sub-device format validation failure generally results in
> >>>> EINVAL, except that
> >>> 
> >>> I think that returning EINVAL here is wrong. EINVAL is returned when
> >>> you set e.g. a format and the format is invalid. In this case the
> >>> format for each subdev is perfectly fine, it's just that the sink and
> >>> source formats do not match.
> >>> 
> >>> Rather than returning EINVAL I think ENOLINK would work well here as
> >>> you can't setup a link between two entities. And EPIPE can still be
> >>> used for other higher-level pipeline errors.
> >>> 
> >>>> - omap3isp CCDC driver returns EPIPE instead and
> >>> 
> >>> That seems definitely the wrong thing to do.
> > 
> > I think I was ambiguous here. What is wrong here is that it replaces the
> > actual error code with EPIPE instead of passing it along to userspace.
> 
> I'm not sure if I follow you. ccdc_link_validate() will not obtain the error
> code from anywhere else; instead, it returns -EPIPE if the media bus
> formats at both ends of the link do not match.
> 
> >> The VIDIOC_STREAMON documentation states that
> >> 
> >> "EPIPE
> >> 
> >> The driver implements pad-level format configuration and the pipeline
> >> configuration is invalid."
> >> 
> >> According to the documentation, EINVAL is clearly wrong, and EPIPE
> >> should be used. I'm open to the idea of using different error codes to
> >> indicate severed link errors and links with an invalid configuration,
> >> but how about backward compatibility ?
> > 
> > Applications should *always* check for any error. An application that only
> > checks for a specific error and assumes that any other error is the same
> > as 'Success' is obviously broken. I have no problem with adding a separate
> > error for link validation errors (keeping EPIPE for format validation
> > errors).
> > 
> > My preferences for such a link validation error are (in descending order):
> > 
> > - ENOLINK
> > - EMLINK
> > 
> > Personally I feel that if you can't validate the video pipeline, then you
> > can't setup the video data links, i.e. ENOLINK.
> > 
> > EMLINK is when you have too many links which feels wrong to me, although
> > Sakari prefers it. Could this actually be a separate error? I.e. if you
> > make too many links active? Perhaps we should allow both errors?
> 
> I originally proposed EMLINK since it was POSIX while ENOLINK at some point
> apparently was not, but man 3 errno now tells both are. I think we agree,
> and my understanding is Laurent is fine with this as well. To summarise:
> 
> - change v4l2_subdev_link_validate_default() return -EPIPE instead of
>   -EINVAL on error,
> 
> - change media_entity_pipeline_start() to return -ENOLINK instead of -EPIPE
>   if link configuration error is encountered and
> 
> - change the documentation accordingly.
> 
> Please ack.

That's fine with me.

-- 
Regards,

Laurent Pinchart

