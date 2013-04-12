Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3234 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3DLKF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 06:05:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: RFC: behavior of QUERYSTD when no signal is present
Date: Fri, 12 Apr 2013 12:05:19 +0200
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	"Martin Bugge (marbugge)" <marbugge@cisco.com>
References: <201005091123.05375.hverkuil@xs4all.nl> <201005161026.05004.hverkuil@xs4all.nl>
In-Reply-To: <201005161026.05004.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201304121205.19180.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Some recent discussions regarding the correct behavior of QUERYSTD brought up
a feeling of déjà vu. Some digging in my mail history resulted in this three
year old RFC which I promised to implement but obviously I never did.

Things have changed a bit. Today v4l_querystd in v4l2-ioctl.c initializes the
std with the tvnorms mask (i.e. the list of supported standards), and then it
calls vidioc_querystd. In most cases vidioc_querystd just calls the querystd op
of all registered sub-devices. The idea is that those subdevices will clear any
std bits that they do not detect. So it makes perfect sense that if no signal
is detected at all the end result is 0 == V4L2_STD_UNKNOWN.

I'd like to go through all drivers and ensure that they implement this behavior
and (very important) update the V4L2 spec accordingly.

Comments?

Regards,

	Hans

On Sun May 16 2010 10:26:04 Hans Verkuil wrote:
> On Sunday 09 May 2010 11:23:05 Hans Verkuil wrote:
> > What is VIDIOC_QUERYSTD supposed to do when there is no signal?
> > 
> > The spec says this:
> > 
> > "The hardware may be able to detect the current video standard automatically.
> > To do so, applications call VIDIOC_QUERYSTD with a pointer to a v4l2_std_id
> > type. The driver stores here a set of candidates, this can be a single flag
> > or a set of supported standards if for example the hardware can only
> > distinguish between 50 and 60 Hz systems. When detection is not possible or
> > fails, the set must contain all standards supported by the current video
> > input or output."
> > 
> > The last sentence is the problem. There are several possibilities:
> > 
> > 1) The hardware is physically unable to detect the current video std. In that
> > case this ioctl shouldn't be implemented at all.
> > 
> > 2) While detecting the std an error occurs (e.g. i2c read error). In that case
> > the error should be returned.
> > 
> > 3) There is no input signal. Does that constitute 'detection is not possible or
> > fails'? If so, then all supported standards should be returned. But that seems
> > very strange. After all, I did detect the standard: i.e. there is none, so I
> > would say that QUERYSTD should return V4L2_STD_UNKNOWN (0).
> > 
> > A quick check of the current state of affairs when no signal is present reveals
> > that:
> > 
> > - saa7115, ks0127, saa7191 return 0 with std set to V4L2_STD_ALL
> > - adv7180, vpx3220 return 0 with std set to V4L2_STD_UNKNOWN
> > - saa7110 returns 0 with std set to the current std
> > - bt819 and bttv do not handle this case at all, and just pick 50 Hz or 60 Hz
> > - tvp514x returns -EINVAL.
> > 
> > Lovely... :-)
> > 
> > It is clear that applications currently have no hope in hell to use the output
> > of querystd in a reliable manner. For all practical purposes the behavior of
> > querystd when no signal is present is undefined.
> > 
> > I would propose to specify that if no signal is present then QUERYSTD should
> > return 0 with std V4L2_STD_UNKNOWN.
> 
> I received no comments, so I will prepare patches to implement this proposal.
> 
> Regards,
> 
> 	Hans
> 
> > It would also be consistent with QUERY_DV_PRESET where the preset DV_INVALID
> > is returned in that case.
> > 
> > If we decide to change it, then it is trivial to fix all drivers that implement
> > querystd.
> > 
> > Comments?
> > 
> > 	Hans
> > 
> > 
> 
> 
