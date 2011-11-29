Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53711 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1K2S6m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 13:58:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 1/2] v4l: Add new alpha component control
Date: Tue, 29 Nov 2011 19:58:48 +0100
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	m.szyprowski@samsung.com, jonghun.han@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com> <201111291910.40076.laurent.pinchart@ideasonboard.com> <201111291930.25608.hverkuil@xs4all.nl>
In-Reply-To: <201111291930.25608.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111291958.48671.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 29 November 2011 19:30:25 Hans Verkuil wrote:
> On Tuesday, November 29, 2011 19:10:39 Laurent Pinchart wrote:
> > On Tuesday 29 November 2011 17:40:10 Sylwester Nawrocki wrote:
> > > On 11/29/2011 12:08 PM, Hans Verkuil wrote:
> > > > On Monday 28 November 2011 14:02:49 Sylwester Nawrocki wrote:
> > > >> On 11/28/2011 01:39 PM, Hans Verkuil wrote:
> > > >>> On Monday 28 November 2011 13:13:32 Sylwester Nawrocki wrote:
> > > >>>> On 11/28/2011 12:38 PM, Hans Verkuil wrote:
> > > >>>>> On Friday 25 November 2011 16:39:31 Sylwester Nawrocki wrote:
> > > > Here is a patch that updates the range. It also sends a control event
> > > > telling any listener that the range has changed. Tested with vivi and
> > > > a modified v4l2-ctl.
> > > > 
> > > > The only thing missing is a DocBook entry for that new event flag and
> > > > perhaps some more documentation in places.
> > > > 
> > > > Let me know how this works for you, and if it is really needed, then
> > > > I can add it to the control framework.
> > > 
> > > Thanks for your work, it's very appreciated.
> > > 
> > > I've tested the patch with s5p-fimc and it works well. I just didn't
> > > check the event part yet.
> > > 
> > > I spoke to Kamil as in the past he considered the control range
> > > updating at the codec driver. But since separate controls are used for
> > > different encoding standards, this is not needed it any more.
> > > 
> > > Nevertheless I have at least two use cases, for the alpha control and
> > > for the image sensor driver. In case of the camera sensor, different
> > > device revisions may have different step and maximum value for some
> > > controls, depending on firmware.
> > > By using v4l2_ctrl_range_update() I don't need to invoke lengthy sensor
> > > start-up procedure just to find out properties of some controls.
> > 
> > Wouldn't it be confusing for applications to start with a range and have
> > it updated at runtime ?
> 
> Good question. It was a nice exercise creating the range_update() function
> and it works well, but it this something we want to do?

I think that being able to modify the range is a very useful functionality. 
It's just that in this case the sensor would start with a default range and 
switch to another based on the model. It would be better if we could start 
with the right range from the start.

> If we do, then we should mark such controls with a flag (_VOLATILE_RANGE or
> something like that) so apps know that the range isn't fixed.
> 
> I think that when it comes to apps writing or reading such a control
> directly it isn't a problem. But for applications that automatically
> generate control panels (xawtv et al) it is rather complex to support such
> things.

-- 
Regards,

Laurent Pinchart
