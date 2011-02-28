Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56600 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab1B1KAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 05:00:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: [RFC PATCH RESEND v2 2/3] v4l2-ctrls: modify uvc driver to use new menu type of V4L2_CID_FOCUS_AUTO
Date: Mon, 28 Feb 2011 11:01:00 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D67A489.2050808@samsung.com> <201102251358.29116.laurent.pinchart@ideasonboard.com> <4D6B2F6B.2080605@samsung.com>
In-Reply-To: <4D6B2F6B.2080605@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102281101.00830.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Monday 28 February 2011 06:15:23 Kim, HeungJun wrote:
> 2011-02-25 오후 9:58, Laurent Pinchart 쓴 글:
> > On Friday 25 February 2011 13:46:01 Kim, HeungJun wrote:
> >> As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu
> >> type, this uvc is modified the usage of V4L2_CID_FOCUS_AUTO.
> >> 
> >> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> 
> >>  drivers/media/video/uvc/uvc_ctrl.c |    9 ++++++++-
> >>  1 files changed, 8 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> >> b/drivers/media/video/uvc/uvc_ctrl.c index 59f8a9a..b98b9f1 100644
> >> --- a/drivers/media/video/uvc/uvc_ctrl.c
> >> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> >> @@ -333,6 +333,11 @@ static struct uvc_menu_info
> >> exposure_auto_controls[] = { { 8, "Aperture Priority Mode" },
> >> 
> >>  };
> >> 
> >> +static struct uvc_menu_info focus_auto_controls[] = {
> >> +	{ 1, "Auto Mode" },
> >> +	{ 0, "Manual Mode" },
> > 
> > Now that manual focus has value 0 and auto focus value 1, the menu
> > entries need to be the other way around.
> 
> I don't really get it. My understanding is that your words are structure
> uvc_menu_info should be changed as fitted to focus menu type. right?
> But, I thinks they don't need to be changed, and I don't find wrong,
> I don't know how to fix what you telling me exactly.
> 
> So, could you explain more details? Some examples helps to me.

The menu entries are indexed by the V4L2 menu value. The first field is the 
UVC menu entry value, and the second field its name. As the V4L2 manual focus 
control has a value of 0, it must be the first entry.

> Sorry to bother if you are busy, but it's good for me your advice.
> I'll waiting.

No worries.

-- 
Regards,

Laurent Pinchart
