Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35249 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3KFAMz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 19:12:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 06/24] V4L2: add a common V4L2 subdevice platform data type
Date: Wed, 06 Nov 2013 01:13:24 +0100
Message-ID: <51250742.Vj8b1nY3JT@avalon>
In-Reply-To: <527783DA.5050905@xs4all.nl>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1310171945170.27369@axis700.grange> <527783DA.5050905@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 04 November 2013 12:24:10 Hans Verkuil wrote:
> Hi Guennadi,
> 
> Sorry for the delay, I only saw this today while I was going through my
> mail backlog.
> 
> On 10/17/2013 08:24 PM, Guennadi Liakhovetski wrote:
> > Hi Hans
> > 
> > Sorry for reviving this old thread. I was going to resubmit a part of
> > those patches for mainlining and then I found this your comment, which I
> > didn't reply to back then.
> > 
> > On Fri, 19 Apr 2013, Hans Verkuil wrote:
> >> On Fri April 19 2013 09:48:27 Guennadi Liakhovetski wrote:
> >>> Hi Hans
> >>> 
> >>> Thanks for reviewing.
> >>> 
> >>> On Fri, 19 Apr 2013, Hans Verkuil wrote:
> >>>> On Thu April 18 2013 23:35:27 Guennadi Liakhovetski wrote:
> >>>>> This struct shall be used by subdevice drivers to pass per-subdevice
> >>>>> data, e.g. power supplies, to generic V4L2 methods, at the same time
> >>>>> allowing optional host-specific extensions via the host_priv pointer.
> >>>>> To avoid having to pass two pointers to those methods, add a pointer
> >>>>> to this new struct to struct v4l2_subdev.
> >>>>> 
> >>>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>>>> ---
> >>>>> 
> >>>>>  include/media/v4l2-subdev.h |   13 +++++++++++++
> >>>>>  1 files changed, 13 insertions(+), 0 deletions(-)
> >>>>> 
> >>>>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> >>>>> index eb91366..b15c6e0 100644
> >>>>> --- a/include/media/v4l2-subdev.h
> >>>>> +++ b/include/media/v4l2-subdev.h
> >>>>> @@ -561,6 +561,17 @@ struct v4l2_subdev_internal_ops {
> >>>>> 
> >>>>>  /* Set this flag if this subdev generates events. */
> >>>>>  #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
> >>>>> 
> >>>>> +struct regulator_bulk_data;
> >>>>> +
> >>>>> +struct v4l2_subdev_platform_data {
> >>>>> +	/* Optional regulators uset to power on/off the subdevice */
> >>>>> +	struct regulator_bulk_data *regulators;
> >>>>> +	int num_regulators;
> >>>>> +
> >>>>> +	/* Per-subdevice data, specific for a certain video host device */
> >>>>> +	void *host_priv;
> >>>>> +};
> >>>>> +
> >>>>> 
> >>>>>  /* Each instance of a subdev driver should create this struct, either
> >>>>>     stand-alone or embedded in a larger struct.
> >>>>>   */
> >>>>> @@ -589,6 +600,8 @@ struct v4l2_subdev {
> >>>>> 
> >>>>>  	/* pointer to the physical device */
> >>>>>  	struct device *dev;
> >>>>>  	struct v4l2_async_subdev_list asdl;
> >>>>> 
> >>>>> +	/* common part of subdevice platform data */
> >>>>> +	struct v4l2_subdev_platform_data *pdata;
> >>>>> 
> >>>>>  };
> >>>>>  
> >>>>>  static inline struct v4l2_subdev *v4l2_async_to_subdev(
> >>>> 
> >>>> Sorry, this is the wrong approach.
> >>>> 
> >>>> This is data that is of no use to the subdev driver itself. It really
> >>>> is v4l2_subdev_host_platform_data, and as such must be maintained by
> >>>> the bridge driver.
> >>> 
> >>> I don't think so. It has been discussed and agreed upon, that only
> >>> subdevice drivers know when to switch power on and off, because only
> >>> they know when they need to access the hardware. So, they have to manage
> >>> regulators. In fact, those regulators supply power to respective
> >>> subdevices, e.g. a camera sensor. Why should the bridge driver manage
> >>> them? The V4L2 core can (and probably should) provide helper functions
> >>> for that, like soc-camera currently does, but in any case it's the
> >>> subdevice driver, that has to call them.
> >> 
> >> Ah, OK. I just realized I missed some context there. I didn't pay much
> >> attention to the regulator discussions since that's not my area of
> >> expertise.
> >> 
> >> In that case my only comment is to drop the host_priv pointer since that
> >> just duplicates v4l2_get/set_subdev_hostdata().
> > 
> > I think it's different. This is _platform_ data, whereas struct
> > v4l2_subdev::host_priv is more like run-time data.
> 
> You mean subdev_hostdata() instead of host_priv, right?
> 
> > This field is for the
> > per-subdevice host-specific data, that the platform has to pass to the
> > host driver. In the soc-camera case this is the largest bulk of the data,
> > that platforms currently pass to the soc-camera framework in the host part
> > of struct soc_camera_link. This data most importantly includes I2C
> > information. Yes, this _could_ be passed to soc-camera separately from the
> > host driver, but that would involve quite some refactoring of the "legacy"
> > synchronous probing mode, which I'd like to avoid if possible. This won't
> > be used in the asynchronous case. Do you think we can keep this pointer in
> > this sruct? We could rename it to avoid confusion with the field, that you
> > told about.
> 
> I'm wondering: do we need host_priv at all? Can't drivers use container_of
> to go from struct v4l2_subdev_platform_data to the platform_data struct
> containing v4l2_subdev_platform_data?
> 
> That would be a cleaner solution IMHO. Using host_priv basically forces you
> to split up the platform_data into two parts, and a void pointer isn't very
> type-safe.

For what it's worth, that's the solution I was thinking about, so it has my 
preference as well.

-- 
Regards,

Laurent Pinchart

