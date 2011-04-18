Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51576 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1DROXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 10:23:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: David Cohen <dacohen@gmail.com>
Subject: Re: OMAP3 ISP deadlocks on my new arm
Date: Mon, 18 Apr 2011 16:23:56 +0200
Cc: Bastian Hecht <hechtb@googlemail.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <BANLkTikwJ2bJr11U_ETZtU4gYuNyak+Xcw@mail.gmail.com> <BANLkTi==Yeniz_Mm4rD2qnGSR5kBE_XCcg@mail.gmail.com> <BANLkTikLJQitB6ojQ3NaXnJ9op4GGx+YGA@mail.gmail.com>
In-Reply-To: <BANLkTikLJQitB6ojQ3NaXnJ9op4GGx+YGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104181623.56866.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 18 April 2011 16:17:15 David Cohen wrote:
> On Mon, Apr 18, 2011 at 1:43 PM, Bastian Hecht wrote:
> > 2011/4/16 David Cohen:
> >> On Thu, Apr 14, 2011 at 1:36 PM, Bastian Hecht wrote:
> >>> Yeah!
> >>> 
> >>> Soooo... when I initialized the the camera (loading a 108 bytes
> >>> register listing) I just let run the camera and sent images.  So I
> >>> first realized a counter overflow  if (count++ > 100000) after a few
> >>> seconds. But this seemed to be handled correctly (ignore and delete
> >>> HS_VS_IRQ flag) while after 2 or more yavta calls it made the driver
> >>> hang.
> >>> 
> >>> I modified my register listing so that the chip gets "booted" silently.
> >>> In
> >>> static struct v4l2_subdev_video_ops framix_subdev_video_ops = {
> >>>        .s_stream       = framix_s_stream, <===============
> >>> };
> >>> I correctly check the stream status now and enable/disable the camera
> >>> signals.
> >>> 
> >>> I am unsure whether the isp should be able to handle an ongoing data
> >>> stream independently of ISP_PIPELINE_STREAM_STOPPED.
> >> 
> >> streamoff should finish synchronously with last ongoing data. So, it
> >> should have no ongoing data afterwards. Was that your question?
> > 
> > I formulated my reply a bit strange. I meant that that the ongoing
> > datastream from my camera module (even when the isp-stack is in
> > stream_stopped state) produces my problem. The question was if it
> > should be allowed for the camera to send data all time long or only
> > when it is told to do so by s_stream.
> 
> I may assume you are mentioning a pipeline which includes camera
> sensor + ISP. In this case there should be no data.

That's the ideal situation: sensors should not produce any data (or rather any 
transition on the VS/HS signals) when they're supposed to be stopped. 
Unfortunately that's not always easy, as some dumb sensors (or sensor-like 
hardware) can't be stopped. The ISP driver should be able to cope with that in 
a way that doesn't kill the system completely.

I've noticed the same issue with a Caspa camera module and an OMAP3503-based 
Gumstix. I'll try to come up with a good fix.

-- 
Regards,

Laurent Pinchart
