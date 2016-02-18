Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:49163 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1425034AbcBRGgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 01:36:53 -0500
Subject: Re: [RFC/PATCH] [media] rcar-vin: add Renesas R-Car VIN IP core
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	linux-renesas-soc@vger.kernel.org,
	Ulrich Hecht <ulrich.hecht@gmail.com>
References: <1455468932-8573-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <56C19A2B.2080502@xs4all.nl> <20160218001342.GA12338@bigcity.dyn.berto.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C5667F.2000809@xs4all.nl>
Date: Thu, 18 Feb 2016 07:36:47 +0100
MIME-Version: 1.0
In-Reply-To: <20160218001342.GA12338@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/2016 01:13 AM, Niklas Söderlund wrote:
> Hi Hans,
> 
> Thanks for your comments.
> 
> On 2016-02-15 10:28:11 +0100, Hans Verkuil wrote:
>> On 02/14/2016 05:55 PM, Niklas Söderlund wrote:
>>> A V4L2 driver for Renesas R-Car VIN IP cores that do not depend on
>>> soc_camera. The driver is heavily based on its predecessor and aims to
>>> replace the soc_camera driver.
>>
>> Fantastic! I've been hoping that this would be done at some point. It
>> was very unfortunate that Renesas went with soc-camera initially.
>>
>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>> ---
>>>
>>> The driver is tested on Koelsch and can grab frames using yavta.  It
>>> also passes a v4l2-compliance (1.10.0) run without failures.
>>
>> Did you compile v4l2-compliance from the master branch of the v4l-utils.git
>> repo? I always recommend that.
>>
>> Can you post the output of 'v4l2-compliance -s' and ideally also 'v4l2-compliance -f'?
>>
>> I always like to see that for new drivers.
> 
> No I used the latest .tar.bz2 snapshot. Will build from master branch
> and include for v2.
> 
>>
>>> There is
>>> however a issues sometimes if one first run v4l2-compliance and then
>>> yavta the grabbed frames are a bit fuzzy. I'm working on it. Also I
>>> could only get frames if the video signal on the composite IN was NTSC,
>>> but this also applied to the soc_camera driver, it might be my test
>>> setup.
>>>
>>> As stated in commit message the driver is based on its soc_camera
>>> version but some features have been drooped (for now?).
>>>  - The driver no longer try to use the subdev for cropping (using
>>>    cropcrop/s_crop).
>>>  - Do not interrogate the subdev using g_mbus_config.
>>>
>>> The goal is to replace the soc_camera driver completely to prepare for
>>> Gen3 enablement.  Is it a good idea to aim for inheriting
>>> CONFIG_VIDEO_RCAR_VIN in such case?  I'm thinking down the road if this
>>> driver is good enough to simply rename the old CONFIG_VIDEO_RCAR_VIN to
>>> something like CONFIG_VIDEO_SOC_CAMERA_RCAR_VIN mark is at deprecated
>>> and use this one as a drop in replacement.
>>
>> We probably want to have both for some time with the soc-camera version
>> marked as 'DEPRECATED'. Especially as long as they aren't at feature parity.
> 
> I agree. I will drop my idea of inheriting CONFIG_VIDEO_RCAR_VIN and use
> CONFIG_VIDEO_RCAR_VIN_NEW until we can figure out something more
> suitable. I plan to include the changes required for building in v2 to
> ease testing.

Actually, I'd rename the old driver to CONFIG_VIDEO_RCAR_VIN_OLD and keep
CONFIG_VIDEO_RCAR_VIN for this driver.

And perhaps you can also move the old driver to staging/media, but that
should be done in a final separate patch since I am not sure yet we want
to do that at the same time as introducing the new driver.

> 
>>
>>> The main feature missing at this point is vidioc_[gs]_selection. The
>>> driver can crop/scale but it's not exposed to the user. However this
>>> will be different on Gen3 HW where not all channels have scalers.
>>
>> Do you plan to add this in the next version?
> 
> Yes.
> 
> [snip]
> 
>>> +
>>> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
>>> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
>>> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
>>> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
>>> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
>>> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
>>> +
>>> +	.vidioc_streamon		= rvin_streamon,
>>> +	.vidioc_streamoff		= rvin_streamoff,
>>> +
>>> +	.vidioc_log_status		= v4l2_ctrl_log_status,
>>> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
>>> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>>> +};
>>
>> General question: I'm missing HDMI support in this driver. Will that be added later?
>>
>> Adding that is quite simple in this driver (as opposed to adding it to soc-camera).
> 
> Ulrich Hecht already beat me to it with whit '[PATCH/RFC 0/9] Lager
> board HDMI input support', thanks Ulrich.

I saw that. I have a Koelsch that's still in the box, but now it is really time to
start setting it up. I'll start working on that tomorrow.

Regards,

	Hans
