Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60346 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3HVKeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:34:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sylvester.nawrocki@gmail.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 08/10] DocBook: document new v4l motion detection event.
Date: Thu, 22 Aug 2013 12:35:50 +0200
Message-ID: <3694568.GamCuCjpdV@avalon>
In-Reply-To: <5215B203.5080203@xs4all.nl>
References: <1376305113-17128-1-git-send-email-hverkuil@xs4all.nl> <7288776.lXyIOr0qYX@avalon> <5215B203.5080203@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 22 August 2013 08:38:59 Hans Verkuil wrote:
> On 08/21/2013 11:41 PM, Laurent Pinchart wrote:
> > On Monday 12 August 2013 12:58:31 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >> 
> >>  Documentation/DocBook/media/v4l/vidioc-dqevent.xml | 40 ++++++++++++++++
> >>  .../DocBook/media/v4l/vidioc-subscribe-event.xml   |  9 +++++
> >>  2 files changed, 49 insertions(+)

[snip]

> >> diff --git a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> >> b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml index
> >> 5c70b61..d9c3e66 100644
> >> --- a/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> >> +++ b/Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml
> >> @@ -155,6 +155,15 @@
> >> 
> >>  	    </entry>
> >>  	  
> >>  	  </row>
> >>  	  <row>
> >> 
> >> +	    <entry><constant>V4L2_EVENT_MOTION_DET</constant></entry>
> >> +	    <entry>5</entry>
> >> +	    <entry>
> >> +	      <para>Triggered whenever the motion detection state changes, 
i.e.
> >> +	      whether motion is detected or not.
> > 
> > Isn't the event also triggered when region_mask changes from a non-zero
> > value to a different non-zero value ? The second part of the sentence
> > seems to imply that the even is only triggered when motion starts being
> > detected or stops being detected.
> 
> Good point. How about this:
> 
> "Triggered whenever the motion detection state for one or more of the
> regions changes."

That sounds good to me.

-- 
Regards,

Laurent Pinchart

