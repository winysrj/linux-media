Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59470 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3CNNCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 09:02:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v3 2/6] v4l2-ctrl: Add helper function for control range update
Date: Thu, 14 Mar 2013 14:03:30 +0100
Message-ID: <3327486.Mtsf9JCdgL@avalon>
In-Reply-To: <5141B6F6.7080909@samsung.com>
References: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com> <201303140810.57504.hverkuil@xs4all.nl> <5141B6F6.7080909@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 14 March 2013 12:39:34 Sylwester Nawrocki wrote:
> On 03/14/2013 08:10 AM, Hans Verkuil wrote:
> > On Tue March 12 2013 07:56:25 Hans Verkuil wrote:
> >> On Wed January 23 2013 23:21:57 Sylwester Nawrocki wrote:
> >>> This patch adds a helper function that allows to modify range,
> >>> i.e. minimum, maximum, step and default value of a v4l2 control,
> >>> after the control has been created and initialized. This is helpful
> >>> in situations when range of a control depends on user configurable
> >>> parameters, e.g. camera sensor absolute exposure time depending on
> >>> an output image resolution and frame rate.
> >>> 
> >>> v4l2_ctrl_modify_range() function allows to modify range of an
> >>> INTEGER, BOOL, MENU, INTEGER_MENU and BITMASK type controls.
> >>> 
> >>> Based on a patch from Hans Verkuil
> >>> http://patchwork.linuxtv.org/patch/8654.
> >>> 
> >>> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> >>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> I've been playing around with this a bit, using this vivi patch:
> >> 
> >> diff --git a/drivers/media/platform/vivi.c
> >> b/drivers/media/platform/vivi.c
> >> index c46d2e8..85bc314 100644
> >> --- a/drivers/media/platform/vivi.c
> >> +++ b/drivers/media/platform/vivi.c
> >> @@ -1093,6 +1093,15 @@ static int vidioc_s_input(struct file *file, void
> >> *priv, unsigned int i)>> 
> >>  		return 0;
> >>  	
> >>  	dev->input = i;
> >> 
> >> +	/*
> >> +	 * Modify the brightness range depending on the input.
> >> +	 * This makes it easy to use vivi to test if applications can
> >> +	 * handle control range modifications and is also how this is
> >> +	 * typically used in practice as different inputs may be hooked
> >> +	 * up to different receivers with different control ranges.
> >> +	 */
> >> +	v4l2_ctrl_modify_range(dev->brightness,
> >> +			128 * i, 255 + 128 * i, 1, 127 + 128 * i);
> >> 
> >>  	precalculate_bars(dev);
> >>  	precalculate_line(dev);
> >>  	return 0;
> >> 
> >> And it made me wonder if it wouldn't be more sensible if modify_range
> >> would also update the current value to the new default value?
> > 
> > Actually, thinking about it some more, I believe that modify_range should
> > actually include the new control value as argument. That way the caller
> > can decide what to do: use the current value (which then might be
> > clamped), use the default_value or use a remembered previous value.
> > 
> > If you agree with this, then I'll make a patch for it. I just need to know
> > what the only user of this call (ov9650.c) should do. I suspect it should
> > use the default value as the new value, but I'm not certain.
> 
> Sorry for the delay. I suppose if we choose either clamping the new value
> or setting it to the default value there will always be users that wanted
> other behaviour than currently implemented. In ov9650 case it seemed
> clamping the value of the exposure control to <min, max> when the image
> size changed a best option. Using the default value each time control's
> range changed would cause changes of the exposure time, even though current
> exposure value would still be inside of new range.
> Thus I think best option for ov9650 would be to use previous value of the
> control, which would then be clamped to <min, max>. This way changes of
> the exposure time caused by the output format change could be minimized.

I agree. If we don't make the new value configurable I would prefer clamping 
the current value. Adding an argument to the function is reasonable, but I 
don't know if we will have use cases for that. Maybe we can clamp the current 
value for now and add the argument if drivers need it in the future.

-- 
Regards,

Laurent Pinchart

